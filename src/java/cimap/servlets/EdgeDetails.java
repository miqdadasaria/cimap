package cimap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.User;



public class EdgeDetails extends HttpServlet {
	private static final long serialVersionUID = 4621046344164542262L;

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		if(user!=null && user.isLoggedIn()){
			int edgeId = Integer.parseInt(request.getParameter("edgeId"));
			if(user.getGraph().getSelectedEdge() == null || user.getGraph().getSelectedEdge().getId() != edgeId){
				user.getGraph().setSelectedEdge(MasterGraph.getEdge(edgeId));
			}
			String update = request.getParameter("update");
			if(update != null)
				session.setAttribute("update", update);
        	response.sendRedirect("cimap.jsp?tab=nodedetails");
		}else{
        	String loginPage = "cimap.jsp";
        	response.sendRedirect(loginPage);
        }
	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}
}
