package cimap.graph;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.logging.Logger;

import cimap.database.Persistence;
import cimap.graph.edge.Edge;
import cimap.graph.edge.EdgeType;
import cimap.graph.node.ContactDetails;
import cimap.graph.node.ContactList;
import cimap.graph.node.ContactListEntry;
import cimap.graph.node.EventNode;
import cimap.graph.node.IndividualNode;
import cimap.graph.node.Node;
import cimap.graph.node.NodeType;
import cimap.graph.node.OrganisationNode;
import cimap.graph.node.Theme;

public class MasterGraph {
	private static Logger logger = Logger.getLogger(MasterGraph.class.getName());

	protected static ArrayList<Edge> edges;
	protected static ArrayList<Node> nodes;
	private static ArrayList<Theme> themes;
	private static ArrayList<User> users;
	private static ArrayList<NodeType> nodeTypes;
	private static ArrayList<EdgeType> edgeTypes;
	private static ArrayList<ContactList> contactLists;
	
	private Node selected;
	private Edge selectedEdge;
	
	public MasterGraph() {
		if (users == null) {
			users = Persistence.populateUsersFromDB();
			Collections.sort(users);
			logger.info("Populated user list with: " + users.size() + " users");
		}
		if (themes == null) {
			themes = Persistence.populateThemesFromDB();
			Collections.sort(themes);
			logger.info("Populated themes list with " + themes.size() + " themes");
		}
		if (nodeTypes == null) {
			nodeTypes = Persistence.populateNodeTypesFromDB();
			Collections.sort(nodeTypes);
			logger.info("Populated node type list with " + nodeTypes.size() + " node types");
		}
		if (edgeTypes == null) {
			edgeTypes = Persistence.populateEdgeTypesFromDB();
			Collections.sort(edgeTypes);
			logger.info("Populated edge type list with " + edgeTypes.size() + " edge types");
		}
		if (nodes == null) {
			nodes = Persistence.populateNodesFromDB();
			Collections.sort(nodes);
			logger.info("Populated node list with " + nodes.size() + " nodes");
		}
		if (edges == null) {
			edges = Persistence.populateEdgesFromDB();
			logger.info("Populating edge list with " + edges.size() + " edges");
		}
		if (contactLists == null) {
			contactLists = Persistence.populateContactListsFromDB();
			Collections.sort(contactLists);
			logger.info("Populating contact lists with " + contactLists.size() + " lists");
		}
	}


	public static Theme getTheme(int id) {
		Iterator<Theme> i = themes.iterator();
		Theme a = null;
		while (i.hasNext()) {
			a = i.next();
			if (a.getId() == id)
				return a;
		}
		return null;
	}

	public static ContactList getContactList(int id) {
		Iterator<ContactList> i = contactLists.iterator();
		ContactList a = null;
		while (i.hasNext()) {
			a = i.next();
			if (a.getId() == id)
				return a;
		}
		return null;
	}

	
	public static User getUser(int id) {
		Iterator<User> i = users.iterator();
		User u = null;
		while (i.hasNext()) {
			u = i.next();
			if (u.getId() == id)
				return u;
		}
		return null;
	}

	public User getUserByUsername(String username) {
		Iterator<User> i = users.iterator();
		User u = null;
		while (i.hasNext()) {
			u = i.next();
			if (u.getUsername().equals(username))
				return u;
		}
		return null;
	}

	public static ArrayList<User> getAllUsers(){
		return users;
	}
	

	public void setSelected(User user, Node sel) {
		if (user != null && user.getNodeViewQuota() > 0 && user.getNodeViewCount() >= user.getNodeViewQuota()) {
			logger.warning("View node permission denied quota exceed user id: " + user.getId());
		} else {
			selected = sel;
			if(sel != null){
				user.setNodeViewCount(user.getNodeViewCount() + 1);
				selected.setViewCount(user, selected.getViewCount() + 1);
			}
		}
	}

	public Node getSelected() {
		return selected;
	}

	public void setSelectedEdge(Edge sel){
		if(sel!=null){
			selectedEdge = sel;
		}
	}
	
	public Edge getSelectedEdge(){
		return selectedEdge;
		
	}
	
	
	public static ArrayList<Theme> getThemeList() {
		return themes;
	}

