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
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Add Theme</h3>
  </div>
  <div class="panel-body">

	<form method="post" name="addthemeform">

		<div class="form-group">
		    <label for="name">Name</label>				
			<input type="text" name="name" id="name" class="form-control">
		</div>

		<div class="form-group">
		    <label for="description">Description</label>				
			<textarea name="description" id="description" class="form-control" rows="10" cols="60"></textarea>
		</div>

		<div class="form-group">
		    <label for="keywords">Keywords (comma separated)</label>				
			<input type="text" name="keywords" id="keywords" class="form-control">
		</div>

		<input type="hidden" name="update" id="update" value="addTheme">

		  <div class="form-group">
		  	<button type="submit" class="btn btn-primary" value="Add Theme" onclick="addTheme();">Add Themes</button>
		  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelAddTheme();">Cancel</button>
	  	  </div>
	</form>

	  <script>
	    function addTheme(){
	      document.addthemeform.action = "AddOrUpdate";
	    }
	    function canceladdTheme(){
	      var update = document.getElementById("update");
	      update.value = "";
	      document.addthemeform.action = "Themes";
	    }
	  </script>
	
	</div>
</div>

<% }%>