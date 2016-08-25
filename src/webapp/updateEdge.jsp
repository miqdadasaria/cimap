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

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	User user = (User)(session.getAttribute("username"));
	if(user.getType() >= User.ADMIN){
		Edge edge = user.getGraph().getSelectedEdge();
		if(edge==null){
%>
			<p><font color="white">please select and edge first (via a participating node)</font></p>
<%		
		} else {
		Node node1 = edge.getNodes().get(0);
		Node node2 = edge.getNodes().get(1);

		ArrayList<EdgeType> ets = MasterGraph.getEdgeTypeList();
		DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");

%>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Relationship Between <%= node1.getName() %> and <%= node2.getName() %></h3>
  </div>
  <div class="panel-body">

	<form method="post" name="updateedgeform">

		<div class="form-group">
		    <label for="edgeType">Relationship Type</label>
		    <select class="selectpicker" data-live-search="true" data-width="fit" id="edgeType" name="edgeType">
				<%
					Iterator<EdgeType> i = ets.iterator();
					EdgeType current;
					while(i.hasNext()){
						current = i.next();
						if(current.getTypeName().equals(edge.getType().getTypeName())){
				%>
						<option value="<%= current.getId() %>" <% if(edge.getType().getId() == current.getId()){ out.print("selected");}%>><%= current.getTypeName() %> - <%= current.getSubTypeName() %></option>
				<%	}
				}%>
			</select>
		</div>

		<div class="form-group">
		    <label for="details">Details</label>				
			<textarea name="details" id="details" class="form-control" rows="10" cols="60"><%	if(edge.getDetails() != null){ out.print(edge.getDetails());}else{%><a href="xxx" target="_blank">source</a><%}%></textarea>
		</div>

		<div class="form-group">
			<label for="startDate">Start Date</label>	
			<input class="form-control" type="date" id="startDate" name="startDate" <% if(edge.getStartDate() != null){ out.print("value=\"" + fmt.format(edge.getStartDate()) +"\"");}%>>
	    </div>

	    <div class="form-group">
			<label for="endDate">End Date</label>	
			<input class="form-control" type="date" id="endDate" name="endDate" <% if(edge.getEndDate() != null){ out.print("value=\"" + fmt.format(edge.getEndDate()) +"\"");}%>>
	    </div>			

		<input type="hidden" name="update" value="updateEdge">
		<input type="hidden" name="edgeId" value="<%= edge.getId() %>">

	  <div class="form-group">
	  	<button type="submit" class="btn btn-primary" value="Update" onclick="updateEdge();">Update Relationship</button>
	  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelUpdateEdge();">Cancel</button>
	  	
  	  </div>
	</form>

  <script>
    function updateEdge(){
      document.updateedgeform.action = "AddOrUpdateEdge";
    }
    function cancelUpdateEdge(){
      document.updateedgeform.action = "EdgeDetails";
    }
  </script>

	
	</div>
</div>
<% }} }%>