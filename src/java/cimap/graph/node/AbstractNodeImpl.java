package cimap.graph.node;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.logging.Logger;

import cimap.database.Persistence;
import cimap.graph.AbstractGraphObject;
import cimap.graph.User;
import cimap.graph.edge.Edge;

public abstract class AbstractNodeImpl extends AbstractGraphObject implements Node {

	private static Logger logger = Logger.getLogger(AbstractNodeImpl.class.getName());	

	private int id;
	protected NodeType type;
	protected String name;
	protected String photo;
	protected String url;
	protected String background;
	private ArrayList<Theme> themes;
	private ArrayList<NewsArticle> news;
	private ArrayList<Edge> organisations;
	private ArrayList<Edge> individuals;
	private ArrayList<Edge> events;
	private ArrayList<Edge> publications;
	private int viewCount;
	private Boolean[] layers;

	
	public AbstractNodeImpl(int id, NodeType type, String name, String photo, String url, String background, ArrayList<Theme> themes,
			ArrayList<NewsArticle> news, ArrayList<Edge> organisations, ArrayList<Edge> individuals, ArrayList<Edge> events, ArrayList<Edge> publications,
			User addedBy, Date dateAdded, int viewCount, User modBy, Date modDate) {
		super(addedBy, dateAdded, modBy, modDate);
		this.themes = themes;
		this.background = background;
		this.events = events;
		this.id = id;
		this.individuals = individuals;
		this.name = name;
		this.news = news;
		this.organisations = organisations;
		this.photo = photo;
		this.publications = publications;
		this.type = type;
		this.url = url;
		this.viewCount = viewCount;
	}

	@Override
	public int getViewCount() {
		return viewCount;
	}

	@Override
	public void setViewCount(User user, int Count) {
		this.viewCount = Count;
		Persistence.updateNodeView(this);
	}

	@Override
	public ArrayList<Theme> getThemes() {
		return themes;
	}

	@Override
	public String getBackground() {
		return background;
	}

	@Override
	public int getId() {
		return id;
	}

	@Override
	public String getName() {
		return name;
	}

	@Override
	public void setName(String name){
		this.name = name;
	}

	@Override
	public ArrayList<NewsArticle> getNews() {
		return news;
	}

	@Override
	public String getPhotograph() {
		return photo;
	}

	@Override
	public ArrayList<Edge> getRelatedPublications() {
		return publications;
	}

	@Override
	public ArrayList<Edge> getRelatedEvents() {
		return events;
	}

	@Override
	public ArrayList<Edge> getRelatedIndividuals() {
		return individuals;
	}

	@Override
	public ArrayList<Edge> getRelatedOrganisations() {
		return organisations;
	}

	@Override
	public NodeType getType() {
		return type;
	}

	@Override
	public void setType(NodeType type) {
		this.type = type;
	}

	@Override
	public String getURL() {
		return url;
	}

	@Override
	public void addRelatedEvent(Edge e) {
		events.add(e);
	}

	@Override
	public void addRelatedIndividual(Edge e) {
		individuals.add(e);
	}

	@Override
	public void addRelatedOrganisation(Edge e) {
		organisations.add(e);
	}

	@Override
	public void addRelatedPublication(Edge e) {
		publications.add(e);
	}

