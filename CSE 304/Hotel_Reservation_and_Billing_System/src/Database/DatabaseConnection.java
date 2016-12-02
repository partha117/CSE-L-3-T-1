package Database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Created by partha on 02-Dec-16.
 */
public class DatabaseConnection {


    private String DBurl = "jdbc:oracle:thin:@localhost:1521:ORCL";
    private String DBusername = "hr";
    private String DBpassword = "hr";
    private Connection conn = null;
    private  boolean connectionStatus=false;

    public DatabaseConnection() {


        try {
            Class.forName("oracle.jdbc.OracleDriver");
            conn = DriverManager.getConnection(DBurl, DBusername, DBpassword);
            if(conn!=null)
            {
                connectionStatus=true;
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();


        }
        catch (SQLException e)
        {
            e.printStackTrace();

        }

    }

    public boolean isConnectionStatus() {
        return connectionStatus;
    }
    public  void closeConnection()
    {
        if(conn!=null)
        {
            try {
                conn.close();
                connectionStatus = false;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }


    }
    public boolean insertEmployee(String first_name,String last_name,String department,String  designation,String contact,String email)
    {

        PreparedStatement statement= null;
        try {
            statement = conn.prepareStatement("insert into EMPLOYEE values(EMPLOYEE_ID_SEQ.NEXTVAL,?,?,?,?,?,?)");
            statement.setString(1,email);
            statement.setString(2,contact);
            statement.setString(3,first_name);
            statement.setString(4,last_name);
            statement.setString(5,department);
            statement.setString(6,designation);
            int state=statement.executeUpdate();
            if(state==1)
            {
                return  true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;

    }
    public boolean insertGuest(String first_name,String last_name,String address,String  contact,String nid,String passport,String person)
    {

        PreparedStatement statement= null;
        System.out.println("i am here");
        try {
            statement = conn.prepareStatement("insert into GUEST values(Guest_ID_SEQ.NEXTVAL,?,?,?,?,?,?,?)");
            statement.setString(1,first_name);
            statement.setString(2,last_name);
            statement.setString(3,address);
            statement.setString(4,contact);
            statement.setInt(5,Integer.parseInt(person));
            statement.setString(6,passport);
            statement.setString(7,nid);
            System.out.println("It is "+statement);
            int state=statement.executeUpdate();
            if(state==1)
            {
                return  true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;

    }
}
