package com.example.kgu_goodrestaurant;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import java.io.IOException;
import java.io.Serializable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class MainActivity extends AppCompatActivity {
    private String homepageUrl = "https://dorm.kyonggi.ac.kr:446/Khostel/mall_main.php?viewform=B0001_foodboard_list&board_no=1";
    List<Menu> menuList;    // 메뉴 리스트
    private int pointerW;     // 현재 가리키는 요일

    ImageButton ibtnPrev, ibtnNext;
    TextView tvDate;
    TextView tvL1,tvL2,tvL3,tvL4,tvL5,tvL6;
    TextView tvD1,tvD2,tvD3,tvD4,tvD5,tvD6;
    List<TextView> lunchViews,dinnerViews;

    Menu getDayMenu(Element targetDay){
        Menu m = new Menu();
        Elements one = targetDay.getElementsByTag("td");    // one[0] : 아침, one[1] : 점심, one[2] : 저녁
        m.setLunch(getSingleMenu(one.get(1).text()));   // lunch
        m.setDinner(getSingleMenu(one.get(2).text()));   // dinner
        m.setDate(targetDay.select("th").text());   // 날짜
        return m;
    }
    List<String> getSingleMenu(String target){
        if(target==null || target.length()<1 || target.contentEquals("미운영"))
            return null;
        int sIdx = target.indexOf("쌀밥");
        String[] con2 = target.substring(sIdx).split(" ");
        ArrayList<String> targetMenu = new ArrayList<>();
        for(int i=0;i<con2.length;i++){
            targetMenu.add(con2[i]);
        }
        return targetMenu;
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        // ui랑 연결
        ibtnPrev = findViewById(R.id.ibtn_prev);
        ibtnNext = findViewById(R.id.ibtn_next);
        tvDate = findViewById(R.id.tv_date);
        tvL1 = findViewById(R.id.tv_lunch1);
        tvL2 = findViewById(R.id.tv_lunch2);
        tvL3 = findViewById(R.id.tv_lunch3);
        tvL4 = findViewById(R.id.tv_lunch4);
        tvL5 = findViewById(R.id.tv_lunch5);
        tvL6 = findViewById(R.id.tv_lunch6);
        tvD1 = findViewById(R.id.tv_dinner1);
        tvD2 = findViewById(R.id.tv_dinner2);
        tvD3 = findViewById(R.id.tv_dinner3);
        tvD4 = findViewById(R.id.tv_dinner4);
        tvD5 = findViewById(R.id.tv_dinner5);
        tvD6 = findViewById(R.id.tv_dinner6);
        lunchViews = new ArrayList<>(Arrays.asList(tvL1,tvL2,tvL3,tvL4,tvL5,tvL6));
        dinnerViews = new ArrayList<>(Arrays.asList(tvD1,tvD2,tvD3,tvD4,tvD5,tvD6));
        // click listener
        ibtnPrev.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                pointerW = pointerW<1?6:pointerW-1;
                //pointerW = (pointerW-1)%7;
                draw_Menu();
            }
        });
        ibtnNext.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                pointerW = (pointerW+1)%7;
                draw_Menu();
            }
        });

        setPointerW();
        final Bundle bundle = new Bundle();
        new Thread(){
            @Override
            public void run() {
                try {
                    Document doc = Jsoup.connect(homepageUrl).get();
                    Log.d("MyActivity","==================");
                    Elements boxstyle02 = doc.getElementsByClass("boxstyle02").get(1).select("tbody");
                    Elements days = boxstyle02.get(0).select("tr");     // 총 7개(일~토) 가져옴
                    System.out.println(days.size()+"");
                    List<Menu> datas = new ArrayList<>();
                    for(int i=0;i<7;i++){   // days[1]:월 ~ days[6]:토 까지만 사용할 것
                        Element day = days.get(i);
                        Menu m = getDayMenu(day);
                        datas.add(m);
                    }
                    // main thread로 보내기
                    bundle.putSerializable("data", (Serializable) datas);
                    Message msg = handler.obtainMessage();
                    msg.setData(bundle);
                    handler.sendMessage(msg);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }.start();
    }
    void setPointerW(){
        Date currentDate = new Date();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        pointerW = calendar.get(Calendar.DAY_OF_WEEK)-1;
    }
    Handler handler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            Bundle bundle = msg.getData();
            menuList = (List<Menu>)bundle.getSerializable("data");
            draw_Menu();
        }
    };
    void draw_Menu(){
        Menu menu = menuList.get(pointerW);
        // 날짜 draw
        tvDate.setText(menu.getDate());

        if(menu.getLunch()==null){
            for(int i=0; i<6; i++){
                lunchViews.get(i).setText("");
            }
            lunchViews.get(2).setText("미운영");
        }
        else{
            for(int i=0; i<menu.lunch.size(); i++){
                lunchViews.get(i).setText(menu.lunch.get(i));
            }
        }
        if(menu.getDinner()==null){
            for(int i=0; i<6; i++){
                dinnerViews.get(i).setText("");
            }
            dinnerViews.get(2).setText("미운영");
        }
        else{
            for(int i=0; i<menu.dinner.size(); i++){
                dinnerViews.get(i).setText(menu.dinner.get(i));
            }
            tvD3.setTextAlignment(View.TEXT_ALIGNMENT_TEXT_START);
        }
    }
}