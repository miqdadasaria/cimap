<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
session.removeAttribute("update");

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	User user = (User)(session.getAttribute("username"));
	if(user.getType() >= User.SUPERUSER){
		int userId = ((Integer)session.getAttribute("userId")).intValue();
		User u = MasterGraph.getUser(userId);
		session.removeAttribute("userId");
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Update User</h3>
  </div>
  <div class="panel-body">

				<form method="post" action="AddOrUpdateUser">
					<h3>Update User</h3>
					<h4>Name</h4>
					<input type="text" name="name" value="<%=u.getName()%>"><br />
					<h4>Photograph URL</h4>
					<input type="text" name="name" <%if(u.getPhotograph()!=null){%>value="<%=u.getPhotograph()%>"<%}%>><br />
					<h4>Country</h4>
					<input type="text" name="country" <%if(u.getCountry()!=null){%>value="<%=u.getCountry()%>"<%}%>><br />
					<h4>Email</h4>
					<input type="text" name="email" <%if(u.getEmail()!=null){%>value="<%=u.getEmail()%>"<%}%>><br />
					<h4>URL</h4>
					<input type="text" name="url" <%if(u.getUrl()!=null){%>value="<%=u.getUrl()%>"<%}%>><br />
					<h4>Orgname</h4>
					<input type="text" name="orgname" <%if(u.getOrgName()!=null){%>value="<%=u.getOrgName()%>"<%}%>><br />
					<h4>Biography</h4>
					<textarea name="bio"><%if(u.getBio()!=null){%><%=u.getBio()%><%}%></textarea><br />
					<h4>Username</h4>
					<input type="text" name="username" value="<%=u.getUsername()%>"><br />
					<h4>Password</h4>
					<input type="text" name="password" value="<%=u.getPassword()%>"><br />
					<h4>Type</h4>
					<select name="type">
					<%
						String typeText = "Super User";
						if(u.getType()==3){
							typeText = "Normal";
						} else if(u.getType()==5){
							typeText = "Admin";
						}
					%>
						<option value="<%=u.getType()%>"><%= typeText%></option>
						<option value="3">Normal</option>
						<option value="5">Admin</option>
						<option value="6">Super User</option>
					</select><br />
					<h4>View Quota</h4>
					<input type="text" name="viewQuota" value="<%=u.getNodeViewQuota()%>"><br />
					<h4>Update Quota</h4>
					<input type="text" name="updateQuota" value="<%=u.getNodeUpdateQuota()%>"><br />
					<input type="hidden" name="userId" value="<%=u.getId()%>">
					<input type="hidden" name="update" value="updateUser2">
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="submit" name="submit" value="Apply">
							</form>
						</td>
						<td>
							<form method="post" action="cimap.jsp?tab=useradmin">
								<input type="submit" name="submit" value="Cancel">
							</form>
						</td>
						</tr>
					</table>
					</center>
	</div>
</div>
<% } }%>