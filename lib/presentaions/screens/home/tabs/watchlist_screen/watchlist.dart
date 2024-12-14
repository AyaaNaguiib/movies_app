import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';

import '../../movie_details/movie__details.dart';
import '../../movie_details/widgets/movie_details_API.dart';


class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<Map<String, dynamic>> _watchlist = [];

  @override
  void initState() {
    super.initState();
    _fetchWatchlist();
  }

  Future<void> _fetchWatchlist() async {
    final watchlist = await MovieService.fetchWatchlist();
    setState(() {
      _watchlist = watchlist;
    });
  }

  Future<void> _removeFromWatchlist(int movieId) async {
    await MovieService.removeFromWatchlist(movieId);
    _fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        backgroundColor: ColorsManager.bg,
      ),
      body: _watchlist.isEmpty
          ? Center(
        child: Text(
          'Your watchlist is empty',
          style: TextStyle(color: ColorsManager.white, fontSize: 16.sp),
        ),
      )
          : ListView.builder(
        itemCount: _watchlist.length,
        itemBuilder: (context, index) {
          final movie = _watchlist[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetails(movieId: movie['id']),
                ),
              );
            },
            child: Card(
              color: ColorsManager.recommendedCard,
              child: Row(
                children: [
                  Image.network(
                    movie['imageUrl'],
                    height: 100.h,
                    width: 80.w,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            movie['runtime'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorsManager.grey,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            movie['rating'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorsManager.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeFromWatchlist(movie['id']),
                    icon: Icon(Icons.delete, color: ColorsManager.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



