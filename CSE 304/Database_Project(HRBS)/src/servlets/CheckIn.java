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
 * Created by partha on 15-Dec-16.
 */
@WebServlet(name = "CheckIn",urlPatterns = "/CheckIn.do")
public class CheckIn extends HttpServlet {
    public  static  final String sessionDataName="MessageFromCheckIn";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String task=request.getParameter("Go");
        if(task==null)
        {
            String guestId = request.getParameter("Guest_Id");
            if (guestId != null) {
                DBconnection database = new DBconnection();
                int update = database.changeRoomStatus(guestId);
                PrintWriter out = response.getWriter();
                HttpSession session=request.getSession();
                if (update != 0) {
                    session.setAttribute(sessionDataName," The guest has booked "+update+" room(s).And they are ready");

                } else {
                    session.setAttribute(sessionDataName,"The guest has not booked any room");

                }
                RequestDispatcher rd=request.getRequestDispatcher("/checkin.jsp");
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
                    /*session.removeAttribute(LogIn.sessionDataName1);
                    session.removeAttribute(LogIn.sessionDataName2);
                    session.removeAttribute(LogIn.sessionDataName3);
                    session.removeAttribute(ChangePassword.SessionDataname);*/

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
