// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'core/routes_manager.dart';
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  ScreenUtilInit(
//       designSize: const Size(412,870),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context,child)=> MaterialApp(
//         debugShowCheckedModeBanner: false,
//         onGenerateRoute: RoutesManager.router ,
//         initialRoute: RoutesManager.splash,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes_manager.dart';
import 'domain/searchcubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 870),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider(
        create: (context) => SearchCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesManager.router,
          initialRoute: RoutesManager.splash,
        ),
      ),
    );
  }
}
