<%@ page import="servlets.BookingWithFacility" %>
<%@ page import="servlets.Booking" %>
<%@ page import="servlets.GuestData" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 18-Dec-16
  Time: 8:23 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <title>Hotel Managment System</title>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <link href="./css/bootstrap.css" rel="stylesheet">
    <link href="./css/override.css" rel="stylesheet">
</head>

<body style="font-family: Georgia, Serif">
<div class="col-md-5 col-md-offset-2" style="padding-top: 15%">
    <%
        int[] facility = (int[]) session.getAttribute(BookingWithFacility.sessionDataName1);
        session.removeAttribute(BookingWithFacility.sessionDataName1);
        int [] rooms= (int[]) session.getAttribute(Booking.sessionDataName);
        session.removeAttribute(Booking.sessionDataName);
        int Guest_id= (Integer) session.getAttribute(GuestData.sessionDataName);
        int roomnum=0;
        int facilitynum=0;
        if((rooms==null)&&(facility==null))
        {
            RequestDispatcher rd=request.getRequestDispatcher("/searchRoom.jsp");
            rd.forward(request,response);
        }
        else
        {
            if (rooms != null) {
                roomnum = rooms.length;
            }
            if (facility != null) {
                facilitynum = facility.length;
            }
        }
    %>
    <span><h2 class="text-success oneline"> Congratulation !!! You have just booked
        <%
            if(roomnum!=0)
            {
                out.print(roomnum+" room(s) ");
            }
            if(facilitynum!=0)
            {
                out.println(facilitynum+" facility");
            }


        %></h2></span>

    <h3><span class="col-md-offset-7 text-center" >Your</span></h3>
    <h1><span class="col-md-offset-5 text-center text-success" >Guest id is
        <%
            out.print(Guest_id);
        %>
        </span></h1>
    <h3><span class="col-md-offset-3 text-center oneline" >You need that guest id when you check in</span></h3>

</div>


</body>
</html>