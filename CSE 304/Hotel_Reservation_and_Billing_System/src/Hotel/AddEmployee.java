package Hotel;

import Database.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by partha on 02-Dec-16.
 */
@WebServlet(name = "Addemployee",urlPatterns = "/AddEmployee.do")
public class AddEmployee extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String employeeFirstName=request.getParameter("FirstName");
        String employeeLastName=request.getParameter("LastName");
        String employeeDepartment=request.getParameter("Department");
        String employeeDesignation=request.getParameter("Designation");
        String employeeContactNo=request.getParameter("Contact");
        String  employeeEmail=request.getParameter("Email");
        PrintWriter out=response.getWriter();
        DatabaseConnection db=new DatabaseConnection();
        db.insertEmployee(employeeFirstName,employeeLastName,employeeDepartment,employeeDesignation,employeeContactNo,employeeEmail);
        db.closeConnection();

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
