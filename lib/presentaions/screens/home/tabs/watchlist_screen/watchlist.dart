// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:movies_app/core/colors_manager.dart';
//
// import '../../movie_details/movie__details.dart';
// import '../../movie_details/widgets/movie_details_API.dart';
//
//
// class WatchlistScreen extends StatefulWidget {
//   const WatchlistScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WatchlistScreen> createState() => _WatchlistScreenState();
// }
//
// class _WatchlistScreenState extends State<WatchlistScreen> {
//   List<Map<String, dynamic>> _watchlist = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWatchlist();
//   }
//
//   Future<void> _fetchWatchlist() async {
//     final watchlist = await MovieService.fetchWatchlist();
//     setState(() {
//       _watchlist = watchlist;
//     });
//   }
//
//   Future<void> _removeFromWatchlist(int movieId) async {
//     await MovieService.removeFromWatchlist(movieId);
//     _fetchWatchlist();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Watchlist'),
//         backgroundColor: ColorsManager.bg,
//       ),
//       body: _watchlist.isEmpty
//           ? Center(
//         child: Text(
//           'Your watchlist is empty',
//           style: TextStyle(color: ColorsManager.white, fontSize: 16.sp),
//         ),
//       )
//           : ListView.builder(
//         itemCount: _watchlist.length,
//         itemBuilder: (context, index) {
//           final movie = _watchlist[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MovieDetails(movieId: movie['id']),
//                 ),
//               );
//             },
//             child: Card(
//               color: ColorsManager.recommendedCard,
//               child: Row(
//                 children: [
//                   Image.network(
//                     movie['imageUrl'],
//                     height: 100.h,
//                     width: 80.w,
//                     fit: BoxFit.cover,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.w),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             movie['title'],
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.bold,
//                               color: ColorsManager.white,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             movie['runtime'],
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: ColorsManager.grey,
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             movie['rating'],
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: ColorsManager.yellow,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => _removeFromWatchlist(movie['id']),
//                     icon: Icon(Icons.delete, color: ColorsManager.white),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/app_styles/app_syles.dart';
import 'movie_item.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Text(
            'WatchList',
            style: AppStyle.tabHeader,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('watchlist')
                  .snapshots(),
              builder: (context, snapshot) {
                // Show a loading indicator while waiting for data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Handle errors in the stream
                else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                // Show a message if the watchlist is empty
                else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Your watchlist is empty.'));
                }
                // If data is available, display the movies
                else {
                  final movies = snapshot.data!.docs;
                  return ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final movie = movies[index].data() as Map<String, dynamic>;

                      // Safely extract data with default values in case of null
                      final imageUrl = movie['imageUrl'] ?? 'default_image_url'; // Provide default image URL if null
                      final title = movie['title'] ?? 'Unknown Title';
                      final year = movie['runtime'] ?? 'Unknown Year';  // Default to 'Unknown Year' if null
                      final cast = movie['rating'] ?? 'Unknown Cast';  // Default to 'Unknown Cast' if null

                      return WatchlistItem(
                        imageUrl: imageUrl,
                        title: title,
                        year: year,
                        cast: cast,
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: ColorsManager.grey,
                      height: 1,
                    ),
                    itemCount: movies.length,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:movies_app/core/colors_manager.dart';
//
// import '../../../../../core/app_styles/app_syles.dart';
// import 'movie_item.dart';
// class WatchListScreen extends StatelessWidget {
//   const WatchListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 30.h),
//           Text(
//             'WatchList',
//             style: AppStyle.tabHeader,
//           ),
//           Expanded(
//               child: ListView.separated(
//                   padding: EdgeInsets.all(0),
//                   itemBuilder: (context, index) => WatchlistItem(),
//                   separatorBuilder: (context, index) => Divider( color: ColorsManager.grey,
//                     height: 1,
//                   ),
//                   itemCount: 4))
//         ],
//       ),
//     );
//   }
// }


