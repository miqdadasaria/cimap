package cimap.graph.node;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.logging.Logger;

import cimap.database.Persistence;
import cimap.graph.User;

public class ContactList implements Comparable<ContactList> {
	private static Logger logger = Logger.getLogger(ContactList.class.getName());

	private int id;
	private String name;
	private String description;
	private User createdBy;
	private Date dateCreated;
	private ArrayList<ContactListEntry> contacts;

	public ContactList(int id, String name, String description, ArrayList<ContactListEntry> contacts, User createdBy, Date dateCreated) {
		super();
		this.id = id;
		this.name = name;
		this.contacts = contacts;
		this.description = description;
		this.createdBy = createdBy;
		this.dateCreated = dateCreated;
	}

	public void addContact(ContactListEntry contact) {
		if (contact.getAddedBy().getType() >= User.ADMIN) {
			contacts.add(contact);
			Persistence.addNewContactToContactList(contact, this);
		} else {
			logger.warning("Add to contact list permission denied user type:" + contact.getAddedBy().getType() + " id: " + contact.getAddedBy().getId());
		}
	}

	public void removeContact(User user, ContactListEntry contact) {
		if (user.getType() >= User.ADMIN) {
			contacts.remove(contact);
			Persistence.removeContactFromContactList(user, contact, this);
		} else {
			logger.warning("Add to contact list permission denied user type:" + user.getType() + " id: " + user.getId());
		}
	}

	public ArrayList<ContactListEntry> getContacts() {
		Collections.sort(contacts);
		return contacts;
	}

	public void setContacts(ArrayList<ContactListEntry> contacts) {
		this.contacts = contacts;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public User getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(User createdBy) {
		this.createdBy = createdBy;
	}

	public Date getDateCreated() {
		return dateCreated;
	}

	public void setDateCreated(Date dateCreated) {
		this.dateCreated = dateCreated;
	}

	@Override
	public int compareTo(ContactList o) {
		return getDateCreated().compareTo(o.getDateCreated());
	}

	public void update(User user, String name, String description) {
		if (user.getType() >= User.ADMIN) {
			this.setName(name);
			this.setDescription(description);
			Persistence.updateContactList(user, this);
		} else {
			logger.warning("Update contact list permission denied user type:" + user.getType() + " id: " + user.getId());
		}
	}

	public ArrayList<ContactListEntry> getOrganisations() {
		ArrayList<ContactListEntry> orgs = new ArrayList<ContactListEntry>();
		if (contacts != null) {
			Iterator<ContactListEntry> i = contacts.iterator();
			while (i.hasNext()) {
				ContactListEntry contact = i.next();
				if (contact.getNode() instanceof OrganisationNode)
					orgs.add(contact);
			}
			Collections.sort(orgs);
		}
		return orgs;
	}

	public ArrayList<ContactListEntry> getIndividuals() {
		ArrayList<ContactListEntry> inds = new ArrayList<ContactListEntry>();
		if (contacts != null) {
			Iterator<ContactListEntry> i = contacts.iterator();
			while (i.hasNext()) {
				ContactListEntry contact = i.next();
				if (contact.getNode() instanceof IndividualNode)
					inds.add(contact);
			}
			Collections.sort(inds);
		}
		return inds;
	}

}
