package cimap.servlets;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.Path;
import cimap.graph.SearchPathsQuery;
import cimap.graph.User;
import cimap.graph.node.Node;



public class SearchPaths extends HttpServlet {
	private static final long serialVersionUID = -8951220542957569487L;
	//private static Logger logger = Logger.getLogger(SearchPaths.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		if(user!=null && user.isLoggedIn()){
			String query = request.getParameter("pathQuery");
			if(query != null){
				Node startNode = MasterGraph.getNode(Integer.parseInt(request.getParameter("startNode")));
				Node endNode = MasterGraph.getNode(Integer.parseInt(request.getParameter("endNode")));
				int maxLength = Integer.parseInt(request.getParameter("maxLength"));
				SearchPathsQuery searchPathsQuery = new SearchPathsQuery(startNode,endNode, maxLength);
				ArrayList<Path> paths = MasterGraph.searchPaths(searchPathsQuery);
				session.setAttribute("searchPathsResults", paths);
				session.setAttribute("pathQuery", searchPathsQuery);
			} else {
				session.removeAttribute("pathQuery");
			}
			String searchResults = "cimap.jsp?tab=searchpaths";
        	response.sendRedirect(searchResults);
		}else{
        	String loginPage = "cimap.jsp";
        	response.sendRedirect(loginPage);
        }

	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