	public static ArrayList<ContactList> getContactLists(){
		return contactLists;
	}
	
	public static ArrayList<NodeType> getNodeTypeList() {
		return nodeTypes;
	}
	
	public static ArrayList<NodeType> getNodeSubTypeList(String nodeType) {
		ArrayList<NodeType> results = new ArrayList<NodeType>();
		Iterator<NodeType> i = nodeTypes.iterator();
		NodeType current = null;
		while(i.hasNext()){
			current = i.next();
			if(current.getTypeName().equals(nodeType))
				results.add(current);
		}
		return results;
	}

	public static ArrayList<EdgeType> getEdgeTypeList() {
		return edgeTypes;
	}

	public static ArrayList<EdgeType> getCompatibleEdgeTypeList(NodeType type, String otherNodeType){
		ArrayList<EdgeType> types = new ArrayList<EdgeType>();
		Iterator<EdgeType> i = edgeTypes.iterator();
		while(i.hasNext()){
			EdgeType et = i.next();
			if(type.getTypeName().equals("Organisation")){
				if(otherNodeType.equals("Organisation") && et.getTypeName().equals("ORG2ORG")){
					types.add(et);
				} else if(otherNodeType.equals("Individual") && et.getTypeName().equals("ORG2IND")){
					types.add(et);
				} else if(otherNodeType.equals("Event") && et.getTypeName().equals("ORG2EVE")){
					types.add(et);
				} else if(otherNodeType.equals("Publication") && et.getTypeName().equals("ORG2PUB")){
					types.add(et);
				}
			} else if(type.getTypeName().equals("Individual")){
				if(otherNodeType.equals("Organisation") && et.getTypeName().equals("ORG2IND")){
					types.add(et);
				} else if(otherNodeType.equals("Individual") && et.getTypeName().equals("IND2IND")){
					types.add(et);
				} else if(otherNodeType.equals("Event") && et.getTypeName().equals("IND2EVE")){
					types.add(et);
				} else if(otherNodeType.equals("Publication") && et.getTypeName().equals("IND2PUB")){
					types.add(et);
				}
			} else if(type.getTypeName().equals("Event")){
				if(otherNodeType.equals("Organisation") && et.getTypeName().equals("ORG2EVE")){
					types.add(et);
				} else if(otherNodeType.equals("Individual") && et.getTypeName().equals("IND2EVE")){
					types.add(et);
				} else if(otherNodeType.equals("Event") && et.getTypeName().equals("EVE2EVE")){
					types.add(et);
				} else if(otherNodeType.equals("Publication") && et.getTypeName().equals("EVE2PUB")){
					types.add(et);
				}
			} else if(type.getTypeName().equals("Publication")){
				if(otherNodeType.equals("Organisation") && et.getTypeName().equals("ORG2PUB")){
					types.add(et);
				} else if(otherNodeType.equals("Individual") && et.getTypeName().equals("IND2PUB")){
					types.add(et);
				} else if(otherNodeType.equals("Event") && et.getTypeName().equals("EVE2PUB")){
					types.add(et);
				} else if(otherNodeType.equals("Publication") && et.getTypeName().equals("PUB2PUB")){
					types.add(et);
				}
			} 
		}	
		return types;
	}
	
	public static void addEdge(Edge edge) {
		if (edge.getAddedBy().getType() >= User.ADMIN) {
			Node node1 = edge.getNodes().get(0);
			Node node2 = edge.getNodes().get(1);
			if (Persistence.addNewEdgeToDB(edge) == 0) {
				addNodeRelationship(node1, node2, edge);
				edges.add(edge);
			}
		}
	}

	public static void addNodeRelationship(Node node1, Node node2, Edge edge) {
		if (node1.getType().getTypeName().equals("Individual")) {
			node2.addRelatedIndividual(edge);
		} else if (node1.getType().getTypeName().equals("Event")) {
			node2.addRelatedEvent(edge);
		} else if (node1.getType().getTypeName().equals("Publication")) {
			node2.addRelatedPublication(edge);
		} else {
			node2.addRelatedOrganisation(edge);
		}
		if (node2.getType().getTypeName().equals("Individual")) {
			node1.addRelatedIndividual(edge);
		} else if (node2.getType().getTypeName().equals("Event")) {
			node1.addRelatedEvent(edge);
		} else if (node2.getType().getTypeName().equals("Publication")) {
			node1.addRelatedPublication(edge);
		} else {
			node1.addRelatedOrganisation(edge);
		}
	}

