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
<!DOCTYPE html>
<html lang="en">
	<head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
	    <title><%=getServletContext().getInitParameter("app_name")%></title>
	    <!-- Bootstrap core CSS -->
	    <link href="./css/bootstrap.min.css" rel="stylesheet">

	</head>
	<body>
		<div class="container">

	      <nav class="navbar navbar-inverse navbar-fixed-top">
	        <div class="container">
	          <div class="navbar-header">
	            <a class="navbar-brand" href="#">
		            <%=getServletContext().getInitParameter("app_name")%>
	            </a>
	          </div>

	          <div id="navbar" class="collapse navbar-collapse pull-right">
	            <ul class="nav navbar-nav">
	              <li class=""><a href="login.jsp">Logout</a></li>
	            </ul>
	          </div>
	        </div>
	      </nav>

      <div class="page-header">
        <h1></h1>
      </div>

	   <div class="panel panel-default">
	      <div class="panel-heading">
	        <h3 class="panel-title">Login</h3>
	      </div>
	      <div class="panel-body">
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script>window.jQuery</script>
    <script src="./js/bootstrap.min.js"></script>
  </body>
  </html>