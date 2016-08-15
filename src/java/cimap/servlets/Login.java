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



public class Login extends HttpServlet {

	private static final long serialVersionUID = 885417389847086217L;
	private static Logger logger = Logger.getLogger(Login.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		String username = request.getParameter("username");
		User user = (User)session.getAttribute(username);
    	String loginPage = "cimap.jsp";
    	String startPage = "cimap.jsp?tab=themes";
		if (user == null){
			String password = request.getParameter("password");
			user = getUser(username, password);
			if(user != null){
				session.setAttribute("username", user);
			}
		}
		if(user!=null && user.isLoggedIn()){
        	response.sendRedirect(startPage);
        }else{
        	response.sendRedirect(loginPage);
        }
	}
	
	private User getUser(String username, String password) {
		MasterGraph g = new MasterGraph();
		User user = g.getUserByUsername(username);
		if(user != null && user.login(username, password)){
			return user;
		} else {
			logger.info("invalid login details:" + username + "/" + password );
			return null;
		}
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}
}
