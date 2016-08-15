package cimap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.User;



public class AddNodeDetail extends HttpServlet {
	private static final long serialVersionUID = 8736553820662816872L;
	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		if(user!=null && user.isLoggedIn()){
			String detail = request.getParameter("detail");
        	String updatePage = "cimap.jsp?tab=nodedetails";
        	if(detail.equals("general")){
        		session.setAttribute("update", "updateNode");        		
        	} else if(detail.equals("theme")){
        		session.setAttribute("update", "nodeTheme");
          	} else if(detail.equals("news")){
        		session.setAttribute("update", "nodeNews");
        	}  else if(detail.equals("node")){
        		session.setAttribute("update", "addNode");
        	}
        	response.sendRedirect(updatePage);
        	
		}else{
        	String loginPage = "cimap.jsp";
        	response.sendRedirect(loginPage);
        }

	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
