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

				<form method="post" action="AddOrUpdate">
				<%
					Iterator<Theme> i = themes.iterator();
					Theme current;
					while(i.hasNext()){
						current = i.next();
				%>
					<input type="checkbox" name="theme" value="<%= current.getId()%>" 
					<% if(nodeTheme.contains(current)){%>
					checked
					<%}%>
					> <%= current.getName() %><br />
				<%	}%>
					<input type="hidden" name="update" value="theme">
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
<% } %>