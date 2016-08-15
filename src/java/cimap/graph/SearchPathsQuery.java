package cimap.graph;

import cimap.graph.node.Node;

public class SearchPathsQuery {
	private Node startNode;
	private Node endNode;
	private int maxLength;
	
	public SearchPathsQuery(Node startNode, Node endNode, int maxLength) {
		this.startNode = startNode;
		this.endNode = endNode;
		this.maxLength = maxLength;
	}	
	
	public Node getStartNode() {
		return startNode;
	}
	public Node getEndNode() {
		return endNode;
	}
	public int getMaxLength() {
		return maxLength;
	}
	
	
}
