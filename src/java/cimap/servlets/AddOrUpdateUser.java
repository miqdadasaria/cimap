package cimap.servlets;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.User;


public class AddOrUpdateUser extends HttpServlet {
	private static final long serialVersionUID = 8355306301902624901L;
	private static Logger logger = Logger.getLogger(AddOrUpdateUser.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		String redirect = "cimap.jsp";
		if(user!=null && user.isLoggedIn()){
			String update = request.getParameter("update");
			if(update.equals("updateUser")){
				int userId = Integer.parseInt(request.getParameter("userId"));
				session.setAttribute("userId", userId);
				session.setAttribute("update", "updateUser");
				redirect = "cimap.jsp?tab=useradmin";
			}else if(update.equals("addUser")){
					session.setAttribute("update", "addUser");
					redirect = "cimap.jsp?tab=useradmin";
			} else if(update.equals("deleteUser")){
				int userId = Integer.parseInt(request.getParameter("userId"));
				logger.info("deleting user with id: " + userId);
				User userToDelete = MasterGraph.getUser(userId);
				if(userToDelete!=null){
					MasterGraph.deleteUser(userToDelete,user);
				} else {
					logger.warning("user to delete with id: " + userId + " not found");
				}
				redirect = "cimap.jsp?tab=useradmin";
			} else if(update.equals("updateUser2")){
				// add new user to database and to graph
				String name = request.getParameter("name");
				String country = request.getParameter("country");
				String email = request.getParameter("email");
				String url = request.getParameter("url");
				String orgname = request.getParameter("orgname");
				String bio = request.getParameter("bio");
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				String photograph = request.getParameter("photograph");
				int type = Integer.parseInt(request.getParameter("type"));
				int viewQuota = Integer.parseInt(request.getParameter("viewQuota"));
				int updateQuota = Integer.parseInt(request.getParameter("updateQuota"));				
				int userId = Integer.parseInt(request.getParameter("userId"));
				User u = MasterGraph.getUser(userId);
				u.update(user, name, country, email, url, orgname, bio, username, password, type, viewQuota, updateQuota, photograph);
				redirect = "cimap.jsp?tab=useradmin";
			} else if(update.equals("addUser2")){
				// add new user to database and to graph
				String name = request.getParameter("name");
				String country = request.getParameter("country");
				String email = request.getParameter("email");
				String url = request.getParameter("url");
				String orgname = request.getParameter("orgname");
				String bio = request.getParameter("bio");
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				String photograph = request.getParameter("photograph");
				int type = Integer.parseInt(request.getParameter("type"));
				
				User newUser = new User(0, username, password, type, name, email, country, bio, orgname, url, photograph, null, null, 0,0,0,0,0,0,0);
				MasterGraph.addNewUser(newUser, user);
				redirect = "cimap.jsp?tab=useradmin";
			}		
		}
    	response.sendRedirect(redirect);
	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
