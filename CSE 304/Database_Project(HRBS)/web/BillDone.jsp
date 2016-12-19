<%@ page import="servlets.CalculateBill" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 19-Dec-16
  Time: 7:13 AM
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

    <span><h2 class="text-success oneline">Bill has been issued </h2></span>

    <h3><span class="col-md-offset-7 text-center" >for</span></h3>
    <h1><span class="col-md-offset-5 text-center text-success" >Guest id </span></h1>
    <h3><span class="col-md-offset-3 text-center oneline" >
        <%
            String  guestId=(String)session.getAttribute(CalculateBill.sessionDataName2);
            out.print(guestId);
            session.removeAttribute(CalculateBill.sessionDataName2);
        %>
    </span></h3>
   <button class="btn add-btn" style="float: right"><a href=\"index.jsp\">OK</a></button>


</div>


</body>
</html>