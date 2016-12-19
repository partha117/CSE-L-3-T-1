<%@ page import="servlets.LogIn" %>
<%@ page import="javax.print.DocFlavor" %>
<%@ page import="servlets.CheckIn" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 15-Dec-16
  Time: 10:17 AM
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
<form method="post" action="CheckIn.do">
<body style="font-family: Georgia, Serif">

<%
    String designation= (String) session.getAttribute(LogIn.sessionDataName2);

    if((designation!=null)&&(designation.toUpperCase().compareTo("RECEPTIONIST")==0))
    {
        String  name= (String) session.getAttribute(LogIn.sessionDataName1);
        if(name!=null)
        {
            String html = "<div class=\"col-md-offset-0\">\n" +
                    "\t\t\tLogged in as   " + name + "\n" +
                    "\t\t\t</div>\n" +
                    "\t\t\t<br>\n" +
                    "\t\t\t<br>";
            out.println(html);
        }
    }
    else
    {
        RequestDispatcher rd=request.getRequestDispatcher("/LogIn.jsp");
        rd.forward(request,response);
    }
%>

<div class="row">
    <div class="col-md-offset-7 col-md-2" >
        <select name="ACTIVITY" style="float: right">
            <option name="option1" value="LOG_OUT">Log out</option>
            <option name="option2" value="CHANGE_PASSWORD">Change Password</option>
        </select>
    </div>
    <div class="col-md-1" style="float: left">
        <input class="btn btn-sm btn add-btn col-md-offset-11" type="submit" value="Go" name="Go" >
    </div>

</div>

</div>
<div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
    <div class="row">
        <div class="col-md-6">
            <h3>Check In</h3>
        </div>
        <div class="col-md-6">
            <h3><a href="Checkout.jsp">Check Out</a></h3>

            <div class="row">
                <div class="col-md-3">
                    Date
                </div>


                <div class="col-md-9">
                    <input class="col-md-11 simpleinput" name="Date" type="date">
                </div>
            </div>

        </div>



    </div>
    <br>


    <div style="padding-left: 20px">
        <div class="row">
            <div class="col-md-2">
                Guest ID
            </div>


            <div class="col-md-4">
                <input class="col-md-11 simpleinput" name="Guest_Id" type="text">
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
            String name = (String) session.getAttribute(LogIn.sessionDataName1);
            String html="<input class=\"simpleinput col-md-12\" name=\"by\" type=\"text\" placeholder=\"Validated by "+name+"("+designation+")"+"\">";
            out.println(html);
        %>

    </div>
    <div class="col-md-7">
        <button class="btn add-btn" style="float: right">Submit</button>
    </div>
    <%
        String message=(String)session.getAttribute(CheckIn.sessionDataName);
        if(message!=null)
        {
            out.println("<h1>"+message+"</h1>");
            session.removeAttribute(CheckIn.sessionDataName);
        }

    %>
</div>

</body>
</form>
</html>