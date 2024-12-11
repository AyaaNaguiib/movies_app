import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';
import '../movie_details/movie__details.dart';

class NewReleaseCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int movieId;

  const NewReleaseCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.movieId,
  }) : super(key: key);

  @override
  State<NewReleaseCard> createState() => _NewReleaseCardState();
}

class _NewReleaseCardState extends State<NewReleaseCard> {
  bool isAdded = false;

  void toggleAddState() {
    setState(() {
      isAdded = !isAdded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetails(movieId: widget.movieId),
          ),
        );
      },
      child: Container(
        width: 120.w,
        margin: EdgeInsets.only(right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    widget.imageUrl,
                    height: 150.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w, // Updated position to left
                  child: GestureDetector(
                    onTap: toggleAddState,
                    child: Image.asset(
                      isAdded
                          ? 'assets/images/bookmark (1).png'
                          : 'assets/images/bookmark.png',
                      height: 32.h,
                      width: 24.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}