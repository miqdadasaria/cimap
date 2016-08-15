<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
session.removeAttribute("update");

User user = null;
if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	user = ((User)(session.getAttribute("username")));
	Node node = user.getGraph().getSelected();
	if(node == null){
%>
<p><font color="white">You must select a node first (use the search or themes tabs to find nodes)</font></p>
<%
	} else {
	if(session.getAttribute("otherNodeType")!=null){
		response.sendRedirect("addRelatedNode.jsp?otherNodeType=" + session.getAttribute("otherNodeType"));
	} else {

%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Add Relatationship to <%= node.getType().getTypeName()%> Node <%= node.getName()%></div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="AddOrUpdateEdge">
				<h3>Add Relationship</h3>
				<h4>Add Link to Node of Type</h4>
				<select name="otherNodeType">
					<option value="Organisation">Organisation</option>
					<option value="Individual">Individual</option>
					<option value="Event">Event</option>
					<option value="Publication">Publication</option>
				</select><br />
					<input type="hidden" name="update" value="addEdge">
			<p></p>
			<center>
			<table>
				<tr>
					<td>
					<input type="submit" name="submit" value="Next">
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
<% } }}%>