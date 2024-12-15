import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/assets_manager.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cubits_states/geners_cubit.dart';
import 'geners_Screen.dart';

class BrowseCategoriesScreen extends StatefulWidget {
  const BrowseCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<BrowseCategoriesScreen> createState() => _BrowseCategoriesScreenState();
}

class _BrowseCategoriesScreenState extends State<BrowseCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GenreCubit>().fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.bg,
      appBar: AppBar(
        backgroundColor: ColorsManager.bg,
        elevation: 0,
        title: Text(
          'Browse Category',
          style: TextStyle(color: ColorsManager.white, fontSize: 20.sp),
        ),
      ),
      body: BlocBuilder<GenreCubit, GenreState>(
        builder: (context, state) {
          if (state is GenreLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GenreError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is GenreLoaded) {
            final genreList = state.genres;
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 2.0,
              ),
              itemCount: genreList.length,
              itemBuilder: (context, index) {
                final genre = genreList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesByGenreScreen(
                          genreId: genre['id'],
                          genreName: genre['name'],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          AssetsManager.categoryItem,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Text(
                          genre['name'],
                          style: TextStyle(
                            color: ColorsManager.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
