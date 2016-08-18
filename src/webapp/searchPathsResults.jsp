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
	SearchPathsQuery query = (SearchPathsQuery)(session.getAttribute("pathQuery"));
	ArrayList<Path> paths = (ArrayList<Path>)(session.getAttribute("searchPathsResults"));
%>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Search Path Results</h3>
  </div>
  <div class="panel-body">

  				<div class="well">
					<h4><%= paths.size()%> paths found between <a href="NodeDetails?nodeId=<%=query.getStartNode().getId() %>"><%= query.getStartNode().getName()%></a> and <a href="NodeDetails?nodeId=<%=query.getEndNode().getId() %>"><%= query.getEndNode().getName()%></a> of length less than or equal to <%= query.getMaxLength()%></h4>
					<%
					Iterator<Path> p = paths.iterator();
			        Path path = null;
					if(!p.hasNext()){
					%>
					No paths found that fit your criteria.
					<%
					}
			        while(p.hasNext()){
						path = p.next();
						%><br /><p><%
						Iterator<Node> nodes = path.getNodes().iterator(); 
						Node node = nodes.next();
						%>
						<a href="NodeDetails?nodeId=<%=node.getId() %>"><%= node.getName()%></a>
						<%
						while(nodes.hasNext()){
							node = nodes.next();
							%>
							> <a href="NodeDetails?nodeId=<%=node.getId() %>"><%= node.getName()%></a>
							<%
						}
						%><p><%
					}	
					%>
				</div>			
			<form method="post" action="SearchPaths">
				<button type="submit" name="submit" class="btn btn-primary">Back to Search Page</button>
			</form>
	</div>
</div>

<%
}
%>