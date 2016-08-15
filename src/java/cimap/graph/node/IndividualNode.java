package cimap.graph.node;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;

import cimap.graph.User;
import cimap.graph.edge.Edge;

public class IndividualNode extends AbstractNodeImpl {
	private static Logger logger = Logger.getLogger(IndividualNode.class.getName());
	private ContactDetails contact;
	private Date dateOfBirth;
	private char gender;

	public IndividualNode(int id, NodeType type, String name, String photo, String url, String background, ArrayList<Theme> themes,
			ArrayList<NewsArticle> news, ArrayList<Edge> organisations, ArrayList<Edge> individuals, ArrayList<Edge> events, ArrayList<Edge> publications,
			User addedBy, Date dateAdded, int viewCount, ContactDetails contact, Date dateOfBirth, char gender, User modBy, Date modDate) {
		super(id, type, name, photo, url, background, themes, news, organisations, individuals, events, publications, addedBy, dateAdded, viewCount, modBy,
				modDate);
		this.contact = contact;
		this.dateOfBirth = dateOfBirth;
		this.gender = gender;
	}

	public ContactDetails getContact() {
		return contact;
	}

	public void setContact(ContactDetails contact) {
		this.contact = contact;
	}

	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public char getGender() {
		return gender;
	}

	public void setGender(char gender) {
		this.gender = gender;
	}

	public void update(User user, String name, NodeType type, String photo, String background, String url, ContactDetails contact, Date dob, char gender) {
		if (user.getType() >= User.ADMIN) {
			this.setModBy(user);
			this.setLastModified(Calendar.getInstance().getTime());
			this.setName(name);
			this.setType(type);
			this.setPhotograph(photo);
			this.setBackground(background);
			this.setURL(url);
			this.setContact(contact);
			this.setDateOfBirth(dob);
			this.setGender(gender);
			this.updateNode(this);
		} else {
			logger.warning("Update permission denied user name:" + user.getName());
		}
	}
}
