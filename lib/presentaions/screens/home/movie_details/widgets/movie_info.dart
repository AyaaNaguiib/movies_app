import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/colors_manager.dart';

class MovieInfo extends StatelessWidget {
  final Map<String, dynamic> movie;
  const MovieInfo({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseUrl = "https://image.tmdb.org/t/p/w500";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            "$baseUrl${movie['poster_path']}",
            width: 100.w,
            height: 150.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${movie['release_date'].split('-')[0]} | ${movie['runtime']} min",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                children: List.generate(
                  movie['genres'].length,
                      (index) => Chip(
                    backgroundColor: ColorsManager.bottomNavBar,
                    label: Text(
                      movie['genres'][index]['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.star, color: ColorsManager.yellow),
                  SizedBox(width: 5.w),
                  Text(
                    movie['vote_average'].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
