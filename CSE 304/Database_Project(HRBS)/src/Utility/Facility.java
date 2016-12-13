package Utility;

/**
 * Created by partha on 13-Dec-16.
 */
public class Facility {

    private  String facility_id;
    private String  facility_type;
    private  String feature;
    private  double price;

    public Facility(String facility_id, String facility_type, String feature, double price) {
        this.facility_id = facility_id;
        this.facility_type = facility_type;
        this.feature = feature;
        this.price = price;
    }

    public String getFacility_id() {
        return facility_id;
    }

    public void setFacility_id(String facility_id) {
        this.facility_id = facility_id;
    }

    public String getFacility_type() {
        return facility_type;
    }

    public void setFacility_type(String facility_type) {
        this.facility_type = facility_type;
    }

    public String getFeature() {
        return feature;
    }

    public void setFeature(String feature) {
        this.feature = feature;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
    public String getHtml()
    {
        String html="<tr>\n" +
                "                    <td> <input type=\"radio\" name =\""+facility_id+"\"value=\""+facility_id+"\">\n" +
                "                    </td>\n" +
                "\n" +
                "                    <td>"+facility_type+"\n" +
                "                    </td>\n" +
                "\n" +
                "                    <td>"+feature+"\n" +
                "                    </td>\n" +
                "\n" +
                "                    <td>TK."+price+"\n" +
                "                    </td>\n" +
                "                </tr>";
        return  html;
    }
}
