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
@WebServlet(name = "ChangePassword",urlPatterns = "/ChangePassword.do")
public class ChangePassword extends HttpServlet {
    public  static  final  String SessionDataname="Message";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        String op=request.getParameter("OldPassword");
        String np=request.getParameter("NewPassword");
        String eid= (String) session.getAttribute(LogIn.sessionDataName3);
        if((op!=null)&&(np!=null)&&(eid!=null))
        {
            DBconnection database=new DBconnection();
            int update=database.changePassword(eid,op,np);
            database.closeConnection();
            if(update!=0)
            {
                session.removeAttribute(LogIn.sessionDataName1);
                session.removeAttribute(LogIn.sessionDataName2);
                session.removeAttribute(LogIn.sessionDataName3);
                session.setAttribute(SessionDataname,"Password has been chaged !!!");
                RequestDispatcher rd=request.getRequestDispatcher("/LogIn.jsp");
                rd.forward(request,response);
            }
            else
            {
                PrintWriter out=response.getWriter();
                out.println("<h1> Something wrong Password is not changed </h1>");
            }


        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
