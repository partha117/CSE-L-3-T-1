<%@ page import="java.util.ArrayList" %>
<%@ page import="Utility.Facility" %>
<%@ page import="servlets.WithFacility" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 13-Dec-16
  Time: 12:46 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 08-Dec-16
  Time: 11:08 PM
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
<form method ="post"  action="BookingWithFacility.do">
<div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
    <div class="row">
        <div class="col-md-6">
            <h3> Room Booking</h3>
        </div>
    </div>
    <br>


    <div style="padding-left: 20px">
        <div class="row">
            <div class="col-md-6">
                <h4> Available Facilities </h4>
            </div>
            <table class="table table-bordered">
                <thead>
                <tr>
                    <th class="col-md-1">Book</th>

                    <th class="col-md-3">Facility Type</th>

                    <th class="col-md-5">Feature</th>

                    <th class="col-md-3">Price</th>
                </tr>
                </thead>


                <tbody>
                <%
                    ArrayList<Facility> arrayList= (ArrayList<Facility>) session.getAttribute(WithFacility.sessionDataName2);
                    for(int i=0;i<arrayList.size();i++)
                    {
                        out.println(arrayList.get(i).getHtml());
                    }

                %>

                </tbody>
            </table>
        </div>
        <br>

        <div class="row">
            <div class="col-md-2">

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
        <button class="btn add-btn" style="float: right">Submit</button>
    </div>
</div>
</form>
</body>
</html>