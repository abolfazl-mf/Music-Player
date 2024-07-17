import 'package:flutter/material.dart';
import 'package:music_player/controllers/page_manager.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/services/service_locator.dart';
import 'package:music_player/splash.dart';

void main() async{
  await setupInitService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  PageController controller = PageController(
    initialPage: 0,
  );

  PageManager get _pageManager => PageManager();

  //برای لیست تایل این کار رو کردیم تا روش میزنیم همون اهنگ در صفحه موزیک اسکرین نشون بده و هوم اسکرین و موزیک اسکرین هم برای این state less کردیم تا همون اهنگ وقتی توی پلی لیست زدیم تو صفحه موزیک اسکرین بیاره و این پیج منیجر هم برای این اینجوری نوشتیم چون کانستراکتور ائودیو پلیر میخواست و چون استیت لس مجبور بودیم اینطوری بنویسیم.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Ubuntu'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: controller,
          scrollDirection: Axis.vertical,
          children: [
            HomeScreen(controller, _pageManager),
            WillPopScope(onWillPop: () async{
              controller.animateToPage(0, duration: const Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
              return false;
            },
            child: MusicScreen(controller, _pageManager)),
          ],
        ),
      ),
    );
  }
}
