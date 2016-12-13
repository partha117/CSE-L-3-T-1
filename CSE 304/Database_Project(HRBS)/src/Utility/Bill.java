package Utility;

import java.util.ArrayList;

/**
 * Created by partha on 13-Dec-16.
 */
public class Bill {

    private ArrayList<Facility> facilities;
    private  ArrayList<Room> rooms;
    private  int guestID;
    private  double total=0;
    private  double totalF=0;
    private  String billHtml;
    private  String memberType;
    public Bill(ArrayList<Facility> facilities, ArrayList<Room> rooms, int guestID,String memberType) {
        this.facilities = facilities;
        this.rooms = rooms;
        this.guestID = guestID;
        this.memberType=memberType;
    }
    public  void generateBill()
    {
        billHtml="<tbody>";
        for(int i=0;i<facilities.size();i++)
        {
            billHtml+="<tr>\n" +
                    "\n" +
                    "              <td><input class=\"form-control simpleinput\" name=\"Service\" type=\"text\" value=\""+facilities.get(i).getFacility_type()+"\">\n" +
                    "              </td>\n" +
                    "\n" +
                    "              <td><input class=\"rate form-control simpleinput\" name=\"Rate\" type=\"text\" value=\""+facilities.get(i).getPrice()+"\">\n" +
                    "              </td>\n" +
                    "\n" +
                    "              <td><input class=\"form-control simpleinput\" name=\"Quantity\" type=\"text\" value=\"1\">\n" +
                    "              </td>\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "              <td><input class=\"form-control simpleinput\" name=\"Amount\" readonly type=\"text\" value=\""+facilities.get(i).getPrice()+"\">\n" +
                    "              </td>\n" +
                    "            </tr>";
            totalF+=facilities.get(i).getPrice();
        }
        double discount=0;
        if(memberType!=null) {
            if (memberType.compareTo("GOLD") == 0) {
                discount = totalF * 0.25;
            } else if (memberType.compareTo("SILVER") == 0) {
                discount = totalF * 0.15;
            }
            else  if(memberType.compareTo("BRONZE") == 0)
            {
                discount=totalF*0.05;
            }
        }
        total+=totalF;
        for(int i=0;i<rooms.size();i++)
        {
            billHtml+="<tr>\n" +
                    "\n" +
                    "              <td><input class=\"form-control simpleinput\" name=\"Service\" type=\"text\" value=\""+rooms.get(i).getRoom_no()+"\">\n" +
                    "              </td>\n" +
                    "\n" +
                    "              <td><input class=\"rate form-control simpleinput\" name=\"Rate\" type=\"text\" value=\""+rooms.get(i).getPrice()+"\">\n" +
                    "              </td>\n" +
                    "\n" +
                    "              <td><input class=\"form-control simpleinput\" name=\"Quantity\" type=\"text\" value=\"1\">\n" +
                    "              </td>\n" +
                    "\n" +
                    "\n" +
                    "\n" +
                    "              <td><input class=\"form-control simpleinput\" name=\"Amount\" readonly type=\"text\" value=\""+rooms.get(i).getPrice()+"\">\n" +
                    "              </td>\n" +
                    "            </tr>";

            total+=rooms.get(i).getPrice();
        }


        billHtml+="\n" +
                "    <div class=\"row\">\n" +
                "      <div class=\"col-md-2 col-md-offset-6\">\n" +
                "        Total\n" +
                "      </div>";
        billHtml+="<div class=\"col-md-4\">\n" +
                "        <input class=\"col-md-11 simpleinput\" name=\"Total\" type=\"text\" value=\""+total+"\">\n" +
                "      </div>\n" +
                "    </div>\n" +
                "    <br>";
        billHtml+= "\n" +
                "    <div class=\"row\">\n" +
                "      <div class=\"col-md-2 col-md-offset-6\">\n" +
                "        Discount\n" +
                "      </div>\n" +
                "\n" +
                "\n" +
                "      <div class=\"col-md-4\">\n" +
                "        <input class=\"col-md-11 simpleinput\" name=\"Discount\" type=\"text\" value=\""+discount+"\">\n" +
                "      </div>\n" +
                "    </div>\n<div class=\"row\" style=\"margin: 20px 0px\">\n" +
                "      <div class=\"col-md-6 col-md-offset-6\" style=\"border: 1px solid gainsboro\">\n" +
                "      </div>\n" +
                "    </div>\n" +
                "\n";
        billHtml+="\n" +
                "    <div class=\"row\">\n" +
                "      <div class=\"col-md-2 col-md-offset-6\">\n" +
                "        Grand Total\n" +
                "      </div>";
        billHtml+="<div class=\"col-md-4\">\n" +
                "        <input class=\"col-md-11 simpleinput\" name=\"Grand_Total\" type=\"text\" value=\""+(total-discount)+"\">\n" +
                "      </div>\n" +
                "    </div>\n" +
                "    <br>"+
                "\n";
        billHtml+=" <div class=\"row\">\n" +
                "      <div class=\"col-md-2 col-md-offset-6\">\n" +
                "        Payment\n" +
                "      </div>\n" +
                "\n" +
                "\n" +
                "      <div class=\"col-md-4\">\n" +
                "        <input class=\"col-md-11 simpleinput\" name=\"Payment\" type=\"text\">\n" +
                "      </div>\n" +
                "    </div>\n" +
                "    <br>\n" +
                "\n";
        billHtml+= "    <div class=\"row\">\n" +
                "      <div class=\"col-md-2 col-md-offset-6\">\n" +
                "        Due\n" +
                "      </div>\n" +
                "\n" +
                "\n" +
                "      <div class=\"col-md-4\">\n" +
                "        <input class=\"col-md-11 simpleinput\" name=\"Due\" type=\"text\">\n" +
                "      </div>\n" +
                "    </div>\n" +
                "  </div>" +
                "    <br>";
        billHtml+="";

    }

    public String getHtml()
    {

        return billHtml;
    }


}
