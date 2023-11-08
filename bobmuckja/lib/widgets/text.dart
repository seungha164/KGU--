import 'package:flutter/material.dart';

Map<String, Color> str2color = {
  'black': const Color(0xff000000),
  'white': const Color(0xffffffff),
  'blue' : const Color(0xff2196f3),
  'red' : const Color(0xfff44336),
  'primary' : const Color(0xff3A4D39),
  'beige' : const Color(0xffECE3CE),
  'primary80' : const Color(0xcc3A4D39),
  'base60' : const Color(0x99512F22),
  'base63' : const Color(0xa1512f22),
  'base80' : const Color(0xcc512f22),
  'base100' : const Color(0xff512F22),
  'Grey' : const Color(0xff9E9E9E),
  'grey': const Color(0xffC1C1C1),
};

Map<String, FontWeight> weightList = {
  'normal' : FontWeight.w400,
  'bold' : FontWeight.w700,
  'extra-bold' : FontWeight.w800,
};

Text label(String str, String weight, double size, String colorTxt){
  return Text(
      str,
      style: TextStyle(
          color: str2color[colorTxt],
          fontWeight: weightList[weight!],
          fontFamily: (weight=='extra-bold')?'Cafe24SupermagicBold':"Cafe24SupermagicRegular",
          fontSize: size,
          overflow: TextOverflow.ellipsis
      )
  );
}

