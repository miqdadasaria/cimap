package cimap.graph.edge;

import java.util.Date;

import cimap.graph.User;
import cimap.graph.node.IndividualNode;
import cimap.graph.node.OrganisationNode;

public class Org2IndEdge extends AbstractEdgeImpl {

	public Org2IndEdge(int id, EdgeType type, Date startDate, Date endDate, String details, OrganisationNode node1, IndividualNode node2, User addedBy, Date dateAdded, User modBy, Date modDate) {
		super(id, type, startDate, endDate, details, node1, node2, addedBy, dateAdded, modBy, modDate);
	}

}
