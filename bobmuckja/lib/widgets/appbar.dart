import 'package:bobmuckja/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSize homeAppbar(String title){
  return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xff4F6F52), // <-- SEE HERE
            statusBarIconBrightness: Brightness.dark,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  label('\u{1F371} 경기대 드림타워', 'bold', 20, 'primary'),
                  const SizedBox(width: 10),
                  label('이번주 식단', 'bold', 18, 'beige'),
                ],
              )
          ),
          backgroundColor: const Color(0xff739072),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xff4F6F52), Color(0xff739072)],
                )
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10)
            ),
          ),
          shadowColor: const Color(0x4D584639)
      )
  );
}