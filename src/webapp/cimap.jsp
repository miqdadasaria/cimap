<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page import="java.util.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 

User user;
String query = request.getParameter("query");
String tab = "login";

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	user = null;
} else {
	user = (User)(session.getAttribute("username"));
	if (request.getParameter("tab") != null && !request.getParameter("tab").equals("")){
		tab = request.getParameter("tab");
	}
}
%>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><%=getServletContext().getInitParameter("app_name")%></title>

<link type="text/css" rel="stylesheet" href="./css/cimap-tabber.css" />
<link type="text/css" rel="stylesheet" href="./css/infovis.css" />
<link type="text/css" rel="stylesheet" href="./css/datepicker.css" />

<script language="javascript" type="text/javascript" src="./js/datepicker.js"></script>
<script language="javascript" type="text/javascript" src="./js/prototype.js"></script>

<script language="javascript" type="text/javascript">
function confirmDeleteNode(nodeName)
{
var agree=confirm("Are you sure you want to delete node: " + nodeName + "?");
if (agree)
	return true ;
else
	return false ;
}
function confirmDeleteTheme(themeName)
{
var agree=confirm("Are you sure you want to delete theme: " + themeName + "?");
if (agree)
	return true ;
else
	return false ;
}
function confirmDeleteUser(userName)
{
var agree=confirm("Are you sure you want to delete user: " + userName + "?");
if (agree)
	return true ;
else
	return false ;
}
function confirmDeleteList(listName)
{
var agree=confirm("Are you sure you want to delete contact lis: " + listName + "?");
if (agree)
	return true ;
else
	return false ;
}
function confirmDeleteEdge()
{
var agree=confirm("Are you sure you want to delete this relationship?");
if (agree)
	return true ;
else
	return false ;
}

</script>

<script type="text/javascript">

/* Optional: Temporarily hide the "tabber" class so it does not "flash"
   on the page as plain HTML. After tabber runs, the class is changed
   to "tabberlive" and it will appear. */

document.write('<style type="text/css">.tabber{display:none;}<\/style>');

