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
        int room[]=new int[array.size()];
        boolean booked[]=new boolean[array.size()];
        for(int i=0;i<array.size();i++)
        {
            String room_no=request.getParameter(String.valueOf(array.get(i).getRoom_no()));
            if(room_no!=null)
            {
                room[i]=array.get(i).getRoom_no();

            }
        }
        session.setAttribute(sessionDataName,room);
        RequestDispatcher rd=request.getRequestDispatcher("/Guestinfo.jsp");
        rd.forward(request, response);
        /*String  room1=request.getParameter("107");
        String  room2=request.getParameter("069");
        PrintWriter out=response.getWriter();
        out.println("<h1>"+room1+room2+"</h1>");*/






    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
