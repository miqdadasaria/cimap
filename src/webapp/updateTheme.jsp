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
	String id = (String)(session.getAttribute("themeid"));
	if(id != null && !id.equals("") && user.getType() >= User.ADMIN){
		int themeId = Integer.parseInt(id);
		Theme theme = MasterGraph.getTheme(themeId);
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Update Theme</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="AddOrUpdate">
					<h3>Update Theme</h3>
					<h4>Name</h4>
					<input type="text" name="name" value="<%= theme.getName()%>"><br />
					<h4>Description</h4>
					<textarea name="description" rows="10" cols="60"><% if(theme.getDetails()!=null){%><%= theme.getDetails()%><%}%></textarea><br />
					<h4>Keywords (comma separated)</h4>
<%
		ArrayList<String> words = theme.getKeywords();
		Iterator<String> w = words.iterator();
		String keywords ="";
		while(w.hasNext())
			keywords=keywords+w.next() + ",";
		if(keywords.length()>0)
			keywords=keywords.substring(0, keywords.length()-1);
%>
					<input type="text" name="keywords" size="60" value="<%= keywords%>"><br />
					<input type="hidden" name="update" value="updateTheme">
					<input type="hidden" name="themeId" value="<%=theme.getId()%>">
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="submit" name="submit" value="Apply">
							</form>
						</td>
						<td>
							<form method="post" action="Themes">
							<input type="hidden" name="themeid" value="<%=theme.getId()%>">
							<input type="submit" name="submit" value="Cancel"><br />
							</form>
						</td>
						</tr>
					</table>
					</center>
			</div>
	</div>
</div>

</td>
</tr>
</table>

</center>
<% }}%>