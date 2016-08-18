<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	User user = (User)(session.getAttribute("username"));
	if(user.getType() >= User.SUPERUSER){
	ArrayList<User> users = MasterGraph.getAllUsers();
	Iterator<User> u = users.iterator();
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">User Details</h3>
  </div>
  <div class="panel-body">

<%
if(user.getType() >= User.ADMIN){
%>
				
					<form method="post" action="AddOrUpdateUser">
					<input type="hidden" name="update" value="addUser">
					<p align="right"><button name="submit" value="submit" type="submit"><img src="images/new.png" alt="add new user"></button></p>
					</form>
<%
}
%>
				<div class="table-responsive">
				<table border="1" cellpadding="6" class="table table-striped">
				<thead>
					<tr>
						<th>Name</th>
						<th>Country</th>
						<th>Email</th>
						<th>Orgname</th>
						<th>Username</th>
						<th>Password</th>
						<th>Type</th>
						<th>View Count</th>
						<th>Update Count</th>
						<th>Last Login</th>
						<th>Login Count</th>
						<th>Update User</th>
						<th>Delete User</th>
					</tr>
				</thead>
				<tbody>
<%
				User current = null;
				while(u.hasNext()){
					current = u.next();
					int type = current.getType();
					String typeText = "Super User";
					if(type == 3){
						typeText = "Normal";
					} else if(type == 5){
						typeText = "Admin";
					}
%>
					<tr>
						<td><%=current.getName()%></td>
						<td><%=current.getCountry()%></td>
						<td><%=current.getEmail()%></td>
						<td><%=current.getOrgName()%></td>
						<td><%=current.getUsername()%></td>
						<td><%=current.getPassword()%></td>
						<td><%=typeText%></td>
						<td><%=current.getNodeViewCount()%></td>
						<td><%=current.getNodeUpdateCount()%></td>
						<td><%=current.getLastLogin()%></td>
						<td><%=current.getLoginCount()%></td>
						<td><form method="post" action="AddOrUpdateUser">
							<input type="hidden" name="update" value="updateUser">
							<input type="hidden" name="userId" value="<%=current.getId()%>">
							<button name="submit" value="submit" type="submit"><img src="images/update.png" alt="update user"></button>
							</form>
						</td>
						<td><form method="post" action="AddOrUpdateUser" onsubmit="return confirmDeleteUser('<%=current.getName()%>')">
							<input type="hidden" name="update" value="deleteUser">
							<input type="hidden" name="userId" value="<%=current.getId()%>">
							<button name="submit" value="submit" type="submit"><img src="images/delete.png" alt="delete user"></button>
							</form>
						</td>
					</tr>
<%
				}
%>
				</tbody>
				</table>
				</div>
	</div>
</div>
<% }}%>