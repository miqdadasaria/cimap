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
%>
	   <div class="panel panel-default">
	      <div class="panel-heading">
	        <h3 class="panel-title">Search</h3>
	      </div>
	      <div class="panel-body">

			<form method="post" action="Search">
			<input type="hidden" name="query" value="search">
			<h3>Search</h3>
			<h4>Name</h4>
			<input type="text" name="name">
			<h4>Background</h4>
			<input type="text" name="background">
			<h4>Node Type</h4>
			<select name="type">
				<option value="All">All</option>
				<option value="Organisation">Organisation</option>
				<option value="Individual">Individual</option>
				<option value="Event">Event</option>
				<option value="Publication">Publication</option>
			</select>
			<h4>Themes</h4>
			Restrict results to only those matched in selected themes (leave all unchecked for unrestricted search)<br />
			<%
				ArrayList<Theme> themes = MasterGraph.getThemeList();
				Iterator<Theme> t = themes.iterator();
				Theme theme;
				while(t.hasNext()){
					theme = t.next();
			%>			
				<%= theme.getName() %> <input type="checkbox" name="themes" value="<%= theme.getId()%>"><br />
			<%  }%>
			<h4>Contact Details</h4>
			<h5>City</h5>
			<input type="text" name="city"><br />
			<h5>State</h5>
			<input type="text" name="state"><br />
			<h5>Country</h5>
			<input type="text" name="country"><br />
			<p></p>
			<center>
			<table>
				<tr>
					<td>
					<input type="submit" name="submit" value="search">
					</td>
				</tr>
			</table>
			</center>
			</form>
		</div>
	</div>
<%}%>