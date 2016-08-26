package cimap.servlets;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Logger;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;

import cimap.graph.MasterGraph;
import cimap.graph.User;
import cimap.graph.node.ContactDetails;
import cimap.graph.node.EventNode;
import cimap.graph.node.IndividualNode;
import cimap.graph.node.Node;
import cimap.graph.node.NodeType;
import cimap.graph.node.OrganisationNode;
import cimap.graph.node.PublicationNode;

public class UpdateNode extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4437562252249415314L;
	private static Logger logger = Logger.getLogger(UpdateNode.class.getName());

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession session = request.getSession(true);
		User user = (User) session.getAttribute("username");
		String redirect = "cimap.jsp?tab=nodedetails";
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		if (user != null && user.isLoggedIn() && isMultipart) {
			Node node = user.getGraph().getSelected();

			DateFormat fmt = new SimpleDateFormat("yyyy-mm-dd");
			ServletFileUpload upload = new ServletFileUpload();

			// Parse the request
			String name = null;
			int type;
			NodeType nodeType = null;
			String background = null;
			String url = null;
			ContactDetails contact = null;
			String addressLine1 = null;
			String addressLine2 = null;
			String city = null;
			String state = null;
			String country = null;
			String postcode = null;
			String phone = null;
			String email = null;
			String originCity = null;
			String originState = null;
			String originCountry = null;
			String longitudeText = null;
			double longitude = 0;
			String latitudeText = null;
			double latitude = 0;
			int numStaff = 0;
			int numCustomers = 0;
			Date dob = null;
			char gender = 'u';
			Date eventDate = null;
			int numPresenters = 0;
			int numAttendees = 0;
			Date pubDate = null;
			String source = null;
			String photograph = node.getPhotograph();
			try {
				FileItemIterator iter = upload.getItemIterator(request);
				while (iter.hasNext()) {
					FileItemStream item = iter.next();
					String itemName = item.getFieldName();
					InputStream stream = item.openStream();
					if (item.isFormField()) {
						if (itemName.equals("name")) {
							name = Streams.asString(stream).trim();
							if (name == null || name.equals(""))
								name = null;
						} else if (itemName.equals("type")) {
							type = Integer.parseInt(Streams.asString(stream));
							nodeType = MasterGraph.getNodeType(type);
						} else if (itemName.equals("background")) {
							background = Streams.asString(stream).trim();
							if (background == null || background.equals(""))
								background = null;
						} else if (itemName.equals("url")) {
							url = Streams.asString(stream).trim();
							if (url == null || url.equals(""))
								url = null;
						} else if (nodeType != null && !nodeType.getTypeName().equals("Publication")) {
							if (itemName.equals("addressline1")) {
								addressLine1 = Streams.asString(stream).trim();
								if (addressLine1 == null || addressLine1.equals(""))
									addressLine1 = null;
							} else if (itemName.equals("addressline2")) {
								addressLine2 = Streams.asString(stream).trim();
								if (addressLine2 == null || addressLine2.equals(""))
									addressLine2 = null;
							} else if (itemName.equals("city")) {
								city = Streams.asString(stream).trim();
								if (city == null || city.equals(""))
									city = null;
							} else if (itemName.equals("state")) {
								state = Streams.asString(stream).trim();
								if (state == null || state.equals(""))
									state = null;
							} else if (itemName.equals("country")) {
								country = Streams.asString(stream).trim();
								if (country == null || country.equals(""))
									country = null;
							} else if (itemName.equals("postcode")) {
								postcode = Streams.asString(stream).trim();
								if (postcode == null || postcode.equals(""))
									postcode = null;
							} else if (itemName.equals("phone")) {
								phone = Streams.asString(stream).trim();
								if (phone == null || phone.equals(""))
									phone = null;
							} else if (itemName.equals("email")) {
								email = Streams.asString(stream).trim();
								if (email == null || email.equals(""))
									email = null;
							} else if (itemName.equals("originCity")) {
								originCity = Streams.asString(stream).trim();
								if (originCity == null || originCity.equals(""))
									originCity = null;
							} else if (itemName.equals("originState")) {
								originState = Streams.asString(stream).trim();
								if (originState == null || originState.equals(""))
									originState = null;
							} else if (itemName.equals("originCountry")) {
								originCountry = Streams.asString(stream).trim();
								if (originCountry == null || originCountry.equals(""))
									originCountry = null;
							} else if (itemName.equals("longitude")) {
								longitudeText = Streams.asString(stream).trim();
								if (longitudeText == null || longitudeText.equals(""))
									longitudeText = null;
								if (longitudeText != null) {
									try {
										longitude = Double.parseDouble(longitudeText);
									} catch (Exception e) {
										logger.warning("failed to parse longitude: " + longitudeText);
									}
								}
							} else if (itemName.equals("latitude")) {
								latitudeText = Streams.asString(stream).trim();
								if (latitudeText == null || latitudeText.equals(""))
									latitudeText = null;
								if (latitudeText != null) {
									try {
										latitude = Double.parseDouble(latitudeText);
									} catch (Exception e) {
										logger.warning("failed to parse latitude: " + latitudeText);
									}
								}
							}

						}

						if (nodeType != null && nodeType.getTypeName().equals("Organisation")) {
							// organisation node
							if (itemName.equals("numStaff")) {
								try {
									numStaff = Integer.parseInt(Streams.asString(stream));
								} catch (Exception e) {
									numStaff = 0;
								}
							} else if (itemName.equals("numCustomers")) {
								try {
									numCustomers = Integer.parseInt(Streams.asString(stream));
								} catch (Exception e) {
									numCustomers = 0;
								}
							}
						} else if (nodeType != null && nodeType.getTypeName().equals("Individual")) {
							// individual node
							if (itemName.equals("dob")) {
								try {
									dob = fmt.parse(Streams.asString(stream));
								} catch (Exception e) {
									dob = null;
								}
							} else if (itemName.equals("gender")) {
								try {
									gender = Streams.asString(stream).charAt(0);
								} catch (Exception e) {
									gender = 'u';
								}
							}
						} else if (nodeType != null && nodeType.getTypeName().equals("Event")) {
							// event node
							if (itemName.equals("eventDate")) {
								try {
									eventDate = fmt.parse(Streams.asString(stream));
								} catch (Exception e) {
									eventDate = null;
								}
							} else if (itemName.equals("numPresenters")) {
								try {
									numPresenters = Integer.parseInt(Streams.asString(stream));
								} catch (Exception e) {
									numPresenters = 0;
								}
							} else if (itemName.equals("numAttendees")) {
								try {
									numAttendees = Integer.parseInt(Streams.asString(stream));
								} catch (Exception e) {
									numAttendees = 0;
								}
							}
						} else if (nodeType != null && nodeType.getTypeName().equals("Publication")) {
							// publication node
							if (itemName.equals("pubDate")) {
								try {
									pubDate = fmt.parse(Streams.asString(stream));
								} catch (Exception e) {
									pubDate = null;
								}
							} else if (itemName.equals("source")) {
								source = Streams.asString(stream).trim();
								if (source == null || source.equals(""))
									source = null;
							}
						}

					} else {
						if (item.getName() != null && !item.getName().trim().equals("") && itemName.equals("photo")) {
							InputStream imageStream = new BufferedInputStream(stream);
							Image image = (Image) ImageIO.read(imageStream);

							int thumbWidth = 600;
							int thumbHeight = 400;

							// Make sure the aspect ratio is maintained, so the
							// image is not skewed
							double thumbRatio = (double) thumbWidth / (double) thumbHeight;
							int imageWidth = image.getWidth(null);
							int imageHeight = image.getHeight(null);
							double imageRatio = (double) imageWidth / (double) imageHeight;
							if (thumbWidth < imageWidth || thumbHeight < imageHeight) {
								if (thumbRatio < imageRatio) {
									thumbHeight = (int) (thumbWidth / imageRatio);
								} else {
									thumbWidth = (int) (thumbHeight * imageRatio);
								}
							} else {
								thumbWidth = imageWidth;
								thumbHeight = imageHeight;
							}

							// Draw the scaled image
							BufferedImage thumbImage = new BufferedImage(thumbWidth, thumbHeight, BufferedImage.TYPE_INT_RGB);
							Graphics2D graphics2D = thumbImage.createGraphics();
							graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
							graphics2D.drawImage(image, 0, 0, thumbWidth, thumbHeight, null);

							// Write the scaled image to the outputstream
							ByteArrayOutputStream out = new ByteArrayOutputStream();
							ImageIO.write(thumbImage, "jpg", out);

							// Read the outputstream into the inputstream for
							// the return value
							stream = new ByteArrayInputStream(out.toByteArray());

							photograph = "photos/" + node.getId() + "-" + item.getName();
							File f = new File(getServletContext().getRealPath("/") + photograph);
							OutputStream fout = new FileOutputStream(f);
							byte buf[] = new byte[1024];
							int len;
							while ((len = stream.read(buf)) > 0)
								fout.write(buf, 0, len);
							out.close();
							stream.close();
						}
					}
				}
			} catch (FileUploadException fue) {
				logger.warning(fue.getMessage());
			}

			if (nodeType != null && !nodeType.getTypeName().equals("Publication")) {
				contact = new ContactDetails(addressLine1, addressLine2, city, country, email, latitude, longitude, originCity, originCountry, originState,
						phone, postcode, state);
			}
			if (nodeType.getTypeName().equals("Organisation"))
				((OrganisationNode) node).update(user, name, nodeType, photograph, background, url, contact, numStaff, numCustomers);
			else if (nodeType.getTypeName().equals("Individual"))
				((IndividualNode) node).update(user, name, nodeType, photograph, background, url, contact, dob, gender);
			else if (nodeType.getTypeName().equals("Event"))
				((EventNode) node).update(user, name, nodeType, photograph, background, url, contact, eventDate, numPresenters, numAttendees);
			else if (nodeType.getTypeName().equals("Publication"))
				((PublicationNode) node).update(user, name, nodeType, photograph, background, url, pubDate, source);

		}
		response.sendRedirect(redirect);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doPost(request, response);
	}

}
