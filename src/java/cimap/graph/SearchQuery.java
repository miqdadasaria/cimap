package cimap.graph;

import java.util.ArrayList;

import cimap.graph.node.Theme;

public class SearchQuery {
	private String name;
	private String nodeTypeName;
	private String background;
	private String city;
	private String state;
	private String country;
	private ArrayList<Theme> themes;
	
	public SearchQuery(String background, String city, String country, String name, String nodeTypeName, String state, ArrayList<Theme> themes) {
		this.background = background;
		this.city = city;
		this.country = country;
		this.name = name;
		this.nodeTypeName = nodeTypeName;
		this.state = state;
		this.themes = themes;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getNodeTypeName() {
		return nodeTypeName;
	}
	public void setNodeTypeName(String nodeTypeName) {
		this.nodeTypeName = nodeTypeName;
	}
	public String getBackground() {
		return background;
	}
	public void setBackground(String background) {
		this.background = background;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public ArrayList<Theme> getThemes() {
		return themes;
	}
	public void setThemes(ArrayList<Theme> themes) {
		this.themes = themes;
	}
	
	
}
