package Database;

import Utility.Facility;
import Utility.Room;
import com.sun.org.apache.regexp.internal.RE;

import java.sql.*;
import java.sql.Date;
import java.util.*;

/**
 * Created by partha on 08-Dec-16.
 */
public class DBconnection {


    private String DBurl = "jdbc:oracle:thin:@localhost:1521:ORCL";
    private String DBusername = "project";
    private String DBpassword = "304";
    private Connection conn = null;
    private  boolean connectionStatus=false;
    public  static  final int SQL_ERROR=-1111;

    public DBconnection() {


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
    public ArrayList<Facility> getFacility(String facility, String  date)
    {
        PreparedStatement statement=null;
        ArrayList<Facility> arrayList=new ArrayList<>();

            String query="SELECT FACILITY_ID,PRICE,SPECIALITY FROM FACILITY WHERE FACILITY_TYPE = '"+facility+
                    "'AND FACILITY_ID NOT IN (SELECT FACILITY_ID FROM FACILITY_BOOKING WHERE BOOKING_ID IN(SELECT  BOOKING_ID FROM BOOKING WHERE DATE_FROM =TO_DATE('"+date+"','YYYY-MM-DD')))";

        try {
            statement=conn.prepareStatement(query);
            System.out.println("it is");
            ResultSet rs=statement.executeQuery();
            for(int i=0;rs.next();i++)
            {
                arrayList.add(new Facility(rs.getString("FACILITY_ID"),facility,rs.getString("SPECIALITY"),rs.getDouble("PRICE")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  arrayList;

    }

    public ArrayList<Room> getRoomList(String sp, String  cap, String ac, String wifi, String pf, String pt, String  df, String  dt)
    {
        ArrayList<Room> room=new ArrayList<>();
        PreparedStatement statement=null;




        try {

            System.out.println("<h1>"+sp+cap+ac+wifi+pf+pt+df+dt+"</h1>");
            String  query="SELECT ROOM_NO,SPECALITY,ROOM_COST FROM ROOM WHERE CAPACITY ='"+cap+"' AND SPECALITY ='"+sp+"'AND AIR_CONDITIONER ='"+ac+"' AND WI_FI = '"+wifi+"'  AND (" +
                    "ROOM_COST BETWEEN "+pf +
                    " AND "+pt +
                    ")" +
                    "AND ROOM_NO NOT IN (SELECT  ROOM_NO FROM ROOM_BOOKING WHERE BOOKING_ID IN(SELECT BOOKING_ID FROM BOOKING WHERE(DATE_FROM = TO_DATE ('"+df+"' , 'YYYY-MM-DD')AND DATE_TO = TO_DATE ('"+dt+"' , 'YYYY-MM-DD'))" +
                    "OR(DATE_FROM BETWEEN TO_DATE ('"+df+"' , 'YYYY-MM-DD')AND TO_DATE ('"+dt+"' , 'YYYY-MM-DD'))OR (DATE_TO BETWEEN TO_DATE ('"+df+"' , 'YYYY-MM-DD')" +
                    "AND TO_DATE ('"+dt+"' , 'YYYY-MM-DD'))))";
            statement=conn.prepareStatement(query);


            System.out.println("it is");
            ResultSet rs=statement.executeQuery();

            for(int i=0;rs.next();i++)
            {
                room.add(new Room(rs.getString("SPECALITY"),rs.getDouble("ROOM_COST"),rs.getInt("ROOM_NO")));
            }
            room.add(new Room(rs.getString("SPECALITY"),rs.getDouble("ROOM_COST"),rs.getInt("ROOM_NO")));


        } catch (SQLException e) {
            e.printStackTrace();
        }
        return room;


    }
    public  int bookFacility(String df,int gid)
    {
        CallableStatement statement=null;

        int bid=0;

        try {

            String sql = "{ ? = call INSERT_BOOKING_FACILITY(?,?) }";
            statement = conn.prepareCall(sql);
            statement.setString(2,df);
            statement.setInt(3,gid);
            statement.registerOutParameter(1, java.sql.Types.INTEGER);
            statement.executeUpdate();
            bid=statement.getInt(1);
            return  bid;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  SQL_ERROR;

    }
    public  boolean updateFacilityBook(int []facility,long facility_booking_id)
    {

        PreparedStatement statement=null;
        /*String query="UPDATE FACILITY SET  FACILITY_BOOKING_ID = "+facility_booking_id+",PAY_STATE='PENDING' WHERE FACILITY_ID= "+facility_id;

        try {
            statement=conn.prepareStatement(query);
            int state=statement.executeUpdate();
            if(state==1)
            {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;*/
        /*String query="UPDATE FACILITY SET  PAY_STATE='PENDING' WHERE FACILITY_ID IN ( ";
        int i=0;
        for( i=0;i<facility.length;i++)
        {
            query+=facility[i]+",";
        }
        if(i!=0)
        {
            query = query.substring(0, query.length() - 1);
        }
        query+=")";*/

        try {
           /* statement=conn.prepareStatement(query);
            int state=statement.executeUpdate();*/

            for (int j = 0; j < facility.length; j++) {
                String sql = "INSERT INTO FACILITY_BOOKING (FACILITY_BOOKING_ID,FACILITY_ID,BOOKING_ID,PAY_STATE) VALUES (FACILITY_BOOKING_ID_SEQ.NEXTVAL," + facility[j] + "," + facility_booking_id + ",'PENDING')";
                statement = conn.prepareStatement(sql);
                statement.executeUpdate();


            }
            return  true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;

    }
    public int bookRoom(String df,String  dt,int gid)
    {
        CallableStatement statement=null;

        int bid=0;

        try {

            String sql = "{ ? = call INSERT_BOOKING(?,?,?) }";
            statement = conn.prepareCall(sql);
            statement.setString(2,df);
            statement.setString(3,dt);
            statement.setInt(4,gid);
            statement.registerOutParameter(1, java.sql.Types.INTEGER);
            statement.executeUpdate();
            bid=statement.getInt(1);
            return  bid;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  SQL_ERROR;

    }
    public  boolean updateRoomBook(int bid,int [] room)
    {
        PreparedStatement statement=null;
        String query="UPDATE ROOM SET STATUS= 'PROCESSING'  WHERE ROOM_NO IN ( ";
        int i=0;
        for( i=0;i<room.length;i++)
        {
            query+=room[i]+",";
        }
        if(i!=0)
        {
            query = query.substring(0, query.length() - 1);
        }
        query+=")";

        try {
            statement=conn.prepareStatement(query);
            int state=statement.executeUpdate();

                for (int j = 0; j < room.length; j++) {
                    String sql = "INSERT INTO ROOM_BOOKING (ROOM_BOOKING_ID,ROOM_NO,BOOKING_ID,PAY_STATE) VALUES (ROOM_BOOKING_ID_SEQ.NEXTVAL," + room[j] + "," + bid + ",'PENDING')";
                    statement = conn.prepareStatement(sql);
                    statement.executeUpdate();


            }
            return  true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public int insertGuest(String first_name,String last_name,String address,String  contact,String nid,String passport,String person)
    {

        CallableStatement statement= null;
        int gid=0;

        System.out.println("i am here");
        try {

            String sql = "{ ? = call INSERT_GUEST(?,?,?,?,?,?,?) }";
             statement = conn.prepareCall(sql);
            statement.setString(2,first_name);
            statement.setString(3,last_name);
            statement.setString(4,address);
            statement.setString(5,contact);
            statement.setInt(6, Integer.parseInt(person));
            statement.setString(7,passport);
            statement.setString(8,nid);
            statement.registerOutParameter(1, java.sql.Types.INTEGER);
            statement.executeUpdate();
            gid=statement.getInt(1);



            //System.out.println("It is state "+state);

            return gid;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return SQL_ERROR;

    }
    public String getDesignation(String  username,String  password)
    {
        PreparedStatement statement=null;
        String designation= String.valueOf(SQL_ERROR);


        String sql="SELECT DESIGNATION FROM EMPLOYEE WHERE EMPLOYEE_ID="+username+" AND PASSWORD = "+password;
        try {
            statement=conn.prepareStatement(sql);
            ResultSet rs=statement.executeQuery();

            if(rs.next())
            {
                designation=rs.getString("DESIGNATION");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  designation;
    }
}

