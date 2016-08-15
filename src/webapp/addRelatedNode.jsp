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
	String otherNodeType = (String)(session.getAttribute("otherNodeType"));
	session.removeAttribute("otherNodeType");
	ArrayList<Node> nodes = new ArrayList<Node>();
	if(otherNodeType.equals("Organisation")){
		nodes = MasterGraph.getOrganisationNodes();
	} else if(otherNodeType.equals("Individual")){
		nodes = MasterGraph.getIndividualNodes();
	} else if(otherNodeType.equals("Event")){
		nodes = MasterGraph.getEventNodes();
	} else if(otherNodeType.equals("Publication")){
		nodes = MasterGraph.getPublicationNodes();
	}

	ArrayList<Node> currentNodes = node.getAllRelatedNodes(otherNodeType);
	if(node.getType().getTypeName().equals(otherNodeType))
		currentNodes.add(node);
	ArrayList<EdgeType> ets = MasterGraph.getCompatibleEdgeTypeList(node.getType(), otherNodeType);
	if((nodes.size()-currentNodes.size())<=0){
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Add Relationship to <%= node.getType().getTypeName()%> Node <%= node.getName()%></div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
	There are no <%= otherNodeType %> nodes in the system that this node is not already connected to. Please add the relevant nodes first - <a href="cimap.jsp?tab=nodedetails">click here to go back to node</a>
			</div>
	</div>
</div>

</td>
</tr>
</table>

</center>
<%		
	} else {

%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Add Relationship to <%= node.getType().getTypeName()%> Node <%= node.getName()%></div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="AddOrUpdate">
				<h3>Add Relationship</h3>
				<h4>Node</h4>
				<select name="node">
				<%
					Iterator<Node> i = nodes.iterator();
					Node current;
					while(i.hasNext()){
						current = i.next();
						if(!currentNodes.contains(current)){%>
							<option value="<%= current.getId()%>"><%= current.getName()%></option>	
				<%		}
					}%>
				</select><br />
				<h4>Edge Type</h4>
				<select name="edgeType">
				<%
					Iterator<EdgeType> ie = ets.iterator();
					EdgeType currentEdge;
					while(ie.hasNext()){
						currentEdge = ie.next();
					%>
						<option value="<%= currentEdge.getId() %>"><%= currentEdge.getTypeName() %> - <%= currentEdge.getSubTypeName() %></option>
				<%	}%>
				</select><br />
				<h4>Details</h4>
				<textarea name="details" rows="10" cols="60"><a href="xxx" target="_blank">source</a></textarea><br />
				<h4>Start Date</h4>
					<input type="text" name="startDate"><input type=button value="select" onclick="displayDatePicker('startDate', false, 'dmy');"><br />
				<h4>End Date</h4>
					<input type="text" name="endDate"><input type=button value="select" onclick="displayDatePicker('endDate', false, 'dmy');"><br />

					<input type="hidden" name="update" value="addEdge">
					<input type="hidden" name="nodeId" value="<%= node.getId() %>">
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="submit" name="submit" value="Apply">
							</form>
						</td>
						<td>
							<form method="post" action="NodeDetails">
								<input type="hidden" name="nodeId" value="<%=node.getId()%>">
								<input type="submit" name="submit" value="Cancel">
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
<%}}%>