var tabberOptions = {

  'onClick': function(argsObj) {

    var t = argsObj.tabber; /* Tabber object */
    var i = argsObj.index; /* Which tab was clicked (0..n) */
    var div = this.tabs[i].div; /* The tab content div */
    var id = div.id;
	if(id==undefined){
		id = '<%= tab %>';
	}
    
	/* Display a loading message */
    div.innerHTML = "<p>Loading...<\/p>";

    /* Fetch some html depending on which tab was clicked */
    var url = 'login.jsp';
	if(id=='themes'){
		<%
		String update = (String)(session.getAttribute("update"));
		if(update != null && update.equals("updateTheme")){%>
			url = 'updateTheme.jsp';
		<%} else if(update != null && update.equals("addTheme")){%>
			url= 'addTheme.jsp';
		<%} else if(session.getAttribute("themeid") != null){%>
			url = 'themeDetails.jsp';
		<%} else {%>
			url = 'themes.jsp';
		<%}%>
		t.tabShow(0);
	} else if (id=='search'){
		<%if(session.getAttribute("query") != null){%>
			url = 'searchResults.jsp';
		<%}else{%>
			url= 'search.jsp';
		<%}%>
		t.tabShow(1);
	} else if (id=="searchpaths"){
		<%if(session.getAttribute("pathQuery") != null){%>
			url = 'searchPathsResults.jsp';
		<%}else{%>
			url = 'searchPaths.jsp';
		<%}%>
		t.tabShow(2);
	} else if (id=='nodedetails'){
		<%if(update != null){
			if(update.equals("nodeTheme")){%>
				url='updateNodeTheme.jsp';
			<%} else if (update.equals("addNode")){%>
				url='addNode.jsp';
			<%} else if (update.equals("nodeNews")){%>
				url='addNews.jsp';
			<%} else if (update.equals("updateNode")){%>
				url='updateNode.jsp';
			<%} else if (update.equals("addEdge")){%>
				url='addRelatedNode.jsp';
			<%} else if(update.equals("updateEdge")){%>
				url = 'updateEdge.jsp';
			<%} else if(update.equals("edgeDetails")){%>
				url = 'edgeDetails.jsp';
			<%}
		}else {%>
			url = 'nodeDetails.jsp';
		<%}%>
		t.tabShow(3);
	} else if (id=='contactlist'){
		<%if(update != null && update.equals("updateContactList")){%>
			url = 'updateContactList.jsp';
		<%} else if(update != null && update.equals("addContactList")){%>
			url = 'addContactList.jsp';
		<%} else if(update != null && update.equals("addContacts")){%>
			url = 'addContacts.jsp';
		<%} else if(update != null && update.equals("addContacts2")){%>
			url = 'addContacts2.jsp';
		<%} else if(session.getAttribute("contactListId") != null){%>
			url = 'contactListDetails.jsp';
		<%} else {%>
			url = 'contactLists.jsp';
		<%}%>
		t.tabShow(4);
	} else if (id=="useradmin"){
		<%if(update !=null && update.equals("addUser")){%>
			url = 'addUser.jsp'
		<%}else if(update !=null && update.equals("updateUser")){%>
			url = 'updateUser.jsp';
		<%} else {%>
			url = 'userAdmin.jsp';
		<%}%>
		t.tabShow(5);
	} else if (id=="logout"){
		url = 'login.jsp';
		t.tabShow(6);
	} else if (id=="help"){
		url = 'userGuide.jsp';
		t.tabShow(7);
	}
    var pars = '';
<%
	if(query!=null){
%>
	pars = pars+'query="<%=query%>"';
<%
  }
%>
    var myAjax = new Ajax.Updater(div, url, {method:'get',parameters:pars});
  },

  'onLoad': function(argsObj) {
    /* Load the first tab */
<%
	if(tab.equals("search")){
%>
	argsObj.index = 1;
<%
	} else if(tab.equals("searchpaths")){
%>
	argsObj.index = 2;
<%
	} else if(tab.equals("nodedetails")){
%>
	argsObj.index = 3;
<%
	} else if(tab.equals("contactlist")){
%>
	argsObj.index = 4;
<%
	} else if(tab.equals("useradmin")){
%>
	argsObj.index = 5;
<%
	} else if(tab.equals("logout")){
%>
	argsObj.index = 6;
<%
	} else if(tab.equals("help")){
%>
	argsObj.index = 7;
<%
	} else {
%>
	argsObj.index = 0;
<%
}
%>
	this.onClick(argsObj);
  }

}

</script>

<script type="text/javascript" src="./js/tabber.js"></script>

<style type="text/css">
.tabberlive .tabbertab {
  #height:350px;
}
</style>
</head>
<body>

<div class="topmenu">
	<table width="100%" bgcolor="#339933">
		<tr>
			<td align="left">
				<h1><%=getServletContext().getInitParameter("app_name")%></h1>
			</td>
			<td align="right">
				<h2>Current Node:
				<%
					if(user != null && user.getGraph().getSelected() != null){
				%>
						<a href="cimap.jsp?tab=nodedetails"><%= user.getGraph().getSelected().getName()%></a>
				<%
					} else {
				%>
					N/A
				<%	
					}
				%>
				</h2>	
			</td>
		</tr>
	</table>
</div>


<div class="tabber">
     <div class="tabbertab" id="themes">
	  <h2>Themes</h2>
     </div>

	 <div class="tabbertab" id="search">
	  <h2>Search</h2>
     </div>

	<div class="tabbertab" id="searchpaths">
	  <h2>Search Paths</h2>
    </div>

     <div class="tabbertab" id="nodedetails">
	  <h2>Node Details</h2>
     </div>

	<%if(user!=null){%>

	<%if(user.getType() >= User.ADMIN){%>
	 <div class="tabbertab" id="contactlist">
	  <h2>Contact Lists</h2>
     </div>
	<%}%>

	<%if(user.getType() >= User.SUPERUSER){%>
     <div class="tabbertab" id="useradmin">
	  <h2>User Admin</h2>
     </div>
	<%}%>

	<%}%>
	<div class="tabbertab" id="logout">
	  <h2>Logout</h2>
    </div>

	<div class="tabbertab" id="help">
	  <h2>User Guide</h2>
    </div>

</div>

</body>
</html>