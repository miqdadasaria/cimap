package cimap.database;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.logging.Logger;

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
import cimap.graph.node.AbstractNodeImpl;
import cimap.graph.node.ContactDetails;
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

public class Persistence {
	private static Logger logger = Logger.getLogger(AbstractNodeImpl.class.getName());

	public static ArrayList<Node> populateNodesFromDB() {
		ArrayList<Node> nodes = new ArrayList<Node>();
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			Statement s2 = con.createStatement();
			sql = "SELECT n.*, nt.id AS node_type_id, nt.node_type AS node_type_name, nt.node_sub_type AS node_sub_type_name FROM node n INNER JOIN def_node_type nt ON n.node_type=nt.id WHERE is_active";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			ResultSet rs2;
			while (rs.next()) {
				// add themes to the node
				int nodeId = rs.getInt("id");
				ArrayList<Theme> themes = new ArrayList<Theme>();
				s2.executeQuery("SELECT nt.theme_id FROM node_theme AS nt WHERE nt.node_id=" + nodeId);
				rs2 = s2.getResultSet();
				while (rs2.next()) {
					themes.add(MasterGraph.getTheme(rs2.getInt("theme_id")));
				}

				// add news
				ArrayList<NewsArticle> news = new ArrayList<NewsArticle>();
				s2
						.execute("SELECT p.* FROM news AS p, node_news AS np WHERE np.news_id = p.id AND p.pub_type='newspaper' AND p.is_active AND np.node_id ="
								+ nodeId);
				rs2 = s2.getResultSet();
				while (rs2.next()) {
					news.add(new NewsArticle(MasterGraph.getUser(rs2.getInt("added_by")), rs2.getDate("date_added"), rs2.getDate("pub_date"), rs2.getString("title"),
							rs2.getString("pub_url"), rs2.getString("pub_source")));
				}

				// node type
				NodeType type = new NodeType(rs.getInt("node_type_id"), rs.getString("node_type_name"), rs.getString("node_sub_type_name"));
				
				// added by
				User addedBy = MasterGraph.getUser(rs.getInt("added_by"));
				
				// modified by
				User modBy = MasterGraph.getUser(rs.getInt("mod_by"));
				
				ContactDetails contact = new ContactDetails(
						rs.getString("address_line1"), 
						rs.getString("address_line2"), 
						rs.getString("city"), 
						rs.getString("country"), 
						rs.getString("email"),
						rs.getDouble("latitude"), 
						rs.getDouble("longitude"), 
						rs.getString("origin_city"), 
						rs.getString("origin_country"),
						rs.getString("origin_state"), 
						rs.getString("phone"), 
						rs.getString("postcode"),
						rs.getString("state") 
						);
				
				// create node
				Node node;
				if(type.getTypeName().equals("Organisation")){
					//organisation node
					node = new OrganisationNode(
							rs.getInt("id"), 
							type, 
							rs.getString("name"), 
							rs.getString("photograph"), 
							rs.getString("node_url"), 
							rs.getString("background"), 
							themes, 
							news, 
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 	
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 
							addedBy, 
							rs.getDate("date_added"),
							rs.getInt("view_count"),
							contact,
							rs.getInt("size1"),
							rs.getInt("size2"),
							modBy,
							rs.getDate("mod_date")
							);
				} else if (type.getTypeName().equals("Individual")) {
					//individual node
					char gender = 'u';
					if(rs.getString("gender") != null) 
						gender = rs.getString("gender").charAt(0);

					node = new IndividualNode(
							rs.getInt("id"), 
							type, 
							rs.getString("name"), 
							rs.getString("photograph"), 
							rs.getString("node_url"), 
							rs.getString("background"), 
							themes, 
							news, 
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 	
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 
							addedBy, 
							rs.getDate("date_added"),
							rs.getInt("view_count"),
							contact,
							rs.getDate("date"),
							gender,
							modBy,
							rs.getDate("mod_date")
							);
				} else if (type.getTypeName().equals("Event")) {
					//event node
					node = new EventNode(							
							rs.getInt("id"), 
							type, 
							rs.getString("name"), 
							rs.getString("photograph"), 
							rs.getString("node_url"), 
							rs.getString("background"), 
							themes, 
							news, 
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 	
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 
							addedBy, 
							rs.getDate("date_added"),
							rs.getInt("view_count"),
							contact,
							rs.getDate("date"),
							rs.getInt("size1"),
							rs.getInt("size2"),
							modBy,
							rs.getDate("mod_date")
							);
				}  else {
					//publication node
					node = new PublicationNode(							
							rs.getInt("id"), 
							type, 
							rs.getString("name"), 
							rs.getString("photograph"), 
							rs.getString("node_url"), 
							rs.getString("background"), 
							themes, 
							news, 
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 	
							new ArrayList<Edge>(), 
							new ArrayList<Edge>(), 
							addedBy, 
							rs.getDate("date_added"),
							rs.getInt("view_count"),
							rs.getDate("date"),
							rs.getString("source"),
							modBy,
							rs.getDate("mod_date")
							);
				} 
				nodes.add(node);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.warning(e.getMessage() + "\n" + sql);
			return null;
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		return nodes;
	}

	public static ArrayList<Edge> populateEdgesFromDB() {
		ArrayList<Edge> edges = new ArrayList<Edge>();
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "SELECT e.*, et.id AS edge_type_id, et.edge_type AS edge_type_name, et.edge_sub_type AS edge_sub_type_name FROM edge AS e INNER JOIN node AS n1 ON e.node1 = n1.id INNER JOIN node AS n2 ON e.node2=n2.id INNER JOIN def_edge_type et ON et.id=e.edge_type WHERE e.is_active AND n1.is_active AND n2.is_active";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			while (rs.next()) {
				EdgeType edgeType = new EdgeType(rs.getInt("edge_type_id"), rs.getString("edge_type_name"), rs.getString("edge_sub_type_name"));
				Node node1 = MasterGraph.getNode(rs.getInt("node1"));
				Node node2 = MasterGraph.getNode(rs.getInt("node2"));
				Edge edge = null;
				int edgeId = rs.getInt("id");
				User addedBy = MasterGraph.getUser(rs.getInt("added_by"));
				User modBy = MasterGraph.getUser(rs.getInt("mod_by"));
				try{
				if(edgeType.getTypeName().equals("ORG2ORG")){ 
					edge = new Org2OrgEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (OrganisationNode)node1, (OrganisationNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));	
				} else if(edgeType.getTypeName().equals("ORG2IND")){ 
					if(node1.getType().getTypeName().equals("Organisation")){
						edge = new Org2IndEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (OrganisationNode)node1, (IndividualNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));
					} else {
						edge = new Org2IndEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (OrganisationNode)node2, (IndividualNode)node1, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));						
					}
				} else if(edgeType.getTypeName().equals("ORG2EVE")){ 
					if(node1.getType().getTypeName().equals("Organisation")){
						edge = new Org2EveEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (OrganisationNode)node1, (EventNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));
					} else {
						edge = new Org2EveEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (OrganisationNode)node2, (EventNode)node1, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));						
					}
				} else if(edgeType.getTypeName().equals("ORG2PUB")){ 
					if(node1.getType().getTypeName().equals("Organisation")){
						edge = new Org2PubEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (OrganisationNode)node1, (PublicationNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));	
					} else {
						edge = new Org2PubEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (OrganisationNode)node2, (PublicationNode)node1, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));	
					}
				} else if(edgeType.getTypeName().equals("IND2IND")){ 
					edge = new Ind2IndEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (IndividualNode)node1, (IndividualNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));	
				} else if(edgeType.getTypeName().equals("IND2EVE")){ 
					if(node1.getType().getTypeName().equals("Individual")){
						edge = new Ind2EveEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (IndividualNode)node1, (EventNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));
					} else {
						edge = new Ind2EveEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (IndividualNode)node2, (EventNode)node1, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));						
					}
				} else if(edgeType.getTypeName().equals("IND2PUB")){ 
					if(node1.getType().getTypeName().equals("Individual")){
						edge = new Ind2PubEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (IndividualNode)node1, (PublicationNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));	
					} else {
						edge = new Ind2PubEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (IndividualNode)node2, (PublicationNode)node1, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));							
					}
				} else if(edgeType.getTypeName().equals("EVE2EVE")){ 
					edge = new Eve2EveEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (EventNode)node1, (EventNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));	
				} else if(edgeType.getTypeName().equals("EVE2PUB")){ 
					if(node1.getType().getTypeName().equals("Event")){
						edge = new Eve2PubEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (EventNode)node1, (PublicationNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));
					} else {
						edge = new Eve2PubEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (EventNode)node2, (PublicationNode)node1, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));						
					}
				} else if(edgeType.getTypeName().equals("PUB2PUB")){ 
					edge = new Pub2PubEdge(edgeId, edgeType, rs.getDate("start_date"), rs.getDate("end_date"), rs.getString("details"), (PublicationNode)node1, (PublicationNode)node2, addedBy, rs.getDate("date_added"), modBy, rs.getDate("mod_date"));	
				}

				edges.add(edge);

				// add nodes to each others edge lists
				MasterGraph.addNodeRelationship(node1, node2, edge);

				} catch(Exception e){
					logger.warning("problem creating edge of type: " + edgeType.getTypeName() + "-" + edgeType.getSubTypeName() + " ("+ edgeId + ") between nodes: " + node1.getName() + "-" + node1.getType().getTypeName() + " ("+  node1.getId() + ") " + node2.getName() + "-" + node2.getType().getTypeName() + " (" + node2.getId() + ")");
				}
			}
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
			return null;
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		return edges;
	}

	public static ArrayList<Theme> populateThemesFromDB() {
		ArrayList<Theme> themes = new ArrayList<Theme>();
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "SELECT * FROM theme";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			while (rs.next()) {
				ArrayList<String> keywordList = new ArrayList<String>();
				String keywords = rs.getString("keywords");
				if (keywords != null) {
					String[] keyword = keywords.split(",");
					for (int i = 0; i < keyword.length; i++) {
						keywordList.add(keyword[i]);
					}
				}
				Theme a = new Theme(rs.getInt("id"), rs.getString("name"), rs.getString("details"), keywordList);
				themes.add(a);
			}
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
			return null;
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		return themes;
	}

	public static ArrayList<User> populateUsersFromDB() {
		ArrayList<User> users = new ArrayList<User>();
		Connection con = null;
		String sql = null;
		try{
			con = Database.getConnection();
		    Statement s = con.createStatement();
		    sql = "SELECT u.id, u.name, u.username, u.password, u.email, u.bio, u.orgname, u.country, u.url, u.level, u.photograph, u.date_added, u.last_login, u.login_count, u.node_add_count, u.node_view_count, u.node_update_count, u.node_add_quota, u.node_view_quota, u.node_update_quota FROM cimap_user u WHERE u.is_active";
		    s.executeQuery(sql);
		    ResultSet rs = s.getResultSet();
		    while(rs.next()){
		    	User u = new User(rs.getInt("id"), rs.getString("username"), rs.getString("password"), rs.getInt("level"), rs.getString("name"), rs.getString("email"), rs.getString("country"), rs.getString("bio"), rs.getString("orgname"), rs.getString("url"), rs.getString("photograph"), rs.getDate("date_added"), rs.getDate("last_login"), rs.getInt("login_count"), rs.getInt("node_add_count"), rs.getInt("node_view_count"), rs.getInt("node_update_count"), rs.getInt("node_add_quota"),
		    			rs.getInt("node_view_quota"), rs.getInt("node_update_quota"));
		    	users.add(u);
		    }
		}catch(Exception e){
			logger.warning(e.getMessage() + "\n" + sql);
			return null;
		}finally{
		    if (con != null) {
		        try { con.close(); } catch (SQLException e) {}
		    }
		}
		return users;
	}

	public static ArrayList<NodeType> populateNodeTypesFromDB() {
		ArrayList<NodeType> nt = new ArrayList<NodeType>();
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "SELECT * FROM def_node_type ORDER BY node_type";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			while (rs.next()) {
				NodeType n = new NodeType(rs.getInt("id"), rs.getString("node_type"), rs.getString("node_sub_type"));
				nt.add(n);
			}
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
			return null;
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		return nt;
	}

	public static ArrayList<EdgeType> populateEdgeTypesFromDB() {
		ArrayList<EdgeType> et = new ArrayList<EdgeType>();
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "SELECT * FROM def_edge_type ORDER BY id";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			while (rs.next()) {
				EdgeType ed = new EdgeType(rs.getInt("id"), rs.getString("edge_type"), rs.getString("edge_sub_type"));
				et.add(ed);
			}
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
			return null;
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		return et;
	}

	public static ArrayList<ContactList> populateContactListsFromDB() {
		ArrayList<ContactList> contactLists = new ArrayList<ContactList>();
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "SELECT * FROM contact_list ORDER BY id";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			while (rs.next()) {
				ArrayList<ContactListEntry> contacts = new ArrayList<ContactListEntry>();
				sql = "SELECT * FROM node_contact_list WHERE contact_list_id=" + rs.getInt("id"); 
				Statement s2 = con.createStatement();
				s2.executeQuery(sql);
				ResultSet rs2 = s2.getResultSet();
				while(rs2.next()){
					ContactListEntry contact = new ContactListEntry(rs2.getInt("id"), MasterGraph.getNode(rs2.getInt("node_id")), MasterGraph.getUser(rs2.getInt("added_by")), rs2.getDate("date_added"));
					contacts.add(contact);
				}
				ContactList contactList = new ContactList(rs.getInt("id"),rs.getString("name"), rs.getString("description"), contacts, MasterGraph.getUser(rs.getInt("added_by")), rs.getDate("date_added"));
				contactLists.add(contactList);
			}
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
			return null;
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		return contactLists;
	}

	
	public static synchronized int addNewNodeToDB(Node node) {
		Date dateAdded = Calendar.getInstance().getTime();
		String sql = null;
		int id = 0;
		char is_active = 'f';

		if (node.getAddedBy().getType() >= User.ADMIN)
			is_active = 't';
		Connection con = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "INSERT INTO node (name, node_type, added_by, date_added, is_active, mod_by, mod_date, mod_version)";
			sql += " VALUES (" + nullOrQuote(node.getName()) + "," + node.getType().getId() + "," + node.getAddedBy().getId() + "," + nullOrQuote(dateAdded) + ",'" + is_active
					+ "'," + node.getAddedBy().getId() + "," + nullOrQuote(dateAdded) + ",1)";
			s.executeUpdate(sql);
			logger.info(sql);
			sql = "SELECT max(id) AS id FROM node";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			if (rs.next())
				id = rs.getInt("id");
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		node.setId(id);
		return id;
	}

	public static void updateNode(Node node) {
		if(node instanceof OrganisationNode){
			updateOrganisationNode((OrganisationNode)node);
		} else if(node instanceof IndividualNode){
			updateIndvidualNode((IndividualNode)node);
		} else if(node instanceof PublicationNode){
			updatePublicationNode((PublicationNode)node);
		} else if(node instanceof EventNode){
			updateEventNode((EventNode)node);
		} else {
			logger.warning("node type not recognised for update id: " + node.getId());
		}
	}

	
	private static String nullOrQuote(String input){
		String output = "null";
		if(input!=null && !input.trim().equals(""))
			output = "'"+replaceQuotes(input.trim())+"'";
		return output;
	}

	private static String nullOrQuote(Date input){
		String output = "null";
		if(input!=null)
			output = "'"+input+"'";
		return output;
	}

	public static void updateOrganisationNode(OrganisationNode node) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE node SET ";
			if(node.getType() != null)
				sql += "node_type=" + node.getType().getId() + ",";
			sql += "name=" + nullOrQuote(node.getName()) + ",";
			sql += "photograph=" + nullOrQuote(node.getPhotograph()) + ",";
			sql += "background=" + nullOrQuote(node.getBackground()) + ",";
			sql += "node_url=" + nullOrQuote(node.getURL()) + ",";
			if(node.getContact() != null){
				sql += "email=" + nullOrQuote(node.getContact().getEmail()) + ",";
				sql += "phone=" + nullOrQuote(node.getContact().getPhone()) + ",";
				sql += "address_line1=" + nullOrQuote(node.getContact().getAddressLine1()) + ",";
				sql += "address_line2=" + nullOrQuote(node.getContact().getAddressLine2()) + ",";
				sql += "postcode=" + nullOrQuote(node.getContact().getPostcode()) + ",";
				sql += "state=" + nullOrQuote(node.getContact().getState()) + ",";
				sql += "city=" + nullOrQuote(node.getContact().getCity()) + ",";
				sql += "country=" + nullOrQuote(node.getContact().getCountry()) + ",";
				sql += "longitude=" + node.getContact().getLongitude() + ",";
				sql += "latitude=" + node.getContact().getLatitude() + ",";
				sql += "origin_state=" + nullOrQuote(node.getContact().getOriginState()) + ",";
				sql += "origin_city=" + nullOrQuote(node.getContact().getOriginCity()) + ",";
				sql += "origin_country=" + nullOrQuote(node.getContact().getOriginCountry()) + ",";
			}
			sql += "size1=" + node.getNumStaff() + ",";
			sql += "size2=" + node.getNumCustomers() + ",";
			sql += "mod_by=" +  node.getModBy().getId() + "," +
			"mod_date=now()," +
			"mod_version=mod_version+1," + 
			"view_count=" + node.getViewCount() +
			" WHERE id=" + node.getId();
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}
	
	public static void updateIndvidualNode(IndividualNode node) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE node SET ";
			if(node.getType() != null)
				sql += "node_type=" + node.getType().getId() + ",";
			sql += "name=" + nullOrQuote(node.getName()) + ",";
			sql += "photograph=" + nullOrQuote(node.getPhotograph()) + ",";
			sql += "background=" + nullOrQuote(node.getBackground()) + ",";
			sql += "node_url=" + nullOrQuote(node.getURL()) + ",";
			if(node.getContact() != null){
				sql += "email=" + nullOrQuote(node.getContact().getEmail()) + ",";
				sql += "phone=" + nullOrQuote(node.getContact().getPhone()) + ",";
				sql += "address_line1=" + nullOrQuote(node.getContact().getAddressLine1()) + ",";
				sql += "address_line2=" + nullOrQuote(node.getContact().getAddressLine2()) + ",";
				sql += "postcode=" + nullOrQuote(node.getContact().getPostcode()) + ",";
				sql += "state=" + nullOrQuote(node.getContact().getState()) + ",";
				sql += "city=" + nullOrQuote(node.getContact().getCity()) + ",";
				sql += "country=" + nullOrQuote(node.getContact().getCountry()) + ",";
				sql += "longitude=" + node.getContact().getLongitude() + ",";
				sql += "latitude=" + node.getContact().getLatitude() + ",";
				sql += "origin_state=" + nullOrQuote(node.getContact().getOriginState()) + ",";
				sql += "origin_city=" + nullOrQuote(node.getContact().getOriginCity()) + ",";
				sql += "origin_country=" + nullOrQuote(node.getContact().getOriginCountry()) + ",";
			}
			sql += "date=" + nullOrQuote(node.getDateOfBirth()) + ",";
			sql += "gender='" + node.getGender() + "',";
			sql += "mod_by=" +  node.getModBy().getId() + "," +
			"mod_date=now()," +
			"mod_version=mod_version+1," + 
			"view_count=" + node.getViewCount() +
			" WHERE id=" + node.getId();
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}
	public static void updateEventNode(EventNode node) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE node SET ";
			if(node.getType() != null)
				sql += "node_type=" + node.getType().getId() + ",";
			sql += "name=" + nullOrQuote(node.getName()) + ",";
			sql += "photograph=" + nullOrQuote(node.getPhotograph()) + ",";
			sql += "background=" + nullOrQuote(node.getBackground()) + ",";
			sql += "node_url=" + nullOrQuote(node.getURL()) + ",";
			if(node.getContact() != null){
				sql += "email=" + nullOrQuote(node.getContact().getEmail()) + ",";
				sql += "phone=" + nullOrQuote(node.getContact().getPhone()) + ",";
				sql += "address_line1=" + nullOrQuote(node.getContact().getAddressLine1()) + ",";
				sql += "address_line2=" + nullOrQuote(node.getContact().getAddressLine2()) + ",";
				sql += "postcode=" + nullOrQuote(node.getContact().getPostcode()) + ",";
				sql += "state=" + nullOrQuote(node.getContact().getState()) + ",";
				sql += "city=" + nullOrQuote(node.getContact().getCity()) + ",";
				sql += "country=" + nullOrQuote(node.getContact().getCountry()) + ",";
				sql += "longitude=" + node.getContact().getLongitude() + ",";
				sql += "latitude=" + node.getContact().getLatitude() + ",";
				sql += "origin_state=" + nullOrQuote(node.getContact().getOriginState()) + ",";
				sql += "origin_city=" + nullOrQuote(node.getContact().getOriginCity()) + ",";
				sql += "origin_country=" + nullOrQuote(node.getContact().getOriginCountry()) + ",";
			}
			sql += "date=" + nullOrQuote(node.getEventDate()) + ",";
			sql += "size1=" + node.getNumPresenters() + ",";
			sql += "size2=" + node.getNumAttendees() + ",";
			sql += "mod_by=" +  node.getModBy().getId() + "," +
			"mod_date=now()," +
			"mod_version=mod_version+1," + 
			"view_count=" + node.getViewCount() +
			" WHERE id=" + node.getId();
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}
	public static void updatePublicationNode(PublicationNode node) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE node SET ";
			if(node.getType() != null)
				sql += "node_type=" + node.getType().getId() + ",";
			sql += "name=" + nullOrQuote(node.getName()) + ",";
			sql += "photograph=" + nullOrQuote(node.getPhotograph()) + ",";
			sql += "background=" + nullOrQuote(node.getBackground()) + ",";
			sql += "node_url=" + nullOrQuote(node.getURL()) + ",";
			sql += "date=" + nullOrQuote(node.getPublicationDate()) + ",";
			sql += "source=" + nullOrQuote(node.getSource()) + ",";
			sql += "mod_by=" +  node.getModBy().getId() + "," +
			"mod_date=now()," +
			"mod_version=mod_version+1," + 
			"view_count=" + node.getViewCount() +
			" WHERE id=" + node.getId();
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}

		public static void deleteNode(Node node, User user) {
		Date dateModified = Calendar.getInstance().getTime();
		String sql = null;

		if (user.getType() >= User.ADMIN) {
			Connection con = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "UPDATE node SET is_active = 'f', mod_by=" + user.getId() + ", mod_date=" + nullOrQuote(dateModified) + ", mod_version=mod_version+1 WHERE id="
						+ node.getId();
				s.executeUpdate(sql);
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}

		} else {
			logger.warning("permission denied to delete to user: " + user.getName());
		}
	}


	// add new edge to the database
	public static synchronized int addNewEdgeToDB(Edge edge) {
		String sql = null;
		Connection con = null;
		char is_active = 'f';
		int id = 0;
		int count = 0;
		if (edge.getAddedBy().getType() >= User.ADMIN)
			is_active = 't';
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			// to stop people adding duplicate edges to database
			sql = "SELECT COUNT(id) AS count FROM edge WHERE edge_type=" + edge.getType().getId() + " AND is_active='t' AND((node1="
					+ edge.getNodes().get(0).getId() + " AND node2=" + edge.getNodes().get(1).getId() + ") OR (node1=" + edge.getNodes().get(1).getId()
					+ " AND node2=" + edge.getNodes().get(0).getId() + "))";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			if (rs.next()) {
				count = rs.getInt("count");
			}
			if (count == 0) {
				String sql1 = "INSERT INTO edge (edge_type, node1, node2,";
				String sql2 = "VALUES (" + edge.getType().getId() + "," + edge.getNodes().get(0).getId() + "," + edge.getNodes().get(1).getId() + ",";
					sql1 += "start_date,";
					sql2 += nullOrQuote(edge.getStartDate()) + ",";
					sql1 += " end_date,";
					sql2 += nullOrQuote(edge.getEndDate()) + ",";
					sql1 += " details,";
					sql2 += nullOrQuote(edge.getDetails()) + ",";
				sql1 += " added_by, date_added, is_active, mod_by, mod_date, mod_version)";
				sql2 += edge.getAddedBy().getId() + "," + nullOrQuote(edge.getDateAdded()) + ",'" + is_active + "'," + edge.getModBy().getId() + "," + nullOrQuote(edge.getLastModified()) + ",1)";
				sql = sql1 + sql2;
				logger.info(sql);
				s.executeUpdate(sql);
				sql = "SELECT max(id) AS id FROM edge";
				s.executeQuery(sql);
				rs = s.getResultSet();
				if (rs.next())
					id = rs.getInt("id");
			} else {
				logger.warning("edge between " + edge.getNodes().get(0).getName() + " and " + edge.getNodes().get(1).getName() + " of type "
						+ edge.getType() + " previously added ... add edge ignored");
			}
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		edge.setId(id);
		return count;
	}

	public static synchronized void updateEdge(Edge edge) {
		String sql = null;
		Connection con = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE edge SET edge_type=" + edge.getType().getId() + ", ";
			sql += "start_date=" + nullOrQuote(edge.getStartDate()) + ", ";
			sql += "end_date=" + nullOrQuote(edge.getEndDate()) + ", ";
			sql += " details=" + nullOrQuote(edge.getDetails()) + ", ";
			sql += " mod_by=" + edge.getModBy().getId() + ", mod_date=" + nullOrQuote(edge.getLastModified()) + ", mod_version=mod_version+1 WHERE id=" + edge.getId();
			if(edge.getModBy().getType() >= User.ADMIN)
				s.executeUpdate(sql);
			else
				logger.warning("update edge permission denied to user: " + edge.getModBy().getUsername());
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}

	}

	public static void deleteEdge(Edge edge, User user) {
		Date dateModified = Calendar.getInstance().getTime();
		String sql = null;

		if (user.getType() >= User.ADMIN) {

			Connection con = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "UPDATE edge SET is_active = 'f', mod_by=" + user.getId() + ", mod_date=" + nullOrQuote(dateModified) + ", mod_version=mod_version+1 WHERE id="
						+ edge.getId();
				s.executeUpdate(sql);
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}

		} else {
			logger.warning("permission denied to delete to user: " + user.getName());
		}
	}

	public static synchronized void addNewUser(User newUser, User addedBy) {
		String sql = null;
		Connection con = null;
		char is_active = 'f';
		int id = 0;

		if (addedBy.getType() >= User.SUPERUSER)
			is_active = 't';
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			String sql1 = "INSERT INTO cimap_user (name, ";
			String sql2 = "VALUES (" + nullOrQuote(newUser.getName()) + ",";
				sql1 += "orgname,";
				sql2 += nullOrQuote(newUser.getOrgName()) + ",";
				sql1 += "country,";
				sql2 += nullOrQuote(newUser.getCountry()) + ",";
				sql1 += "email,";
				sql2 += nullOrQuote(newUser.getEmail()) + ",";
				sql1 += "url,";
				sql2 += nullOrQuote(newUser.getUrl()) + ",";
				sql1 += "bio,";
				sql2 += nullOrQuote(newUser.getBio()) + ",";
			if (newUser.getType() > -1){
				sql1 += "level,";
				sql2 += newUser.getType() + ",";
			}
				sql1 += "photograph,";
				sql2 += nullOrQuote(newUser.getPhotograph()) + ",";
			
			sql1 += "username, password, is_active)";
			sql2 += nullOrQuote(newUser.getUsername()) + "," + nullOrQuote(newUser.getPassword()) + "," + "'" + is_active + "')";
			sql = sql1 + sql2;
			s.executeUpdate(sql);

			sql = "SELECT max(id) AS id FROM cimap_user";
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			if (rs.next())
				id = rs.getInt("id");
			
			// populate default values for newUser from DB
			sql = "SELECT login_count, date_added, node_add_count, node_update_count, node_view_count, node_add_quota, node_view_quota, node_update_quota FROM cimap_user WHERE id="+id;
			s.executeQuery(sql);
			rs = s.getResultSet();
			if (rs.next()){
				newUser.setDefaults(rs.getInt("login_count"),rs.getDate("date_added"),rs.getInt("node_add_count"),rs.getInt("node_update_count"),rs.getInt("node_view_count"),rs.getInt("node_add_quota"),rs.getInt("node_update_quota"),rs.getInt("node_view_quota"));
			}

		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}

		newUser.setId(id);
	}

	public static void updateUser(User user) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE cimap_user SET " +
					"name=" + nullOrQuote(user.getName())+
					",orgname=" + nullOrQuote(user.getOrgName())+ 
					",country=" + nullOrQuote(user.getCountry())+
					",email="+nullOrQuote(user.getEmail())+
					",url="+nullOrQuote(user.getUrl())+
					",bio="+nullOrQuote(user.getBio())+
					",username="+nullOrQuote(user.getUsername())+
					",password="+nullOrQuote(user.getPassword())+
					",photograph="+nullOrQuote(user.getPhotograph())+
					",level="+user.getType()+
					",date_added="+nullOrQuote(user.getCreationDate())+
					",last_login="+nullOrQuote(user.getLastLogin())+
					",login_count="+user.getLoginCount()+
					",node_add_count="+user.getNodeAddCount()+
					",node_view_count="+user.getNodeViewCount()+
					",node_update_count="+user.getNodeUpdateCount()+
					",node_add_quota="+user.getNodeAddQuota()+
					",node_view_quota="+user.getNodeViewQuota()+
					",node_update_quota="+user.getNodeUpdateQuota()+
					" WHERE id=" + user.getId();
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}
	
	public static void deleteUser(User userToDelete, User user) {
		String sql = null;
		if (user.getType() >= User.SUPERUSER) {
			Connection con = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "UPDATE cimap_user SET is_active = 'f' WHERE id="
						+ userToDelete.getId();
				s.executeUpdate(sql);
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to delete to user: " + user.getName());
		}
	}
	
	public static void addNodeTheme(Node node, Theme theme) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "INSERT INTO node_theme (node_id, theme_id) VALUES (" + node.getId() + "," + theme.getId() + ")";
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}

	public static void removeNodeTheme(Node node, Theme theme) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "DELETE FROM node_theme WHERE node_id=" + node.getId() + " AND theme_id=" + theme.getId();
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}

	public static synchronized void addNodeNews(Node node, NewsArticle news) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			User user = news.getAddedBy();
			char isActive = 'f';
			if (user.getType() >= User.ADMIN)
				isActive = 't';
			s.executeQuery("SELECT max(id) AS id FROM news");
			ResultSet rs = s.getResultSet();
			int id = 0;
			if (rs.next()) {
				id = rs.getInt("id");
			}
			id++;
			String sql1 = "INSERT INTO news (id, pub_type, title,";
			String sql2 = "VALUES (" + id + ", 'newspaper'," + nullOrQuote(news.getTitle()) + ",";
			sql1 += "pub_date, ";
			sql2 +=  nullOrQuote(news.getDate()) + ", ";
			sql1 += "pub_source, ";
			sql2 += nullOrQuote(news.getSource()) + ",";
			sql1 += "pub_url, ";
			sql2 += nullOrQuote(news.getUrl()) + ", ";
			sql1 += "added_by, date_added, is_active)";

			sql2 += user.getId() + ",now(),'" + isActive + "')";
			sql = sql1 + sql2;
			s.executeUpdate(sql);
			sql = "INSERT INTO node_news (node_id, news_id) VALUES (" + node.getId() + ", " + id + ")";
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}

	public static String replaceQuotes(String input) {
		String output = null;
		if (input != null) {
			output = input.replace("'", "&#039;");
			// logger.info("input:" + input + " output: " + output);
		}
		return output;
	}

	public static void login(User user) {
		Connection con = null;
		String sql = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE cimap_user SET last_login=now(), login_count=login_count+1 WHERE id=" + user.getId();
			//logger.info("login: "+ sql);
			s.executeUpdate(sql);
			sql = "SELECT last_login, login_count FROM cimap_user WHERE id=" + user.getId();
			s.executeQuery(sql);
			ResultSet rs = s.getResultSet();
			if (rs.next()){
				user.setLastLogin(rs.getDate("last_login"));
				user.setLoginCount(rs.getInt("login_count"));
			}
			
			
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
	}

	public static void addNewThemeToDB(User user, Theme theme) {
		String sql = null;
		if (user.getType() >= User.ADMIN) {
			Connection con = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				String keywords = "";
				if(theme.getKeywords() != null){
					Iterator<String> i = theme.getKeywords().iterator();
					if(i.hasNext())
						keywords = i.next();
					while(i.hasNext())
						keywords += "," + i.next();
				}
				sql = "INSERT INTO theme (name,details,keywords,added_by,date_added) VALUES ("+nullOrQuote(theme.getName())+","+nullOrQuote(theme.getDetails())+","+nullOrQuote(keywords)+","+user.getId()+",now())";
				s.executeUpdate(sql);
				sql = "SELECT max(id) AS id FROM theme";
				s.executeQuery(sql);
				ResultSet rs = s.getResultSet();
				if (rs.next())
					theme.setId(rs.getInt("id"));

			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to add theme to user: " + user.getName());
		}
	}

	public static synchronized void updateTheme(User updatedBy, Theme theme) {
		String sql = null;
		Connection con = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			String keywords = "";
			if(theme.getKeywords() != null){
				Iterator<String> i = theme.getKeywords().iterator();
				if(i.hasNext())
					keywords = i.next();
				while(i.hasNext())
					keywords += "," + i.next();
			}

			sql = "UPDATE theme SET name="+nullOrQuote(theme.getName()) + ", details=" + nullOrQuote(theme.getDetails()) + ", keywords=" + nullOrQuote(keywords) + " WHERE id="+theme.getId();
			if(updatedBy.getType() >= User.ADMIN){
				s.executeUpdate(sql);
			}else{
				logger.warning("update theme permission denied to user: " + updatedBy.getUsername());
			}
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}

	}

	public static void removeThemeFromDB(Theme theme, User user) {
		String sql = null;
		if (user.getType() >= User.ADMIN) {
			Connection con = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "DELETE FROM node_theme WHERE theme_id="+theme.getId();
				s.executeUpdate(sql);
				sql = "DELETE FROM theme WHERE id="+theme.getId();
				s.executeUpdate(sql);
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to remove theme to user: " + user.getName());
		}		
	}

	public static void updateNodeView(Node node) {
		String sql = null;
		Connection con = null;
		try {
			con = Database.getConnection();
			Statement s = con.createStatement();
			sql = "UPDATE node SET view_count=view_count+1 WHERE id="+node.getId();
			s.executeUpdate(sql);
		} catch (Exception e) {
			logger.warning(e.getMessage() + "\n" + sql);
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
				}
			}
		}
		
	}

	public static void addNewContactToContactList(ContactListEntry contact, ContactList contactList) {
		if (contact.getAddedBy().getType() >= User.ADMIN) {
			Connection con = null;
			String sql = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "INSERT INTO node_contact_list(node_id,contact_list_id, added_by,date_added) VALUES ("+contact.getNode().getId()+","+ contactList.getId()+","+ contact.getAddedBy().getId()+","+ nullOrQuote(contact.getDateAdded())+")";				
				s.executeUpdate(sql);
				sql = "SELECT MAX(id) AS id FROM node_contact_list";
				ResultSet rs = s.executeQuery(sql);
				if(rs.next())
					contact.setId(rs.getInt("id"));
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to add contact to list to user: " + contact.getAddedBy().getName());
		}		
	}

	public static void removeContactFromContactList(User user, ContactListEntry contact, ContactList contactList) {
		if (user.getType() >= User.ADMIN) {
			Connection con = null;
			String sql = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "DELETE FROM node_contact_list WHERE id="+contact.getId();				
				s.executeUpdate(sql);
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to remove contact from list to user: " + user.getName());
		}		
	}

	public static void addNewContactListToDB(ContactList contacts){
		if (contacts.getCreatedBy().getType() >= User.ADMIN) {
			Connection con = null;
			String sql = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "INSERT INTO contact_list (name,description,added_by,date_added) VALUES ("+nullOrQuote(contacts.getName())+","+nullOrQuote(contacts.getDescription())+","+contacts.getCreatedBy().getId()+","+nullOrQuote(contacts.getDateCreated())+")";				
				s.executeUpdate(sql);
				sql = "SELECT MAX(id) AS id FROM contact_list";
				ResultSet rs = s.executeQuery(sql);
				if(rs.next())
					contacts.setId(rs.getInt("id"));
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to add contact list to user: " + contacts.getCreatedBy().getName());
		}				
	}

	public static void updateContactList(User user, ContactList contacts){
		if (user.getType() >= User.ADMIN) {
			Connection con = null;
			String sql = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "UPDATE contact_list SET name="+nullOrQuote(contacts.getName())+", description=" + nullOrQuote(contacts.getDescription()) +" WHERE id=" + contacts.getId();				
				s.executeUpdate(sql);
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to update contact list to user: " + user.getName());
		}				
	}

	public static void deleteContactList(User user, ContactList contacts){
		if (user.getType() >= User.ADMIN) {
			Connection con = null;
			String sql = null;
			try {
				con = Database.getConnection();
				Statement s = con.createStatement();
				sql = "DELETE FROM node_contact_list WHERE contact_list_id=" + contacts.getId();				
				s.executeUpdate(sql);
				sql = "DELETE FROM contact_list WHERE id=" + contacts.getId();				
				s.executeUpdate(sql);
			} catch (Exception e) {
				logger.warning(e.getMessage() + "\n" + sql);
			} finally {
				if (con != null) {
					try {
						con.close();
					} catch (SQLException e) {
					}
				}
			}
		} else {
			logger.warning("permission denied to delete contact list to user: " + user.getName());
		}				
	}

}