package com.example.kgu_goodrestaurant;

import java.util.ArrayList;
import java.util.List;

public class Menu {
    String date;            // 날짜
    List<String> lunch;     // 점심 메뉴
    List<String> dinner;    // 저녁 메뉴

    public void print(){
        System.out.printf("[%s] \nlunch : ",date);
        if(lunch!=null){
            System.out.print("("+lunch.size()+"개)");
            for(String s:lunch) System.out.printf(s+" ");
        }
        else
            System.out.printf("미운영");
        System.out.printf("\ndinner : ");
        if(dinner!=null)
            for(String s:dinner) System.out.printf(s+" ");
        else
            System.out.printf("미운영");
        System.out.println("");
    }
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
