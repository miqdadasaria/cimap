package cimap.graph.node;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;

import cimap.graph.User;
import cimap.graph.edge.Edge;

public class PublicationNode extends AbstractNodeImpl{
	private static Logger logger = Logger.getLogger(PublicationNode.class.getName());

	private Date publicationDate;
	private String source;
	
	public PublicationNode(
			int id,
			NodeType type, 
			String name,
			String photo,
			String url, 
			String background,
			ArrayList<Theme> themes,
			ArrayList<NewsArticle> news,
			ArrayList<Edge> organisations, 
			ArrayList<Edge> individuals,
			ArrayList<Edge> events,
			ArrayList<Edge> publications, 			 
			User addedBy, 
			Date dateAdded, 
			int viewCount,
			Date publicationDate, 
			String source, 
			User modBy, 
			Date modDate) {
		super(id, type, name, photo, url, background, themes, news, organisations, individuals, events, publications, addedBy, dateAdded, viewCount, modBy, modDate);
		this.publicationDate = publicationDate;
		this.source = source;
	}

	public Date getPublicationDate() {
		return publicationDate;
	}

	public void setPublicationDate(Date publicationDate) {
			this.publicationDate = publicationDate;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
			this.source = source;
	}

	public void update(User user, String name, NodeType type, String photo, String background, String url, Date publicationDate, String source){
		if(user.getType() >= User.ADMIN){
			this.setModBy(user);
			this.setLastModified(Calendar.getInstance().getTime());
			this.setName(name);
			this.setType(type);
			this.setPhotograph(photo);
			this.setBackground(background);
			this.setURL(url);
			this.setPublicationDate(publicationDate);
			this.setSource(source);
			this.updateNode(this);
		} else {
			logger.warning("Update permission denied user name:" + user.getName());
		}
	}
}
