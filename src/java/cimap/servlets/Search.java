package cimap.servlets;

import java.io.IOException;
import java.util.ArrayList;
//import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.SearchQuery;
import cimap.graph.User;
import cimap.graph.node.Node;
import cimap.graph.node.Theme;



public class Search extends HttpServlet {
	private static final long serialVersionUID = -8951220542957569487L;
	//private static Logger logger = Logger.getLogger(Search.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		if(user!=null && user.isLoggedIn()){
			String query = request.getParameter("query");
			if(query != null){
				String name = request.getParameter("name");
				String type = request.getParameter("type");
				if(type == null)
					type = "All";
				String[] themes = request.getParameterValues("themes");
				ArrayList<Theme> themesList = new ArrayList<Theme>();
				if(themes != null){
					for (int i = 0; i < themes.length; i++) {
						int themeId = Integer.parseInt(themes[i]);
						Theme theme = MasterGraph.getTheme(themeId);
						themesList.add(theme);
					}
				}
				String background = request.getParameter("background");
				String city = request.getParameter("city");
				String state = request.getParameter("state");
				String country = request.getParameter("country");
				SearchQuery searchQuery = new SearchQuery(background,city,country,name,type,state,themesList);
				ArrayList<Node> orgResults= new ArrayList<Node>();
				ArrayList<Node> indResults = new ArrayList<Node>();
				ArrayList<Node> eveResults = new ArrayList<Node>();
				ArrayList<Node> pubResults = new ArrayList<Node>();
				if(type.equals("All") || type.equals("Organisation"))
					orgResults = MasterGraph.searchOrgNodes(searchQuery);
				if(type.equals("All") || type.equals("Individual"))
					indResults = MasterGraph.searchIndNodes(searchQuery);
				if(type.equals("All") || type.equals("Event"))
					eveResults = MasterGraph.searchEveNodes(searchQuery);
				if(type.equals("All") || type.equals("Publication"))
					pubResults = MasterGraph.searchPubNodes(searchQuery);
				session.setAttribute("indSearchResults", indResults);
				session.setAttribute("orgSearchResults", orgResults);
				session.setAttribute("eveSearchResults", eveResults);
				session.setAttribute("pubSearchResults", pubResults);
				session.setAttribute("query", searchQuery);
			} else {
				session.removeAttribute("query");
			}
			String searchResults = "cimap.jsp?tab=search";
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
