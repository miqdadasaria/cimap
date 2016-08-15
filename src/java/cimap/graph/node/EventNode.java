package cimap.graph.node;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;

import cimap.graph.User;
import cimap.graph.edge.Edge;

public class EventNode extends AbstractNodeImpl{
	private static Logger logger = Logger.getLogger(PublicationNode.class.getName());

	private ContactDetails contact;
	private Date eventDate;
	private int numPresenters;
	private int numAttendees;
	
	public EventNode(			
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
			ContactDetails contact, 
			Date eventDate, 
			int numPresenter, 
			int numAttendees,
			User modBy, 
			Date modDate) {
		super(id, type, name, photo, url, background, themes, news, organisations, individuals, events, publications, addedBy, dateAdded, viewCount, modBy, modDate);
		this.contact = contact;
		this.eventDate = eventDate;
		this.numPresenters = numPresenter;
		this.numAttendees = numAttendees;
	}

	public ContactDetails getContact() {
		return contact;
	}

	public void setContact(ContactDetails contact) {
		this.contact = contact;
	}

	public Date getEventDate() {
		return eventDate;
	}

	public void setEventDate(Date eventDate) {
		this.eventDate = eventDate;
	}

	public int getNumPresenters() {
		return numPresenters;
	}

	public void setNumPresenters(int numPresenters) {
		this.numPresenters = numPresenters;
	}

	public int getNumAttendees() {
		return numAttendees;
	}

	public void setNumAttendees(int numAttendees) {
		this.numAttendees = numAttendees;
	}

	public void update(User user, String name, NodeType type, String photo, String background, String url, ContactDetails contact, Date eventDate, int numPresenters, int numAttendees){
		if(user.getType() >= User.ADMIN){
			this.setModBy(user);
			this.setLastModified(Calendar.getInstance().getTime());
			this.setName(name);
			this.setType(type);
			this.setPhotograph(photo);
			this.setBackground(background);
			this.setURL(url);
			this.setContact(contact);
			this.setEventDate(eventDate);
			this.setNumPresenters(numPresenters);
			this.setNumAttendees(numAttendees);
			this.updateNode(this);
		} else {
			logger.warning("Update permission denied user name:" + user.getName());
		}
	}
}
