package cimap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cimap.graph.MasterGraph;
import cimap.graph.User;
import cimap.graph.node.Node;



public class JSON extends HttpServlet {
	private static final long serialVersionUID = -778682746871230817L;

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("username");
		if(user!=null && user.isLoggedIn()){
			int id = Integer.parseInt(request.getParameter("id"));
			Node node = MasterGraph.getNode(id);
			String layers = request.getParameter("layers");
			Boolean[] temp=node.getLayers();
			Boolean[] layers_booleans=null;
			if(layers!=null){
				String[] layers_strings = request.getParameter("layers").split(",");
				layers_booleans = new Boolean[layers_strings.length];
				for(int i=0;i<layers_booleans.length;i++){
					if(layers_strings[i].equals("0"))
						layers_booleans[i]=false;
					else
						layers_booleans[i]=true;
				}
			}	
			node.setLayers(layers_booleans);
			if(node.toJSON().equals("empty"))
				node.setLayers(temp);
        	// change user argument to null here if you want to ignore graph traversal in view count 
			user.getGraph().setSelected(user, node);
			String graphPage = "rgraph.jsp";
        	response.sendRedirect(graphPage);

		}else{
        	String loginPage = "cimap.jsp";
        	response.sendRedirect(loginPage);
        }

	}
	

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException{
		doGet(request, response);
	}

}
