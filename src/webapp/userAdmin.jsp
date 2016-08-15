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
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">User Details</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
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
				<h3>User Admin</h3>
				<table border="1" cellpadding="6">
					<tr>
						<td><h4><font color="#555555">Name</font></h4></td>
						<td><h4><font color="#555555">Country</font></h4></td>
						<td><h4><font color="#555555">Email</font></h4></td>
						<td><h4><font color="#555555">Orgname</font></h4></td>
						<td><h4><font color="#555555">Username</font></h4></td>
						<td><h4><font color="#555555">Password</font></h4></td>
						<td><h4><font color="#555555">Type</font></h4></td>
						<td><h4><font color="#555555">View Count</font></h4></td>
						<td><h4><font color="#555555">Update Count</font></h4></td>
						<td><h4><font color="#555555">Last Login</font></h4></td>
						<td><h4><font color="#555555">Login Count</font></h4></td>
						<td><h4><font color="#555555">Update User</font></h4></td>
						<td><h4><font color="#555555">Delete User</font></h4></td>
					</tr>
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
				</table>
			</div>
	</div>
</div>

</td>
</tr>
</table>

</center>
<% }}%>