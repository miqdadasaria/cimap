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
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Search for Paths</div>
	<div class="element contained-item">
		<div class="inner" id="inner-details">
			<form method="post" action="SearchPaths">
			<input type="hidden" name="pathQuery" value="search">
			<h3>Search for Paths</h3>
			<h4>Start Node</h4>
				<select name="startNode">
				<%
					Iterator<Node> i = nodes.iterator();
					Node current;
					while(i.hasNext()){
						current = i.next();
						%><option value="<%= current.getId()%>"><%= current.getName()%></option>	
				<%	}%>
				</select><br />
			<h4>End Node</h4>
				<select name="endNode">
				<%
					Iterator<Node> j = nodes.iterator();
					while(j.hasNext()){
						current = j.next();
						%><option value="<%= current.getId()%>"><%= current.getName()%></option>	
				<%	}%>
				</select><br />
			<h4>Max Path Length<h4>
				<select name="maxLength">
					<% for(int k = 1; k<11; k++){%>
					<option value="<%=k%>" <% if(k==5){%>selected<%}%>><%=k%></option>
					<%}%>
				</select>
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

</div>

</td>
</tr>
</table>

</center>
<%}%>
