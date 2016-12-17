package Utility;

/**
 * Created by partha on 08-Dec-16.
 */
public class Room {
    String  speciality;
    double price;
    int room_no;

    public Room(String speciality, double price, int room_no) {
        this.speciality = speciality;
        this.price = price;
        this.room_no = room_no;
    }

    public String getSpeciality() {
        return speciality;
    }

    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getRoom_no() {
        return room_no;
    }

    public void setRoom_no(int room_no) {
        this.room_no = room_no;
    }
    public String gethtml()
    {
        String st="<tr>\n" +
                "                    <td> <input type=\"radio\" name =\""+room_no+"\"value=\""+room_no+"\">\n" +
                "                    </td>\n" +
                "\n" +
                "                    <td>"+ room_no+"\n" +
                "                    </td>\n" +
                "\n" +
                "                    <td>"+ speciality+"\n" +
                "                    </td>\n" +
                "\n" +
                "                    <td> TK. "+ price+"\n" +
                "                    </td>\n" +
                "                </tr>";
        return st;
    }
}
