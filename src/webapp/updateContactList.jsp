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
	String id = (String)(session.getAttribute("contactListId"));
	if(id != null && !id.equals("") && user.getType() >= User.ADMIN){
		int contactListId = Integer.parseInt(id);
		ContactList list = MasterGraph.getContactList(contactListId);
		ArrayList<ContactListEntry> orgMatches = list.getOrganisations();
		ArrayList<ContactListEntry> indMatches = list.getIndividuals();
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Update Contact List</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="AddOrUpdate">
					<h3>Update Contact List</h3>
					<h4>Name</h4>
					<input type="text" name="name" value="<%= list.getName()%>"><br />
					<h4>Description</h4>
					<textarea name="description" rows="10" cols="60"><% if(list.getDescription()!=null){%><%= list.getDescription()%><%}%></textarea><br />
					<h4>Organisations</h4>
<%
		ArrayList<Node> orgs = new ArrayList<Node>();
		Iterator<ContactListEntry> o = orgMatches.iterator();
		while(o.hasNext()){
			Node node = o.next().getNode();
%>
			<input type="checkbox" name="contact" value="<%= node.getId()%>" checked> <%= node.getName()%><br />
<%
		}
%>
				<h4>Individuals</h4>
<%
		ArrayList<Node> inds = new ArrayList<Node>();
		Iterator<ContactListEntry> i = indMatches.iterator();
		while(i.hasNext()){
			Node node = i.next().getNode();
%>
			<input type="checkbox" name="contact" value="<%= node.getId()%>"  checked> <%= node.getName()%><br />
<%
		}
%>

					<input type="hidden" name="update" value="updateContactList">
					<input type="hidden" name="contactListId" value="<%=list.getId()%>">
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="submit" name="submit" value="Apply">
							</form>
						</td>
						<td>
							<form method="post" action="ContactLists">
								<input type="hidden" name="contactListId" value="<%=list.getId()%>">
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
<% }}%>