	@Override
	public String toJSON() {
		if(layers==null){
			layers = new Boolean[4];
			for(int i=0;i<layers.length;i++)
				layers[i]=true;
		}
		StringBuffer json = new StringBuffer();
		json.append("{\"id\":\"");
		json.append(getId());
		json.append("\",\n\"name\":\"");
		json.append(getName());
		json.append("\",\n\"data\":[\n");

		StringBuffer children = new StringBuffer();
		Edge e;
		Node other;
		boolean first = true;
		Iterator<Edge> ind = getRelatedIndividuals().iterator();
		if(layers[0]){
			while (ind.hasNext()) {
				e = ind.next();
				other = e.getOtherNode(this);
				if (!first) {
					json.append(",\n");
					children.append(",\n");
				} else {
					first = false;
				}
				json.append("{\"key\":\"");
				json.append(other.getName()+"["+other.edgeCount()+"]");
				json.append("\",\n\"value\":\"");
				json.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				json.append("\"}");
	
				children.append("{\"id\":\"");
				children.append(other.getId());
				children.append("\",\"name\":\"");
				children.append(other.getName()+"["+other.edgeCount()+"]");
				children.append("\",\"data\":[{\"key\":\"");
				children.append(getName()+"["+this.edgeCount()+"]");
				children.append("\",\"value\":\"");
				children.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				children.append("\"}],\"children\":[]}");
			}
		}
		Iterator<Edge> org = getRelatedOrganisations().iterator();
		if(layers[1]){
			while (org.hasNext()) {
				e = org.next();
				other = e.getOtherNode(this);
				if (!first) {
					json.append(", ");
					children.append(", ");
				} else {
					first = false;
				}
				json.append("{\"key\":\"");
				json.append(other.getName()+"["+other.edgeCount()+"]");
				json.append("\",\"value\":\"");
				json.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				json.append("\"}");
	
				children.append("{\"id\":\"");
				children.append(other.getId());
				children.append("\",\"name\":\"");
				children.append(other.getName()+"["+other.edgeCount()+"]");
				children.append("\",\"data\":[{\"key\":\"");
				children.append(getName()+"["+this.edgeCount()+"]");
				children.append("\",\"value\":\"");
				children.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				children.append("\"}],\"children\":[]}");
			}
		}
		Iterator<Edge> events = getRelatedEvents().iterator();
		if(layers[2]){
			while (events.hasNext()) {
				e = events.next();
				other = e.getOtherNode(this);
				if (!first) {
					json.append(", ");
					children.append(", ");
				} else {
					first = false;
				}
				json.append("{\"key\":\"");
				json.append(other.getName()+"["+other.edgeCount()+"]");
				json.append("\",\"value\":\"");
				json.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				json.append("\"}");
	
				children.append("{\"id\":\"");
				children.append(other.getId());
				children.append("\",\"name\":\"");
				children.append(other.getName()+"["+other.edgeCount()+"]");
				children.append("\",\"data\":[{\"key\":\"");
				children.append(getName()+"["+this.edgeCount()+"]");
				children.append("\",\"value\":\"");
				children.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				children.append("\"}],\"children\":[]}");
			}
		}
		Iterator<Edge> pubs = getRelatedPublications().iterator();
		if(layers[3]){
			while (pubs.hasNext()) {
				e = pubs.next();
				other = e.getOtherNode(this);
				if (!first) {
					json.append(", ");
					children.append(", ");
				} else {
					first = false;
				}
				json.append("{\"key\":\"");
				json.append(other.getName()+"["+other.edgeCount()+"]");
				json.append("\",\"value\":\"");
				json.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				json.append("\"}");
	
				children.append("{\"id\":\"");
				children.append(other.getId());
				children.append("\",\"name\":\"");
				children.append(other.getName()+"["+other.edgeCount()+"]");
				children.append("\",\"data\":[{\"key\":\"");
				children.append(getName()+"["+this.edgeCount()+"]");
				children.append("\",\"value\":\"");
				children.append(e.getType().getTypeName() + " - " + e.getType().getSubTypeName());
				children.append("\"}],\"children\":[]}");
			}
		}
		if(children.toString().equals(""))
			return "empty";
		
		json.append("],\"children\":[");
		json.append(children);
		json.append("]};");
		return json.toString();
	}

	@Override
	public void setPhotograph(String photograph) {
			this.photo = photograph;
	}

	@Override
	public void setBackground(String background) {
		this.background = background;
	}

	@Override
	public void setURL(String url) {
		this.url = url;
	}

	@Override
	public void addTheme(User user, Theme theme) {
		if (user.getType() >= User.ADMIN) {
			if (!themes.contains(theme)) {
				themes.add(theme);
				Persistence.addNodeTheme(this, theme);
			}
		} else {
			logger.warning("Permission denied user type:" + user.getType());
		}
	}

