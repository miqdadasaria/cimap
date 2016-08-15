package cimap.graph.node;

import java.util.ArrayList;
import java.util.Date;

import cimap.graph.User;
import cimap.graph.edge.Edge;

public interface Node extends Comparable<Node>{

	public abstract int getId();
	public abstract void setId(int id);
	public abstract NodeType getType();
	public abstract void setType(NodeType type);
	public abstract String getName();
	public abstract void setName(String name);
	public abstract String getPhotograph();
	public abstract void setPhotograph(String photograph);
	public abstract String getBackground();
	public abstract void setBackground(String background);
	public abstract String getURL();
	public abstract void setURL(String url);
	public abstract int getViewCount();
	public abstract void setViewCount(User user, int Count);
	public abstract ArrayList<Theme> getThemes();
	public abstract void addTheme(User user, Theme theme);
	public abstract void removeTheme(User user, Theme theme);
	public abstract void removeAllThemes(User user);
	public abstract ArrayList<NewsArticle> getNews();
	public abstract void addNews(NewsArticle news);
	public abstract ArrayList<Edge> getRelatedOrganisations();
	public abstract ArrayList<Edge> getRelatedIndividuals();
	public abstract ArrayList<Edge> getRelatedEvents();
	public abstract ArrayList<Edge> getRelatedPublications();
	public abstract ArrayList<Node> getAllRelatedNodes(String type);
	public abstract void addRelatedOrganisation(Edge e);
	public abstract void addRelatedIndividual(Edge e);
	public abstract void addRelatedEvent(Edge e);
	public abstract void addRelatedPublication(Edge e);
	public abstract void deleteEdge(User user, Edge edge);
	public abstract String toJSON();
	public abstract Date getDateAdded();
	public abstract void setDateAdded(Date date);
	public abstract User getAddedBy();
	public abstract void setAddedBy(User user);
	public abstract Date getLastModified();
	public abstract void setLastModified(Date date);
	public abstract User getModBy();
	public abstract void setModBy(User user);
	public abstract void setLayers(Boolean[] layers);
	public abstract Boolean[] getLayers();
	public abstract int edgeCount();
}
