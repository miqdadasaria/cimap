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
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Add News for <%= node.getName()%></div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="AddOrUpdate">
					<h3>Add News Coverage</h3>
					<h4>Headline</h4>
					<input type="text" name="title"><br />
					<h4>Source</h4>
					<input type="text" name="source"><br />
					<h4>Date</h4>
					<input type="text" name="date"><input type=button value="select" onclick="displayDatePicker('date', false, 'dmy');"><br />
					<h4>URL</h4>
					<input type="text" name="url"><br />
					<input type="hidden" name="update" value="news">
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
</div>

</td>
</tr>
</table>

</center>
<% } %>