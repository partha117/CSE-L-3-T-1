package servlets;

import Database.DBconnection;
import Utility.Bill;
import Utility.Facility;
import Utility.Rate;
import Utility.Room;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by partha on 13-Dec-16.
 */
@WebServlet(name = "CalculateBill",urlPatterns = "/CalculateBill.do")
public class CalculateBill extends HttpServlet {

    public  static  final  String sessionDataName="BILL";
    public  static  final  String sessionDataName2="guest_id";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        HttpSession session=request.getSession();
        String task=request.getParameter("Go");
        if(task==null) {
            String status = request.getParameter("Submit");
            if (status == null) {


                String calculate = request.getParameter("Calculate");
                if (calculate != null) {
                    String guestId = request.getParameter("Guest_Id");
                    DBconnection database = new DBconnection();
                    ArrayList<Facility> facilities = database.getAllFacility(Integer.parseInt(guestId));
                    ArrayList<Room> rooms = database.getAllRoom(Integer.parseInt(guestId));
                    String member = database.memberType(Integer.parseInt(guestId));
                    ArrayList<Rate> data=null;
                    if(member!=null)
                    {
                        data=database.getdiscountPolicy(member);
                    }
                    Bill bill = new Bill(facilities, rooms, Integer.parseInt(guestId), member,data);

                    session.setAttribute(sessionDataName, bill);
                    session.setAttribute(sessionDataName2, guestId);
                    database.closeConnection();
                    RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
                    rd.forward(request, response);
                }
            } else {
                String refundable = request.getParameter("refundable");
                if (refundable == null) {
                    refundable = "NO";
                }
                String guest_id = (String) session.getAttribute(sessionDataName2);
                String payment = request.getParameter("Payment Method");
                String amount = request.getParameter("Payment");
                String employee_id = (String) session.getAttribute(LogIn.sessionDataName3);
                DBconnection database = new DBconnection();
                database.updatePayState(guest_id);
                database.insertBill(refundable, guest_id, employee_id, amount, payment);
                database.closeConnection();


            }
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
