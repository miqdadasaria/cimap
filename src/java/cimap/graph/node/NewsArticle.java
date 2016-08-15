package cimap.graph.node;

import java.util.Date;

import cimap.graph.User;

public class NewsArticle {
	//private static Logger logger = Logger.getLogger(NewsArticle.class.getName());
	private String title;
	private Date date;
	private String url;
	private String source;
	private User addedBy;
	private Date dateAdded;
	
	public NewsArticle(User addedBy, Date dateAdded, Date date, String title, String url, String source) {
		this.addedBy = addedBy;
		this.dateAdded = dateAdded;
		this.date = date;
		this.title = title;
		this.url = url;
		this.source = source;
	}

	public User getAddedBy(){
		return addedBy;
	}
	
	public Date getDateAdded(){
		return dateAdded;
	}
	
	public String getTitle() {
		return title;
	}

	public Date getDate() {
		return date;
	}

	public String getUrl() {
		return url;
	}
	
	public String getSource(){
		return source;
	}
}
