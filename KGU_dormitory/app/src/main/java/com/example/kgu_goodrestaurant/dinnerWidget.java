package com.example.kgu_goodrestaurant;

import android.annotation.SuppressLint;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.RemoteViews;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Implementation of App Widget functionality.
 */
public class dinnerWidget extends AppWidgetProvider {
    private static int pointerW;   // 오늘 날짜 (0:일 ~ 6:토)

    void setPointerW(){
        Date currentDate = new Date();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        pointerW = calendar.get(Calendar.DAY_OF_WEEK)-1;
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager,
                                int appWidgetId) {
        // Construct the RemoteViews object
        @SuppressLint("RemoteViewLayout") RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.dinner_widget);
        //views.setTextViewText(R.id.appwidget_text, widgetText);
        // 1. 오늘 날짜 가져오기
        final Bundle bundle = new Bundle();
        new Thread(){
            @Override
            public void run() {
                try {
                    String url = "https://dorm.kyonggi.ac.kr:446/Khostel/mall_main.php?viewform=B0001_foodboard_list&board_no=1";
                    Document doc = Jsoup.connect(url).get();
                    Elements content = doc.select("tr");
                    // 객체 가져오기
                    Element e = content.get(32+pointerW);
                    String date = e.select("th").text();
                    String con = e.select("td").text();
                    List<String> dinner = new ArrayList<>();
                    if(con!=null && con.length()>0){
                        String[] con2 = con.split(" ");
                        for(int i=7;i<13;i++)
                            dinner.add(con2[i]);
                    }

                    Menu m = new Menu();
                    m.setDate(date);
                    m.setDinner(dinner);

                    // main thread로 보내기
                    bundle.putSerializable("data", (Serializable) m);
                    Message msg = handler.obtainMessage();
                    msg.setData(bundle);
                    handler.sendMessage(msg);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }.start();

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
    Handler handler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            Bundle bundle = msg.getData();
            Menu menu = (Menu)bundle.getSerializable("data");

        }
    };
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // There may be multiple widgets active, so update all of them
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}