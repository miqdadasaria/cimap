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

Node currentNode = null;
if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
User user = (User)(session.getAttribute("username"));
if (user.getGraph().getSelected() == null){
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Add Node</div>
	<div class="element contained-item">
		<div class="inner" id="inner-details">
			<p></p>
			<center>
			<table>
				<tr>
				<td>
					<form method="post" action="AddNodeDetail">
					<input type="hidden" name="detail" value="node" />
					<button name="submit" value="submit" type="submit"><img src="images/new.png" alt="add new node"></button>
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

<%
} else {
	currentNode = user.getGraph().getSelected();
	boolean isAdmin = (user.getType() >= User.ADMIN);
	DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
	String type = currentNode.getType().getTypeName();
%>

<center>
<table>
<tr>
<td valign="center">
<div id="left">


	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Details for: <%= currentNode.getName()%></div>
	<div class="element contained-item">
		<div class="inner" id="inner-details">
				<p align="right">
				<table>
				<tr>
				<% if(user.getType() >=User.ADMIN){%>
				<td>
					<form method="post" action="AddNodeDetail">
					<input type="hidden" name="detail" value="general" />
					<button name="submit" value="submit" type="submit"><img src="images/update.png" alt="update node" border="0"></button>
					</form>
				</td>
				<td>
					<form method="post" action="AddOrUpdate" onsubmit="return confirmDeleteNode('<%=currentNode.getName()%>')">
					<input type="hidden" name="update" value="deleteNode" />
					<button name="submit" value="submit" type="submit"><img src="images/delete.png" alt="delete node"></button>
					</form>
				</td>
				<%}%>
				<td>
					<form method="post" action="AddNodeDetail">
					<input type="hidden" name="detail" value="node" />
					<!--input type="submit" name="submit" value="Add New Node" /-->
					<button name="submit" value="submit" type="submit"><img src="images/new.png" alt="add new node"></button>
					</form>
				</td>
				<% if(user.getType() >=User.ADMIN && MasterGraph.getContactLists().size() > 0){%>
				<td>
					<form method="post" action="ContactLists">
					<input type="hidden" name="update" value="currentNode" />
					<!--input type="submit" name="submit" value="Add to Contact List" /-->
					<button name="submit" value="submit" type="submit"><img src="images/contacts.png" alt="export to contacts list"></button>
					</form>
				</td>
				<%}%>
				</tr>
			</table>
			</p>
			<h3>Node Details</h3>
			<%if(currentNode.getPhotograph() != null){ %>
				<img src="<%= currentNode.getPhotograph() %>" border="0">
			<%} %>
			<h4>Name</h4> <a href="JSON?id=<%= currentNode.getId() %>"><%= currentNode.getName() %></a> <br />
			<h4>Type</h4>
			<%= type %> - <%= currentNode.getType().getSubTypeName()%>

			<%
				if(type.equals("Organisation")){	
				OrganisationNode orgNode = (OrganisationNode)currentNode;
			%>
			<% if(orgNode.getNumStaff() > 0){%>
			<h4>Number of Staff</h4>
			<%= orgNode.getNumStaff()%>
			<%}%>
			<% if(orgNode.getNumCustomers() > 0){%>
			<h4>Number of Customers / Students</h4>
			<%= orgNode.getNumCustomers()%>
			<%}%>
			<%
				} else if(type.equals("Individual")){
				IndividualNode indNode = (IndividualNode)currentNode;
			%>
			<% if(indNode.getDateOfBirth()!=null){%>
			<h4>Date of Birth</h4> 
			<%= fmt.format(indNode.getDateOfBirth()) %>
			<% }%>
			<% if(indNode.getGender() != 'u'){%>
			<h4>Gender</h4>
				<%
					char gender = indNode.getGender();
					String genderText = null;
					if(gender == 'm'){
						genderText = "Male";
					} else if(gender == 'f'){
						genderText = "Female";
					}
				%>
			<%= genderText %>
			<% }
				} else if(type.equals("Event")){
				EventNode eveNode = (EventNode)currentNode;
			%>
			<% if(eveNode.getEventDate()!=null){%>
			<h4>Event Date</h4> 
			<%= fmt.format(eveNode.getEventDate()) %>
			<%}%>
			<% if(eveNode.getNumPresenters() > 0){ %>
			<h4>Number of Presenters</h4>
			<%= eveNode.getNumPresenters()%>
			<%}%>
			<% if(eveNode.getNumAttendees() > 0){ %>
			<h4>Number of Attendees</h4>
			<%= eveNode.getNumAttendees()%>
			<%}%>
			<%
				} else if(type.equals("Publication")){
				PublicationNode pubNode = (PublicationNode)currentNode;
			%>
			<% if(pubNode.getPublicationDate()!=null){%>
			<h4>Publication Date</h4>
			<%= fmt.format(pubNode.getPublicationDate())%>
			<%}%>
			<% if(pubNode.getSource()!= null){ %>
			<h4>Publisher / Journal</h4>
			<%= pubNode.getSource()%>
			<%}%>
			<%
				}	
			%>

			<% if(currentNode.getBackground() != null) {%>
			<h4>Background</h4>
			<%= currentNode.getBackground() %><br />
			<% } %>
			<h4>Themes</h4>
			<% 
				ArrayList<Theme> themes = currentNode.getThemes();
				if (themes != null) {
				Iterator<Theme> i = themes.iterator();
				while(i.hasNext()){
					Theme a = i.next();
			%>
				<a href="Themes?themeid=<%= a.getId() %>"><%= a.getName() %></a>&nbsp;
			<%	}}%>
			<% if(isAdmin){%>
			<p></p>
			<form method="post" action="AddNodeDetail"><input type="submit" name="submit" value="Add or Remove Themes" /><input type="hidden" name="detail" value="theme" /><input type="hidden" name="nodeId" value="<%= currentNode.getId()%>" /></form>
			<%}%>
			<% if(currentNode.getURL() != null){%>
			<h4>URL</h4>
			<a href="<%= currentNode.getURL() %>"><%= currentNode.getURL() %></a><br />
			<% }%>
			<% 
				ContactDetails contact = null;
				if(type.equals("Organisation")){
					OrganisationNode orgNode = (OrganisationNode)currentNode;
					contact = orgNode.getContact();
				} else if(type.equals("Individual")){
					IndividualNode indNode = (IndividualNode)currentNode;
					contact = indNode.getContact();
				} else if(type.equals("Event")){
					EventNode eveNode = (EventNode)currentNode;
					contact = eveNode.getContact();
				}
				
				if(contact != null){
			%>
				<h4>Contact Details</h4>
			<%
					if(contact.getAddressLine1() != null)
						out.print(contact.getAddressLine1()+"<br />");
					if(contact.getAddressLine2() != null)
						out.print(contact.getAddressLine2()+"<br />");
					if(contact.getCity() != null)
						out.print(contact.getCity()+"<br />");
					if(contact.getState() != null)
						out.print(contact.getState()+"<br />");
					if(contact.getCountry() != null)
						out.print(contact.getCountry()+"<br />");
					if(contact.getLatitude() != 0 && contact.getLongitude() != 0)
						out.print("coordinates: " + contact.getLatitude()+","+contact.getLongitude()+"<br />");
					if(contact.getPostcode() != null)
						out.print("postcode: " + contact.getPostcode()+"<br />");
					if(contact.getPhone() != null)
						out.print("tel: " + contact.getPhone()+"<br />");
					if(contact.getEmail() != null)
						out.print("email: <a href=\"mailto:" + contact.getEmail()+"\">"+contact.getEmail()+"</a><br />");
					if(contact.getOriginCity() != null)
						out.print("city of origin: " + contact.getOriginCity()+"<br />");
					if(contact.getOriginState() != null)
						out.print("state of origin: " + contact.getOriginState()+"<br />");
					if(contact.getOriginCountry() != null)
						out.print("country of origin: " + contact.getOriginCountry()+"<br />");
				}
			%>
			<h4>Affiliations</h4>
			<h5>Organisations</h5>
				<%
					ArrayList<Edge> orgs = currentNode.getRelatedOrganisations();
					Iterator<Edge> o = orgs.iterator();
					Edge currentEdge;
					Node related;
					while(o.hasNext()){
						currentEdge = o.next();
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%}%>
				<% if(isAdmin){%>
				<p><form method="post" action="AddOrUpdateEdge"><input type="submit" name="submit" value="Add Organisation" /><input type="hidden" name="update" value="addEdge" /><input type="hidden" name="otherNodeType" value="Organisation" /></form></p>
				<%}%>
			<h5>Individuals</h5>
				<%
					ArrayList<Edge> inds = currentNode.getRelatedIndividuals();
					Iterator<Edge> in = inds.iterator();
					while(in.hasNext()){
						currentEdge = in.next();
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%
					}
				%>
				<% if(isAdmin){%>
				<p><form method="post" action="AddOrUpdateEdge"><input type="submit" name="submit" value="Add Individual" /><input type="hidden" name="update" value="addEdge" /><input type="hidden" name="otherNodeType" value="Individual" /></form></p>
				<%}%>
			<h5>Events</h5>
				<%
					ArrayList<Edge> events = currentNode.getRelatedEvents();
					Iterator<Edge> event = events.iterator();
					while(event.hasNext()){
						currentEdge = event.next(); 
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%
					}
				%>
				<% if(isAdmin){ %>
				<p><form method="post" action="AddOrUpdateEdge"><input type="submit" name="submit" value="Add Event" /><input type="hidden" name="update" value="addEdge" /><input type="hidden" name="otherNodeType" value="Event" /></form></p>
				<%}%>
			<h5>Publications</h5>
				<%
					ArrayList<Edge> publications = currentNode.getRelatedPublications();
					Iterator<Edge> pubs = publications.iterator();
					while(pubs.hasNext()){
						currentEdge = pubs.next(); 
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%
					}
				%>
				<% if(isAdmin){ %>
				<p><form method="post" action="AddOrUpdateEdge"><input type="submit" name="submit" value="Add Publication" /><input type="hidden" name="update" value="addEdge" /><input type="hidden" name="otherNodeType" value="Publication" /></form></p>
				<%}%>
			<h4>Coverage</h4>
				<%
					ArrayList<NewsArticle> newss = currentNode.getNews();
					Iterator<NewsArticle> n = newss.iterator();
					NewsArticle news;
					while(n.hasNext()){
						news = n.next();
				%>
					<a href="<%= news.getUrl() %>" target="_blank"><%= news.getTitle() %></a> <% if(news.getSource() !=null){ out.print("<i>"+news.getSource()+"</i>");} %> <% if(news.getDate() !=null){ out.print(fmt.format(news.getDate()));} %><br />
				<%
					}
				%>
				<% if(isAdmin){%>
				<p><form method="post" action="AddNodeDetail"><input type="submit" name="submit" value="Add News" /><input type="hidden" name="detail" value="news" /><input type="hidden" name="nodeId" value="<%= currentNode.getId()%>" /></form></p>
				<%}%>
			<h4>Audit Info</h4>
			<% if(currentNode.getAddedBy() != null){%>
				Created By: <%= currentNode.getAddedBy().getName()%><br />
			<% }%>
				Creation Date: <%= currentNode.getDateAdded()%><br />
			<% if(currentNode.getModBy() != null){%>
				Last Modified By: <%= currentNode.getModBy().getName()%><br />
			<% }%>
				Last Modified Date: <%= currentNode.getLastModified()%><br />
				View Count: <%= currentNode.getViewCount()%><br />
			</div>
	</div>
</div>

</td>
</tr>
</table>
</center>
<%}}%>