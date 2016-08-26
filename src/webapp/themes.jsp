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
} else{
	User user = (User)(session.getAttribute("username"));
%>

	   <div class="panel panel-default">
	      <div class="panel-heading">
	        <h3 class="panel-title">Themes</h3>
	      </div>
	      <div class="panel-body">
				<%
				if(user.getType() >= User.ADMIN){
				%>
					<form method="post" action="Themes">
					<input type="hidden" name="update" value="addTheme">
					<p align="right"><button name="submit" value="submit" type="submit"><img src="images/new.png" alt="add new theme"></button></p>
					</form>
				<%
				}
				%>

			<div class="list-group">
			<%
				ArrayList<Theme> themes = MasterGraph.getThemeList();
				Iterator<Theme> a = themes.iterator();
				Theme theme;
				while(a.hasNext()){
					theme = a.next();
			%>			
				<a href="Themes?update=themeDetails&themeId=<%= theme.getId() %>" class="list-group-item"><%= theme.getName() %></a><br />
			<%  }%>
			</div>

			</div>
		</div>
<%}%>