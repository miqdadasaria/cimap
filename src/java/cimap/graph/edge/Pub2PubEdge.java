package cimap.graph.edge;

import java.util.Date;

import cimap.graph.User;
import cimap.graph.node.PublicationNode;

public class Pub2PubEdge extends AbstractEdgeImpl {

	public Pub2PubEdge(int id, EdgeType type, Date startDate, Date endDate, String details, PublicationNode node1, PublicationNode node2, User addedBy, Date dateAdded, User modBy, Date modDate) {
		super(id, type, startDate, endDate, details, node1, node2, addedBy, dateAdded, modBy, modDate);
	}

}
