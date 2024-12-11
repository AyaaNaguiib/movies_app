import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../movie__details.dart';


class MoreLikeThis extends StatelessWidget {
  final Future<List<dynamic>> similarMoviesFuture;
  const MoreLikeThis({Key? key, required this.similarMoviesFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseUrl = "https://image.tmdb.org/t/p/w500";

    return FutureBuilder<List<dynamic>>(
      future: similarMoviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final movies = snapshot.data!;
          return SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(movieId: movie['id']),
                      ),
                    );
                  },
                  child: Container(
                    width: 120.w,
                    margin: EdgeInsets.only(left: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            "$baseUrl${movie['poster_path']}",
                            height: 150.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          movie['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}


