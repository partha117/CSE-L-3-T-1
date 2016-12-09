package Database;

import Utility.Room;

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
    private  String dateConverter(String  st)
    {
        String converted;
        String [] temp;
        temp=st.split("-");
        converted=temp[2]+"/"+temp[1]+"/"+temp[0];
        return converted;

    }
    public ArrayList<Room> getRoomList(String sp, String  cap, String ac, String wifi, String pf, String pt, String  df, String  dt)
    {
        ArrayList<Room> room=new ArrayList<>();
        PreparedStatement statement=null;
        String  temp1=dateConverter(df);
        String  temp2=dateConverter(dt);
        if(ac.compareTo("Airconditioned")==0)
        {
            ac="YES";
        }
        else
        {
            ac="NO";
        }
        if(wifi.compareTo("Wifi")==0)
        {
            wifi="YES";
        }
        else
        {
            wifi="NO";
        }


        try {

            System.out.println("<h1>"+sp+cap+ac+wifi+pf+pt+df+dt+"</h1>");
            String  query="SELECT ROOM_NO,SPECALITY,ROOM_COST FROM ROOM WHERE CAPACITY ='"+cap+"' AND SPECALITY ='"+sp+"'AND AIR_CONDITIONER ='"+ac+"' AND WI_FI = '"+wifi+"'  AND STATUS ='VACCANT' AND (" +
                    "ROOM_COST BETWEEN "+pf +
                    " AND "+pt +
                    ")" +
                    "AND ROOM_BOOKING_ID NOT IN (SELECT BOOKING_ID FROM BOOKING WHERE(DATE_FROM = TO_DATE ('"+temp1+"' , 'DD/MM/YYYY')AND DATE_TO = TO_DATE ('"+temp2+"' , 'DD/MM/YYYY'))" +
                    "OR(DATE_FROM BETWEEN TO_DATE ('"+temp1+"' , 'DD/MM/YYYY')AND TO_DATE ('"+temp2+"' , 'DD/MM/YYYY'))OR (DATE_FROM BETWEEN TO_DATE ('"+temp1+"' , 'DD/MM/YYYY')" +
                    "AND TO_DATE ('"+temp2+"' , 'DD/MM/YYYY')))";
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
    public int bookRoom(String df,String  dt,int gid)
    {
        CallableStatement statement=null;
        df=dateConverter(df);
        dt=dateConverter(dt);
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
    public  boolean updateRoom(int bid,int [] room)
    {
        PreparedStatement statement=null;
        String query="UPDATE ROOM SET STATUS= 'PROCESSING', ROOM_BOOKING_ID = "+bid+" WHERE ROOM_NO IN ( ";
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
            if(state==1)
            {
                return true;
            }
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
}

