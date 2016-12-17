package servlets;

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
@WebServlet(name = "Booking",urlPatterns = "/Booking.do")
public class Booking extends HttpServlet {
    public  static  final String sessionDataName="Booked Room";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {



        HttpSession session = request.getSession();
        ArrayList<Room> array= (ArrayList<Room>) session.getAttribute("Room Data");

            int room[] = new int[array.size()];
            int k = 0;
            for (int i = 0; i < array.size(); i++) {
                String room_no = request.getParameter(String.valueOf(array.get(i).getRoom_no()));
                if (room_no != null) {
                    room[k] = array.get(i).getRoom_no();
                    k++;

                }
            }
            int nRoom[] = new int[k];
            for (int j = 0; j < k; j++) {
                nRoom[j] = room[j];
            }
            session.setAttribute(sessionDataName, nRoom);
            String st = request.getParameter("Facility");
            if (st != null) {

                RequestDispatcher rd = request.getRequestDispatcher("/bookFacility.jsp");
                rd.forward(request, response);
            }
            if(nRoom.length!=0) {
                RequestDispatcher rd = request.getRequestDispatcher("/Guestinfo.jsp");
                rd.forward(request, response);
            }


        else
        {
            RequestDispatcher rd = request.getRequestDispatcher("/Booking.jsp");
            rd.forward(request, response);
        }
        /*String  room1=request.getParameter("107");
        String  room2=request.getParameter("069");
        PrintWriter out=response.getWriter();
        out.println("<h1>"+room1+room2+"</h1>");*/






    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
