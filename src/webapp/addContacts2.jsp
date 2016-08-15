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
	String id = (String)(session.getAttribute("contactListId"));
	int contactListId = Integer.parseInt(id);
	ContactList list = MasterGraph.getContactList(contactListId);
	ArrayList<ContactListEntry> orgMatches = list.getOrganisations();
	ArrayList<ContactListEntry> indMatches = list.getIndividuals();
	ArrayList<Node> orgs = new ArrayList<Node>();
	Iterator<ContactListEntry> o = orgMatches.iterator();
	while(o.hasNext()){
		Node org = o.next().getNode();
		orgs.add(org);
	}
	ArrayList<Node> inds = new ArrayList<Node>();
	Iterator<ContactListEntry> i = indMatches.iterator();
	while(i.hasNext()){
		Node ind = i.next().getNode();
		inds.add(ind);
	}
	String source = (String)(session.getAttribute("contactsSource"));
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Select Contacts to Add to List <%= list.getName()%></div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
				<form method="post" action="AddOrUpdate">
				<h3>Add Contacts</h3>
				<h4>Organisations</h4>
<%
		ArrayList<Node> orgResults = new ArrayList<Node>();
		if(source.equals("searchResults")){
			orgResults = (ArrayList<Node>)session.getAttribute("orgSearchResults");
		} else if(source.equals("currentNode")) {
			Node node = user.getGraph().getSelected();
			orgResults = node.getAllRelatedNodes("Organisation");
			if(node instanceof OrganisationNode)
				orgResults.add(node);
		}
			
		Iterator<Node> or = orgResults.iterator();
		while(or.hasNext()){
			Node node = or.next();
			if(!orgs.contains(node)){
%>
				<input type="checkbox" name="contact" value="<%= node.getId()%>" checked> <%= node.getName()%><br />
<%
			}
		}
%>
				<h4>Individuals</h4>
<%
		ArrayList<Node> indResults = new ArrayList<Node>();
		if(source.equals("searchResults")){
			indResults = (ArrayList<Node>)session.getAttribute("indSearchResults");
		} else if(source.equals("currentNode")) {
			Node node = user.getGraph().getSelected();
			indResults = node.getAllRelatedNodes("Individual");
			if(node instanceof IndividualNode)
				indResults.add(node);
		}
		Iterator<Node> ir = indResults.iterator();
		while(ir.hasNext()){
			Node node = ir.next();
			if(!inds.contains(node)){
%>
				<input type="checkbox" name="contact" value="<%= node.getId()%>"  checked> <%= node.getName()%><br />
<%
			}
		}
%>					
					<input type="hidden" name="update" value="addContacts">
					<input type="hidden" name="contactListId" value="<%= list.getId()%>">
					<p></p>
					<center>
					<table>
						<tr>
						<td>
							<input type="submit" name="submit" value="Add">
							</form>
						</td>
						<td>
							<form method="post" action="ContactLists">
								<input type="hidden" name="update" value="addContactsBack">
								<input type="submit" name="submit" value="Back">
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