package servlets;

import Database.DBconnection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by partha on 18-Dec-16.
 */
@WebServlet(name = "checkOut",urlPatterns = "/checkout.do")
public class checkOut extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String task=request.getParameter("Go");

        if(task==null)
        {
            String guestId = request.getParameter("Guest_Id");
            if (guestId != null) {
                DBconnection database = new DBconnection();
                int bill = database.getBillStatus(guestId);
                PrintWriter out = response.getWriter();
                if (bill != 0) {
                    out.println("<h1> The guest has  " + bill + "payment pending" + "</h1>");
                } else {
                    database.setRoomStatus(guestId);
                    out.println("<h1> The guest is ready for checkout" +
                            "" + "</h1>");
                }
            }
        }
        else
        {
            String activity=request.getParameter("ACTIVITY");
            if(activity!=null)
            {
                if(activity.compareTo("LOG_OUT")==0)
                {
                    HttpSession session=request.getSession();
                    session.invalidate();
                    RequestDispatcher rd=request.getRequestDispatcher("/LogIn.jsp");
                    rd.forward(request,response);
                }
                else if(activity.compareTo("CHANGE_PASSWORD")==0)
                {
                    RequestDispatcher rd=request.getRequestDispatcher("/ChangePassword.jsp");
                    rd.forward(request,response);
                }
            }
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
