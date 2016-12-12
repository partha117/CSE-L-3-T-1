<%@ page import="servlets.WithFacility" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 12-Dec-16
  Time: 7:50 PM
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
<form method ="post"  action="WithFacility.do">
    <div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
        <div class="row">
            <div class="col-md-6">
                <h3>Book Facility</h3>
            </div>


            <div class="col-md-1 col-md-offset-1">
                Date
            </div>


            <div class="col-md-4">
                <input class="col-md-11 simpleinput" name="Date" type="date">
            </div>
        </div>
        <br>


        <div style="padding-left: 20px">
            <div class="row">
                <div class="col-md-2">
                    Facility
                </div>


                <div class="col-md-4">
                    <select name="Facility">
                        <option name="Conference room" value="Conference room">Conference room</option>
                        <option name="Restaurant" value="Restaurant">Restaurant</option>
                    </select>
                </div>
            </div>
            <br>

            <div class="row">
                <div class="col-md-2">
                    Booking Date
                </div>


                <div class="col-md-4">
                    <input class="col-md-11 simpleinput" name="Booking_Date" type="date">
                </div>
            </div>
            <br>
        </div>

        <div class="row" style="margin: 20px 0px">
            <div class="col-md-12" style="border: 1px solid gainsboro">
            </div>
        </div>
        <br>
        <div class="col-md-5">
            <%
                String st= (String) session.getAttribute(WithFacility.sessionDataName1);
                if(st!=null)
                {
                    out.println("<h1> Facility is not available on that day</h1>");
                }
            %>

        </div>
        <div class="col-md-7">
            <button class="btn add-btn" style="float: right" >Submit</button>
        </div>
    </div>
</form>
</body>
</html>