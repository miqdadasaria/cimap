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
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Add Relationship to <%= node.getType().getTypeName()%> Node: <%= node.getName()%></h3>
  </div>
  <div class="panel-body">
<%
	if((nodes.size()-currentNodes.size())<=0){
%>

	There are no <%= otherNodeType %> nodes in the system that this node is not already connected to. Please add the relevant nodes first - <a href="cimap.jsp?tab=nodedetails">click here to go back to node</a>

<%		
	} else {

%>

	<form method="post" name="relatednodeform">

		<div class="form-group">
		    <label for="node">Node</label>
		    <select class="selectpicker" data-live-search="true" data-width="fit" id="node" name="node">
			<%
			Iterator<Node> i = nodes.iterator();
			Node current;
			while(i.hasNext()){
				current = i.next();
				%><option value="<%= current.getId()%>"><%= current.getName()%></option>	
			<%	}%>
			</select>
		</div>

		<div class="form-group">
		    <label for="edgeType">Edge Type</label>
		    <select class="selectpicker" data-live-search="true" data-width="fit" id="edgeType" name="edgeType">
			<%
			Iterator<EdgeType> ie = ets.iterator();
			EdgeType currentEdge;
			while(ie.hasNext()){
				currentEdge = ie.next();
			%>
			<option value="<%= currentEdge.getId() %>"><%= currentEdge.getTypeName() %> - <%= currentEdge.getSubTypeName() %></option>
			<%	}%>
			</select>
		</div>

		<div class="form-group">
		    <label for="details">Details</label>				
			<textarea name="details" id="details" class="form-control" rows="10" cols="60"><a href="xxx" target="_blank">source</a></textarea>
		</div>

	  <div class="form-group">
		<label for="startDate">Start Date</label>	
		<input class="form-control" type="date" id="startDate" name="startDate">
      </div>

      <div class="form-group">
		<label for="endDate">End Date</label>	
		<input class="form-control" type="date" id="endDate" name="endDate">
      </div>

	<input type="hidden" name="update" value="addEdge">
	<input type="hidden" name="nodeId" value="<%= node.getId() %>">

		  <div class="form-group">
		  	<button type="submit" class="btn btn-primary" value="Update" onclick="addRelNode();">Add Related Node</button>
		  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelAddRelNode();">Cancel</button>
		  	
	  	  </div>
	</form>

  <script>
    function addRelNode(){
      document.relatednodeform.action = "AddOrUpdate";
    }
    function cancelAddRelNode(){
      document.relatednodeform.action = "NodeDetails";
    }
  </script>
	

<%}%>
	</div>
</div>
<%}%>