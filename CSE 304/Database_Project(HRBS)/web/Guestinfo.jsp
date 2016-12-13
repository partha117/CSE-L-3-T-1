<%@ page import="servlets.Booking" %>
<%@ page import="servlets.BookingWithFacility" %>
<!DOCTYPE html>


<head>
    <title>Hotel Managment System</title>

    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <link href="./css/bootstrap.css" rel="stylesheet">
    <link href="./css/override.css" rel="stylesheet">
</head>

<body style="font-family: Georgia, Serif">
<form method ="post"  action="guestdata.do">

    <%
        if((session.getAttribute(Booking.sessionDataName)==null)&&(session.getAttribute(BookingWithFacility.sessionDataName1)==null))
        {
            RequestDispatcher rd=request.getRequestDispatcher("/searchRoom.jsp");
            rd.forward(request, response);
        }

    %>
    <div class="col-md-8 col-md-offset-2" style="margin-top: 5%; margin-bottom: 10%">
        <div class="row">
            <div class="col-md-6">
                <h3> Guest Info</h3>
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
                    First name
                </div>


                <div class="col-md-4">
                    <input class="col-md-11 simpleinput" name="FirstName" type="text">
                </div>
            </div>
            <br>




            <div class="row">
                <div class="col-md-2">
                    Last name
                </div>


                <div class="col-md-4">
                    <input class="col-md-11 simpleinput" name="LastName" type="text">
                </div>
            </div>
            <br>

            <div class="row">
                <div class="col-md-2">
                    Address
                </div>

                <div class="col-md-10">
                    <input class="col-md-11 simpleinput" name="Address" type="text">
                </div>
            </div>
            <br>

            <div class="row">
                <div class="col-md-2">
                    Contact No
                </div>


                <div class="col-md-4">
                    <input class="col-md-11 simpleinput" name="Contact_No" type="text">
                </div>
            </div>
            <br>

            <div class="row">
                <div class="col-md-2">
                    NID
                </div>


                <div class="col-md-4">
                    <input class="col-md-11 simpleinput" name="NID" type="text">
                </div>
            </div>
            <br>

            <div class="row">
                <div class="col-md-2">
                    Passport No
                </div>


                <div class="col-md-4">
                    <input class="col-md-11 simpleinput" name="Passport" type="text">
                </div>
            </div>
            <br>
            <%
                if(session.getAttribute(BookingWithFacility.sessionDataName1)!=null)
                {
                    out.println("<div class=\"row\">\n" +
                            "                <div class=\"col-md-2\">\n" +
                            "                    Club member no\n" +
                            "                </div>\n" +
                            "\n" +
                            "\n" +
                            "                <div class=\"col-md-4\">\n" +
                            "                    <input class=\"col-md-11 simpleinput\" name=\"Club_member\" type=\"text\" placeholder=\"If you are a club member\">\n" +
                            "                </div>\n" +
                            "            </div>");
                }
            %>

            <br>
        </div>
        <%
            if(session.getAttribute(Booking.sessionDataName)!=null)
            {
                out.println("\n" +
                        "        <div class=\"row\">\n" +
                        "            <div class=\"col-md-2\">\n" +
                        "                Total person:\n" +
                        "            </div>\n" +
                        "\n" +
                        "\n" +
                        "            <div class=\"col-md-4\">\n" +
                        "                <input class=\"col-md-11 \" name=\"Person\" type=\"number\" min=\"1\" max=\"5\">\n" +
                        "                \n" +
                        "            </div>\n" +
                        "        </div>");
            }

        %>
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