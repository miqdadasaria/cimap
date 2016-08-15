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
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Themes</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
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
			<h3>Themes</h3>
			<%
				ArrayList<Theme> themes = MasterGraph.getThemeList();
				Iterator<Theme> a = themes.iterator();
				Theme theme;
				while(a.hasNext()){
					theme = a.next();
			%>			
				<a href="Themes?update=themeDetails&themeid=<%= theme.getId() %>"><%= theme.getName() %></a><br />
			<%  }%>

		</div>
	</div>
</div>

</td>
</tr>
</table>

</center>
<%}%>