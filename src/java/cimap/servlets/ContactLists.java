package cimap.servlets;

import java.io.IOException;
//import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.User;



public class ContactLists extends HttpServlet {

	private static final long serialVersionUID = -9005227299460620562L;
	//private static Logger logger = Logger.getLogger(ContactLists.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		String redirect = "cimap.jsp";
		if(user!=null && user.isLoggedIn()){
			String contactListId = request.getParameter("contactListId");
			String update = request.getParameter("update");
			redirect = "cimap.jsp?tab=contactlist";
			if(contactListId==null){
				session.removeAttribute("contactListId");
			} else {
				session.setAttribute("contactListId", contactListId);
			}
			if(update!=null){
				if(update.equals("deleteContactList")){
					MasterGraph.deleteContactList(MasterGraph.getContactList(Integer.parseInt(contactListId)), user);
					session.removeAttribute("contactListId");
				} else if(update.equals("addContactList")) {
					session.setAttribute("update", "addContactList");
				} else if(update.equals("searchResults")) {
					session.setAttribute("update", "addContacts");
					session.setAttribute("contactsSource", "searchResults");
				} else if(update.equals("currentNode")) {
					session.setAttribute("update", "addContacts");
					session.setAttribute("contactsSource", "currentNode");
				}  else if(update.equals("addContacts")) {
					session.setAttribute("update", "addContacts2");
				}  else if(update.equals("addContactsBack")) {
					session.setAttribute("update", "addContacts");
				} else {
					session.setAttribute("update", "updateContactList");
				}
			}
		}
		response.sendRedirect(redirect);

	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
