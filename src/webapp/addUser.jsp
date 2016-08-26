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
	if(user.getType() >= User.SUPERUSER){
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Add User</h3>
  </div>
  <div class="panel-body">

	<form method="post" name="adduserform">
		<div class="form-group">
		    <label for="name">Name</label>				
		  	<input type="text" name="name" id="name" class="form-control">
		</div>

		<div class="form-group">
		    <label for="country">Country</label>				
		  	<input type="text" name="country" id="country" class="form-control">
		</div>


		<div class="form-group">
		    <label for="email">Email</label>				
		  	<input type="email" name="email" id="email" class="form-control">
		</div>

		<div class="form-group">
		    <label for="url">URL</label>				
		  	<input type="url" name="url" id="url" class="form-control">
		</div>

		<div class="form-group">
		    <label for="orgname">Orgname</label>				
		  	<input type="text" name="orgname" id="orgname" class="form-control">
		</div>

		<div class="form-group">
		    <label for="bio">Biography</label>				
		  	<textarea name="bio" id="bio" class="form-control" rows="10" cols="60"></textarea>
		</div>

		<div class="form-group">
		    <label for="username">Username</label>				
		  	<input type="text" name="username" id="username" class="form-control">
		</div>

		<div class="form-group">
		    <label for="password">Password</label>				
		  	<input type="password" name="password" id="password" class="form-control">
		</div>

		<div class="form-group">
		    <label for="type">Type</label>
		    <select class="selectpicker" data-live-search="true" data-width="fit" id="type" name="type">
				<option value="3">Normal</option>
				<option value="5">Admin</option>
			</select>
		</div>

		<input type="hidden" name="update" value="addUser2">
		  <div class="form-group">
		  	<button type="submit" class="btn btn-primary" value="Update" onclick="addUser();">Add User</button>
		  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelAddUser();">Cancel</button>
		  	
	  	  </div>
	</form>

  <script>
    function addUser(){
      document.adduserform.action = "AddOrUpdateUser";
    }
    function cancelAddUser(){
      document.adduserform.action = "cimap.jsp?tab=useradmin";
    }
  </script>


	</div>
</div>
<% } }%>