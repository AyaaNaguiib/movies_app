import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:movies_app/presentaions/screens/home/tabs/search/API.dart';
import 'package:movies_app/presentaions/screens/home/tabs/search/search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> searchResults;

  @override
  void initState() {
    super.initState();
    searchResults = Future.value([]);
  }

  void onSearch() {
    setState(() {
      searchResults = SearchService.searchMovies(_searchController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.bg,
      appBar: AppBar(
        backgroundColor: ColorsManager.bg,
        elevation: 0,
        title: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: ColorsManager.searchBar,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: ColorsManager.white, fontSize: 16.sp),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: ColorsManager.white),
              hintText: "Search",
              hintStyle: TextStyle(color: ColorsManager.white, fontSize: 14.sp,fontWeight: FontWeight.w400),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 8.h),
            ),
            onSubmitted: (value) => onSearch(),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: ColorsManager.localMoviesIcon),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_movies, size: 80.sp, color: ColorsManager.localMoviesIcon),
                  SizedBox(height: 10.h),
                  Text(
                    'No movies found',
                    style: TextStyle(color: ColorsManager.white, fontSize: 18.sp,fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(
                color: ColorsManager.dividerLine,
                thickness: 1.h,
                indent: 15.w,
                endIndent: 15.w,
              ),
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return SearchResultItem(movie: movie, baseUrl: SearchService.imageUrl);
              },
            );
          }
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:movies_app/core/colors_manager.dart';
// import 'package:movies_app/presentaions/screens/home/tabs/search/API.dart';
// import 'package:movies_app/presentaions/screens/home/tabs/search/search_result.dart';
//
// import '../../movie_details/movie__details.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late Future<List<dynamic>> searchResults;
//
//   @override
//   void initState() {
//     super.initState();
//     searchResults = Future.value([]);
//   }
//
//   void onSearch() {
//     setState(() {
//       searchResults = SearchService.searchMovies(_searchController.text.trim());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.bg,
//       appBar: AppBar(
//         backgroundColor: ColorsManager.bg,
//         elevation: 0,
//         title: Container(
//           height: 40.h,
//           decoration: BoxDecoration(
//             color: ColorsManager.searchBar,
//             borderRadius: BorderRadius.circular(15.r),
//           ),
//           child: TextField(
//             controller: _searchController,
//             style: TextStyle(color: ColorsManager.white, fontSize: 16.sp),
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.search, color: ColorsManager.white),
//               hintText: "Search",
//               hintStyle: TextStyle(color: ColorsManager.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 8.h),
//             ),
//             onSubmitted: (value) => onSearch(),
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: searchResults,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: TextStyle(color: ColorsManager.localMoviesIcon),
//               ),
//             );
//           } else if (snapshot.data!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.local_movies, size: 80.sp, color: ColorsManager.localMoviesIcon),
//                   SizedBox(height: 10.h),
//                   Text(
//                     'No movies found',
//                     style: TextStyle(color: ColorsManager.white, fontSize: 18.sp, fontWeight: FontWeight.w400),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return ListView.separated(
//               itemCount: snapshot.data!.length,
//               separatorBuilder: (context, index) => Divider(
//                 color: ColorsManager.dividerLine,
//                 thickness: 1.h,
//                 indent: 15.w,
//                 endIndent: 15.w,
//               ),
//               itemBuilder: (context, index) {
//                 final movie = snapshot.data![index];
//                 return GestureDetector(
//                   onTap: () {
//                     // Navigate to the MovieDetails screen with the selected movie ID
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MovieDetails(movieId: movie['id']),
//                       ),
//                     );
//                   },
//                   child: SearchResultItem(movie: movie, baseUrl: SearchService.imageUrl),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
