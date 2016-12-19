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

/**
 * Created by partha on 13-Dec-16.
 */
@WebServlet(name = "LogIn",urlPatterns = "/LogIn.do")
public class LogIn extends HttpServlet {


    public  static  final  String sessionDataName1="LoggedInAs";
    public  static  final  String sessionDataName2="designation";
    public  static  final  String sessionDataName3="Employee id";
    public  static  final  String sessionDataName4="Alert from Log in";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userName=request.getParameter("Username");
        String  password=request.getParameter("Password");
        DBconnection database=new DBconnection();

        String designation=database.getDesignation(userName,password);
        String  name=database.getName(userName,password);
        HttpSession session=request.getSession();
        if(designation.compareTo(String.valueOf(DBconnection.SQL_ERROR))!=0)
        {
            session.setAttribute(sessionDataName3,userName);
            if(designation.toUpperCase().compareTo("ACCOUNTANT")==0)
            {
                session.setAttribute(sessionDataName1,name);
                session.setAttribute(sessionDataName2,designation);
                RequestDispatcher rd=request.getRequestDispatcher("/index.jsp");
                rd.forward(request,response);
            }
            else if(designation.toUpperCase().compareTo("RECEPTIONIST")==0)
            {
                session.setAttribute(sessionDataName1,name);
                session.setAttribute(sessionDataName2,designation);
                RequestDispatcher rd=request.getRequestDispatcher("/checkin.jsp");
                rd.forward(request,response);
            }
            else if(designation.toUpperCase().compareTo("MAINTENANCE MANAGER")==0)
            {

            }
            else if(designation.toUpperCase().compareTo("MANAGER")==0)
            {
                session.setAttribute(sessionDataName1,name);
                session.setAttribute(sessionDataName2,designation);
                RequestDispatcher rd=request.getRequestDispatcher("/employee.jsp");
                rd.forward(request,response);

            }
        }
        else
        {
            session.setAttribute(sessionDataName4,"!!! The username or password you have entered is not correct !!!");
            RequestDispatcher rd=request.getRequestDispatcher("/LogIn.jsp");
            rd.forward(request,response
            );
        }


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
