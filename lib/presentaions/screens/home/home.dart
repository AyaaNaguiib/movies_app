import 'dart:async';
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
  bool isAdded = false;
  late Future<Map<String, dynamic>> data;
  int _selectedIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    data = ApiService.fetchData();
    _pageController = PageController(viewportFraction: 1.0);

    // Auto-scroll timer
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.toInt() + 1;
        if (nextPage >= 5) { // Assuming there are 5 movies
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   data = ApiService.fetchData();
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void toggleAddState() {
    setState(() {
      isAdded = !isAdded;
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
          const BrowseCategoriesScreen(),
           WatchListScreen(),
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
    return SizedBox(
      height: 300.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: newReleases.length,
        itemBuilder: (context, index) {
          final movie = newReleases[index];
          return Stack(
            children: [
              // Background Poster Image
              Image.network(
                "${ApiService.baseUrl}${movie['backdrop_path']}",
                width: MediaQuery.of(context).size.width,
                height: 240.h,
                fit: BoxFit.cover,
              ),
              // Gradient Overlay
              Container(
                height: 300.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, ColorsManager.bg],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 140.h,
                left: 16.w,
                child: Stack(
                  children: [
                    // Movie Poster
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        "${ApiService.baseUrl}${movie['poster_path']}",
                        width: 120.w,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8.h,
                      left: 8.w,
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
              ),
              Positioned(
                bottom: 5.h,
                left: 150.w,
                right: 16.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "2019 | PG-13 | 2h 7m",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorsManager.white.withOpacity(0.8),
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
                            movieId: movie['id'],
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundColor: ColorsManager.white,
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
        },
      ),
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

