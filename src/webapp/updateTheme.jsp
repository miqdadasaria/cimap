<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
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
	String id = (String)(session.getAttribute("themeId"));
	if(id != null && !id.equals("") && user.getType() >= User.ADMIN){
		int themeId = Integer.parseInt(id);
		Theme theme = MasterGraph.getTheme(themeId);
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Update Theme</h3>
  </div>
  <div class="panel-body">

		<form method="post" name="updatethemeform">
			<div class="form-group">
			    <label for="name">Name</label>				
				<input type="text" name="name" id="name" class="form-control" value="<%= theme.getName()%>">
			</div>

			<div class="form-group">
			    <label for="description">Description</label>				
				<textarea name="description" id="description" class="form-control" rows="10" cols="60"><% if(theme.getDetails()!=null){%><%= theme.getDetails()%><%}%></textarea>
			</div>


			<%
			ArrayList<String> words = theme.getKeywords();
			Iterator<String> w = words.iterator();
			String keywords ="";
			while(w.hasNext())
				keywords=keywords+w.next() + ",";
			if(keywords.length()>0)
				keywords=keywords.substring(0, keywords.length()-1);
			%>
			<div class="form-group">
			    <label for="keywords">Keywords (comma separated)</label>				
				<input type="text" name="keywords" id="keywords" class="form-control" value="<%= keywords%>">
			</div>

			<input type="hidden" name="update" id="update" value="updateTheme">
			<input type="hidden" name="themeId" value="<%=theme.getId()%>">

		  <div class="form-group">
		  	<button type="submit" class="btn btn-primary" value="Update" onclick="updateTheme();">Update Themes</button>
		  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelUpdateTheme();">Cancel</button>
	  	  </div>
	</form>

	  <script>
	    function updateTheme(){
	      document.updatethemeform.action = "AddOrUpdate";
	    }
	    function cancelUpdateTheme(){
	      var update = document.getElementById("update");
	      update.value = "";
	      document.updatethemeform.action = "Themes";
	    }
	  </script>

	</div>
</div>

<% }}%>