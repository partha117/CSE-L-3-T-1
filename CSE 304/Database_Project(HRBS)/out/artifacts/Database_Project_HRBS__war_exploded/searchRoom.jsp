<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 08-Dec-16
  Time: 8:43 PM
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
<form method ="post"  action="RoomSearch.do">
<div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
    <div class="row">
        <div class="col-md-6">
            <h3> Room Search</h3>
        </div>
    </div>
    <br>
    <br>

    <div style="padding-left: 20px">

        <div class="row">
            <div class="col-md-2">
                Speciality
            </div>


            <div class="col-md-4">
                <select name="Speciality",type="text">
                    <option  value="Sea facing">Sea facing</option>
                    <option  value="Garden facing">Garden facing</option>
                    <option  value="No Speciality">No Speciality</option>
                </select>
            </div>
        </div>
        <br>

        <div class="row">
            <div class="col-md-2">
                Capacity
            </div>


            <div class="col-md-4">
                <input class="col-md-11 simpleinput" name="Capacity" type="number" min ="2" max="3">
            </div>
        </div>
        <br>

        <div class="row">
            <div class="col-md-2">
                Facilities
            </div>

            <div class="col-md-5">
                <input type="radio" name="Airconditioned" value="YES"> Air Conditioned
            </div>

            <div class="col-md-5">
                <input type="radio" name="Wifi" value="YES"> Unlimited Wifi
            </div>
        </div>
        <br>

        <div class="row">
            <div class="col-md-2">
                Price Range :
            </div>
            <div class="col-md-2">
                From
            </div>

            <div class="col-md-3">
                <input class="col-md-11 simpleinput" name="From" type="number">
            </div>

            <div class="col-md-2">
                To
            </div>

            <div class="col-md-3">
                <input class="col-md-11 simpleinput" name="To" type="number">
            </div>
        </div>
            <br>
            <div class="row">
                <div class="col-md-2">
                    From
                </div>


                <div class="col-md-3">
                    <input class="col-md-11 simpleinput" name="Date_Start" type="Date">
                </div>

                <div class="col-md-2 col-md-offset-1">
                    To
                </div>


                <div class="col-md-3">
                    <input class="col-md-11 simpleinput" name="Date_To" type="Date">
                </div>
            </div>




        <br>
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
        <button class="btn add-btn" style="float: right">Find</button>
    </div>
</div>
</form>
</body>
</html>
