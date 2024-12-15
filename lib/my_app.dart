import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routes_manager.dart';
import 'cubits_states/geners_cubit.dart';
import 'cubits_states/geners_states.dart';
import 'cubits_states/searchcubit.dart';
import 'cubits_states/watchlist_cubit.dart';
import 'model/watchlist_Repo.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 870),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchCubit(),
          ),
          BlocProvider(
            create: (context) => WatchlistCubit(WatchlistRepository()),
          ),
          BlocProvider(create: (_) => GenreCubit()
          ),
          BlocProvider(create: (_) => MovieByGenreCubit()
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesManager.router,
          initialRoute: RoutesManager.splash,
        ),
      ),
    );
  }
}