	@Override
	public void removeTheme(User user, Theme theme) {
		if (user.getType() >= User.ADMIN) {
			if (themes.contains(theme)) {
				themes.remove(theme);
				Persistence.removeNodeTheme(this, theme);
			}
		} else {
			logger.warning("Permission denied user type:" + user.getType());
		}
	}

	@Override
	public void removeAllThemes(User user) {
		if (user.getType() >= User.ADMIN) {
			ArrayList<Theme> themesClone = (ArrayList<Theme>) (themes.clone());
			Iterator<Theme> i = themesClone.iterator();
			Theme theme = null;
			while (i.hasNext()) {
				theme = i.next();
				removeTheme(user, theme);
			}
		} else {
			logger.warning("Permission denied user type:" + user.getType());
		}
	}

	@Override
	public void addNews(NewsArticle newsArticle) {
		User user = newsArticle.getAddedBy();
		if (user.getType() >= User.ADMIN) {
			news.add(newsArticle);
			Persistence.addNodeNews(this, newsArticle);
		} else {
			logger.warning("Permission denied user type:" + user.getType());
		}
	}

	@Override
	public int compareTo(Node o) {
		return getName().compareTo(o.getName());
	}

	@Override
	public ArrayList<Node> getAllRelatedNodes(String type) {
		ArrayList<Node> results = new ArrayList<Node>();
		Edge current;
		if(type.equals("Organisation")){
			Iterator<Edge> org = organisations.iterator();
			while (org.hasNext()) {
				current = org.next();
				results.add(current.getOtherNode(this));
			} 
		}else if(type.equals("Individual")){
			Iterator<Edge> ind = individuals.iterator();
			while (ind.hasNext()) {
				current = ind.next();
				results.add(current.getOtherNode(this));
			}
		} else if(type.equals("Event")){
			Iterator<Edge> eve = events.iterator();
			while (eve.hasNext()) {
				current = eve.next();
				results.add(current.getOtherNode(this));
			}
		} else if(type.equals("Publication")){
			Iterator<Edge> pub = publications.iterator();
			while (pub.hasNext()) {
				current = pub.next();
				results.add(current.getOtherNode(this));
			}
		}
		Collections.sort(results);
		return results;
	}

	@Override
	public void setId(int id) {
		this.id = id;
	}

	@Override
	public void deleteEdge(User user, Edge edge) {
		if (user.getType() >= User.ADMIN) {
			if (organisations.contains(edge)) {
				organisations.remove(organisations.indexOf(edge));
			}
			if (individuals.contains(edge)) {
				individuals.remove(individuals.indexOf(edge));
			}
			if (events.contains(edge)) {
				events.remove(events.indexOf(edge));
			}
			if (publications.contains(edge)) {
				publications.remove(publications.indexOf(edge));
			}
		} else {
			logger.warning("Permission denied user type:" + user.getType());
		}

	}

	protected void updateNode(Node node) {
		User user = node.getModBy();
		if (user != null && user.getType() >= User.ADMIN && (user.getNodeUpdateQuota() < 0 || user.getNodeUpdateCount() < user.getNodeUpdateQuota())) {
			user.setNodeUpdateCount(user.getNodeUpdateCount() + 1);
			Persistence.updateNode(node);
		} else if(user != null) {
			logger.warning("Node update permission denied user type:" + user.getType() + " id: " + user.getId() + " update quota: " + user.getNodeAddQuota()
					+ " update count: " + user.getNodeUpdateCount());
		} else {
			logger.warning("Node update error modified by not set");
		}
	}

	@Override
	public int edgeCount() {
		return organisations.size()+ individuals.size()+ events.size()+ publications.size();
	}
	
	@Override
	public void setLayers(Boolean [] layers){
		this.layers=layers;
	}
	
	@Override
	public Boolean[] getLayers(){
		return layers;
	}
}
