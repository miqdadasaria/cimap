package cimap.graph.node;

import java.util.ArrayList;
import java.util.logging.Logger;

import cimap.database.Persistence;
import cimap.graph.User;

public class Theme implements Comparable<Theme>{

	private static Logger logger = Logger.getLogger(Theme.class.getName());

	private int id;
	private String name;
	private String details;
	private ArrayList<String> keywords;
	
	public int getId() {
		return id;
	}
	
	public void setId(int id){
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	public String getDetails() {
		return details;
	}
	public ArrayList<String> getKeywords() {
		return keywords;
	}
	
	public Theme(int id, String name, String details, ArrayList<String> keywords) {
		super();
		this.details = details;
		this.id = id;
		this.keywords = keywords;
		this.name = name;
	}
	@Override
	public int compareTo(Theme o) {
		return getName().compareTo(o.getName());	
	}
	
	public void update(User user, String name, String description, ArrayList<String> keywords){
		if(user.getType()>=User.ADMIN){
			this.name = name;
			this.details = description;
			this.keywords= keywords;
			Persistence.updateTheme(user, this);
		} else {
			logger.warning("Update permission denied user name:" + user.getName());
		}
		
	}
}
