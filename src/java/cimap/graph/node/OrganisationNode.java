package cimap.graph.node;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;

import cimap.graph.User;
import cimap.graph.edge.Edge;

public class OrganisationNode extends AbstractNodeImpl {
	private static Logger logger = Logger.getLogger(OrganisationNode.class.getName());

	private ContactDetails contact;
	private int numStaff;
	private int numCustomers;

	public OrganisationNode(int id, NodeType type, String name, String photo, String url, String background, ArrayList<Theme> themes,
			ArrayList<NewsArticle> news, ArrayList<Edge> organisations, ArrayList<Edge> individuals, ArrayList<Edge> events, ArrayList<Edge> publications,
			User addedBy, Date dateAdded, int viewCount, ContactDetails contact, int numStaff, int numCustomers, User modBy, Date modDate) {
		super(id, type, name, photo, url, background, themes, news, organisations, individuals, events, publications, addedBy, dateAdded, viewCount, modBy,
				modDate);
		this.contact = contact;
		this.numStaff = numStaff;
		this.numCustomers = numCustomers;
	}

	public ContactDetails getContact() {
		return contact;
	}

	public void setContact(ContactDetails contact) {
		this.contact = contact;
	}

	public int getNumStaff() {
		return numStaff;
	}

	public void setNumStaff(int numStaff) {
		this.numStaff = numStaff;
	}

	public int getNumCustomers() {
		return numCustomers;
	}

	public void setNumCustomers(int numCustomers) {
		this.numCustomers = numCustomers;
	}

	public void update(User user, String name, NodeType type, String photo, String background, String url, ContactDetails contact, int numStaff,
			int numCustomers) {
		if (user.getType() >= User.ADMIN) {
			this.setModBy(user);
			this.setLastModified(Calendar.getInstance().getTime());
			this.setName(name);
			this.setType(type);
			this.setPhotograph(photo);
			this.setBackground(background);
			this.setURL(url);
			this.setContact(contact);
			this.setNumStaff(numStaff);
			this.setNumCustomers(numCustomers);
			this.updateNode(this);
		} else {
			logger.warning("Update permission denied user name:" + user.getName());
		}
	}
}
