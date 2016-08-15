package cimap.graph;

import java.util.Date;
import java.util.logging.Logger;

import cimap.database.Persistence;

public class User implements Comparable<User>{
	private static Logger logger = Logger.getLogger(User.class.getName());

	// user type
	public static final int PUBLIC = 0;
	public static final int STANDARD = 3;
	public static final int ADMIN = 5;
	public static final int SUPERUSER = 6;
	
	private int id;
	private int type;
	private MasterGraph graph;
	private String username;
	private String password;
	private boolean loggedIn;
	private String name;
	private String orgName;
	private String email;
	private String url;
	private String bio;
	private String country;

	private String photograph;
	private Date creationDate;
	private Date lastLogin;
	private int loginCount;
	private int nodeAddCount;
	private int nodeViewCount;
	private int nodeUpdateCount;
	private int nodeAddQuota;
	private int nodeViewQuota;
	private int nodeUpdateQuota;

	public User(int id, String username, String password, int type, String name, String email, String country, String bio, String orgName, String url,
			String photograph, Date creationDate, Date lastLogin, int loginCount, int nodeAddCount, int nodeViewCount, int nodeUpdateCount, int nodeAddQuota,
			int nodeViewQuota, int nodeUpdateQuota) {
		super();
		this.id = id;
		this.type = type;
		this.username = username;
		this.password = password;
		this.loggedIn = false;
		this.name = name;
		this.email = email;
		this.country = country;
		this.bio = bio;
		this.orgName = orgName;
		this.url = url;

		this.photograph = photograph;
		this.creationDate = creationDate;
		this.lastLogin = lastLogin;
		this.loginCount = loginCount;
		this.nodeAddCount = nodeAddCount;
		this.nodeViewCount = nodeViewCount;
		this.nodeUpdateCount = nodeUpdateCount;
		this.nodeAddQuota = nodeAddQuota;
		this.nodeViewQuota = nodeViewQuota;
		this.nodeUpdateQuota = nodeUpdateQuota;
	}

	public int getType() {
		return type;
	}

	public MasterGraph getGraph() {
		return graph;
	}

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}

	public boolean isLoggedIn() {
		return loggedIn;
	}

	public boolean login(String username, String password) {
		if (this.username.equals(username) && this.password.equals(password)) {
			if (isLoggedIn())
				logout();
			this.graph = new MasterGraph();
			this.loggedIn = true;
			Persistence.login(this);
		}
		return loggedIn;
	}

	public void logout() {
		this.graph = null;
		this.loggedIn = false;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
		updateUser();
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
		updateUser();
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
		updateUser();
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
		updateUser();
	}

	public String getBio() {
		return bio;
	}

	public void setBio(String bio) {
		this.bio = bio;
		updateUser();
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
		updateUser();		
	}

	public void setType(int type) {
		this.type = type;
		updateUser();
	}

	public void setGraph(MasterGraph graph) {
		this.graph = graph;
	}

	public void setUsername(String username) {
		this.username = username;
		updateUser();
	}

	public void setPassword(String password) {
		this.password = password;
		updateUser();
	}

	public String getPhotograph() {
		return photograph;
	}

	public void setPhotograph(String photograph) {
		this.photograph = photograph;
		updateUser();
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
		updateUser();
	}

	public Date getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}

	public int getLoginCount() {
		return loginCount;
	}

	public void setLoginCount(int loginCount) {
		this.loginCount = loginCount;
	}

	public int getNodeAddCount() {
		return nodeAddCount;
	}

	public void setNodeAddCount(int nodeAddCount) {
		this.nodeAddCount = nodeAddCount;
		updateUser();
	}

	public int getNodeViewCount() {
		return nodeViewCount;
	}

	public void setNodeViewCount(int nodeViewCount) {
		this.nodeViewCount = nodeViewCount;
		updateUser();
	}

	public int getNodeUpdateCount() {
		return nodeUpdateCount;
	}

	public void setNodeUpdateCount(int nodeUpdateCount) {
		this.nodeUpdateCount = nodeUpdateCount;
		updateUser();
	}

	public int getNodeAddQuota() {
		return nodeAddQuota;
	}

	public void setNodeAddQuota(int nodeAddQuota) {
		this.nodeAddQuota = nodeAddQuota;
		updateUser();
	}

	public int getNodeViewQuota() {
		return nodeViewQuota;
	}

	public void setNodeViewQuota(int nodeViewQuota) {
		this.nodeViewQuota = nodeViewQuota;
		updateUser();
	}

	public int getNodeUpdateQuota() {
		return nodeUpdateQuota;
	}

	public void setNodeUpdateQuota(int nodeUpdateQuota) {
		this.nodeUpdateQuota = nodeUpdateQuota;
		updateUser();
	}
	
	public void setDefaults(int loginCount, Date dateAdded, int nodeAddCount, int nodeUpdateCount, int nodeViewCount, int nodeAddQuota, int nodeUpdateQuota, int nodeViewQuota){
		this.loginCount = loginCount;
		this.creationDate = dateAdded;
		this.nodeAddCount = nodeAddCount;
		this.nodeUpdateCount = nodeUpdateCount;
		this.nodeViewCount = nodeViewCount;
		this.nodeAddQuota = nodeAddQuota;
		this.nodeUpdateQuota = nodeUpdateQuota;
		this.nodeViewQuota = nodeViewQuota;
	}
	
	private void updateUser(){
		Persistence.updateUser(this);
	}

	public void update(User user, String name, String country, String email, String url, String orgname, String bio, String username, String password, int type, int viewQuota, int updateQuota, String photograph){
		if(user.type >= User.SUPERUSER){
			this.name=name;
			this.country=country;
			this.email=email;
			this.url=url;
			this.orgName=orgname;
			this.bio=bio;
			this.username=username;
			this.password=password;
			this.type=type;
			this.nodeViewQuota=viewQuota;
			this.nodeUpdateQuota=updateQuota;
			this.photograph=photograph;
			updateUser();
		} else {
			logger.warning("permission denied to update user details by: " + user.getName());
		}
	}
	
	@Override
	public int compareTo(User o) {
		return getName().compareTo(o.getName());
	}
}