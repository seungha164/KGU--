import 'package:cp949_codec/cp949_codec.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import '../models/model.dart';
import '../widgets/appbar.dart';
import '../widgets/text.dart';

class BaseWidget extends StatefulWidget{
  const BaseWidget({Key?key}):super(key:key);
  @override
  State<BaseWidget> createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{

  late Future futureMenu;
  List<TodayMenu> weekMenus= [];
  int cIdx = 1;
  @override
  void initState() {    // 초기 호출 메서드
    // TODO: implement initState
    super.initState();
    futureMenu = getMenu();
  }

  Future getMenu() async {
    const String url = 'https://dorm.kyonggi.ac.kr:446/Khostel/mall_main.php?viewform=B0001_foodboard_list&board_no=1';
    final http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      dom.Document document = parser.parse(response.body);
      dom.Element table = document.getElementsByClassName("boxstyle02")[1];
      table
          .getElementsByTagName('tbody')[0]
          .getElementsByTagName('tr')
          .forEach((dom.Element element) {

        String date = cp949.decodeString(element.getElementsByTagName("th")[0].text.trim());
        List<dom.Element> times = element.getElementsByTagName("td");   // times = [(아침), (점심), (저녁)]
        // 1. 점심 추출
        List<String> lunchMenus = [];
        String lunch = cp949.decodeString(times[1].text.trim());
        if(lunch != ''){
          lunchMenus = (lunch.split('\n').toList());
        }
        // 2. 저녁 추출
        List<String> dinnerMenus = [];
        String dinner = cp949.decodeString(times[2].text.trim());
        if(dinner != ''){
          dinnerMenus = (dinner.split('\n').toList());
        }
        weekMenus.add(
          TodayMenu(
              today: date,
              lunch: lunchMenus,
              dinner: dinnerMenus
          )
        );

      });
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar(''),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffECE3CE),
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: futureMenu,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (!snapshot.hasData){
                return Center(
                  child: label('데이터를 불러오고 있습니다..', 'bold', 20, 'base100')
                );
              }
              else if(snapshot.hasError){
                return label('Error: ${snapshot.error}', 'bold', 15, 'base100');
              }
              else{
                TodayMenu today = weekMenus[cIdx];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: (){
                                setState(() {
                                  cIdx = (0 < cIdx) ? (cIdx - 1) : cIdx;
                                });
                              },
                              icon: const Icon(Icons.keyboard_arrow_left, color: Color(0xff3A4D39), size: 35)
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Center(
                                child: label(today.today, 'extra-bold', 20, 'base100')
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    cIdx = (cIdx < weekMenus.length-1) ? (cIdx + 1) : cIdx;
                                  });
                                },
                                icon: const Icon(Icons.keyboard_arrow_right, color: Color(0xff3A4D39), size: 35)
                            )
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      height: 280,
                      decoration: BoxDecoration(
                            color: const Color(0xfffffaf5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 5.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0,3),
                              )
                            ]
                        ),
                      child: Column(
                        children: [
                          label('점심', 'extra-bold', 18, 'primary'),
                          const Divider(thickness: 1),
                          drawTimes(today.lunch)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      height: 280,
                      decoration: BoxDecoration(
                          color: const Color(0xffFFFBF5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 5.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0,3),
                              )
                            ]
                        ),
                      child: Column(
                        children: [
                          label('저녁', 'extra-bold', 18, 'primary'),
                          const Divider(thickness: 1),
                          drawTimes(today.dinner)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, top: 5),
                      child: label('made by nute11a \u{1F36B}', 'regular', 15, 'base60')
                    )
                  ],
                );

              }
            }
        ),
      )
    );
  }
  drawTimes(List<String> menus){
    if(menus.isEmpty){
      return label('미운영', 'regular', 15, 'base100');
    }else{
      return Expanded(
          child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (BuildContext ctx, int idx) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: label(menus[idx], 'regular', 15, 'base100')
                );
              }
          )
      );
    }
  }
}