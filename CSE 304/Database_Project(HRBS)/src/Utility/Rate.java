package Utility;

/**
 * Created by partha on 15-Dec-16.
 */
public class Rate {
    private String  facilityName;
     private double discount;

    public Rate(String facilityName, double discount) {
        this.facilityName = facilityName;
        this.discount = discount;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }
}
