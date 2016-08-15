<%@page import="cimap.graph.*"%>
<%@page import="cimap.graph.node.*"%>
<%@page import="cimap.graph.edge.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-store,no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Collaborative Intelligence Map</title>
	<link type="text/css" rel="stylesheet" href="./css/infovis.css" />
	<link type="text/css" rel="stylesheet" href="./css/cimap-rgraph.css" />

	<script type="text/javascript" src="./js/mootools-beta-1.2b2.js"></script>
<!--[if IE]><script language="javascript" type="text/javascript" src="./js/excanvas.js"></script><![endif]-->
	<script language="javascript" type="text/javascript" src="./js/RGraph.js"></script>
	<script language="javascript" type="text/javascript" src="./js/infovis.js"></script>
	<script language="javascript" type="text/javascript" src="./js/cimap-rgraph.js"></script>

</head>
<%
if (((User)(session.getAttribute("username"))).getGraph().getSelected() == null){
%>
<body>
<p>You must select a node first</p>
</body>
<%
} else {
	User user = (User)(session.getAttribute("username"));
%>
	<script language="javascript" type="text/javascript">

		function updateJSON(layers)	{
			window.location.href='JSON?id=' + my_node.id+'&layers='+layers;	
		}
		
		function changeLayer(){
			if(document.getElementById("check_box_form").check1.checked)b1=1;else b1=0;
			if(document.getElementById("check_box_form").check2.checked)b2=1;else b2=0;
			if(document.getElementById("check_box_form").check3.checked)b3=1;else b3=0;
			if(document.getElementById("check_box_form").check4.checked)b4=1;else b4=0;
			layers=b1+","+b2+","+b3+","+b4;			
			updateJSON(layers);			
		}
		var json = <%= user.getGraph().getSelected().toJSON() %>
	</script>
<%
%>
<body onload="init();">

<div id="header">
	


</div>
<div id="left">
	
	<div class="small-title"><a href="cimap.jsp?tab=search"><font color="white">Collaborative Intelligence Map</font></a></div>
	<div id="details" class="toggler left-item">Connections</div>
	<div class="element contained-item">
		<div class="inner" id="inner-details">
			No Connections Listed<br />
			<a href="cimap.jsp?tab=nodedetails">Back</a><br />
		</div>		
	</div>		
</div>

<div id="right">	

	<div class="small-title"><font color="white">Filter by Node Type</font></div>
	<div id="details1" class="toggler left-item">Layers</div>
	<div class="element contained-item">
		<div class="inner" id="inner-details1">
				<form id="check_box_form">
					<input type="checkbox" name="check1" onclick="changeLayer()" <%if(user.getGraph().getSelected().getLayers()[0]){%> checked="checked"<%} %>/> Individuals<br />
					<input type="checkbox" name="check2" onclick="changeLayer()" <%if(user.getGraph().getSelected().getLayers()[1]){%> checked="checked"<%} %>/> Organisations<br />
					<input type="checkbox" name="check3" onclick="changeLayer()" <%if(user.getGraph().getSelected().getLayers()[2]){%> checked="checked"<%} %>/> Events<br />
					<input type="checkbox" name="check4" onclick="changeLayer()" <%if(user.getGraph().getSelected().getLayers()[3]){%> checked="checked"<%} %>/> Publications<br />
				</form>			
				<hr width="90%">
				<center>
				<form method="post" action="Search">
				<input type="hidden" name="query" value="search">
				&nbsp;<input type="text" name="name"></input><br />
				&nbsp;<input type="submit" name="submit" value="search">
				</form>
				</center>
		</div>
	</div>			
</div>

	
<canvas id="infovis"></canvas>
<div id="label_container"></div>

</body>
<%}%>
</html>
<%
}
%>