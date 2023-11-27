import 'package:cp949_codec/cp949_codec.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import '../models/model.dart';
import '../widgets/appbar.dart';
import '../widgets/text.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BaseWidget extends StatefulWidget{
  const BaseWidget({Key?key}):super(key:key);
  @override
  State<BaseWidget> createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{

  late Future futureMenu;
  List<TodayMenu> weekMenus= [];

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
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar(''),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffECE3CE),
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
                return Container(
                  padding: const EdgeInsets.only(top: 25),
                  child: CarouselSlider(
                    carouselController: carouselController,
                    items: [0, 1, 2, 3, 4, 5, 6].map((i) {
                      TodayMenu today = weekMenus[i];
                      return Builder(
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              Center(
                                  child: label(today.today, 'extra-bold', 20, 'base100')
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
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: double.infinity,

                      // Set the size of each carousel item
                      // if height is not specified
                      aspectRatio: 16 / 9,

                      // Set how much space current item widget
                      // will occupy from current page view
                      viewportFraction: 0.8,

                      // Set the initial page
                      initialPage: DateTime.now().weekday%7,

                      // Set carousel to repeat when reaching the end
                      enableInfiniteScroll: true,

                      // Set carousel to scroll in opposite direction
                      reverse: false,

                      // Set the current page to be displayed
                      // bigger than previous or next page
                      enlargeCenterPage: true,

                      // Do actions for each page change
                      onPageChanged: (index, reason) {},

                      // Set the scroll direction
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
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