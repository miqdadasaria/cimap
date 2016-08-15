<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 

if(session.getAttribute("username") != null && (((User)(session.getAttribute("username"))).isLoggedIn())){
	User user = ((User)(session.getAttribute("username")));
	user.logout();
	session.removeAttribute("username");
	session.invalidate();
}
%>

<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Login</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="Login">
					<h3>Login</h3>
					<h4>Username</h4>
					<input type="text" name="username">
					<h4>Password</h4>
					<input type="password" name="password">
					<center>
					<p></p>
					<table>
						<tr>
						<td>
							<input type="submit" name="Login" value="Login">
						</td>
						</tr>
					</table>
					</center>
				</form>
			</div>
	</div>
</div>

</td>
</tr>
</table>

</center>