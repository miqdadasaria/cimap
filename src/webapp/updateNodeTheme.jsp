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
	Node node = user.getGraph().getSelected();
	ArrayList<Theme> nodeTheme = node.getThemes();
	ArrayList<Theme> themes = MasterGraph.getThemeList();
%>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Update Node Themes</h3>
  </div>
  <div class="panel-body">

	<form method="post" name="updatenodethemeform">

		<div class="form-group">
		    <label for="theme">Themes</label>
		    <select name="theme" class="selectpicker" data-live-search="true" data-width="fit" id="theme" multiple>   		
		    <%
			Iterator<Theme> i = themes.iterator();
			Theme current;
			while(i.hasNext()){
			current = i.next();
			%>			
			<option value="<%= current.getId()%>"
				<% if(nodeTheme.contains(current)){%> selected<%}%>>
				<%= current.getName() %></option>
			<%  }%>
			</select>
		</div>
	<%

	%>

		<input type="hidden" name="update" value="theme">

		<input type="hidden" name="nodeId" value="<%=node.getId()%>">

		  <div class="form-group">
		  	<button type="submit" class="btn btn-primary" value="Update" onclick="updateNodeTheme();">Update Node Themes</button>
		  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelUpdateNodeTheme();">Cancel</button>
		  	
	  	  </div>
	</form>

  <script>
    function updateNodeTheme(){
      document.updatenodethemeform.action = "AddOrUpdate";
    }
    function cancelUpdateNodeTheme(){
      document.updatenodethemeform.action = "NodeDetails";
    }
  </script>

	</div>
</div>
<% } %>