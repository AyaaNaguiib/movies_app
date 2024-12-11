import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:movies_app/core/assets_manager.dart';
import 'package:movies_app/presentaions/screens/home/tabs/browse_screen/browse.dart';
import 'package:movies_app/presentaions/screens/home/tabs/search/search.dart';
import 'package:movies_app/presentaions/screens/home/tabs/watchlist_screen/watchlist.dart';
import 'API_home_Screen/API.dart';
import 'cards/newrelease.dart';
import 'cards/recommended.dart';
import 'movie_details/movie__details.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>> data;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    data = ApiService.fetchData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.bg,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreen(),
          const SearchScreen(),
          const Browse(),
          const WatchList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsManager.bottomNavBar,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorsManager.yellow,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetsManager.homeIcon)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetsManager.searchIcon)),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetsManager.browseIcon)),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetsManager.watchListIcon)),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return FutureBuilder<Map<String, dynamic>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final newReleases = snapshot.data!["newReleases"]["results"];
          final recommended = snapshot.data!["recommended"]["results"];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopPoster(newReleases),
                SizedBox(height: 20.h),
                buildSection(
                  title: "New Releases",
                  movieList: newReleases,
                  cardBuilder: (movie) => NewReleaseCard(
                    imageUrl: "${ApiService.baseUrl}${movie['poster_path']}",
                    title: movie['title'],
                    movieId: movie['id'],
                  ),
                ),
                SizedBox(height: 20.h),
                buildSection(
                  title: "Recommended",
                  movieList: recommended,
                  cardBuilder: (movie) => RecommendedCard(
                    imageUrl: "${ApiService.baseUrl}${movie['poster_path']}",
                    title: movie['title'],
                    rating: movie['vote_average'].toString(),
                    runtime: "1h 50m", // Placeholder runtime
                    movieId: movie['id'],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildTopPoster(List<dynamic> newReleases) {
    return Stack(
      children: [
        Image.network(
          "${ApiService.baseUrl}${newReleases[0]['backdrop_path']}",
          width: double.infinity,
          height: 250.h,
          fit: BoxFit.cover,
        ),
        Container(
          height: 250.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, ColorsManager.bg],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: 20.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newReleases[0]['title'],
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.white,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "2019 | PG-13 | 2h 7m", // Placeholder runtime
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.white,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(
                      movieId: newReleases[0]['id'],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: ColorsManager.white.withOpacity(0.7),
                child: Icon(
                  Icons.play_arrow,
                  size: 40.sp,
                  color: ColorsManager.bg,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSection({
    required String title,
    required List<dynamic> movieList,
    required Widget Function(dynamic movie) cardBuilder,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorsManager.grey,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: title == "Recommended" ? 260.h : 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movieList.length,
                itemBuilder: (context, index) => cardBuilder(movieList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:movies_app/core/colors_manager.dart';
// import 'package:movies_app/core/assets_manager.dart';
// import 'package:movies_app/presentaions/screens/home/tabs/search/search.dart';
// import '../../../API/movie_details_API.dart';
// import 'cards/newrelease.dart';
// import 'cards/recommended.dart';
// import 'movie_details/movie__details.dart';
//
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   late Future<Map<String, dynamic>> data;
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     data = ApiService.fetchData();
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.bg,
//       body: _selectedIndex == 0
//           ? FutureBuilder<Map<String, dynamic>>(
//         future: data,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else {
//             final newReleases = snapshot.data!["newReleases"]["results"];
//             final recommended = snapshot.data!["recommended"]["results"];
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top Poster Section
//                   Stack(
//                     children: [
//                       Image.network(
//                         "${ApiService.baseUrl}${newReleases[0]['backdrop_path']}",
//                         width: double.infinity,
//                         height: 250.h,
//                         fit: BoxFit.cover,
//                       ),
//                       Container(
//                         height: 250.h,
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.transparent, ColorsManager.bg],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 40.h,
//                         left: 20.w,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               newReleases[0]['title'],
//                               style: TextStyle(
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: ColorsManager.white,
//                               ),
//                             ),
//                             SizedBox(height: 5.h),
//                             Text(
//                               "2019 | PG-13 | 2h 7m", // Placeholder runtime
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: ColorsManager.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Centered Play Button
//                       Positioned.fill(
//                         child: Center(
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MovieDetails(
//                                     movieId: newReleases[0]['id'],
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: CircleAvatar(
//                               radius: 30.r,
//                               backgroundColor:
//                               ColorsManager.white.withOpacity(0.7),
//                               child: Icon(
//                                 Icons.play_arrow,
//                                 size: 40.sp,
//                                 color: ColorsManager.bg,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                   // New Releases Section
//                   buildSection(
//                     title: "New Releases",
//                     movieList: newReleases,
//                     cardBuilder: (movie) => NewReleaseCard(
//                       imageUrl:
//                       "${ApiService.baseUrl}${movie['poster_path']}",
//                       title: movie['title'],
//                       movieId: movie['id'],
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   // Recommended Section
//                   buildSection(
//                     title: "Recommended",
//                     movieList: recommended,
//                     cardBuilder: (movie) => RecommendedCard(
//                       imageUrl:
//                       "${ApiService.baseUrl}${movie['poster_path']}",
//                       title: movie['title'],
//                       rating: movie['vote_average'].toString(),
//                       runtime: "1h 50m", // Placeholder runtime
//                       movieId: movie['id'],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       )
//           : _selectedIndex == 1
//           ? const SearchScreen()
//           : Center(
//         child: Text(
//           _selectedIndex == 2
//               ? "Browse Screen"
//               : "Watchlist Screen",
//           style: TextStyle(color: Colors.white, fontSize: 20.sp),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: ColorsManager.bottomNavBar,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: ColorsManager.yellow,
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(
//             icon: ImageIcon(AssetImage(AssetsManager.homeIcon)),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: ImageIcon(AssetImage(AssetsManager.searchIcon)),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: ImageIcon(AssetImage(AssetsManager.browseIcon)),
//             label: 'Browse',
//           ),
//           BottomNavigationBarItem(
//             icon: ImageIcon(AssetImage(AssetsManager.watchListIcon)),
//             label: 'Watchlist',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSection({
//     required String title,
//     required List<dynamic> movieList,
//     required Widget Function(dynamic movie) cardBuilder,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Container(
//         padding: EdgeInsets.all(12.w),
//         decoration: BoxDecoration(
//           color: ColorsManager.grey,
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 color: ColorsManager.white,
//               ),
//             ),
//             SizedBox(height: 10.h),
//             SizedBox(
//               height: title == "Recommended" ? 260.h : 200.h,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: movieList.length,
//                 itemBuilder: (context, index) => cardBuilder(movieList[index]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
