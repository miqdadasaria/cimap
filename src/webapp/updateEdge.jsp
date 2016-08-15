<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
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
	if(user.getType() >= User.ADMIN){
		Edge edge = user.getGraph().getSelectedEdge();
		if(edge==null){
%>
			<p><font color="white">please select and edge first (via a participating node)</font></p>
<%		
		} else {
		Node node1 = edge.getNodes().get(0);
		Node node2 = edge.getNodes().get(1);

		ArrayList<EdgeType> ets = MasterGraph.getEdgeTypeList();
		DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");

%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Relationship Between <%= node1.getName() %> and <%= node2.getName() %></div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="AddOrUpdateEdge">
				<h3>Update Relationship</h3>
				<h4>Relationship Type</h4>
				<select name="edgeType">
				<%
					Iterator<EdgeType> i = ets.iterator();
					EdgeType current;
					while(i.hasNext()){
						current = i.next();
						if(current.getTypeName().equals(edge.getType().getTypeName())){
				%>
						<option value="<%= current.getId() %>" <% if(edge.getType().getId() == current.getId()){ out.print("selected");}%>><%= current.getTypeName() %> - <%= current.getSubTypeName() %></option>
				<%	}
				}%>
				</select><br />
				<h4>Details</h4>
				<textarea name="details" rows="10" cols="60"><%	if(edge.getDetails() != null){ out.print(edge.getDetails());}else{%><a href="xxx" target="_blank">source</a><%}%></textarea><br />
				<h4>Start Date</h4>
					<input type="text" name="startDate" <% if(edge.getStartDate() != null){ out.print("value=\"" + fmt.format(edge.getStartDate()) +"\"");}%>><input type=button value="select" onclick="displayDatePicker('startDate', false, 'dmy');"><br />
				<h4>End Date</h4>
					<input type="text" name="endDate" <% if(edge.getEndDate() != null){ out.print("value=\"" + fmt.format(edge.getEndDate()) +"\"");}%>><input type=button value="select" onclick="displayDatePicker('endDate', false, 'dmy');"><br />
					<input type="hidden" name="update" value="updateEdge">
					<input type="hidden" name="edgeId" value="<%= edge.getId() %>">
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="submit" name="submit" value="Apply">
							</form>
						</td>
						<td>
							<form method="post" action="EdgeDetails">
								<input type="hidden" name="edgeId" value="<%= edge.getId()%>">
								<input type="hidden" name="update" value="edgeDetails">
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
<% }} }%>