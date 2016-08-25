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

				<form method="post" name="addnodeform">
			    <%if(node!=null){%>
			    <input type="hidden" name="nodeId" value="<%=node.getId()%>">
			    <%}%>
						    
					<div class="form-group">
					    <label for="name">Name</label>				
					  	<input type="text" name="name" id="name" class="form-control">
					</div>


					<div class="form-group">
					    <label for="type">Node Type</label>				
						  <select name="type" class="selectpicker" data-live-search="true" data-width="fit" id="type">
                <%
        					Iterator<NodeType> i = nts.iterator();
        					NodeType current;
        					while(i.hasNext()){
        						current = i.next();
        				%>
        						<option value="<%= current.getId()%>"><%= current.getTypeName()%> - 
        						<%= current.getSubTypeName()%></option> 
        				<%	}%>
						  </select>
					</div>				
					<input type="hidden" name="update" value="addNode">

          <div class="form-group">
					  <button type="submit" class="btn btn-primary" value="Add" onclick="addNode();">Add</button>
					  <button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelAddNode();">Cancel</button>
					</div>
				</form>
					
  <script>
    function addNode(){
      document.addnodeform.action ="AddOrUpdate";
    }
    function cancelAddNode(){
      document.addnodeform.action = "NodeDetails";
    }
  </script>


	</div>
</div>
<% } }%>