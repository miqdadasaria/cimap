package cimap.graph.edge;

import java.util.Date;

import cimap.graph.User;
import cimap.graph.node.OrganisationNode;

public class Org2OrgEdge extends AbstractEdgeImpl {

	public Org2OrgEdge(int id, EdgeType type, Date startDate, Date endDate, String details, OrganisationNode node1, OrganisationNode node2 , User addedBy, Date dateAdded, User modBy, Date modDate) {
		super(id, type, startDate, endDate, details, node1, node2, addedBy, dateAdded, modBy, modDate);
	}

}
