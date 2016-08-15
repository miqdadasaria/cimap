package cimap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.User;

public class NodeDetails extends HttpServlet {
	private static final long serialVersionUID = -4066675292092360927L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession session = request.getSession(true);
		User user = (User) session.getAttribute("username");
		if (user != null && user.isLoggedIn()) {
			String id = request.getParameter("nodeId");
			if (id != null) {
				int nodeId = Integer.parseInt(id);
				if (user.getGraph().getSelected() == null || user.getGraph().getSelected().getId() != nodeId) {
					user.getGraph().setSelected(user, MasterGraph.getNode(nodeId));
				}
			}
			String nodeDetails = "cimap.jsp?tab=nodedetails";
			response.sendRedirect(nodeDetails);
		} else {
			String loginPage = "cimap.jsp";
			response.sendRedirect(loginPage);
		}

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doGet(request, response);
	}
}
