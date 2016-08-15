package cimap.graph;

import java.util.ArrayList;
import java.util.Iterator;

import cimap.graph.node.Node;

public class Path implements Comparable<Path>{
	//private static Logger logger = Logger.getLogger(Path.class.getName());

	private ArrayList<Node> nodes;
	private int maxLength; 
	private Node startNode;
	private Node currentNode;
	private Node endNode;
	
	public Path(Node startNode, Node currentNode, Node endNode, ArrayList<Node> nodes, int maxLength){
		this.nodes = nodes;
		this.startNode = startNode;
		this.currentNode = currentNode;
		this.endNode = endNode;
		this.maxLength = maxLength;
		this.nodes.add(this.currentNode);
	}
	
	public int length(){
		return nodes.size()-1;
	}
	
	public int getMaxLength(){
		return this.maxLength;
	}
	
	public ArrayList<Node> getNodes(){
		return nodes;
	}
	
	public ArrayList<Path> extend(){
		ArrayList<Path> paths = new ArrayList<Path>();
		if(!currentNode.equals(endNode) && this.length()< maxLength){
			ArrayList<Node> inds = currentNode.getAllRelatedNodes("Individual");
			ArrayList<Node> orgs = currentNode.getAllRelatedNodes("Organisation");
			ArrayList<Node> eves = currentNode.getAllRelatedNodes("Event");
			ArrayList<Node> pubs = currentNode.getAllRelatedNodes("Publication");
			Iterator<Node> i = inds.iterator();
			Node node = null;
			while(i.hasNext()){
				node=i.next();
				if(!this.nodes.contains(node)){
					Path path = new Path(this.startNode, node, this.endNode, (ArrayList<Node>)this.nodes.clone(), this.maxLength);
					paths.add(path);
				}
			}
			Iterator<Node> o = orgs.iterator();
			while(o.hasNext()){
				node=o.next();
				if(!this.nodes.contains(node)){
					Path path = new Path(this.startNode, node, this.endNode, (ArrayList<Node>)this.nodes.clone(), this.maxLength);
					paths.add(path);
				}
			}
			Iterator<Node> e = eves.iterator();
			while(e.hasNext()){
				node=e.next();
				if(!this.nodes.contains(node)){
					Path path = new Path(this.startNode, node, this.endNode, (ArrayList<Node>)this.nodes.clone(), this.maxLength);
					paths.add(path);
				}
			}
			Iterator<Node> p = pubs.iterator();
			while(p.hasNext()){
				node=p.next();
				if(!this.nodes.contains(node)){
					Path path = new Path(this.startNode, node, this.endNode, (ArrayList<Node>)this.nodes.clone(), this.maxLength);
					paths.add(path);
				}
			}
		}
		return paths;
	}
	
	public boolean isComplete(){
		if(nodes.contains(this.endNode) && length()<=maxLength){
			return true;
		} else {
			return false;
		}
	}
	
	public String toString(){
		StringBuffer path = new StringBuffer("Path between node: " + startNode.getName() + " and node: " + endNode.getName() + " maxLength: " + maxLength + "\n");
		Iterator<Node> i = nodes.iterator();
		while(i.hasNext()){
			path.append(i.next().getName() + "\n");
		}
		return path.toString();
	}

	public int compareTo(Path p) {
		if(p.length() < this.length())
			return 1;
		else if(p.length() > this.length())
			return -1;
		else
			return 0;
	}
}
