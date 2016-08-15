package cimap.graph.node;

public class ContactDetails {
	private String email;
	private String phone;
	private String addressLine1;
	private String addressLine2;
	private String postcode;
	private String state;
	private String city;
	private String country;
	private double longitude;
	private double latitude;
	private String originState;
	private String originCity;
	private String originCountry;

	public ContactDetails(String address_line1, String address_line2, String city, String country, String email, double latitude, double longitude,
			String origin_city, String origin_country, String origin_state, String phone, String postcode, String state) {
		this.addressLine1 = address_line1;
		this.addressLine2 = address_line2;
		this.postcode = postcode;
		this.city = city;
		this.country = country;
		this.email = email;
		this.latitude = latitude;
		this.longitude = longitude;
		this.originCity = origin_city;
		this.originCountry = origin_country;
		this.originState = origin_state;
		this.phone = phone;
		this.state = state;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddressLine1() {
		return addressLine1;
	}

	public void setAddressLine1(String addressLine1) {
		this.addressLine1 = addressLine1;
	}

	public String getAddressLine2() {
		return addressLine2;
	}

	public void setAddressLine2(String addressLine2) {
		this.addressLine2 = addressLine2;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public String getOriginState() {
		return originState;
	}

	public void setOriginState(String origin_state) {
		this.originState = origin_state;
	}

	public String getOriginCity() {
		return originCity;
	}

	public void setOriginCity(String origin_city) {
		this.originCity = origin_city;
	}

	public String getOriginCountry() {
		return originCountry;
	}

	public void setOriginCountry(String origin_country) {
		this.originCountry = origin_country;
	}

}
