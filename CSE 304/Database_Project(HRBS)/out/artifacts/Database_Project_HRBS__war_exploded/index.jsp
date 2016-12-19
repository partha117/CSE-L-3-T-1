<%@ page import="servlets.LogIn" %>
<%@ page import="servlets.CalculateBill" %>
<%@ page import="Utility.Bill" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 08-Dec-16
  Time: 8:30 PM
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
<div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
    <form method="post" action="CalculateBill.do">
    <%
        String designation= (String) session.getAttribute(LogIn.sessionDataName2);

        if((designation!=null)&&(designation.toUpperCase().compareTo("ACCOUNTANT")==0))
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
  <div class="row">
    <div class="col-md-6">
      <h3>Bill Entry</h3>
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
        Payment Method
      </div>


      <div class="col-md-4">

        <select name="Payment Method">
          <option name="option1" value="CASH">Cash</option>
          <option name="option2" value="VISA">Credit Card(VISA)</option>
          <option name="option2" value="MASTER CARD">Credit Card(Master Card)</option>
          <option name="option2" value="AMERICAN EXPRESS">Credit Card(American Express)</option>
          <option name="option2" value="BKASH">BKASH</option>
          <option name="option2" value="ROCKET">DBBL(ROCKET)</option>
          <option name="option2" value="BANK CHECK">Bank Check</option>
        </select>
      </div>
    </div>
    <br>


    <div class="row">
      <div class="col-md-2">
        Guest ID
      </div>


      <div class="col-md-4">
        <input class="col-md-11 simpleinput" name="Guest_Id" type="text">
      </div>
        <input class="btn btn-sm btn add-btn"  type="submit" value="Calculate" name="Calculate">
    </div>
    <br>
  </div>

        <%
            Bill bill=(Bill)session.getAttribute(CalculateBill.sessionDataName);
            if(bill!=null)
            {
                bill.generateBill();
                String  html=" <h4>Purchases</h4>\n" +
                "        </div>"+"<table class=\"table table-no-border\">\n" +
                "            <thead>\n" +
                "            <tr>\n" +
                "              <th class=\"col-md-5\">Service</th>\n" +
                "\n" +
                "              <th class=\"col-md-2\">Rate</th>\n" +
                "\n" +
                "              <th class=\"col-md-1\">Quantity</th>\n" +
                "\n" +
                "\n" +
                "\n" +
                "              <th class=\"col-md-2 text-center\">Amount</th>\n" +
                "            </tr>\n" +
                "            </thead>";

                    out.flush();
                    //out.println(bill.getHtml());
                    String  others=" <div class=\"inputroot\">\n" +
                    "    <div style=\"margin: 30px 0px\">\n" +
                    "      <div class=\"panel panel-default\">\n" +
                    "        <div class=\"panel-heading\">\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "        <div class=\"panel-body\">\n" +
                    "\n" +
                    "  <br>\n" +
                    "  <div class=\"row\" style=\"margin: 20px 0px\">\n" +
                    "    <div class=\"col-md-12\" style=\"border: 1px solid gainsboro\">\n" +
                    "    </div>\n" +
                    "  </div>\n" +
                    "  <br>\n" +
                    "  <div class=\"col-md-4\">\n" +
                    "    <input type=\"radio\" name=\"refundable\" value=\"YES\"> Refundable\n" +
                    "  </div>\n" +
                    "  <div class=\"col-md-5\">\n" +
                    "    <input class=\"simpleinput col-md-12\" name=\"by\" type=\"text\" placeholder=\"Validated by"+(String) session.getAttribute(LogIn.sessionDataName1)+"("+designation+")\">\n" +
                    "  </div>\n" +
                    "  <div class=\"col-md-3\">\n" +
                    "    <input class=\"btn btn-sm btn add-btn\"  type=\"submit\" value=\"Submit\" name=\"Submit\">" +
                    "  </div>\n" +
                    "</div>";

                    out.println(html);
                    out.append(bill.getHtml());
                    out.append(others);
                    out.flush();

                    out.close();

            }


        %>




</body>
</html>