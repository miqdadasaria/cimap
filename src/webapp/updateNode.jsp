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
	DateFormat fmt = new SimpleDateFormat("yyyy-mm-dd");
%>
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Update Node: <%= node.getName()%></h3>
  </div>
  <div class="panel-body">
	<form method="post" enctype="multipart/form-data" name="updatenodeform">
		<input type="hidden" name="nodeId" value="<%=node.getId()%>">

		<div class="form-group">
		    <label for="name">Name</label>				
		  	<input type="text" name="name" id="name" class="form-control" 
		  	<% if(node.getName()!= null) out.print("value=\""+node.getName()+"\"");%>>
		</div>
		
		<div class="form-group">
		    <label for="type">Node Type</label>				
			  <select name="type" class="selectpicker" data-live-search="true" data-width="fit" id="type">
			    <%
				Iterator<NodeType> t = types.iterator();
				NodeType currentType = null;
				while(t.hasNext()){
					currentType = t.next();
		    %>
					<option value="<%= currentType.getId()%>"
					<% if(currentType.getId() == node.getType().getId()) out.print(" selected");%>>
					<%= currentType.getSubTypeName()%>
					</option>
			    <%	}%>
			  </select>
		</div>
		
		</select>
		
		<div class="form-group">
		    <label for="photo">Photograph URL</label>	
		    
			<% if(node.getPhotograph()!= null) 
				out.print("<img src=\""+node.getPhotograph()+"\">");
			%>
			<input type="file" class="form-control-file" id="photo" name="photo">
		</div>

	<%
		if(type.equals("Organisation")){	
		OrganisationNode orgNode = (OrganisationNode)node;
	%>
	    <div class="form-group">
		      <label for="numStaff">Number of Staff</label>	
		  <input class="form-control" type="number" name="numStaff" id ="numStaff" 
		  value="<%= orgNode.getNumStaff()%>">
		</div>
		
		<div>
		  <label for="numCustomers">Number of Customers / Students</label>	
			  <input class="form-control" type="number" name="numCustomers" id="numCustomers" 
			  value="<%= orgNode.getNumCustomers()%>">
		    </div>
	<%
		} else if(type.equals("Individual")){
		IndividualNode indNode = (IndividualNode)node;
	%>

	  <div class="form-group">
		    <label for="dob">Date of Birth</label>	
		<input class="form-control" type="date" id="dob" name="dob"
	          <% if(indNode.getDateOfBirth()!=null) out.print("value=\""+fmt.format(indNode.getDateOfBirth())+"\"");%>>
      </div>
		

	  <div class="form-group">
		    <label for="gender">Gender</label>
		<select class="selectpicker" data-live-search="true" data-width="fit" id="gender" name="gender">
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
	  </div>
	<%
		} else if(type.equals("Event")){
		EventNode eveNode = (EventNode)node;
	%>
	  <div class="form-group">
		    <label for="eventDate">Event Date</label>	
		<input class="form-control" type="date" id="eventDate" name="eventDate"
			<% if(eveNode.getEventDate()!=null) out.print("value=\""+fmt.format(eveNode.getEventDate())+"\"");%>>
      </div>

	  <div class="form-group">
		      <label for="numPresenters">Number of Presenters</label>	
		  <input class="form-control" type="number" name="numPresenters" id ="numPresenters" 
		  value="<%= eveNode.getNumPresenters()%>">
		  </div>

	  <div class="form-group">
		      <label for="numAttendees">Number of Attendees</label>	
		  <input class="form-control" type="number" name="numAttendees" id ="numAttendees" 
		  value="<%= eveNode.getNumAttendees()%>">
		  </div>
	<%
		} else if(type.equals("Publication")){
		PublicationNode pubNode = (PublicationNode)node;
	%>
	  <div class="form-group">
		    <label for="pubDate">Publication Date</label>	
		<input class="form-control" type="date" id="pubDate" name="pubDate"
			<% if(pubNode.getPublicationDate()!=null) out.print("value=\""+fmt.format(pubNode.getPublicationDate())+"\"");%>>
      </div>

	  <div class="form-group">
		      <label for="source">Publisher / Journal</label>	
		  <input class="form-control" type="text" name="source" id ="source" 
		  <% if(pubNode.getSource()!= null) out.print("value=\""+pubNode.getSource()+"\"");%>>
		  </div>
	<%
		}	
	%>

	  <div class="form-group">
		      <label for="background">Background Information</label>
		  <textarea class="form-control" name="background" rows="15" cols="60">"<% if(node.getBackground() != null){ out.print(node.getBackground());}else{out.print("<a href=\"xxx\" target=\"_blank\">source</a>");}%>"</textarea>
	  </div>

	  <div class="form-group">
		      <label for="url">URL</label>	
		  <input class="form-control" type="url" name="url" id ="url" 
		  <% if(node.getURL()!= null) out.print("value=\""+node.getURL()+"\"");%>>
		  </div>  
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

	  <div class="form-group">
		      <label for="addressline1">Address Line 1</label>	
		  <input class="form-control" type="text" name="addressline1" id ="addressline1" 
		  	<%
			if(contact!=null && contact.getAddressLine1() != null)
			out.print(" value=\""+contact.getAddressLine1()+"\"");
			%>>
	  </div> 


	  <div class="form-group">
		      <label for="addressline2">Address Line 2</label>	
		  <input class="form-control" type="text" name="addressline2" id ="addressline2" 
		  	<%
			if(contact!=null && contact.getAddressLine2() != null)
			out.print(" value=\""+contact.getAddressLine2()+"\"");
			%>>
	  </div> 

	  <div class="form-group">
		      <label for="city">City</label>	
		  <input class="form-control" type="text" name="city" id ="city" 
		  	<%
			if(contact!=null && contact.getCity() != null)
			out.print(" value=\""+contact.getCity()+"\"");
			%>>
	  </div> 


	  <div class="form-group">
		      <label for="state">State</label>	
		  <input class="form-control" type="text" name="state" id ="state" 
		  	<%
			if(contact!=null && contact.getState() != null)
			out.print(" value=\""+contact.getState()+"\"");
			%>>
		  </div> 

	  <div class="form-group">
		      <label for="country">Country</label>	
		  <input class="form-control" type="text" name="country" id ="country" 
		  	<%
			if(contact!=null && contact.getCountry() != null)
			out.print(" value=\""+contact.getCountry()+"\"");
			%>>
	  </div> 

	  <div class="form-group">
		      <label for="latitude">Latitude</label>	
		  <input class="form-control" type="text" name="latitude" id ="latitude" 
		  	<%
			if(contact!=null)
			out.print(" value=\""+contact.getLatitude()+"\"");
			%>>
	  </div> 

	  <div class="form-group">
		      <label for="longitude">Longitude</label>	
		  <input class="form-control" type="text" name="longitude" id ="longitude" 
		  	<%
			if(contact!=null)
			out.print(" value=\""+contact.getLongitude()+"\"");
			%>>
	  </div> 

	  <div class="form-group">
		      <label for="postcode">Postcode</label>	
		  <input class="form-control" type="text" name="postcode" id ="postcode" 
		  	<%
			if(contact!=null && contact.getPostcode() != null)
			out.print(" value=\""+contact.getPostcode()+"\"");
			%>>
	  </div> 

	  <div class="form-group">
		      <label for="phone">Phone</label>	
		  <input class="form-control" type="tel" name="phone" id ="phone" 
		  	<%
			if(contact!=null && contact.getPhone() != null)
			out.print(" value=\""+contact.getPhone()+"\"");
			%>>
	  </div> 

	  <div class="form-group">
		      <label for="email">Email</label>	
		  <input class="form-control" type="email" name="email" id ="email" 
		  	<%
			if(contact!=null && contact.getEmail() != null)
			out.print(" value=\""+contact.getEmail()+"\"");
			%>>
		  </div> 


	  <div class="form-group">
		      <label for="originCity">City of Origin</label>	
		  <input class="form-control" type="text" name="originCity" id ="originCity" 
		  	<%
			if(contact!=null && contact.getOriginCity() != null)
			out.print(" value=\""+contact.getOriginCity()+"\"");
			%>>
	  </div> 


	  <div class="form-group">
		      <label for="originState">State of Origin</label>	
		  <input class="form-control" type="text" name="originState" id ="originState" 
		  	<%
			if(contact!=null && contact.getOriginState() != null)
			out.print(" value=\""+contact.getOriginState()+"\"");
			%>>
	  </div> 

	  <div class="form-group">
		      <label for="originCountry">Country of Origin</label>	
		  <input class="form-control" type="text" name="originCountry" id ="originCountry" 
		  	<%
			if(contact!=null && contact.getOriginCountry() != null)
			out.print(" value=\""+contact.getOriginCountry()+"\"");
			%>>
	  </div> 
	<%
	}				
	%>					
		  <input type="hidden" name="update" value="node">
		  
		  <div class="form-group">
		  	<button type="submit" class="btn btn-primary" value="Update" onclick="updateNode();">Update</button>
		  	<button type="submit" class="btn btn-primary" value="Cancel" onclick="cancelUpdateNode();">Cancel</button>
		  	
	  	  </div>
	</form>

  <script>
    function updateNode(){
      document.updatenodeform.action = "UpdateNode";
    }
    function cancelUpdateNode(){
      document.updatenodeform.action = "NodeDetails";
    }
  </script>


	</div>
</div>
<% } %>