package cimap.graph.edge;

import java.util.ArrayList;
import java.util.Date;
import cimap.graph.User;
import cimap.graph.node.Node;

public interface Edge {
	public abstract int getId();
	public abstract void setId(int id);
	public abstract ArrayList<Node> getNodes();
	public abstract void setNodes(ArrayList<Node> nodes);
	public abstract Date getStartDate();
	public abstract void setStartDate(Date date);
	public abstract Date getEndDate();
	public abstract void setEndDate(Date date);
	public abstract String getDetails();
	public abstract void setDetails(String details);
	public abstract Node getOtherNode(Node n);
	public abstract EdgeType getType();
	public abstract void update(User user, EdgeType type, Date startDate, Date endDate, String details);
	public abstract Date getDateAdded();
	public abstract void setDateAdded(Date date);
	public abstract User getAddedBy();
	public abstract void setAddedBy(User user);
	public abstract Date getLastModified();
	public abstract void setLastModified(Date date);
	public abstract User getModBy();
	public abstract void setModBy(User user);

}
