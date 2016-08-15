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

if(session.getAttribute("username") == null || !(((User)(session.getAttribute("username"))).isLoggedIn())){
	String url = "login.jsp";
	response.sendRedirect(url);
} else {
	User user = (User)(session.getAttribute("username"));
	DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
%>
<center>
<table>
<tr>
<td valign="center">
<div id="left">
	
	<div class="small-title"><%=getServletContext().getInitParameter("app_name")%></div>
	<div class="small-title2">Contact Lists</div>
	<div class="element contained-item">
			<div class="inner" id="inner-details">
			<% if(user.getType() >=User.ADMIN){%>
				<form method="post" action="ContactLists">
				<input type="hidden" name="update" value="addContactList">
				<p align="right"><button name="submit" value="submit" type="submit"><img src="images/new.png" alt="add new contact list"></button></p>
				</form>
			<%}%>
				<h3>Contact Lists</h3>
			<%
				ArrayList<ContactList> lists = MasterGraph.getContactLists();
				Iterator<ContactList> i = lists.iterator();
				ContactList list;
				while(i.hasNext()){
					list = i.next();
			%>			
				<a href="ContactLists?contactListId=<%= list.getId() %>"><%= list.getName() %></a> (<%= fmt.format(list.getDateCreated())%>)<br />
			<%  }%>
			</div>
	</div>
</div>

</td>
</tr>
</table>

</center>
<%}%>