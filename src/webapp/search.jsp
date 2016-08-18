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

					<div class="form-group">
					    <label for="name">Name</label>				
						<input type="text" name="name" id="name" class="form-control">
					</div>
					
					<div class="form-group">
					    <label for="background">Background</label>				
						<input type="text" name="background" id="background" class="form-control">
					</div>
					
					<div class="form-group">
					    <label for="type">Node Type</label>				
						<select name="type" class="selectpicker" data-live-search="true" data-width="fit" id="type">
							<option value="All">All</option>
							<option value="Organisation">Organisation</option>
							<option value="Individual">Individual</option>
							<option value="Event">Event</option>
							<option value="Publication">Publication</option>
						</select>
					</div>
					
					<div class="form-group">
					    <label for="theme">Themes</label>
					    <select name="theme" class="selectpicker" data-live-search="true" data-width="fit" id="theme" multiple>   		<%
						ArrayList<Theme> themes = MasterGraph.getThemeList();
						Iterator<Theme> t = themes.iterator();
						Theme theme;
						while(t.hasNext()){
							theme = t.next();
						%>			
						<option value="<%= theme.getId()%>"><%= theme.getName() %></option>
						<%  }%>
						</select>
					</div>
					
					<div class="form-group">
					    <label for="city">City</label>				
						<input type="text" name="city" id="city" class="form-control">
					</div>
					
					<div class="form-group">
					    <label for="state">State</label>				
						<input type="text" name="state" id="state" class="form-control">
					</div>
					
					<div class="form-group">
					    <label for="country">Country</label>				
						<input type="text" name="country" id="country" class="form-control">
					</div>			
					
					<button type="submit" class="btn btn-primary" value="search">Search</button>
				</form>

		</div>
	</div>
<%}%>