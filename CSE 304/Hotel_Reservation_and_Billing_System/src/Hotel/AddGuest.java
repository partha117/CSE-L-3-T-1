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
@WebServlet(name = "AddGuest",urlPatterns = "/AddGuest.do")
public class AddGuest extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String guestFirstName=request.getParameter("FirstName");
        String guestLastName=request.getParameter("LastName");
        String guestAddress=request.getParameter("Address");
        String guestContact=request.getParameter("Contact_No");
        String guestNID=request.getParameter("NID");
        String guestPassport=request.getParameter("Passport");
        String guestMemberNo=request.getParameter("Club_member");
        String guestPerson=request.getParameter("Person");
        PrintWriter out=response.getWriter();
        out.println("<h1>"+guestFirstName+guestLastName+guestAddress+guestContact+guestNID+guestPassport+guestMemberNo+guestPerson+"</h1>");

        DatabaseConnection db=new DatabaseConnection();
        System.out.println("It is "+db.insertGuest(guestFirstName,guestLastName,guestAddress,guestContact,guestNID,guestPassport,guestPerson));
        db.closeConnection();

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {



    }
}
