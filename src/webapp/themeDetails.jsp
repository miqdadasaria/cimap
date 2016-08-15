<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
session.removeAttribute("update");

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {

String id = (String)(session.getAttribute("themeid"));
if(id != null && !id.equals("")){
int themeId = Integer.parseInt(id);
Theme theme = MasterGraph.getTheme(themeId);
ArrayList<Node> orgMatches = MasterGraph.getOrganisationNodesByTheme(theme);
ArrayList<Node> indMatches = MasterGraph.getIndividualNodesByTheme(theme);
ArrayList<Node> eveMatches = MasterGraph.getEventNodesByTheme(theme);
ArrayList<Node> pubMatches = MasterGraph.getPublicationNodesByTheme(theme);
User user = (User)(session.getAttribute("username"));
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Theme: <%= theme.getName() %></div>
	<div class="element contained-item">
		<div class="inner" id="inner-details">
<%
if(user.getType() >= User.ADMIN){
%>
			<p align="right">
			<table>
			<tr>
				<td>
					<form method="post" action="Themes">
					<input type="hidden" name="themeid" value="<%= theme.getId() %>">
					<input type="hidden" name="update" value="updateTheme">
					<button name="submit" value="submit" type="submit"><img src="images/update.png" alt="update theme" border="0"></button>
					</form>
				</td>
				<td>
					<form method="post" action="AddOrUpdate" onsubmit="return confirmDeleteTheme('<%=theme.getName()%>')">
					<input type="hidden" name="themeId" value="<%= theme.getId() %>">
					<input type="hidden" name="update" value="deleteTheme">
					<button name="submit" value="submit" type="submit"><img src="images/delete.png" alt="delete theme"></button>
					</form>
				</td>
			</tr>
			</table>
			</p>
<%
}
%>
		<h3>Theme</h3>
		<h4>Name</h4>
		<p><%= theme.getName() %></p>
		<h4>Description</h4>
		<p><% if(theme.getDetails()!=null){%><%=theme.getDetails()%><%}%></p>
		<h4>Keywords</h4>
		<p>
<%
		ArrayList<String> words = theme.getKeywords();
		Iterator<String> w = words.iterator();
		while(w.hasNext())
			out.print(w.next() + " ");
%>
		</p>
		<h4>Matching Nodes</h4>
		<h5>Organisations</h5>
<%
			Iterator<Node> i = orgMatches.iterator();
			Node current;
	        if(!i.hasNext()){
%>
			No organisations found for theme: <%= theme.getName() %><br />
<%
			}
	        while(i.hasNext()){
				current = i.next();
%>
				<a href="NodeDetails?nodeId=<%= current.getId() %>"><%= current.getName() %></a><br />
<%
			}	
%>

		<h5>Individuals</h5>
<%
			Iterator<Node> j = indMatches.iterator();
	        if(!j.hasNext()){
%>
			No individuals found for theme: <%= theme.getName() %><br />
<%
			}
	        while(j.hasNext()){
				current = j.next();
%>
				<a href="NodeDetails?nodeId=<%= current.getId() %>"><%= current.getName() %></a><br />
<%
			}	
%>
		<h5>Events</h5>
<%
			Iterator<Node> k = eveMatches.iterator();
	        if(!k.hasNext()){
%>
			No events found for theme: <%= theme.getName() %><br />
<%
			}
	        while(k.hasNext()){
				current = k.next();
%>
				<a href="NodeDetails?nodeId=<%= current.getId() %>"><%= current.getName() %></a><br />
<%
			}	
%>
		<h5>Publications</h5>
<%
			Iterator<Node> l = pubMatches.iterator();
	        if(!l.hasNext()){
%>
			No publications found for theme: <%= theme.getName() %><br />
<%
			}
	        while(l.hasNext()){
				current = l.next();
%>
				<a href="NodeDetails?nodeId=<%= current.getId() %>"><%= current.getName() %></a><br />
<%
			}	
%>
		
		<br />
			<center>
			<hr width="80%" />
			<p></p>
			<table>
				<tr>
				<td>
					<form method="post" action="Themes">
					<input type="submit" name="submit" value="Back to Themes Page"><br />
					</form>
				</td>
				</tr>
			</table>
			</center>
		</div>
	</div>
</div>

</td>
</tr>
</table>

</center>
<% } else {
%>
<p><font color="white">No theme selected</font></p>
<%
}} %>