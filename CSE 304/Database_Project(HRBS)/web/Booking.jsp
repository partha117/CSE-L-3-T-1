<%@ page import="java.util.ArrayList" %>
<%@ page import="Utility.Room" %>
<%@ page import="servlets.RoomSearch" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 08-Dec-16
  Time: 11:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<html lang="en">
<head>
    <title>Hotel Managment System</title>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <link href="./css/bootstrap.css" rel="stylesheet">
    <link href="./css/override.css" rel="stylesheet">
</head>

<body style="font-family: Georgia, Serif">
<form method ="post"  action="Booking.do">
<div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
    <div class="row">
        <div class="col-md-6">
            <h3> Room Booking</h3>
        </div>
    </div>
    <br>




       <%

           ArrayList<Room>array= (ArrayList<Room>) session.getAttribute(RoomSearch.sessionDataName1);
           if((array!=null)&&(array.size()!=0))

           {
               out.println("<div style=\"padding-left: 20px\">\n" +
                       "        <div class=\"row\">\n" +
                       "            <div class=\"col-md-6\">\n" +
                       "                <h4> Available Rooms </h4>\n" +
                       "            </div>");

               out.println("<div class=\"row\">\n" +
                       "            <div class=\"col-md-6\">\n" +
                       "                <h4> Available Rooms </h4>\n" +
                       "            </div>\n<table class=\"table table-bordered\">\n" +
                       "                <thead>\n" +
                       "                <tr>\n" +
                       "                    <th class=\"col-md-1\">Book</th>\n" +
                       "\n" +
                       "                    <th class=\"col-md-3\">Room No</th>\n" +
                       "\n" +
                       "                    <th class=\"col-md-5\">Feature</th>\n" +
                       "\n" +
                       "                    <th class=\"col-md-3\">Price</th>\n" +
                       "                </tr>\n" +
                       "                </thead>\n" +
                       "\n" +
                       "\n" +
                       "                <tbody>");





               for (int i = 0; i < array.size(); i++) {
                   out.println(array.get(i).gethtml());
               }
               out.println(" </tbody>\n" +
                       "            </table>");

           }
           else
           {
               out.println("<h1> No room available according to your criteria</h1>");
           }
       %>


        </div>
        <br>

        <div class="row">
            <div class="col-md-2">

            </div>


            <div class="col-md-3">

            </div>

            <div class="col-md-2 col-md-offset-1">

            </div>


            <div class="col-md-3">

            </div>
        </div>
        <br>
    </div>


    <br>
    <div class="row" style="margin: 20px 0px">
        <div class="col-md-12" style="border: 1px solid gainsboro">
        </div>
    </div>
    <br>


    <div class="col-md-7">
        <%
            if((array!=null)&&(array.size()!=0))
            {
                out.println("<button class=\"btn add-btn\" style=\"float: right\">Submit</button> <input class=\"col-md-3 btn add-btn\"  type=\"submit\" value=\"Facility\" name=\"Facility\">");
            }
            else
            {
                out.println("<button class=\"btn add-btn\" style=\"float: right\"><a href=\"searchRoom.jsp\">Go BAck</a></button>");
            }

        %>
    </div>
</div>
</form>
</body>
</html>