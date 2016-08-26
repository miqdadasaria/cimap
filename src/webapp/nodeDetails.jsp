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
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Add Node</h3>
      </div>
      <div class="panel-body">
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
	  </div>
	 </div>
<%
} else {
	currentNode = user.getGraph().getSelected();
	boolean isAdmin = (user.getType() >= User.ADMIN);
	DateFormat fmt = new SimpleDateFormat("yyyy-mm-dd");
	String type = currentNode.getType().getTypeName();
%>
   <div class="panel panel-default">
	<div class="panel-heading">
		Details for: <%= currentNode.getName()%>
	</div>
	<div class="panel-body">
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
					<button name="submit" value="submit" type="submit"><img src="images/new.png" alt="add new node"></button>
					</form>
				</td>
				</tr>
			</table>
			</p>
			<%if(currentNode.getPhotograph() != null){%>
				<img src="<%= currentNode.getPhotograph() %>" border="0">
			<%}%>
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
			<div class="well">
			<%= currentNode.getBackground() %><br />
			</div>
			<% } %>
			<h4>Themes</h4>
			<div class="list-group">
			<% 
				ArrayList<Theme> themes = currentNode.getThemes();
				if (themes != null) {
				Iterator<Theme> i = themes.iterator();
				while(i.hasNext()){
					Theme a = i.next();
			%>
				<a href="Themes?themeid=<%= a.getId() %>" class="list-group-item"><%= a.getName() %></a>
			<%	}}%>
			</div>
			<% if(isAdmin){%>
			<p></p>
			<form method="post" action="AddNodeDetail">
			<button type="submit" class="btn btn-primary" value="Add or Remove Themes">Add or Remove Themes</button>
			<input type="hidden" name="detail" value="theme" />
			<input type="hidden" name="nodeId" value="<%= currentNode.getId()%>" />
			</form>
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
				<div class="well">
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
			%>
				</div>
			<%
				}
			%>
			<h4>Affiliations</h4>
			<h5>Organisations</h5>
				<div class="list-group">
				<%
					ArrayList<Edge> orgs = currentNode.getRelatedOrganisations();
					Iterator<Edge> o = orgs.iterator();
					Edge currentEdge;
					Node related;
					while(o.hasNext()){
						currentEdge = o.next();
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>" class="list-group-item"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%}%>
				</div>
				<% if(isAdmin){%>
				<p><form method="post" action="AddOrUpdateEdge">
				<button type="submit" class="btn btn-primary" value="Add Organisation">Add Organisation</button>
				<input type="hidden" name="update" value="addEdge" />
				<input type="hidden" name="otherNodeType" value="Organisation" />
				</form></p>
				<%}%>
			<h5>Individuals</h5>
				<div class="list-group">
				<%
					ArrayList<Edge> inds = currentNode.getRelatedIndividuals();
					Iterator<Edge> in = inds.iterator();
					while(in.hasNext()){
						currentEdge = in.next();
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>" class="list-group-item"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%
					}
				%>
				</div>
				<% if(isAdmin){%>
				<p><form method="post" action="AddOrUpdateEdge">
				<button type="submit" class="btn btn-primary" value="Add Individual">Add Individual</button>
				<input type="hidden" name="update" value="addEdge" />
				<input type="hidden" name="otherNodeType" value="Individual" />
				</form></p>
				<%}%>
			<h5>Events</h5>
				<div class="list-group">
				<%
					ArrayList<Edge> events = currentNode.getRelatedEvents();
					Iterator<Edge> event = events.iterator();
					while(event.hasNext()){
						currentEdge = event.next(); 
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>" class="list-group-item"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%
					}
				%>
				</div>
				<% if(isAdmin){ %>
				<p><form method="post" action="AddOrUpdateEdge">
				<button type="submit" class="btn btn-primary" value="Add Event">Add Event</button>
				<input type="hidden" name="update" value="addEdge" />
				<input type="hidden" name="otherNodeType" value="Event" />
				</form></p>
				<%}%>
			<h5>Publications</h5>
				<div class="list-group">
				<%
					ArrayList<Edge> publications = currentNode.getRelatedPublications();
					Iterator<Edge> pubs = publications.iterator();
					while(pubs.hasNext()){
						currentEdge = pubs.next(); 
						related = currentEdge.getOtherNode(currentNode);
				%>
					<a href="NodeDetails?nodeId=<%= related.getId() %>" class="list-group-item"><%= related.getName() %></a>&nbsp;<a href="EdgeDetails?update=edgeDetails&edgeId=<%= currentEdge.getId() %>">(<%= currentEdge.getType().getSubTypeName()%>)</a><br />
				<%
					}
				%>
				</div>
				<% if(isAdmin){ %>
				<p><form method="post" action="AddOrUpdateEdge">
				<button type="submit" class="btn btn-primary" value="Add Publication">Add Publication</button>
				<input type="hidden" name="update" value="addEdge" />
				<input type="hidden" name="otherNodeType" value="Publication" />
				</form></p>
				<%}%>
			<h5>Coverage</h5>
				<div class="list-group">
				<%
					ArrayList<NewsArticle> newss = currentNode.getNews();
					Iterator<NewsArticle> n = newss.iterator();
					NewsArticle news;
					while(n.hasNext()){
						news = n.next();
				%>
					<a href="<%= news.getUrl() %>" target="_blank" class="list-group-item"><%= news.getTitle() %></a> <% if(news.getSource() !=null){ out.print("<i>"+news.getSource()+"</i>");} %> <% if(news.getDate() !=null){ out.print(fmt.format(news.getDate()));} %><br />
				<%
					}
				%>
				</div>
				<% if(isAdmin){%>
				<p><form method="post" action="AddNodeDetail">
				<button type="submit" class="btn btn-primary" value="Add News">Add News</button>
				<input type="hidden" name="detail" value="news" />
				<input type="hidden" name="nodeId" value="<%= currentNode.getId()%>" />
				</form></p>
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
<%}}%>