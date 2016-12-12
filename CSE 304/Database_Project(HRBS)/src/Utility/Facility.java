package Utility;

/**
 * Created by partha on 13-Dec-16.
 */
public class Facility {

    private  String facility_id;
    private String  facility_name;
    private  double price;

    public Facility(String facility_id, String facility_name, double price) {
        this.facility_id = facility_id;
        this.facility_name = facility_name;
        this.price = price;
    }

    public String getFacility_id() {
        return facility_id;
    }

    public void setFacility_id(String facility_id) {
        this.facility_id = facility_id;
    }

    public String getFacility_name() {
        return facility_name;
    }

    public void setFacility_name(String facility_name) {
        this.facility_name = facility_name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
