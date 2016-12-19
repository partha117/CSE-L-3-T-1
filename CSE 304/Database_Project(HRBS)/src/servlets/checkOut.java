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
    public  static  final String sessionDataName="MessageFromCheckOut";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String task=request.getParameter("Go");

        if(task==null)
        {
            String guestId = request.getParameter("Guest_Id");
            if (guestId != null) {
                DBconnection database = new DBconnection();
                int bill = database.getBillStatus(guestId);
                PrintWriter out = response.getWriter();
                HttpSession session=request.getSession();
                if (bill != 0) {
                    session.setAttribute(sessionDataName,"Guest "+guestId+" has "+bill+" pending payment");

                } else {
                    database.setRoomStatus(guestId);
                    session.setAttribute(sessionDataName,"Guest "+guestId+" is ready for checkout");
                }
                RequestDispatcher rd=request.getRequestDispatcher("/Checkout.jsp");
                rd.forward(request,response);
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
