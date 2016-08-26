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
	Node node = user.getGraph().getSelected();
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Add News for <%= node.getName()%></h3>
  </div>
  <div class="panel-body">

	<form method="post" name="newsform">
		<div class="form-group">
		    <label for="name">Headline</label>				
		  	<input type="text" name="title" id="title" class="form-control">
		</div>		

		<div class="form-group">
		    <label for="name">Source</label>				
		  	<input type="text" name="source" id="source" class="form-control">
		</div>	

		<div class="form-group">
		    <label for="name">Date</label>				
		  	<input type="date" name="date" id="date" class="form-control">
		</div>

		<div class="form-group">
		    <label for="name">URL</label>				
		  	<input type="url" name="url" id="url" class="form-control">
		</div>

		<input type="hidden" name="update" value="news">
		<input type="hidden" name="nodeId" value="<%=node.getId()%>">

	  <div class="form-group">
	  	<button type="submit" class="btn btn-primary" value="Add News" onclick="addNews();">Add News</button>
	  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelAddNews();">Cancel</button>	
  	  </div>
	</form>

  <script>
    function addNews(){
      document.newsform.action = "AddOrUpdate";
    }
    function cancelAddNews(){
      document.newsform.action = "NodeDetails";
    }
  </script>

</div>
</div>
<% } %>