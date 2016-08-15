package cimap.graph.edge;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;

import cimap.database.Persistence;
import cimap.graph.AbstractGraphObject;
import cimap.graph.User;
import cimap.graph.node.Node;



public abstract class AbstractEdgeImpl extends AbstractGraphObject implements Edge {
	private static Logger logger = Logger.getLogger(AbstractEdgeImpl.class.getName());

	private int id;
	private EdgeType type;
	private Date startDate;
	private Date endDate;
	private String details;
	private ArrayList<Node> nodes;

	public AbstractEdgeImpl(int id, EdgeType type, Date startDate, Date endDate, String details, Node node1, Node node2, User addedBy, Date dateAdded, User modBy, Date modDate) {
		super(addedBy, dateAdded, modBy, modDate);
		this.details = details;
		this.endDate = endDate;
		this.id = id;
		this.nodes = new ArrayList<Node>();
		this.nodes.add(node1);
		this.nodes.add(node2);
		this.startDate = startDate;
		this.type = type;
	}
	

	public void setType(EdgeType type) {
		this.type = type;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public void setDetails(String details) {
		this.details = details;
	}

	public void setNodes(ArrayList<Node> nodes) {
		this.nodes = nodes;
	}

	@Override
	public String getDetails() {
		return details;
	}

	@Override
	public Date getEndDate() {
		return endDate;
	}

	@Override
	public ArrayList<Node> getNodes() {
		return nodes;
	}

	@Override
	public Node getOtherNode(Node n) {
		if(nodes.get(0).getId() == n.getId()){
			return nodes.get(1);
		} else if(nodes.get(1).getId() == n.getId()){
			return nodes.get(0);
		}
		return null;
	}

	@Override
	public Date getStartDate() {
		return startDate;
	}

	@Override
	public int getId() {
		return id;
	}

	@Override
	public EdgeType getType() {
		return type;
	}
	
	@Override
	public void setId(int id){
		this.id = id;
	}

	@Override
	public void update(User user, EdgeType type, Date startDate, Date endDate, String details) {
		if(user.getType() >= User.ADMIN){
			this.setModBy(user);
			this.setLastModified(Calendar.getInstance().getTime());
			this.setType(type);
			this.setStartDate(startDate);
			this.setEndDate(endDate);
			this.setDetails(details);
			Persistence.updateEdge(this);
		} else {
			logger.warning("Permission denied user type:" + user.getType());
		}
	}
}
