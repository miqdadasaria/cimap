<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	int numNodes = MasterGraph.getNumNodes();
	int numEdges = MasterGraph.getNumEdges();
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">CIMAP - Analytics</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
			<%= numNodes %> Nodes and <%= numEdges %> Edges in the Database.
			</div>
	</div>
</div>

</td>
</tr>
</table>

</center>

<%}%>