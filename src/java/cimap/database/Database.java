package cimap.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.postgresql.jdbc3.Jdbc3PoolingDataSource;

import cimap.graph.MasterGraph;
import cimap.graph.User;


public class Database {

	private static Jdbc3PoolingDataSource source;
	private static Logger logger = Logger.getLogger(Database.class.getName());
	
	public static Connection getConnection() throws SQLException{
		if(source==null){
			ResourceBundle database = ResourceBundle.getBundle("database");
			source = new Jdbc3PoolingDataSource();
			source.setDataSourceName(database.getString("dataSourceName"));
			source.setServerName(database.getString("serverName"));
			source.setDatabaseName(database.getString("databaseName"));
			source.setUser(database.getString("username"));
			source.setPassword(database.getString("password"));
			source.setMaxConnections(Integer.parseInt(database.getString("maxConnections")));
			/*source.setDataSourceName("CIMAP-DB");
			source.setServerName("localhost");
			source.setDatabaseName("crid_cimap");
			source.setUser("crid");
			source.setPassword("sokoto");
			source.setMaxConnections(10);
			*/
			logger.log(Level.INFO, "Connection pool created");
		}
		return source.getConnection();
	}
	
	public static void main(String[] args){
		
		Connection con = null;
		try {
		    logger.log(Level.INFO, "requesting connection");
			con = getConnection();
			logger.log(Level.INFO, "creating graph");
			MasterGraph g = new MasterGraph();
			User u = g.getUserByUsername("miqdad");
			u.login("miqdad", "pa55word");
			logger.log(Level.INFO, "Last login: " + u.getLastLogin() + " Login count: " + u.getLoginCount() );
		} catch (SQLException e) {
		    logger.log(Level.INFO, "oops!!!" + e.getLocalizedMessage());
		} finally {
		    if (con != null) {
			    logger.log(Level.INFO, "returning connection");
		        try { con.close(); } catch (SQLException e) {}
		    }
		}


	}
}