	public static void addNewUser(User newUser, User addedBy) {
		if (addedBy.getType() >= User.SUPERUSER) {
			users.add(newUser);
			Persistence.addNewUser(newUser, addedBy);
		} else {
			logger.warning("Add user permission denied user type:" + addedBy.getType() + " id: " + addedBy.getId());
		}
	}

	public static void addNewContactList(ContactList contactList) {
		if (contactList.getCreatedBy().getType() >= User.ADMIN) {
			contactLists.add(contactList);
			Persistence.addNewContactListToDB(contactList);
		} else {
			logger.warning("Add contact list permission denied user type:" + contactList.getCreatedBy().getType() + " id: " + contactList.getCreatedBy().getId());
		}
	}

	
	public static boolean addNode(Node node) {
		if (node.getAddedBy().getType() >= User.ADMIN) {
			if ((node.getAddedBy().getNodeAddQuota() < 0) || (node.getAddedBy().getNodeAddCount() < node.getAddedBy().getNodeAddQuota())) {
				nodes.add(node);
				Collections.sort(nodes);
				Persistence.addNewNodeToDB(node);
				node.getAddedBy().setNodeAddCount(node.getAddedBy().getNodeAddCount() + 1);
				return true;
			} else {
				logger.warning("Add node quota exceeded for user id: " + node.getAddedBy().getId());
				return false;
			}
		} else {
			logger.warning("Add node permission denied user type:" + node.getAddedBy().getType() + " id: " + node.getAddedBy().getId());
			return false;
		}
	}

	public static void deleteNode(Node node, User user) {
		if (user.getType() >= User.ADMIN) {
			nodes.remove(nodes.indexOf(node));
			ArrayList<Edge> edges = new ArrayList<Edge>();
			edges.addAll(node.getRelatedOrganisations());
			edges.addAll(node.getRelatedIndividuals());
			edges.addAll(node.getRelatedEvents());
			edges.addAll(node.getRelatedPublications());
			Iterator<Edge> i = edges.iterator();
			while (i.hasNext())
				deleteEdge(i.next(), user);
			
			if(node.getId() == user.getGraph().getSelected().getId())
				user.getGraph().setSelected(user, null);
			//remove from all contact lists
			Iterator<ContactList> lists = contactLists.iterator();
			while(lists.hasNext()){
				ContactList list = lists.next();
				if(list.getContacts()!=null){
					Iterator<ContactListEntry> entries = ((ArrayList<ContactListEntry>)(list.getContacts().clone())).iterator();
					while(entries.hasNext()){
						ContactListEntry entry = entries.next();
						if(node.getId() == entry.getNode().getId())
							list.removeContact(user, entry);
					}
				}
			}
			Persistence.deleteNode(node, user);
		} else {
			logger.warning("Delete node permission denied user type:" + user.getType() + " id: " + user.getId());
		}

	}

	public static void deleteEdge(Edge edge, User user) {
		if (user.getType() >= User.ADMIN) {
			edges.remove(edges.indexOf(edge));
			edge.getNodes().get(0).deleteEdge(user, edge);
			edge.getNodes().get(1).deleteEdge(user, edge);
			Persistence.deleteEdge(edge, user);
		} else {
			logger.warning("Delete edge permission denied user type:" + user.getType() + " id: " + user.getId());
		}
	}
	
	public static void deleteUser(User userToDelete, User user){
		if(user.getType()>=User.SUPERUSER && user.getId()!=userToDelete.getId()){
			userToDelete.logout();
			users.remove(userToDelete);
			Persistence.deleteUser(userToDelete, user);
		} else {
			logger.warning("Delete user permission denied user type:" + user.getType() + " id: " + user.getId());
		}
	}

	public static void deleteContactList(ContactList contactList, User user) {
		if (user.getType() >= User.ADMIN) {
			contactLists.remove(contactList);
			Persistence.deleteContactList(user, contactList);
		} else {
			logger.warning("Delete contact list permission denied user type:" + user.getType() + " id: " + user.getId());
		}
	}
	
