<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
session.removeAttribute("update");

User user = null;
if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	user = ((User)(session.getAttribute("username")));
	ArrayList<ContactList> lists = MasterGraph.getContactLists();
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Select List to Add Contacts</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="ContactLists">
				<h3>Add Contacts</h3>
				<h4>Add to Contact List:</h4>
				<select name="contactListId">
<%
				Iterator<ContactList> i = lists.iterator();
				ContactList list;
				while(i.hasNext()){
					list = i.next();
%>					
					<option value="<%= list.getId()%>"><%= list.getName()%></option>
<%
				}
%>				
				</select><br />
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="hidden" name="update" value="addContacts">
							<input type="submit" name="submit" value="Next">
							</form>
						</td>
						<td>
						<% if(session.getAttribute("contactsSource").equals("currentNode")){%>
							<form method="post" action="cimap.jsp?tab=nodedetails">
						<% }else if(session.getAttribute("contactsSource").equals("searchResults")){%>
							<form method="post" action="cimap.jsp?tab=search">						
						<%}%>
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
<%}%>