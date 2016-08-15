package cimap.graph;

import java.util.Date;

public abstract class AbstractGraphObject {


	private Date dateAdded;
	private User addedBy;
	private Date modDate;
	private User modBy;
	
	public AbstractGraphObject(User addedBy, Date dateAdded, User modBy, Date modDate) {
		super();
		this.addedBy = addedBy;
		this.dateAdded = dateAdded;
		this.modBy = modBy;
		this.modDate = modDate;
	}
	
	public Date getDateAdded(){
		return dateAdded;
	}
	
	public User getAddedBy(){
		return addedBy;
	}
		
	public Date getLastModified(){
		return modDate;
	}
	
	public User getModBy(){
		return modBy;
	}

	public String toString(){
		return "";
	};
	
	public String toJSON(){
		return "";
	};

	public void setLastModified(Date modDate) {
		this.modDate = modDate;
	}

	public void setDateAdded(Date dateAdded) {
		this.dateAdded = dateAdded;
	}

	public void setAddedBy(User addedBy) {
		this.addedBy = addedBy;
	}

	public void setModBy(User modBy) {
		this.modBy = modBy;
	}
}
