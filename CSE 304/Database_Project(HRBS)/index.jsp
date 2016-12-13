<%@ page import="servlets.LogIn" %><%--
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
        if(designation.compareTo("ACCOUNTANT")==0)
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
        Memo No
      </div>


      <div class="col-md-4">
        <input class="col-md-11 simpleinput" name="Memo_Id" type="text">
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


  <div class="inputroot">
    <div style="margin: 30px 0px">
      <div class="panel panel-default">
        <div class="panel-heading">


          <h4>Purchases</h4>
        </div>


        <div class="panel-body">
          <table class="table table-no-border">
            <thead>
            <tr>
              <th class="col-md-5">Service</th>

              <th class="col-md-2">Rate</th>

              <th class="col-md-1">Quantity</th>



              <th class="col-md-2 text-center">Amount</th>
            </tr>
            </thead>


            <tbody>
            <tr>

              <td><input class="form-control simpleinput" name="Service" type="text">
              </td>

              <td><input class="rate form-control simpleinput" name="Rate" type="text">
              </td>

              <td><input class="form-control simpleinput" name="Quantity" type="text">
              </td>



              <td><input class="form-control simpleinput" name="Amount" readonly type="text">
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>



    <div class="row">
      <div class="col-md-2 col-md-offset-6">
        Grand Total
      </div>


      <div class="col-md-4">
        <input class="col-md-11 simpleinput" name="Grand_Total" type="text" value="1023">
      </div>
    </div>
    <br>


    <div class="row">
      <div class="col-md-2 col-md-offset-6">
        Payment
      </div>


      <div class="col-md-4">
        <input class="col-md-11 simpleinput" name="Payment" type="text">
      </div>
    </div>
    <br>


    <div class="row">
      <div class="col-md-2 col-md-offset-6">
        Discount
      </div>


      <div class="col-md-4">
        <input class="col-md-11 simpleinput" name="Discount" type="text">
      </div>
    </div>
    <br>


    <div class="row" style="margin: 20px 0px">
      <div class="col-md-6 col-md-offset-6" style="border: 1px solid gainsboro">
      </div>
    </div>


    <div class="row">
      <div class="col-md-2 col-md-offset-6">
        Due
      </div>


      <div class="col-md-4">
        <input class="col-md-11 simpleinput" name="Due" type="text">
      </div>
    </div>
  </div>

  <br>
  <div class="row" style="margin: 20px 0px">
    <div class="col-md-12" style="border: 1px solid gainsboro">
    </div>
  </div>
  <br>
  <div class="col-md-4">
    <input type="radio" name="type" value="refundable"> Refundable
  </div>
  <div class="col-md-5">
    <input class="simpleinput col-md-12" name="by" type="text" placeholder="Validated by">
  </div>
  <div class="col-md-3">
    <button class="btn add-btn" style="float: right">Submit</button>
  </div>
</div>

</body>
</html>