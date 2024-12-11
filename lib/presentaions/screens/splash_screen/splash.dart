import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/assets_manager.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2),
          (){
        Navigator.pushReplacementNamed(context, RoutesManager.home);
      },);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: ColorsManager.bg,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              AssetsManager.movieIcon,
              width: 199.w,
              height: 208.h,),
            const Spacer(),
            Image.asset(
              AssetsManager.routeIcon,
              width: 213.w,
              height: 128.h,),
          ],
        )
      ],
    );
  }
}