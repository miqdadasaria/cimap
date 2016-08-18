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
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Add Theme</h3>
  </div>
  <div class="panel-body">

				<form method="post" action="AddOrUpdate">
					<h3>Add Theme</h3>
					<h4>Name</h4>
					<input type="text" name="name"><br />
					<h4>Description</h4>
					<textarea name="description" rows="10" cols="60"></textarea><br />
					<h4>Keywords (comma separated)</h4>
					<input type="text" name="keywords" size="60"><br />
					<input type="hidden" name="update" value="addTheme">
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="submit" name="submit" value="Add">
							</form>
						</td>
						<td>
							<form method="post" action="Themes">
							<input type="submit" name="submit" value="Cancel"><br />
							</form>
						</td>
						</tr>
					</table>
					</center>
	</div>
</div>

<% }%>