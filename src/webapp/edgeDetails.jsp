<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
session.removeAttribute("update");

Edge edge;
Node node;
if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	User user = (User)(session.getAttribute("username"));
	edge = user.getGraph().getSelectedEdge();
	node = user.getGraph().getSelected();
	if(edge==null){
%>
	<p><font color="white">please select an edge first (via a participating node)</font></p>
<%
	}else{
		Node node1 = edge.getNodes().get(0);
		Node node2 = edge.getNodes().get(1);
		DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");

%>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Relationship Between <a href="NodeDetails?nodeId=<%= node1.getId()%>"><%= node1.getName() %></a> and <a href="NodeDetails?nodeId=<%= node2.getId()%>"><%= node2.getName() %></a></h3>
  </div>
  <div class="panel-body">


			<% if(user.getType() >=User.ADMIN){%>
				<p align="right">
				<table>
				<tr>
					<td>
						<form method="post" action="EdgeDetails">
						<input type="hidden" name="update" value="updateEdge" />
						<input type="hidden" name="edgeId" value="<%= edge.getId()%>" />
						<button name="submit" value="submit" type="submit"><img src="images/update.png" alt="update relationship" border="0"></button>
						</form>
					</td>
					<td>
						<form method="post" action="AddOrUpdateEdge"onsubmit="return confirmDeleteEdge()">
						<input type="hidden" name="update" value="deleteEdge" />
						<input type="hidden" name="edgeId" value="<%= edge.getId()%>" />
						<button name="submit" value="submit" type="submit"><img src="images/delete.png" alt="delete relationship"></button>
						</form>
					</td>
				</tr>
				</table>
				</p>
			<%}%>

			<h4>Relationship Type:</h4> <%= edge.getType().getTypeName() %> - <%= edge.getType().getSubTypeName() %><br />
			<% if(edge.getStartDate() != null){ %>
			<h4>Start Date:</h4> <%= fmt.format(edge.getStartDate()) %><br />
			<%}%>
			<% if(edge.getEndDate() != null){ %>
			<h4>End Date:</h4> <%= fmt.format(edge.getEndDate()) %><br />
			<%}%>
			<% if(edge.getDetails() != null){ %>
			<h4>Details:</h4> <%= edge.getDetails() %><br />
			<%}%>
			<h4>Audit Info:</h4> 
			<% if(edge.getAddedBy() != null){%>
			Created by: <%= edge.getAddedBy().getName() %><br />
			<%}%>
			Creation date: <%= edge.getDateAdded() %><br />
			<% if(edge.getModBy() != null){%>
			Last modified by: <%= edge.getModBy().getName() %><br />
			<%}%>
			Last modfied date: <%= edge.getLastModified() %><br />

			<form method="post" action="NodeDetails">
			<input class="btn btn-primary" type="submit" name="submit" value="Back" />
			<input type="hidden" name="nodeId" value="<%= node.getId()%>" />
			</form>

	</div>
</div>
<%}}%>