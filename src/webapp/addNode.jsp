<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
session.removeAttribute("update");

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	User user = (User)(session.getAttribute("username"));
	if(user.getType() >= User.ADMIN){
		ArrayList<NodeType> nts = MasterGraph.getNodeTypeList();
		Node node = user.getGraph().getSelected();
%>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Add Node</h3>
  </div>
  <div class="panel-body">

				<form method="post" action="AddOrUpdate">
					<h3>Add Node</h3>
					<h4>Name</h4>
					<input type="text" name="name"><br />
					<h4>Type</h4>
					<select name="type">	
				<%
					Iterator<NodeType> i = nts.iterator();
					NodeType current;
					while(i.hasNext()){
						current = i.next();
				%>
						<option value="<%= current.getId()%>"><%= current.getTypeName()%> - <%= current.getSubTypeName()%></option> 
				<%	}%>
					</select><br />
					<input type="hidden" name="update" value="addNode">
					<p></p>
			<center>
			<table>
				<tr>
					<td>
					<input type="submit" name="submit" value="Add">
					</form>
					</td>
					<td>
						<form method="post" action="NodeDetails">
							<%if(node!=null){%>
							<input type="hidden" name="nodeId" value="<%=node.getId()%>">
							<%}%>
							<input type="submit" name="submit" value="Cancel">
						</form>
					</td>

				</tr>
			</table>
			</center>

	</div>
</div>
<% } }%>