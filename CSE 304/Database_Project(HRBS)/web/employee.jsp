<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 15-Dec-16
  Time: 10:16 AM
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
    <script src="./js/bootstrap.js">
    </script>
    <script src="./js/autocomplete.js">
    </script>
    <script src="js/back.js"></script>
    <script src="js/front.js"></script>
</head>

<body style="font-family: Georgia, Serif">
<div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
    <div class="row">
        <div class="col-md-6">
            <h3> Add Employee</h3>
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
                Name
            </div>


            <div class="col-md-4">
                <input class="col-md-11 simpleinput" name="Name" type="text">
            </div>
        </div>
        <br>

        <div class="row">
            <div class="col-md-2">
                Depatment
            </div>


            <div class="col-md-4">
                <select name="Department">
                    <option name="option1" value="Accounts">Accounts</option>
                    <option name="option2" value="Maintenance">Maintenance</option>
                    <option name="option2" value="Security">Security</option>
                    <option name="option2" value="Housekeeping">Housekeeping</option>
                    <option name="option2" value="Front Office">Front Office</option>
                </select>
            </div>
        </div>
        <br>

        <div class="row">
            <div class="col-md-2">
                Designation
            </div>


            <div class="col-md-4">
                <input class="col-md-11 simpleinput" name="Designation" type="text">
            </div>
        </div>
        <br>

        <div class="row">
            <div class="col-md-2">
                Email
            </div>


            <div class="col-md-4">
                <input class="col-md-11 simpleinput" name="Email" type="email">
            </div>
        </div>
        <br>


        <div class="row">
            <div class="col-md-2">
                Contact No
            </div>


            <div class="col-md-4">
                <input class="col-md-11 simpleinput" name="Contact" type="text">
            </div>
        </div>
        <br>




        <div class="row">
            <div class="col-md-2">
                Password
            </div>


            <div class="col-md-5">
                <input class="simpleinput col-md-12" name="by" type="text" placeholder="Demo Password">
            </div>
        </div>
    </div>

    <br>
    <div class="row" style="margin: 20px 0px">
        <div class="col-md-12" style="border: 1px solid gainsboro">
        </div>
    </div>
    <br>
    <div class="col-md-5">
        <input class="simpleinput col-md-12" name="by" type="text" placeholder="Validated by">
    </div>
    <div class="col-md-7">
        <button class="btn add-btn" style="float: right">Submit</button>
    </div>


</div>

</body>
</html>