	public static NodeType getNodeType(int type) {
		Iterator<NodeType> i = nodeTypes.iterator();
		NodeType nt = null;
		while (i.hasNext()) {
			nt = i.next();
			if (nt.getId() == type)
				return nt;
		}
		return null;
	}

	public static EdgeType getEdgeType(int type) {
		Iterator<EdgeType> i = edgeTypes.iterator();
		EdgeType et = null;
		while (i.hasNext()) {
			et = i.next();
			if (et.getId() == type)
				return et;
		}
		return null;
	}

	public static void addNewTheme(User user, Theme theme) {
		if (user.getType() >= User.ADMIN) {
				themes.add(theme);
				Collections.sort(themes);
				Persistence.addNewThemeToDB(user, theme);
		} else {
			logger.warning("Add theme permission denied user type:" + user.getType() + " id: " + user.getId());
		}
	}

	public static void deleteTheme(Theme theme, User user) {
		if (user.getType() >= User.ADMIN) {
			Iterator<Node> n = nodes.iterator();
			while(n.hasNext()){
				Node node = n.next();
				if(node.getThemes() != null)
					node.getThemes().remove(theme);
			}
			themes.remove(theme);
			Persistence.removeThemeFromDB(theme, user);
		} else {
			logger.warning("Remove theme permission denied user type:" + user.getType() + " id: " + user.getId());
		}
	}

	public static int getNumNodes(){
		return nodes.size();
	}

	public static int getNumEdges(){
		return edges.size();
	}

	
	// get a specified node from the node list
	public static Node getNode(int nodeId) {
		Iterator<Node> i = nodes.iterator();
		Node n = null;
		while (i.hasNext()) {
			n = i.next();
			if (n.getId() == nodeId) {
				return n;
			}
		}
		return n;
	}

	public static Edge getEdge(int edgeId) {
		Iterator<Edge> i = edges.iterator();
		Edge e = null;
		while (i.hasNext()) {
			e = i.next();
			if (e.getId() == edgeId)
				return e;
		}
		return e;
	}

	// Searches for all matching nodes in the graph
	public static ArrayList<Node> searchNodes(ArrayList<Node> nodeList, SearchQuery query) {
		ArrayList<Node> searchResults = new ArrayList<Node>();
		Iterator<Node> i = nodeList.iterator();
		Node currentNode;
		while (i.hasNext()) {
			currentNode = i.next();
			boolean add = true;
			if(query.getName() != null && !query.getName().equals("")){
				if (!currentNode.getName().toLowerCase().contains(query.getName().toLowerCase()))
					add=false;
			}
			
			if (query.getBackground() != null && !query.getBackground().equals("")) {
				if (currentNode.getBackground()== null || !currentNode.getBackground().toLowerCase().contains(query.getBackground().toLowerCase()))
					add = false;
			}

			ContactDetails contact = null;
			if(currentNode instanceof OrganisationNode)
				contact = ((OrganisationNode)currentNode).getContact();
			else if(currentNode instanceof IndividualNode)
				contact = ((IndividualNode)currentNode).getContact();
			else if(currentNode instanceof EventNode)
				contact = ((EventNode)currentNode).getContact();

			ArrayList<Theme> themes = query.getThemes();
			Iterator<Theme> t = themes.iterator();
			while(t.hasNext()){
				Theme theme = t.next();
				if(!currentNode.getThemes().contains(theme))
					add = false;
			}
			
			if (query.getCity() != null && !query.getCity().equals("")) {				
				if(contact == null || contact.getCity()==null || !contact.getCity().toLowerCase().equals(query.getCity().toLowerCase()))
					add = false;
			}

			if (query.getCountry() != null && !query.getCountry().equals("")) {				
				if(contact == null || contact.getCountry()==null || !contact.getCountry().toLowerCase().equals(query.getCountry().toLowerCase()))
					add = false;
			}

			if (query.getState() != null && !query.getState().equals("")) {				
				if(contact == null || contact.getState()==null || !contact.getState().toLowerCase().equals(query.getState().toLowerCase()))
					add = false;
			}

			if(add)
				searchResults.add(currentNode);
		}
		Collections.sort(searchResults);
		return searchResults;
	}

	public static ArrayList<Node> searchOrgNodes(SearchQuery query){
		return searchNodes(getOrganisationNodes(), query);
	}

