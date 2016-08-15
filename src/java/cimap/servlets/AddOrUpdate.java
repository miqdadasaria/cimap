package cimap.servlets;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
//import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.User;
import cimap.graph.edge.Edge;
import cimap.graph.edge.EdgeType;
import cimap.graph.edge.Eve2EveEdge;
import cimap.graph.edge.Eve2PubEdge;
import cimap.graph.edge.Ind2EveEdge;
import cimap.graph.edge.Ind2IndEdge;
import cimap.graph.edge.Ind2PubEdge;
import cimap.graph.edge.Org2EveEdge;
import cimap.graph.edge.Org2IndEdge;
import cimap.graph.edge.Org2OrgEdge;
import cimap.graph.edge.Org2PubEdge;
import cimap.graph.edge.Pub2PubEdge;
import cimap.graph.node.ContactList;
import cimap.graph.node.ContactListEntry;
import cimap.graph.node.EventNode;
import cimap.graph.node.IndividualNode;
import cimap.graph.node.NewsArticle;
import cimap.graph.node.Node;
import cimap.graph.node.NodeType;
import cimap.graph.node.OrganisationNode;
import cimap.graph.node.PublicationNode;
import cimap.graph.node.Theme;


public class AddOrUpdate extends HttpServlet {

	private static final long serialVersionUID = 7803873054024948660L;
	//private static Logger logger = Logger.getLogger(AddOrUpdate.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		String redirect = "cimap.jsp";
		if(user!=null && user.isLoggedIn()){
			String update = request.getParameter("update");
			if(!update.equals("addNode") && !update.equals("addTheme") && !update.equals("updateTheme") && !update.equals("deleteTheme") && !update.equals("addContactList") && !update.equals("updateContactList") && !update.equals("addContacts")){
				Node node = user.getGraph().getSelected();
				
				DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
				/*if(update.equals("node")){
					String name = request.getParameter("name").trim();
					if(name == null || name.equals(""))
						name = null;
					int type = Integer.parseInt(request.getParameter("type"));
					NodeType nodeType = MasterGraph.getNodeType(type);
					String photograph = request.getParameter("photo").trim();
					if(photograph == null || photograph.equals(""))
						photograph = null;
					String background = request.getParameter("background").trim();
					if(background == null || background.equals(""))
						background = null;
					String url = request.getParameter("url").trim();
					if(url == null || url.equals(""))
						url = null;
					//contact details
					ContactDetails contact = null;
					if(!nodeType.getTypeName().equals("Publication")){
						String addressLine1 = request.getParameter("addressLine1").trim();
						if(addressLine1==null || addressLine1.equals(""))
							addressLine1 = null;
						String addressLine2 = request.getParameter("addressLine2").trim();
						if(addressLine2==null || addressLine2.equals(""))
							addressLine2 = null;
						String city = request.getParameter("city").trim();
						if(city==null || city.equals(""))
							city = null;
						String state = request.getParameter("state").trim();
						if(state==null || state.equals(""))
							state = null;
						String country = request.getParameter("country").trim();
						if(country==null || country.equals(""))
							country = null;
						String postcode = request.getParameter("postcode").trim();
						if(postcode==null || postcode.equals(""))
							postcode = null;
						String phone = request.getParameter("phone").trim();
						if(phone==null || phone.equals(""))
							phone = null;
						String email = request.getParameter("email").trim();
						if(email==null || email.equals(""))
							email = null;
						String originCity = request.getParameter("originCity").trim();
						if(originCity==null || originCity.equals(""))
							originCity = null;
						String originState = request.getParameter("originState").trim();
						if(originState==null || originState.equals(""))
							originState = null;
						String originCountry = request.getParameter("originCountry").trim();
						if(originCountry==null || originCountry.equals(""))
							originCountry = null;
						String longitudeText = request.getParameter("longitude").trim();
						if(longitudeText==null || longitudeText.equals(""))
							longitudeText = null;
						double longitude = 0;
						if(longitudeText!=null){
							try{
								longitude = Double.parseDouble(longitudeText);
							}catch (Exception e) {
								logger.warning("failed to parse longitude: " + longitudeText);
							}
						}
						String latitudeText = request.getParameter("latitude").trim();
						if(latitudeText==null || latitudeText.equals(""))
							latitudeText = null;
						double latitude = 0;
						if(latitudeText!=null){
							try{
								latitude = Double.parseDouble(latitudeText);
							}catch (Exception e) {
								logger.warning("failed to parse latitude: " + latitudeText);
							}
						}
						
						contact = new ContactDetails(addressLine1,addressLine2,city,country,email,latitude,longitude,originCity,originCountry,originState,phone,postcode,state);
					}
					
					if(nodeType.getTypeName().equals("Organisation")){
						//organisation node
						int numStaff;
						try{
							numStaff = Integer.parseInt(request.getParameter("numStaff"));
						}catch (Exception e) {
							numStaff = 0;
						}
						int numCustomers;
						try{
							numCustomers = Integer.parseInt(request.getParameter("numCustomers"));
						}catch (Exception e) {
							numCustomers = 0;
						}
						((OrganisationNode)node).update(user, name, nodeType, photograph, background, url, contact, numStaff, numCustomers);
					} else if(nodeType.getTypeName().equals("Individual")){
						//individual node
						Date dob;
						try{
							dob = fmt.parse(request.getParameter("dob"));
						}catch (Exception e) {
							dob=null;
						}
						char gender;
						try{
							gender = request.getParameter("gender").charAt(0);
						}catch (Exception e) {
							gender = 'u';
						}
						((IndividualNode)node).update(user, name, nodeType, photograph, background, url, contact, dob, gender);
					} else if(nodeType.getTypeName().equals("Event")){
						//event node
						Date eventDate;
						try{
							eventDate = fmt.parse(request.getParameter("eventDate"));
						}catch (Exception e) {
							eventDate=null;
						}
						int numPresenters;
						try{
							numPresenters = Integer.parseInt(request.getParameter("numPresenters"));
						}catch (Exception e) {
							numPresenters = 0;
						}
						int numAttendees;
						try{
							numAttendees = Integer.parseInt(request.getParameter("numAttendees"));
						}catch (Exception e) {
							numAttendees = 0;
						}
						((EventNode)node).update(user, name, nodeType, photograph, background, url, contact, eventDate, numPresenters, numAttendees);
					} else if(nodeType.getTypeName().equals("Publication")){
						//publication node
						Date pubDate;
						try{
							pubDate = fmt.parse(request.getParameter("pubDate"));
						}catch (Exception e) {
							pubDate=null;
						}
						String source = request.getParameter("source").trim();
						if(source == null || source.equals(""))
							source = null;
						((PublicationNode)node).update(user, name, nodeType, photograph, background, url, pubDate, source);
					}
				}
				else*/ if(update.equals("theme")){
					String[] theme = request.getParameterValues("theme");
					if(theme != null){
						ArrayList<Theme> themes = new ArrayList<Theme>();
						for (int i = 0; i < theme.length; i++) {
							Theme a = MasterGraph.getTheme(Integer.parseInt(theme[i])); 
							themes.add(a);
							node.addTheme(user, a);
						}
						Iterator<Theme> ni = ((ArrayList<Theme>)(node.getThemes().clone())).iterator();
						while(ni.hasNext()){
							Theme a = ni.next();
							if(!themes.contains(a)){
								node.removeTheme(user, a);
							}
						}
					} else {
						node.removeAllThemes(user);
					}
				} else if(update.equals("news")){
					String headline = request.getParameter("title").trim();
					String source = request.getParameter("source").trim();
					String url = request.getParameter("url").trim();
					Date date;
					try {
						date = fmt.parse(request.getParameter("date"));
					} catch (ParseException e) {
						date = null;
					}
					NewsArticle news = new NewsArticle(user,Calendar.getInstance().getTime(),date,headline,url,source);
					node.addNews(news);
				} 
				else if(update.equals("addEdge")){
					int otherNodeId = Integer.parseInt(request.getParameter("node"));
					Node otherNode = MasterGraph.getNode(otherNodeId);
					EdgeType edgeType = MasterGraph.getEdgeType(Integer.parseInt(request.getParameter("edgeType")));
					ArrayList<Node> nodes = new ArrayList<Node>();
					nodes.add(node);
					nodes.add(otherNode);
					String details = request.getParameter("details");
					String startDateStr = request.getParameter("startDate");
					String endDateStr = request.getParameter("endDate");
					Date startDate = null;
					Date endDate = null;
					
					if(startDateStr != null){
						try {
							startDate = fmt.parse(startDateStr);
						} catch (ParseException e) {}
					}
					if(endDateStr != null){
						try {
							endDate = fmt.parse(endDateStr);
						} catch (ParseException e) {}
					}
					Edge edge = null; 
					if(edgeType.getTypeName().equals("ORG2ORG")){ 
						edge = new Org2OrgEdge(0, edgeType, startDate, endDate, details, (OrganisationNode)node, (OrganisationNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());	
					} else if(edgeType.getTypeName().equals("ORG2IND")){ 
						if(node instanceof OrganisationNode){
							edge = new Org2IndEdge(0, edgeType, startDate, endDate, details, (OrganisationNode)node, (IndividualNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						} else {
							edge = new Org2IndEdge(0, edgeType, startDate, endDate, details, (OrganisationNode)otherNode, (IndividualNode)node, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						}							
					} else if(edgeType.getTypeName().equals("ORG2EVE")){ 
						if(node instanceof OrganisationNode){
							edge = new Org2EveEdge(0, edgeType, startDate, endDate, details, (OrganisationNode)node, (EventNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						} else {
							edge = new Org2EveEdge(0, edgeType, startDate, endDate, details, (OrganisationNode)otherNode, (EventNode)node, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						}							
					} else if(edgeType.getTypeName().equals("ORG2PUB")){ 
						if(node instanceof OrganisationNode){
							edge = new Org2PubEdge(0, edgeType, startDate, endDate, details, (OrganisationNode)node, (PublicationNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						} else {
							edge = new Org2PubEdge(0, edgeType, startDate, endDate, details, (OrganisationNode)otherNode, (PublicationNode)node, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						}							
					} else if(edgeType.getTypeName().equals("IND2IND")){ 
							edge = new Ind2IndEdge(0, edgeType, startDate, endDate, details, (IndividualNode)node, (IndividualNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
					} else if(edgeType.getTypeName().equals("IND2EVE")){ 
						if(node instanceof IndividualNode){
							edge = new Ind2EveEdge(0, edgeType, startDate, endDate, details, (IndividualNode)node, (EventNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						} else {
							edge = new Ind2EveEdge(0, edgeType, startDate, endDate, details, (IndividualNode)otherNode, (EventNode)node, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						}							
					} else if(edgeType.getTypeName().equals("IND2PUB")){ 
						if(node instanceof IndividualNode){
							edge = new Ind2PubEdge(0, edgeType, startDate, endDate, details, (IndividualNode)node, (PublicationNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						} else {
							edge = new Ind2PubEdge(0, edgeType, startDate, endDate, details, (IndividualNode)otherNode, (PublicationNode)node, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						}							
					} else if(edgeType.getTypeName().equals("EVE2EVE")){ 
							edge = new Eve2EveEdge(0, edgeType, startDate, endDate, details, (EventNode)node, (EventNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
					} else if(edgeType.getTypeName().equals("EVE2PUB")){ 
						if(node instanceof EventNode){
							edge = new Eve2PubEdge(0, edgeType, startDate, endDate, details, (EventNode)node, (PublicationNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						} else {
							edge = new Eve2PubEdge(0, edgeType, startDate, endDate, details, (EventNode)otherNode, (PublicationNode)node, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
						}							
					} else if(edgeType.getTypeName().equals("PUB2PUB")){ 
							edge = new Pub2PubEdge(0, edgeType, startDate, endDate, details, (PublicationNode)node, (PublicationNode)otherNode, user, Calendar.getInstance().getTime(), user, Calendar.getInstance().getTime());
					}

					MasterGraph.addEdge(edge);
				} else if(update.equals("deleteNode")){
					MasterGraph.deleteNode(node, user);
					redirect = "cimap.jsp?tab=search";
				} 
				if(!update.equals("deleteNode")){
					user.getGraph().setSelected(user, node);
					redirect = "cimap.jsp?tab=nodedetails";
				}
			} else if(update.equals("addNode")){
				String name = request.getParameter("name");
				int type = Integer.parseInt(request.getParameter("type"));
				NodeType nodeType = MasterGraph.getNodeType(type);
				Node node = null;
				if(nodeType.getTypeName().equals("Organisation")){
					node = new OrganisationNode(0,nodeType, name, null,null,null,new ArrayList<Theme>(),new ArrayList<NewsArticle>(),new ArrayList<Edge>(), new ArrayList<Edge>(),new ArrayList<Edge>(),new ArrayList<Edge>(),user,Calendar.getInstance().getTime(),0,null,0,0, user, Calendar.getInstance().getTime());
				} else if (nodeType.getTypeName().equals("Individual")){
					node = new IndividualNode(0,nodeType, name, null,null,null,new ArrayList<Theme>(),new ArrayList<NewsArticle>(),new ArrayList<Edge>(), new ArrayList<Edge>(),new ArrayList<Edge>(),new ArrayList<Edge>(),user, Calendar.getInstance().getTime(),0, null, null, 'u', user, Calendar.getInstance().getTime());
				} else if (nodeType.getTypeName().equals("Event")){
					node = new EventNode(0,nodeType,name,null,null,null,new ArrayList<Theme>(), new ArrayList<NewsArticle>(),new ArrayList<Edge>(),new ArrayList<Edge>(), new ArrayList<Edge>(),new ArrayList<Edge>(),user,Calendar.getInstance().getTime(),0,null,null,0,0, user, Calendar.getInstance().getTime());
				} else if (nodeType.getTypeName().equals("Publication")){
					node = new PublicationNode(0,nodeType,name,null,null,null,new ArrayList<Theme>(), new ArrayList<NewsArticle>(),new ArrayList<Edge>(),new ArrayList<Edge>(), new ArrayList<Edge>(),new ArrayList<Edge>(),user,Calendar.getInstance().getTime(),0,null,null, user, Calendar.getInstance().getTime());
				}
				if(MasterGraph.addNode(node)){
					user.getGraph().setSelected(user, node);
					redirect = "cimap.jsp?tab=nodedetails";
				} else {
					redirect= "quotaExceeded.jsp";
				}
			} else if(update.equals("addTheme")){
				String name = request.getParameter("name");
				String description = request.getParameter("description");
				String keywords = request.getParameter("keywords");
				ArrayList<String> keywordList = new ArrayList<String>();
				if (keywords != null) {
					String[] keyword = keywords.split(",");
					for (int i = 0; i < keyword.length; i++) {
						keywordList.add(keyword[i]);
					}
				}

				Theme theme = new Theme(0, name, description,keywordList);
				MasterGraph.addNewTheme(user, theme);
				session.removeAttribute("themeid");
				redirect = "cimap.jsp?tab=themes";
			} else if(update.equals("updateTheme")){
				String name = request.getParameter("name");
				String description = request.getParameter("description");
				String keywords = request.getParameter("keywords");
				int themeId = Integer.parseInt(request.getParameter("themeId"));
				Theme theme = MasterGraph.getTheme(themeId);
				ArrayList<String> keywordList = new ArrayList<String>();
				if (keywords != null) {
					String[] keyword = keywords.split(",");
					for (int i = 0; i < keyword.length; i++) {
						keywordList.add(keyword[i]);
					}
				}
				theme.update(user, name, description, keywordList);
				redirect = "cimap.jsp?tab=themes";
			} else if(update.equals("deleteTheme")){
				int themeId = Integer.parseInt(request.getParameter("themeId"));
				Theme theme = MasterGraph.getTheme(themeId);
				MasterGraph.deleteTheme(theme, user);
				session.removeAttribute("themeid");
				redirect = "cimap.jsp?tab=themes";
			} else if(update.equals("addContactList")){
				String name = request.getParameter("name");
				String description = request.getParameter("description");
				ContactList list = new ContactList(0, name, description,new ArrayList<ContactListEntry>(),user,Calendar.getInstance().getTime());
				MasterGraph.addNewContactList(list);
				session.removeAttribute("contactListId");
				redirect = "cimap.jsp?tab=contactlist";
			} else if(update.equals("updateContactList")){
				String name = request.getParameter("name");
				String description = request.getParameter("description");
				int contactListId = Integer.parseInt(request.getParameter("contactListId"));
				ContactList list = MasterGraph.getContactList(contactListId);
				list.update(user, name, description);
				String[] contacts = request.getParameterValues("contact");
				if(contacts != null){
					ArrayList<Node> nodes = new ArrayList<Node>();
					for (int i = 0; i < contacts.length; i++) {
						Node node = MasterGraph.getNode(Integer.parseInt(contacts[i]));
						nodes.add(node);
					}
					Iterator<ContactListEntry> ce = ((ArrayList<ContactListEntry>)(list.getContacts().clone())).iterator();
					while(ce.hasNext()){
						ContactListEntry current = ce.next();
						if(!nodes.contains(current.getNode()))
							list.removeContact(user, current);
					}
				}
				redirect = "cimap.jsp?tab=contactlist";
			} else if(update.equals("addContacts")){
				int contactListId = Integer.parseInt(request.getParameter("contactListId"));
				ContactList list = MasterGraph.getContactList(contactListId);
				String[] contacts = request.getParameterValues("contact");
				if(contacts != null){
					Date dateAdded = Calendar.getInstance().getTime();
					for (int i = 0; i < contacts.length; i++) {
						Node node = MasterGraph.getNode(Integer.parseInt(contacts[i]));
						ContactListEntry contact = new ContactListEntry(0,node,user,dateAdded);
						list.addContact(contact);
					}
				}
				redirect = "cimap.jsp?tab=contactlist";
			}
		}
    	response.sendRedirect(redirect);
	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
