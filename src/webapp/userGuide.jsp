<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">User Guide</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
			<h3><%=getServletContext().getInitParameter("app_name")%> - User Guide</h3>
			<h4>Introduction</h4>
			<p>The <%=getServletContext().getInitParameter("app_name")%> allows a group of users to work together to build up a dynamically evolving shared knowledge base. It is primarily used as a research tool for mapping out context. It also has event and contact management functionality. The core concept is that of a graph visualising relationships between the nodes of information stored in the system. It can be thought of as a cross between wikipedia and facebook.</p>
			<h4>Key Concepts</h4>
			<h5>Nodes</h5>
			<p>Information in the graph is stored in nodes. The system captures information about four different types of nodes, these are:
			<ul>
			<li>Organisations</li>
			<li>Individuals</li>
			<li>Events</li>
			<li>Publications</li>
			</ul>
			For each node type there are a number of subtypes and the different types of node capture different data fields. Nodes are added to the system by selecting the Node Details tab and clicking on the add new node icon: <img src="images/new.png" alt="add new node"> nodes can be edited and updated with new information by selecting the update node icon: <img src="images/update.png" alt="update node"> nodes can be removed from the system by clicking the delete node icon: <img src="images/delete.png" alt="delete node"> and the node and its related nodes can be added to a contact list (see below for more details) by clicking on the add to contact list icon: <img src="images/contacts.png" alt="add to contacts"> these functions are only available to admin users. Nodes consist of information about the node (background, contact details etc.), a set of themes that the node is tagged with, a set of relationships to other nodes and a set of links to media coverage regarding the node.
			</p>
			<h5>Relationships</h5>
			<p>Nodes are related to each other through a series of relationships. Relationships are typed and different types of relationships apply between different types of node. Relationships can also have a temporal element and so the system can optionally capture start and/or end dates for a relationship. To add a relationship to a node you must find the node that you want to add the realtionship to (using the search functionality described below). On the node details page you will see options to add affiliations to other organisations, individuals, events or publications. Clicking on one of these options will guide you through the process of adding the relevant relationship. Relationships can only be created by admin users. Once the relationship is set up it will be visible on the node details page. Clicking on the link in brackets after the related node will show you the details of the relationship and admin users will be able to modify: <img src="images/update.png" alt="update relationship"> or delete: <img src="images/delete.png" alt="delete relationship"> the relationship using the relevant icons as described in the node section above.</p>
			<h5>Graph</h5>
			<p>
			Clicking the node name in the node details page takes you to a visual representation of the node and its relationships as a MasterGraph. This graph is interactive and allows you to traverse the relationships by following related nodes. The number in square brakets e.g. [x] after the node name indicates how many relationships that node is involved in. Clicking on the node names in the left hand pane takes you to the node details page for the selected node. The screenshot below shows the  graph in action.</p>
			<p>
			<img src="images/userguide/MasterGraph.jpg" alt="example graph">
			</p>
			<h5>Themes</h5>
			<p>Themes are like topics or keywords that are used to tag nodes. Nodes can be tagged under multiple themes. Themes are accessed through the themes tab. Clicking a theme will show a description of the theme and the nodes that are tagged with that theme. Admin users can modify or delete themes by clicking on the edit: <img src="images/update.png" alt="update theme"> and delete: <img src="images/delete.png" alt="delete theme"> buttons on the theme details page. New themes can be added from the main themes page by clicking on the add themes: <img src="images/new.png" alt="add theme"> button. Themes are associated with nodes or removed from nodes by going to the node details page and clicking the "add or remove themes" button and checking/unchecking the desired themes. Clicking the themes links in the node details page will take you to the page for the selected theme.</p>
			<h5>Contact Lists</h5>
			<p>Contact lists are selections of organisation and individual nodes who are grouped together so that they can be contacted through electonic or physical mailing lists. Contact lists are created by clicking the new contact list icon: <img src="images/new.png" alt="add contact list"> on the contact list page. Nodes are added to contact lists either through the node details or the search results pages. Contacts who are already part of a contact list will not be added to the list again. Once the list is ready it can be exported as a set of contact details in spreadsheet (CSV) format. Contact list functionality is only available to admin users.</p>
			<h5>Search</h5>
			<p>The search functionality allows you to locate nodes in the system. The more fields you fill in the more restrictive the search is i.e. results must meet all conditions entered. For admin users the search results can be added to a contact list by clicking on the add to contact list icon: <img src="images/contacts.png" alt="add to contacts"> on the search results page.</p>
			<h5>User Admin</h5>
			<p>Super users have the ability to set up new user, set permissions for them, monitor their usage, set view and update quotas for users and remove users from the system.</p>
			</div>
	</div>
</div>

</td>
</tr>
</table>

</center>