	public static ArrayList<Node> searchIndNodes(SearchQuery query){
		return searchNodes(getIndividualNodes(), query);
	}

	public static ArrayList<Node> searchEveNodes(SearchQuery query){
		return searchNodes(getEventNodes(), query);
	}

	public static ArrayList<Node> searchPubNodes(SearchQuery query){
		return searchNodes(getPublicationNodes(), query);
	}

	public static ArrayList<Node> getNodesByTheme(ArrayList<Node> nodeList, Theme theme) {
		ArrayList<Node> results = new ArrayList<Node>();
		Iterator<Node> i = nodeList.iterator();
		Node current;
		while (i.hasNext()) {
			current = i.next();
			if (current.getThemes().contains(theme))
				results.add(current);
		}
		Collections.sort(results);
		return results;
	}

	public static ArrayList<Node> getOrganisationNodesByTheme(Theme theme){
		return getNodesByTheme(getOrganisationNodes(), theme);
	}

	public static ArrayList<Node> getIndividualNodesByTheme(Theme theme){
		return getNodesByTheme(getIndividualNodes(), theme);
	}
	public static ArrayList<Node> getEventNodesByTheme(Theme theme){
		return getNodesByTheme(getEventNodes(), theme);
	}
	public static ArrayList<Node> getPublicationNodesByTheme(Theme theme){
		return getNodesByTheme(getPublicationNodes(), theme);
	}

	public static ArrayList<Node> getAllNodes() {
		return nodes;
	}

	public static ArrayList<Node> getOrganisationNodes() {
		ArrayList<Node> orgs = new ArrayList<Node>();
		Iterator<Node> i = nodes.iterator();
		Node current;
		while (i.hasNext()) {
			current = i.next();
			if (current.getType().getId() < 100)
				orgs.add(current);
		}
		return orgs;
	}

	public static ArrayList<Node> getIndividualNodes() {
		ArrayList<Node> inds = new ArrayList<Node>();
		Iterator<Node> i = nodes.iterator();
		Node current;
		while (i.hasNext()) {
			current = i.next();
			if (current.getType().getId() > 100 && current.getType().getId() < 200)
				inds.add(current);
		}
		return inds;
	}

	public static ArrayList<Node> getEventNodes() {
		ArrayList<Node> events = new ArrayList<Node>();
		Iterator<Node> i = nodes.iterator();
		Node current;
		while (i.hasNext()) {
			current = i.next();
			if (current.getType().getId() > 200 && current.getType().getId() < 300)
				events.add(current);
		}
		return events;
	}

	public static ArrayList<Node> getPublicationNodes() {
		ArrayList<Node> pubs = new ArrayList<Node>();
		Iterator<Node> i = nodes.iterator();
		Node current;
		while (i.hasNext()) {
			current = i.next();
			if (current.getType().getId() > 300 && current.getType().getId() < 400)
				pubs.add(current);
		}
		return pubs;
	}

	public static ArrayList<Path> searchPaths(SearchPathsQuery searchPathsQuery){
		ArrayList<Path> completePaths = new ArrayList<Path>();
		ArrayList<Path> incompletePaths = new ArrayList<Path>();
		Path path = new Path(searchPathsQuery.getStartNode(), searchPathsQuery.getStartNode(), searchPathsQuery.getEndNode(), new ArrayList<Node>(), searchPathsQuery.getMaxLength());
		incompletePaths = path.extend();
		for(int i = 0; i<searchPathsQuery.getMaxLength(); i++){
			incompletePaths = explorePaths(incompletePaths, completePaths);
		}
		// recursive way - gives stack overflow
		// completePaths = oldExplorePaths(incompletePaths);
		Collections.sort(completePaths);
		// logger.info(completePaths.toString());
		return completePaths;
	}

	private static ArrayList<Path> explorePaths(ArrayList<Path> incompletePaths, ArrayList<Path> completePaths){
		ArrayList<Path> newIncompletePaths = new ArrayList<Path>();
		Iterator<Path> i = incompletePaths.iterator();
		while(i.hasNext()){
			Path path = i.next();
			if(path.isComplete())
				completePaths.add(path);
			else if(path.length() < path.getMaxLength()){
				ArrayList<Path> newPaths = path.extend();
				newIncompletePaths.addAll(newPaths);
			}
		}
		return newIncompletePaths;
	}

}
