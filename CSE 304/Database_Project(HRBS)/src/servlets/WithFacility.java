package servlets;

import Database.DBconnection;
import Utility.Facility;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.util.ArrayList;

/**
 * Created by partha on 12-Dec-16.
 */
@WebServlet(name = "WithFacility",urlPatterns ="/WithFacility.do")
public class WithFacility extends HttpServlet {
    public  static  final String sessionDataName1="Not Available";
    public  static  final String sessionDataName2="Facilities";
    public  static  final String sessionDataName3="Facility_Date";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

           String date=request.getParameter("Booking_Date");
        String facility=request.getParameter("Facility");
        HttpSession session=request.getSession();
        if(date!=null)
        {
            DBconnection database=new DBconnection();
            ArrayList<Facility> facility_id=database.getFacility(facility,date);
            if(facility_id.size()!=0)
            {

                session.setAttribute(sessionDataName2,facility_id);
                session.setAttribute(sessionDataName3,date);
                RequestDispatcher rd=request.getRequestDispatcher("/BookingFacility.jsp");
                rd.forward(request,response);
            }
            else
            {
                session.setAttribute(sessionDataName1,"Not Available");
                RequestDispatcher rd=request.getRequestDispatcher("/bookFacility.jsp");
                rd.forward(request,response);

            }




        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
