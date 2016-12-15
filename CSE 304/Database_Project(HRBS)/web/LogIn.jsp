<%@ page import="servlets.LogIn" %>
<%@ page import="servlets.ChangePassword" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 13-Dec-16
  Time: 12:50 PM
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
<form method="post" action="LogIn.do">




    <div class="col-md-5 text-center" style="padding-top: 15%">
        <h2> Hotel Management System </h2>
        <p> Award winning hotel management system</p>
    </div>
    <div class="col-md-6" style="margin-top: 12%; margin-bottom: 10%">
        <div class="row">
            <div class="col-md-6">
                <h3>User Login</h3>
            </div>
        </div>


            <%
                String  name= (String) session.getAttribute(LogIn.sessionDataName1);
                String message=(String )session.getAttribute(ChangePassword.SessionDataname);
                if(name!=null)
                {
                    String designation= (String) session.getAttribute(LogIn.sessionDataName2);
                    if(designation.compareTo("ACCOUNTANT")==0)
                    {
                        RequestDispatcher rd=request.getRequestDispatcher("/index.jsp");
                        rd.forward(request,response);
                    }
                    else if(designation.compareTo("RECEPTIONIST")==0)
                    {
                        RequestDispatcher rd=request.getRequestDispatcher("/checkin.jsp");
                        rd.forward(request,response);
                    }
                    else if(designation.compareTo("MAINTENANCE MANAGER")==0)
                    {

                    }
                }
                if(message!=null)
                {
                    out.println("<h3>"+message+"</h3>");
                }

            %>
        <div class="row">

            <div class="col-md-2 col-md-offset-2">
                Username
            </div>


            <div class="col-md-6">
                <input class="col-md-11 simpleinput" name="Username" type="text">
            </div>
        </div>
        <br>


        <div class="row">
            <div class="col-md-2 col-md-offset-2">
                Password
            </div>


            <div class="col-md-6">
                <input class="col-md-11 simpleinput" name="Password" type="password">
            </div>
        </div>

        <br>
        <div class="row" style="margin: 20px 0px">
            <div class="col-md-12" style="border: 1px solid gainsboro">
            </div>
        </div>
        <br>
        <div class="col-md-12">
            <button class="btn add-btn" style="float: right">Submit</button>
        </div>
    </div>
</form>
</body>
</html>