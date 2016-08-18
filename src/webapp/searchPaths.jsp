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
	ArrayList<Node> nodes = new ArrayList<Node>();
	nodes = MasterGraph.getAllNodes();
%>

	<div class="panel panel-default">
	    <div class="panel-heading">
	        <h3 class="panel-title">Search for Paths</h3>
	    </div>
	    <div class="panel-body">
				<form method="post" action="SearchPaths">
					<input type="hidden" name="pathQuery" value="search">

					<div class="form-group">
					    <label for="startNode">Start Node</label>
					    <select class="selectpicker" data-live-search="true" data-width="fit" id="startNode" name="startNode">
						<%
						Iterator<Node> i = nodes.iterator();
						Node current;
						while(i.hasNext()){
							current = i.next();
							%><option value="<%= current.getId()%>"><%= current.getName()%></option>	
						<%	}%>
						</select>
  					</div>

					<div class="form-group">
					    <label for="endNode">End Node</label>
					    <select class="selectpicker" data-live-search="true" data-width="fit" id="endNode" name="endNode">
						<%
						Iterator<Node> j = nodes.iterator();
						while(j.hasNext()){
							current = j.next();
							%><option value="<%= current.getId()%>"><%= current.getName()%></option>	
						<%	}%>
						</select>
					</div>


					<div class="form-group">
					    <label for="maxLength">Maximum path length</label>
					    <select class="selectpicker" data-live-search="true" data-width="fit" id="maxLength" name="maxLength">
						<% for(int k = 1; k<11; k++){%>
						<option value="<%=k%>" <% if(k==5){%>selected<%}%>><%=k%></option>
						<%}%>
						</select>
					</div>

					<button type="submit" class="btn btn-primary" value="search">Search</button>
				</form>
			</div>
		</div>
<%}%>
