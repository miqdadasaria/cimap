package cimap.graph.edge;

public class EdgeType implements Comparable<EdgeType> {
	
	//ORG2ORG
	public static final int FUNDING = 1;
	public static final int TRAINING = 2;
	public static final int SUBSIDIARY = 3;
	public static final int REGULATORY = 4;
	public static final int MONITORING = 5;
	public static final int PARTNERSHIP = 6;
	public static final int OTHER_ORG2ORG = 7;
	
	//ORG2IND
	public static final int EMPLOYEE = 101;
	public static final int DIRECTOR = 102;
	public static final int HEAD_LEADER = 103;
	public static final int OWNER_SHAREHOLDER = 104;
	public static final int MEMBER = 105;
	public static final int FUNDER_ORG2IND = 106;
	public static final int CONSULTANT = 107;
	public static final int EDUCATION = 108;
	public static final int OTHER_ORG2IND = 109;

	//IND2IND
	public static final int FAMILY = 201;
	public static final int ASSOCIATES = 202;
	public static final int OPPONENTS = 203;

	//ORG2EVE
	public static final int ORGANISER_ORG2EVE = 301;
	public static final int FUNDER_ORG2EVEV = 302;
	public static final int PARTICIPANT = 303;

	//IND2EVE
	public static final int PRESENTER = 401;
	public static final int ATTENDEE = 402;
	public static final int ORGANISER_IND2EVE = 403;
	public static final int FUNDER_IND2EVE = 404;
	
	//ORG2PUB
	public static final int PUBLISHER = 501;
	public static final int FUNDER_ORG2PUB = 502;

	//IND2PUB
	public static final int AUTHOR = 601;
	public static final int FUNDER_IND2PUB = 602;
	
	//PUB2PUB 
	public static final int REFERENCE = 701;
	
	//EVE2EVE 
	public static final int RELATED_EVENT_SERIES = 801;

	//EVE2PUB
	public static final int CONFERENCE_PAPER = 901;
	
	private int id;
	private String typeName;
	private String subTypeName;
	
	public EdgeType(int id, String typeName, String subTypeName){
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
	public int compareTo(EdgeType o) {
		if ((getTypeName().compareTo(o.getTypeName())) == 0){
			return getSubTypeName().compareTo(o.getSubTypeName());
		} else {
			return getTypeName().compareTo(o.getTypeName());
		}
	}
	
}
