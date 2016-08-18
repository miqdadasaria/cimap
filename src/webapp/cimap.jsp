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
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	user = (User)(session.getAttribute("username"));
	if (request.getParameter("tab") != null && !request.getParameter("tab").equals("")){
		tab = request.getParameter("tab");
	} else {
		tab = "themes";
	}
%>
<!DOCTYPE html>
<html lang="en">
	<head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
	    <title><%=getServletContext().getInitParameter("app_name")%></title>
	    <!-- Bootstrap core CSS -->
	    <link href="./css/bootstrap.min.css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
			function confirmDeleteNode(nodeName){
				var agree=confirm("Are you sure you want to delete node: " + nodeName + "?");
				if (agree)
					return true ;
				else
					return false ;
			}
			function confirmDeleteTheme(themeName){
				var agree=confirm("Are you sure you want to delete theme: " + themeName + "?");
				if (agree)
					return true ;
				else
					return false ;
			}
			function confirmDeleteUser(userName){
				var agree=confirm("Are you sure you want to delete user: " + userName + "?");
				if (agree)
					return true ;
				else
					return false ;
			}
			function confirmDeleteList(listName){
				var agree=confirm("Are you sure you want to delete contact lis: " + listName + "?");
				if (agree)
					return true ;
				else
					return false ;
			}
			function confirmDeleteEdge(){
				var agree=confirm("Are you sure you want to delete this relationship?");
				if (agree)
					return true ;
				else
					return false ;
			}
		</script>
	</head>
<body>
    
	<div class="container">

	      <nav class="navbar navbar-inverse navbar-fixed-top">
	        <div class="container">
	          <div class="navbar-header">
	            <a class="navbar-brand" href="#">
		            <%=getServletContext().getInitParameter("app_name")%>
	            </a>
	          </div>

	          <div id="navbar" class="collapse navbar-collapse pull-right">
	            <ul class="nav navbar-nav">
	              <li class=""><a href="userGuide.jsp">Tutorial</a></li>
	              <li class=""><a href="login.jsp">Logout</a></li>
	            </ul>
	          </div>
	        </div>
	      </nav>

      <div class="page-header">
        <h1></h1>
      </div>

	    <div>
	        <!-- Nav tabs -->
	        <ul class="nav nav-tabs" role="tablist">
	          <li role="presentation" <%if(tab.equals("themes")){%>class="active"<%}%>><a href="#theme" aria-controls="theme" role="tab" data-toggle="tab">Themes</a></li>
	         <li role="presentation" <%if(tab.equals("search")){%>class="active"<%}%>><a href="#search" aria-controls="search" role="tab" data-toggle="tab">Search</a></li>
	         <li role="presentation" <%if(tab.equals("searchpaths")){%>class="active"<%}%>><a href="#paths" aria-controls="paths" role="tab" data-toggle="tab">Search Paths</a></li>
	          <li role="presentation" <%if(tab.equals("nodedetails")){%>class="active"<%}%>><a href="#details" aria-controls="details" role="tab" data-toggle="tab">Node Details</a></li>
			<%if(user.getType() >= User.SUPERUSER){%>
		      <li role="presentation" <%if(tab.equals("useradmin")){%>class="active"<%}%>><a href="#admin" aria-controls="admin" role="tab" data-toggle="tab">Admin</a></li>
	        <%}%>
	        </ul>

	        <!-- Tab panes -->
	        <div class="tab-content">

	          <div role="tabpanel" class="tab-pane <%if(tab.equals("themes")){%>active<%}%>" id="theme">
	          	<%
				String update = (String)(session.getAttribute("update"));
				String themeurl = "themes.jsp";
				if(update != null && update.equals("updateTheme")){
					themeurl = "updateTheme.jsp";
				} else if(update != null && update.equals("addTheme")){
					themeurl= "addTheme.jsp";
				} else if(session.getAttribute("themeid") != null){
					themeurl = "themeDetails.jsp";
				}%>
				<jsp:include page="<%=themeurl%>"/>
	          </div>

	          <div role="tabpanel" class="tab-pane <%if(tab.equals("nodedetails")){%>active<%}%>" id="details">
				<%
				String nodeurl = "nodeDetails.jsp";
				if(update != null){
					if(update.equals("nodeTheme")){
						nodeurl="updateNodeTheme.jsp";
					} else if (update.equals("addNode")){
						nodeurl="addNode.jsp";
					} else if (update.equals("nodeNews")){
						nodeurl="addNews.jsp";
					} else if (update.equals("updateNode")){
						nodeurl="updateNode.jsp";
					} else if (update.equals("addEdge")){
						nodeurl="addRelatedNode.jsp";
					} else if(update.equals("updateEdge")){
						nodeurl = "updateEdge.jsp";
					} else if(update.equals("edgeDetails")){
						nodeurl = "edgeDetails.jsp";
					}
				}%>
					<jsp:include page="<%=nodeurl%>"/>
	          </div>

	          <div role="tabpanel" class="tab-pane <%if(tab.equals("search")){%>active<%}%>" id="search">
	          	<%String searchurl = "search.jsp";
				if(session.getAttribute("query") != null){
					searchurl = "searchResults.jsp";
				}%>
				<jsp:include page="<%=searchurl%>"/>				
	          </div>
  
	          <div role="tabpanel" class="tab-pane <%if(tab.equals("searchpaths")){%>active<%}%>" id="paths">
				<%String pathurl = "searchPaths.jsp";
				if(session.getAttribute("pathQuery") != null){
					pathurl = "searchPathsResults.jsp";
				}%>
				<jsp:include page="<%=pathurl%>"/>
	          </div>



		 	<%if(user.getType() >= User.SUPERUSER){%>
	          <div role="tabpanel" class="tab-pane <%if(tab.equals("useradmin")){%>active<%}%>" id="admin">
	           		<%String adminurl = "userAdmin.jsp";
	           		if(update !=null && update.equals("addUser")){
						adminurl = "addUser.jsp";
					} else if(update !=null && update.equals("updateUser")){
						adminurl = "updateUser.jsp";
					}%>
					<jsp:include page="<%=adminurl%>"/>
	          </div>
	   		<%}%>

    	</div>

    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script>window.jQuery</script>
    <script src="./js/bootstrap.min.js"></script>
</body>
</html>
<%}%>