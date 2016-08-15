package cimap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.User;



public class Themes extends HttpServlet {

	private static final long serialVersionUID = -4347633087602801687L;
	//private static Logger logger = Logger.getLogger(Themes.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		String redirect = "cimap.jsp";
		if(user!=null && user.isLoggedIn()){
			String themeid = request.getParameter("themeid");
			String update = request.getParameter("update");
			redirect = "cimap.jsp?tab=themes";
			if(themeid==null){
				session.removeAttribute("themeid");
			} else {
				session.setAttribute("themeid", themeid);
			}
			if(update!=null)
				session.setAttribute("update", update);
		}
		response.sendRedirect(redirect);

	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
