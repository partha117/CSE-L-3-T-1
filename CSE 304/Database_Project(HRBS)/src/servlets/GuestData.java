package servlets;

import Database.DBconnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by partha on 09-Dec-16.
 */
@WebServlet(name = "GuestData",urlPatterns ="/guestdata.do")
public class GuestData extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String guestFirstName=request.getParameter("FirstName");
        String guestLastName=request.getParameter("LastName");
        String guestAddress=request.getParameter("Address");
        String guestContact=request.getParameter("Contact_No");
        String guestNID=request.getParameter("NID");
        String guestPassport=request.getParameter("Passport");
        String guestMemberNo=request.getParameter("Club_member");
        String guestPerson=request.getParameter("Person");
        PrintWriter out=response.getWriter();




        DBconnection db=new DBconnection();
        int guestId=db.insertGuest(guestFirstName,guestLastName,guestAddress,guestContact,guestNID,guestPassport,guestPerson);
        HttpSession session=request.getSession();
        session.setAttribute("GUEST_ID",guestId);
        String  df= (String) session.getAttribute(RoomSearch.sessionDataName2);
        String dt=(String) session.getAttribute(RoomSearch.sessionDataName3);
        int [] rooms= (int[]) session.getAttribute(Booking.sessionDataName);
        int BOOKINGID=db.bookRoom(df,dt,guestId);
        if(BOOKINGID!=DBconnection.SQL_ERROR)
        {
            if(db.updateRoom(BOOKINGID,rooms))
            {

                out.println("<h1>"+"all right"+"</h1>");
            }
            else
            {
                out.println("<h1>"+"something wrong"+"</h1>");
            }
        }


        db.closeConnection();

    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
