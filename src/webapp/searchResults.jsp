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
}else{
	User user = (User)(session.getAttribute("username"));
	SearchQuery query = (SearchQuery)(session.getAttribute("query"));
	String type = query.getNodeTypeName();
	Node current;
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">

<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Search Results</div>
	<div class="element contained-item">
		<div class="inner" id="inner-details">
				<p align="right">
				<table>
					<tr>
				<% if(user.getType() >=User.ADMIN && MasterGraph.getContactLists().size() > 0){%>
						<td valign="top">
							<form method="post" action="ContactLists">
							<input type="hidden" name="update" value="searchResults">
							<button name="submit" value="submit" type="submit"><img src="images/contacts.png" alt="export to contacts list"></button>
							</form>
						</td>
				<%}%>
					</tr>
				</table>
				</p>
				<h3>Search Results</h3>
<%
if(type.equals("All") || type.equals("Organisation")){	
%>
		<h4>Organisations</h4>
<%
			ArrayList<Node> orgResults = (ArrayList<Node>)session.getAttribute("orgSearchResults");
			Iterator<Node> i = orgResults.iterator();
	        if(!i.hasNext()){
%>
			No matching organisations found
<%
			}
	        while(i.hasNext()){
				current = i.next();
%>
				<a href="NodeDetails?nodeId=<%=current.getId() %>"><%=current.getName() %></a><br />
<%
			}	
%>
<%
}
if(type.equals("All") || type.equals("Individual")){	
%>
		<h4>Individuals</h4>
<%
			ArrayList<Node> indResults = (ArrayList<Node>)session.getAttribute("indSearchResults");
			Iterator<Node> j = indResults.iterator();
	        if(!j.hasNext()){
%>
			No matching individuals found
<%
			}
	        while(j.hasNext()){
				current = j.next();
%>
				<a href="NodeDetails?nodeId=<%=current.getId() %>"><%=current.getName() %></a><br />
<%
			}	
%>
<%
}
if(type.equals("All") || type.equals("Event")){	
%>
		<h4>Events</h4>
<%
			ArrayList<Node> eveResults = (ArrayList<Node>)session.getAttribute("eveSearchResults");
			Iterator<Node> k = eveResults.iterator();
	        if(!k.hasNext()){
%>
			No matching events found
<%
			}
	        while(k.hasNext()){
				current = k.next();
%>
				<a href="NodeDetails?nodeId=<%=current.getId() %>"><%=current.getName() %></a><br />
<%
			}	
%>
<%
}
if(type.equals("All") || type.equals("Publication")){	
%>
		<h4>Publications</h4>
<%
			ArrayList<Node> pubResults = (ArrayList<Node>)session.getAttribute("pubSearchResults");
			Iterator<Node> l = pubResults.iterator();
	        if(!l.hasNext()){
%>
			No matching publications found
<%
			}
	        while(l.hasNext()){
				current = l.next();
%>
				<a href="NodeDetails?nodeId=<%=current.getId() %>"><%=current.getName() %></a><br />
<%
			}	
%>
<%
}
%>
			
			<hr width="80%" />
			<p></p>
				<center>
				<table>
					<tr>
						<td valign="top">
							<form method="post" action="Search">
							<input type="submit" name="submit" value="Back to Search Page"><br />
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
<%}%>