package servlets;

import Database.DBconnection;
import Utility.Room;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * Created by partha on 08-Dec-16.
 */
@WebServlet(name = "RoomSearch",urlPatterns = "/RoomSearch.do")
public class RoomSearch extends HttpServlet {
    public  static  final String sessionDataName1="Room Data";
    public  static  final String sessionDataName2="Booked From";
    public  static  final String sessionDataName3="Booked To";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String speciality=request.getParameter("Speciality");
        String capacity=request.getParameter("Capacity");
        String ac=request.getParameter("Airconditioned");
        String  wifi=request.getParameter("Wifi");
        String price_from=request.getParameter("From");
        String price_to=request.getParameter("To");
        String  datefrom=request.getParameter("Date_Start");
        String dateto=request.getParameter("Date_To");
        if(wifi==null)
        {
            wifi="NO";
        }

        if(ac==null)
        {
            ac="NO";
        }

        PrintWriter out=response.getWriter();
        //out.println("<h1>"+speciality+capacity+ac+wifi+price_from+price_to+datefrom+dateto+"</h1>");
        HttpSession session = request.getSession();
        session.setAttribute("Booked From",datefrom);
        session.setAttribute("Booked To",dateto);
        DBconnection database=new DBconnection();
        if(database.isConnectionStatus())
        {
           //out.println("<h1>"+"it is on"+"</h1>");
            ArrayList<Room>room=database.getRoomList(speciality,capacity,ac,wifi,price_from,price_to,datefrom,dateto);
            session.setAttribute(sessionDataName1,room);
            session.setAttribute(sessionDataName2,datefrom);
            session.setAttribute(sessionDataName3,dateto);
            RequestDispatcher rd=request.getRequestDispatcher("/Booking.jsp");
            rd.forward(request, response);
            database.closeConnection();
        }
        else
        {
            out.println("<h1>"+"Database is in maintenance .Please try later"+"</h1>");
        }





    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

}
