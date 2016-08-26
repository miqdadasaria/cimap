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
				
				DateFormat fmt = new SimpleDateFormat("yyyy-mm-dd");
        if(update.equals("theme")){
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
