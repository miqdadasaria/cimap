package cimap.graph.node;

public class NodeType implements Comparable<NodeType>{
	
	// Organisation Node Types
	public static final int POLITICAL = 1; 
	public static final int CIVIL_SOCIETY = 2;
	public static final int RELIGIOUS = 3;
	public static final int POLICY_INSTITUTE = 4;
	public static final int GOVERNANCE = 5;
	public static final int BUSINESS = 6;
	public static final int MILITARY_POLICE_SECURITY = 7;
	public static final int MEDIA = 8;
	public static final int ACADEMIA = 9;
	public static final int ECOWAS_INSTITUTION = 10;
	public static final int LEGISLATURE = 11;
	public static final int JUDICIARY = 12;
	public static final int TRADITIONAL = 13; 
	public static final int EMBASSY = 14; 
	public static final int INTERNATIONAL_COMMUNITY = 15;
	public static final int LABOUR = 16;
	public static final int YOUTH = 17; 
	public static final int SOCIO_CULTURAL = 18; 
	public static final int OTHER_ORG = 19; 
	
	// Individual Node Types
	public static final int JOURNALIST = 101; 
	public static final int RELIGIOUS_LEADER = 102; 
	public static final int THINKER = 103;
	public static final int ACTIVIST = 104;
	public static final int POLITICIAN = 105;
	public static final int BUSINESS_PERSON = 106;
	public static final int ACADEMIC = 107;
	public static final int TECHNOCRAT = 108;
	public static final int DIPLOMAT = 109;
	public static final int TRADITIONAL_RULER = 110;
	public static final int MILITARY_PERSONNEL = 111;
	public static final int JUDGE = 112;
	public static final int PROFESSIONAL = 113;
	public static final int OTHER_IND = 114;

	// Event Node Types
	public static final int CONFERENCE = 201; 
	public static final int SEMINAR = 202;
	public static final int WORKSHOP = 203; 
	 
	// Publication Node Types
	public static final int BOOK = 301; 
	public static final int JOURNAL_PAPER = 302;

	private int id;
	private String typeName;
	private String subTypeName;
	
	public NodeType(int id, String typeName, String subTypeName) {
		super();
		this.id = id;
		this.typeName = typeName;
		this.subTypeName = subTypeName;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	
	public String getSubTypeName() {
		return subTypeName;
	}

	public void setSubTypeName(String subTypeName) {
		this.subTypeName = subTypeName;
	}

	@Override
	public int compareTo(NodeType o) {
		if ((getTypeName().compareTo(o.getTypeName())) == 0){
			return getSubTypeName().compareTo(o.getSubTypeName());
		} else {
			return getTypeName().compareTo(o.getTypeName());
		}
	}
	
}
