package servlets;

import Database.DBconnection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by partha on 13-Dec-16.
 */
@WebServlet(name = "LogIn",urlPatterns = "/LogIn.do")
public class LogIn extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userName=request.getParameter("Username");
        String  password=request.getParameter("Password");
        DBconnection database=new DBconnection();

        String designation=database.getDesignation(userName,password);
        if(designation.compareTo(String.valueOf(DBconnection.SQL_ERROR))!=0)
        {
            if(designation.compareTo("ACCOUNTANT")==0)
            {
                RequestDispatcher rd=request.getRequestDispatcher("/index.jsp");
                rd.forward(request,response);
            }
            else if(designation.compareTo("RECEPTIONIST")==0)
            {
                RequestDispatcher rd=request.getRequestDispatcher("/checkin.html");
                rd.forward(request,response);
            }
            else if(designation.compareTo("MAINTENANCE MANAGER")==0)
            {

            }
        }


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
