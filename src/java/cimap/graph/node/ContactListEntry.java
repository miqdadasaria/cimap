package cimap.graph.node;

import java.util.Date;

import cimap.graph.User;

public class ContactListEntry implements Comparable<ContactListEntry> {
	private int id;
	private Node node;
	private User addedBy;
	private Date dateAdded;

	public ContactListEntry(int id, Node node, User addedBy, Date dateAdded) {
		this.addedBy = addedBy;
		this.dateAdded = dateAdded;
		this.id = id;
		this.node = node;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Node getNode() {
		return node;
	}

	public void setNode(Node node) {
		this.node = node;
	}

	public User getAddedBy() {
		return addedBy;
	}

	public void setAddedBy(User addedBy) {
		this.addedBy = addedBy;
	}

	public Date getDateAdded() {
		return dateAdded;
	}

	public void setDateAdded(Date dateAdded) {
		this.dateAdded = dateAdded;
	}

	@Override
	public int compareTo(ContactListEntry o) {
		return node.getName().compareTo(o.getNode().getName());
	}

}
