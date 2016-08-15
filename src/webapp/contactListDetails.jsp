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

String id = (String)(session.getAttribute("contactListId"));
if(id != null && !id.equals("")){
int contactListId = Integer.parseInt(id);
ContactList list = MasterGraph.getContactList(contactListId);
ArrayList<ContactListEntry> orgMatches = list.getOrganisations();
ArrayList<ContactListEntry> indMatches = list.getIndividuals();
User user = (User)(session.getAttribute("username"));
DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");

%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Contact List: <%= list.getName() %></div>
	<div class="element contained-item">
		<div class="inner" id="inner-details">

<%
if(user.getType() >= User.ADMIN){
%>
			<p align="right">
			<table>
				<tr>
				<td>
					<form method="post" action="ContactLists">
						<input type="hidden" name="contactListId" value="<%= list.getId() %>">
						<input type="hidden" name="update" value="updateContactList">
						<button name="submit" value="submit" type="submit"><img src="images/update.png" alt="update contact list" border="0"></button>
					</form>
				</td>
				<td>
					<form method="post" action="ContactLists"  onsubmit="return confirmDeleteList('<%=list.getName()%>')">
						<input type="hidden" name="contactListId" value="<%= list.getId() %>">
						<input type="hidden" name="update" value="deleteContactList">
						<button name="submit" value="submit" type="submit"><img src="images/delete.png" alt="delete contact list"></button>
					</form>
				</td>
				</tr>
			</table>
			</p>
<%
}
%>
		<h3>Contact List</h3>
		<h4>Name</h4>
		<p><%= list.getName() %></p>
		<h4>Description</h4>
		<p><% if(list.getDescription()!=null){%><%=list.getDescription()%><%}%></p>
		<h4>Created By</h4>
		<p><% if(list.getCreatedBy()!=null){%><%=list.getCreatedBy().getName()%><%}%></p>
		<h4>Date Created</h4>
		<p><%=fmt.format(list.getDateCreated())%></p>
		<h4>Contacts</h4>
		<h5>Organisations [<%= orgMatches.size()%>]</h5>
<%
			Iterator<ContactListEntry> i = orgMatches.iterator();
			ContactListEntry current;
	        if(!i.hasNext()){
%>
			No organisations found<br />
<%
			}
	        while(i.hasNext()){
				current = i.next();
%>
				<a href="NodeDetails?nodeId=<%= current.getNode().getId() %>"><%= current.getNode().getName() %></a> <% if(current.getAddedBy()!=null){%><%= current.getAddedBy().getName()%><%}%> (<%= fmt.format(current.getDateAdded())%>)<br />
<%
			}	
%>

		<h5>Individuals [<%= indMatches.size()%>]</h5>
<%
			Iterator<ContactListEntry> j = indMatches.iterator();
	        if(!j.hasNext()){
%>
			No individuals found<br />
<%
			}
	        while(j.hasNext()){
				current = j.next();
%>
				<a href="NodeDetails?nodeId=<%= current.getNode().getId() %>"><%= current.getNode().getName() %></a> <%if(current.getAddedBy()!=null){%><%= current.getAddedBy().getName()%><%}%> (<%= fmt.format(current.getDateAdded())%>)<br />
<%
			}	
%>
		
		<br />
			<center>
			<hr width="80%" />
			<p></p>
			<table>
				<tr>
				<td>
					<form method="post" action="ContactLists">
						<input type="submit" name="submit" value="Back to Contact Lists Page"><br />
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
<% } else {
%>
<p><font color="white">No contact list selected</font></p>
<%
}} %>