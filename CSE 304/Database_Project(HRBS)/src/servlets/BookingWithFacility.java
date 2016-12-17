package servlets;

import Utility.Facility;
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
@WebServlet(name = "BookingWithFacility",urlPatterns = "/BookingWithFacility.do")
public class BookingWithFacility extends HttpServlet {
    public  static  final String sessionDataName1="FACILITY_CHECKED";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        ArrayList<Facility> array= (ArrayList<Facility>) session.getAttribute(WithFacility.sessionDataName2);

            int facility[] = new int[array.size()];
            int k = 0;
            for (int i = 0; i < array.size(); i++) {
                String facility_id = request.getParameter(String.valueOf(array.get(i).getFacility_id()));
                if (facility_id != null) {
                    facility[k] = Integer.parseInt(array.get(i).getFacility_id());
                    k++;

                }
            }
            int nFacility[] = new int[k];
            for (int j = 0; j < k; j++) {
                nFacility[j] = facility[j];
            }
            if(nFacility.length!=0) {

                session.setAttribute(sessionDataName1, nFacility);
                RequestDispatcher rd = request.getRequestDispatcher("/Guestinfo.jsp");
                rd.forward(request, response);
            }
            else
            {

                RequestDispatcher rd = request.getRequestDispatcher("/BookingFacility.jsp");
                rd.forward(request, response);
            }



    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
