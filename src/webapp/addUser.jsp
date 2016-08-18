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
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Add User</h3>
  </div>
  <div class="panel-body">


				<form method="post" action="AddOrUpdateUser">
					<h3>Add User</h3>
					<h4>Name</h4>
					<input type="text" name="name"><br />
					<h4>Country</h4>
					<input type="text" name="country"><br />
					<h4>Email</h4>
					<input type="text" name="email"><br />
					<h4>URL</h4>
					<input type="text" name="url"><br />
					<h4>Orgname</h4>
					<input type="text" name="orgname"><br />
					<h4>Biography</h4>
					<textarea name="bio"></textarea><br />
					<h4>Username</h4>
					<input type="text" name="username"><br />
					<h4>Password</h4>
					<input type="text" name="password"><br />
					<h4>Type</h4>
					<select name="type">
						<option value="3">Normal</option>
						<option value="5">Admin</option>
					</select><br />
					<input type="hidden" name="update" value="addUser2">
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