package cimap.servlets;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.User;
import cimap.graph.edge.Edge;
import cimap.graph.edge.EdgeType;



public class AddOrUpdateEdge extends HttpServlet {
	private static final long serialVersionUID = -6781206395143355036L;


	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		String redirect = "cimap.jsp";
		if(user!=null && user.isLoggedIn()){
			String update = request.getParameter("update");
				Edge edge = user.getGraph().getSelectedEdge();
				
				DateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
				if(update.equals("updateEdge")){
					int type = Integer.parseInt(request.getParameter("edgeType"));
					EdgeType edgeType = MasterGraph.getEdgeType(type);
					String details = request.getParameter("details");
					String startDateStr = request.getParameter("startDate");
					String endDateStr = request.getParameter("endDate");
					Date startDate = null;
					Date endDate = null;
					
					if(startDateStr != null){
						try {
							startDate = fmt.parse(startDateStr);
						} catch (ParseException e) {}
					}
					if(endDateStr != null){
						try {
							endDate = fmt.parse(endDateStr);
						} catch (ParseException e) {}
					}
					edge.update(user, edgeType, startDate, endDate, details);
					redirect="EdgeDetails?edgeId="+edge.getId();
				} else if(update.equals("deleteEdge")){
					MasterGraph.deleteEdge(edge, user);
					redirect = "cimap.jsp?tab=nodedetails";
				} else if(update.equals("addEdge")){
					String otherNodeType = request.getParameter("otherNodeType");
					if(otherNodeType != null)
						session.setAttribute("otherNodeType", otherNodeType);
					session.setAttribute("update", "addEdge");
					redirect = "cimap.jsp?tab=nodedetails";
				}

		}
    	response.sendRedirect(redirect);

	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
