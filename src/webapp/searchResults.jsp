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
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Search Results</h3>
  </div>
  <div class="panel-body">

	<%
	if(type.equals("All") || type.equals("Organisation")){	
	%>
			<h4>Organisations</h4>
			<div class="list-group">
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
					<a href="NodeDetails?nodeId=<%=current.getId() %>" class="list-group-item"><%=current.getName() %></a><br />
	<%
				}	
	%>
			</div>
	<%
	}
	if(type.equals("All") || type.equals("Individual")){	
	%>
			<h4>Individuals</h4>
			<div class="list-group">
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
					<a href="NodeDetails?nodeId=<%=current.getId() %>" class="list-group-item"><%=current.getName() %></a><br />
	<%
				}	
	%>
			</div>
	<%
	}
	if(type.equals("All") || type.equals("Event")){	
	%>
			<h4>Events</h4>
			<div class="list-group">
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
					<a href="NodeDetails?nodeId=<%=current.getId() %>" class="list-group-item"><%=current.getName() %></a><br />
	<%
				}	
	%>
			</div>
	<%
	}
	if(type.equals("All") || type.equals("Publication")){	
	%>
			<h4>Publications</h4>
			<div class="list-group">
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
					<a href="NodeDetails?nodeId=<%=current.getId() %>" class="list-group-item"><%=current.getName() %></a><br />
	<%
				}	
	%>
			</div>
	<%
	}
	%>
				
	<hr width="80%" />
	<form method="post" action="Search">
		<button type="submit" class="btn btn-primary" value="Back to Search Page">Back to Search Page</button>
	</form>

	</div>
</div>

<%}%>