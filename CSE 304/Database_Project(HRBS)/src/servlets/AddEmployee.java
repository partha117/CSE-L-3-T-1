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
 * Created by partha on 16-Dec-16.
 */
@WebServlet(name = "AddEmployee",urlPatterns = "/AddEmployee.do")
public class AddEmployee extends HttpServlet {
    public static  final String sessionDataName="MESSAGE";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        HttpSession session = request.getSession();
        String task=request.getParameter("Go");
        if(task==null)
        {
            String employeeFirstName = request.getParameter("FirstName");
            String employeeLastName = request.getParameter("LastName");
            String employeeDepartment = request.getParameter("Department");
            String employeeDesignation = request.getParameter("Designation");
            String employeeContactNo = request.getParameter("Contact");
            String employeeEmail = request.getParameter("Email");
            String password=request.getParameter("password");
            String message;
            PrintWriter out = response.getWriter();
            DBconnection db = new DBconnection();
            if (db.insertEmployee(employeeFirstName, employeeLastName, employeeDepartment, employeeDesignation, employeeContactNo, employeeEmail,password)) {
                message = "New Employee added";
            } else {
                message = "Something Wrong";
            }
            session.setAttribute(sessionDataName, message);
            RequestDispatcher rd = request.getRequestDispatcher("/employee.jsp");
            rd.forward(request, response);
        }
        else
        {
            String activity=request.getParameter("ACTIVITY");
            if(activity!=null)
            {
                if(activity.compareTo("LOG_OUT")==0)
                {
                    session=request.getSession();
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
