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
	Node node = user.getGraph().getSelected();
	ArrayList<NodeType> types = MasterGraph.getNodeSubTypeList(node.getType().getTypeName());
	String type = node.getType().getTypeName();
	DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Update Node <%= node.getName()%></h3>
  </div>
  <div class="panel-body">

				<form method="post" action="UpdateNode" enctype="multipart/form-data">
					<h3>Update Node</h3>
					<h4>Name</h4>
					<input type="text" name="name" <% if(node.getName()!= null) out.print("value=\""+node.getName()+"\"");%>>
					<h4>Type</h4>
					<%= type %> - 
					<select name="type">
					<%
						
						Iterator<NodeType> t = types.iterator();
						NodeType currentType = null;
						while(t.hasNext()){
							currentType = t.next();
					%>
							<option value="<%= currentType.getId()%>"<% if(currentType.getId() == node.getType().getId()) out.print(" selected");%>><%= currentType.getSubTypeName()%></option>
					<%	}%>
					</select>
					<h4>Photograph URL</h4>
					<% if(node.getPhotograph()!= null) 
						out.print("<img src=\""+node.getPhotograph()+"\">");%>
					<br />
					<input type="file" name="photo">
					<%
						if(type.equals("Organisation")){	
						OrganisationNode orgNode = (OrganisationNode)node;
					%>
					<h4>Number of Staff</h4>
					<input type="text" name="numStaff" value="<%= orgNode.getNumStaff()%>">
					<h4>Number of Customers / Students</h4>
					<input type="text" name="numCustomers" value="<%= orgNode.getNumCustomers()%>">
					<%
						} else if(type.equals("Individual")){
						IndividualNode indNode = (IndividualNode)node;
					%>
					<h4>Date of Birth</h4>
					<input type="text" name="dob" 
					<% if(indNode.getDateOfBirth()!=null) out.print("value=\""+fmt.format(indNode.getDateOfBirth())+"\"");
					%>><input type=button value="select" onclick="displayDatePicker('dob', false, 'dmy');"><br />
					<h4>Gender</h4>
					<select name="gender">
						<%
							char gender = indNode.getGender();
							String genderText = null;
							if(gender == 'u'){
								genderText = "Unknown";
							} else if(gender == 'm'){
								genderText = "Male";
							} else if(gender == 'f'){
								genderText = "Female";
							}

						%>
						<option value="<%= gender %>"><%= genderText%></option>
						<option value="m">Male</option>
						<option value="f">Female</option>
						<option value="u">Uknown</option>
					</select>
					<%
						} else if(type.equals("Event")){
						EventNode eveNode = (EventNode)node;
					%>
					<h4>Event Date</h4>
					<input type="text" name="eventDate" 
					<% if(eveNode.getEventDate()!=null) out.print("value=\""+fmt.format(eveNode.getEventDate())+"\"");
					%>><input type=button value="select" onclick="displayDatePicker('eventDate', false, 'dmy');"><br />
					<h4>Number of Presenters</h4>
					<input type="text" name="numPresenters" value="<%= eveNode.getNumPresenters()%>">
					<h4>Number of Attendees</h4>
					<input type="text" name="numAttendees" value="<%= eveNode.getNumAttendees()%>">
					<%
						} else if(type.equals("Publication")){
						PublicationNode pubNode = (PublicationNode)node;
					%>
					<h4>Publication Date</h4>
					<input type="text" name="pubDate" 
					<% if(pubNode.getPublicationDate()!=null) out.print("value=\""+fmt.format(pubNode.getPublicationDate())+"\"");
					%>><input type=button value="select" onclick="displayDatePicker('pubDate', false, 'dmy');"><br />
					<h4>Publisher / Journal</h4>
					<input type="text" name="source" <% if(pubNode.getSource()!= null) out.print("value=\""+pubNode.getSource()+"\"");%>>
					<%
						}	
					%>
					<h4>Background Information</h4>
						<textarea name="background" rows="15" cols="60"><% if(node.getBackground() != null){ out.print(node.getBackground());}else{%><a href="xxx" target="_blank">source</a><%}%></textarea>
					<h4>URL</h4>
					<input type="text" name="url" <% if(node.getURL()!= null) out.print("value=\""+node.getURL()+"\"");%>>
			<% 
				ContactDetails contact = null;
				if(type.equals("Organisation")){
					OrganisationNode orgNode = (OrganisationNode)node;
					contact = orgNode.getContact();
				} else if(type.equals("Individual")){
					IndividualNode indNode = (IndividualNode)node;
					contact = indNode.getContact();
				} else if(type.equals("Event")){
					EventNode eveNode = (EventNode)node;
					contact = eveNode.getContact();
				}

if(!type.equals("Publication")){

				%>
				<h4>Contact Details</h4>
				<h5>Address Line 1</h5>
				<input type="text" name="addressLine1"
			<%
					if(contact!=null && contact.getAddressLine1() != null)
						out.print(" value=\""+contact.getAddressLine1()+"\"");
			%>>
				<h5>Address Line 2</h5>
				<input type="text" name="addressLine2"
			<%
					if(contact!=null && contact.getAddressLine2() != null)
						out.print(" value=\""+contact.getAddressLine2()+"\"");
			%>>
				<h5>City</h5>
				<input type="text" name="city"
			<%		if(contact!=null && contact.getCity() != null)
						out.print(" value=\""+contact.getCity()+"\"");
			%>>
				<h5>State</h5>
				<input type="text" name="state"
			<%		if(contact!=null && contact.getState() != null)
						out.print(" value=\""+contact.getState()+"\"");
			%>>
				<h5>Country</h5>
				<input type="text" name="country"
			<%
					if(contact!=null && contact.getCountry() != null)
						out.print(" value=\""+contact.getCountry()+"\"");
			%>>
				<h5>Latitude</h5>
				<input type="text" name="latitude"
			<%
					if(contact!=null && contact.getLatitude() != 0)
						out.print(" value=\""+contact.getLatitude()+"\"");
			%>>
				<h5>Longitude</h5>
				<input type="text" name="longitude"
			<%
					if(contact!=null && contact.getLongitude() != 0)
						out.print(" value=\""+contact.getLongitude()+"\"");
			%>>
				<h5>Postcode</h5>
				<input type="text" name="postcode"
			<%
					if(contact!=null && contact.getPostcode() != null)
						out.print(" value=\"" + contact.getPostcode()+"\"");
			%>>
				<h5>Phone</h5>
				<input type="text" name="phone"
			<%
					if(contact!=null && contact.getPhone() != null)
						out.print(" value=\"" + contact.getPhone()+"\"");
			%>>
				<h5>Email</h5>
				<input type="text" name="email"
			<%
					if(contact!=null && contact.getEmail() != null)
						out.print(" value=\"" + contact.getEmail()+"\"");
			%>>
				<h5>City of Origin</h5>
				<input type="text" name="originCity"
			<%
					if(contact!=null && contact.getOriginCity() != null)
						out.print(" value=\"" + contact.getOriginCity()+"\"");
			%>>
				<h5>State of Origin</h5>
				<input type="text" name="originState"
			<%
					if(contact!=null && contact.getOriginState() != null)
						out.print(" value=\"" + contact.getOriginState()+"\"");
			%>>
				<h5>Country of Origin</h5>
				<input type="text" name="originCountry"
			<%
					if(contact!=null && contact.getOriginCountry() != null)
						out.print(" value=\"" + contact.getOriginCountry()+"\"");
			%>>
<%
}				
%>					
					<input type="hidden" name="update" value="node">
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