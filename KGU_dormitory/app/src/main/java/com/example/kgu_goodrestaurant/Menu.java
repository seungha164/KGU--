package com.example.kgu_goodrestaurant;

import java.util.List;

public class Menu {
    String date;            // 날짜
    List<String> lunch;     // 점심 메뉴
    List<String> dinner;    // 저녁 메뉴

    public String getDate() {
        return date;
    }
    public void setDate(String date) {
        this.date = date;
    }

    public List<String> getLunch() {
        return lunch;
    }

    public void setLunch(List<String> lunch) {
        this.lunch = lunch;
    }

    public List<String> getDinner() {
        return dinner;
    }

    public void setDinner(List<String> dinner) {
        this.dinner = dinner;
    }
}
