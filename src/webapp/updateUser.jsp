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
		int userId = ((Integer)session.getAttribute("userId")).intValue();
		User u = MasterGraph.getUser(userId);
		session.removeAttribute("userId");
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Update User</h3>
  </div>
  <div class="panel-body">

	<form method="post" name="updateuserform">
		<div class="form-group">
		    <label for="name">Name</label>				
		  	<input type="text" name="name" id="name" class="form-control" value="<%=u.getName()%>">
		</div>

		<div class="form-group">
		    <label for="country">Country</label>				
		  	<input type="text" name="country" id="country" class="form-control" <%if(u.getCountry()!=null){%>value="<%=u.getCountry()%>"<%}%>>
		</div>


		<div class="form-group">
		    <label for="email">Email</label>				
		  	<input type="email" name="email" id="email" class="form-control" <%if(u.getEmail()!=null){%>value="<%=u.getEmail()%>"<%}%>>
		</div>

		<div class="form-group">
		    <label for="url">URL</label>				
		  	<input type="url" name="url" id="url" class="form-control" <%if(u.getUrl()!=null){%>value="<%=u.getUrl()%>"<%}%>>
		</div>

		<div class="form-group">
		    <label for="orgname">Orgname</label>				
		  	<input type="text" name="orgname" id="orgname" class="form-control" <%if(u.getOrgName()!=null){%>value="<%=u.getOrgName()%>"<%}%>>
		</div>

		<div class="form-group">
		    <label for="bio">Biography</label>				
		  	<textarea name="bio" id="bio" class="form-control" rows="10" cols="60"><%if(u.getBio()!=null){%><%=u.getBio()%><%}%></textarea>
		</div>

		<div class="form-group">
		    <label for="username">Username</label>				
		  	<input type="text" name="username" id="username" class="form-control" value="<%=u.getUsername()%>">
		</div>

		<div class="form-group">
		    <label for="password">Password</label>				
		  	<input type="password" name="password" id="password" class="form-control" value="<%=u.getPassword()%>">
		</div>

		<div class="form-group">
		    <label for="type">Type</label>
		    <select class="selectpicker" data-live-search="true" data-width="fit" id="type" name="type">
				<%
					String typeText = "Super User";
					if(u.getType()==3){
						typeText = "Normal";
					} else if(u.getType()==5){
						typeText = "Admin";
					}
				%>
				<option value="<%=u.getType()%>"><%= typeText%></option>
				<option value="3">Normal</option>
				<option value="5">Admin</option>
				<option value="6">Super User</option>
			</select>
		</div>

		<div class="form-group">
		    <label for="viewQuota">View Quota</label>				
		  	<input type="text" name="viewQuota" id="viewQuota" class="form-control" value="<%=u.getNodeViewQuota()%>">
		</div>

		<div class="form-group">
		    <label for="updateQuota">Update Quota</label>				
		  	<input type="text" name="updateQuota" id="updateQuota" class="form-control" value="<%=u.getNodeUpdateQuota()%>">
		</div>

		<input type="hidden" name="userId" value="<%=u.getId()%>">
		<input type="hidden" name="update" value="updateUser2">

		  <div class="form-group">
		  	<button type="submit" class="btn btn-primary" value="Update" onclick="updateUser();">Update User</button>
		  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelUpdateUser();">Cancel</button>
		  	
	  	  </div>
	</form>

  <script>
    function updateUser(){
      document.updateuserform.action = "AddOrUpdateUser";
    }
    function cancelUpdateUser(){
      document.updateuserform.action = "cimap.jsp?tab=useradmin";
    }
  </script>								

	</div>
</div>
<% } }%>