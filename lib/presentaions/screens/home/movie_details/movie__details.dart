// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../../../core/colors_manager.dart';
//
// class MovieDetails extends StatefulWidget {
//   final int movieId;
//   const MovieDetails({Key? key, required this.movieId}) : super(key: key);
//
//   @override
//   State<MovieDetails> createState() => _MovieDetailsState();
// }
//
// class _MovieDetailsState extends State<MovieDetails> {
//   String baseUrl = "https://image.tmdb.org/t/p/w500";
//   late Future<Map<String, dynamic>> movieData;
//   late Future<List<dynamic>> similarMovies;
//
//   Future<Map<String, dynamic>> fetchMovieDetails() async {
//     final response = await http.get(Uri.parse(
//         'https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=48c9c8777253bd8945c7d1da1a02653d'));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load movie details');
//     }
//   }
//
//   Future<List<dynamic>> fetchSimilarMovies() async {
//     final response = await http.get(Uri.parse(
//         'https://api.themoviedb.org/3/movie/${widget.movieId}/similar?api_key=48c9c8777253bd8945c7d1da1a02653d'));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['results'];
//     } else {
//       throw Exception('Failed to load similar movies');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     movieData = fetchMovieDetails();
//     similarMovies = fetchSimilarMovies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: movieData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final movie = snapshot.data!;
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Movie Banner
//                   Stack(
//                     children: [
//                       Image.network(
//                         "$baseUrl${movie['backdrop_path']}",
//                         width: double.infinity,
//                         height: 250.h,
//                         fit: BoxFit.cover,
//                       ),
//                       Container(
//                         height: 250.h,
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.transparent, Colors.black],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 20.h,
//                         left: 20.w,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               movie['title'],
//                               style: TextStyle(
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             Text(
//                               "${movie['release_date'].split('-')[0]} | ${movie['runtime']} min",
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Genre Tags
//                         Wrap(
//                           spacing: 8.w,
//                           children: List.generate(
//                             movie['genres'].length,
//                                 (index) => Chip(
//                               backgroundColor: ColorsManager.bottomNavBar,
//                               label: Text(
//                                 movie['genres'][index]['name'],
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20.h),
//
//                         // Overview
//                         Text(
//                           movie['overview'],
//                           style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                         ),
//                         SizedBox(height: 20.h),
//
//                         // Rating
//                         Row(
//                           children: [
//                             Icon(Icons.star, color: ColorsManager.yellow),
//                             SizedBox(width: 5.w),
//                             Text(
//                               movie['vote_average'].toString(),
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20.h),
//
//                         // Similar Movies Section
//                         Text(
//                           "More Like This",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                         FutureBuilder<List<dynamic>>(
//                           future: similarMovies,
//                           builder: (context, similarSnapshot) {
//                             if (similarSnapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             } else if (similarSnapshot.hasError) {
//                               return Center(
//                                   child: Text(
//                                       'Error: ${similarSnapshot.error}'));
//                             } else {
//                               return SizedBox(
//                                 height: 200.h,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: similarSnapshot.data!.length,
//                                   itemBuilder: (context, index) {
//                                     final similarMovie =
//                                     similarSnapshot.data![index];
//                                     return GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 MovieDetails(
//                                                     movieId: similarMovie[
//                                                     'id']),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         width: 120.w,
//                                         margin: EdgeInsets.only(left: 16.w),
//                                         child: Column(
//                                           children: [
//                                             Image.network(
//                                               "$baseUrl${similarMovie['poster_path']}",
//                                               height: 150.h,
//                                               fit: BoxFit.cover,
//                                             ),
//                                             SizedBox(height: 5.h),
//                                             Text(
//                                               similarMovie['title'],
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                 fontSize: 14.sp,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/movie_details_API.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/more_like_this.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/movie_info.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/overview.dart';
import '../../../../core/colors_manager.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;
  const MovieDetails({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<Map<String, dynamic>> movieData;
  late Future<List<dynamic>> similarMovies;

  @override
  void initState() {
    super.initState();
    movieData = MovieService.fetchMovieDetails(widget.movieId);
    similarMovies = MovieService.fetchSimilarMovies(widget.movieId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.bg,
      body: FutureBuilder<Map<String, dynamic>>(
        future: movieData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movie = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      movie['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: Stack(
                      children: [
                        Image.network(
                          "https://image.tmdb.org/t/p/w500${movie['backdrop_path']}",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 70.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieInfo(movie: movie),
                        const SizedBox(height: 20),
                        Overview(overview: movie['overview']),
                        const SizedBox(height: 20),
                        MoreLikeThis(
                          similarMoviesFuture: similarMovies,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../../../core/colors_manager.dart';
//
// class MovieDetails extends StatefulWidget {
//   final int movieId;
//   const MovieDetails({Key? key, required this.movieId}) : super(key: key);
//
//   @override
//   State<MovieDetails> createState() => _MovieDetailsState();
// }
//
// class _MovieDetailsState extends State<MovieDetails> {
//   String baseUrl = "https://image.tmdb.org/t/p/w500";
//   late Future<Map<String, dynamic>> movieData;
//   late Future<List<dynamic>> similarMovies;
//
//   Future<Map<String, dynamic>> fetchMovieDetails() async {
//     final response = await http.get(Uri.parse(
//         'https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=48c9c8777253bd8945c7d1da1a02653d'));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load movie details');
//     }
//   }
//
//   Future<List<dynamic>> fetchSimilarMovies() async {
//     final response = await http.get(Uri.parse(
//         'https://api.themoviedb.org/3/movie/${widget.movieId}/similar?api_key=48c9c8777253bd8945c7d1da1a02653d'));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['results'];
//     } else {
//       throw Exception('Failed to load similar movies');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     movieData = fetchMovieDetails();
//     similarMovies = fetchSimilarMovies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.bg,
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: movieData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final movie = snapshot.data!;
//             return CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   expandedHeight: 250.h,
//                   pinned: true,
//                   flexibleSpace: FlexibleSpaceBar(
//                     title: Text(
//                       movie['title'],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     background: Stack(
//                       children: [
//                         Image.network(
//                           "$baseUrl${movie['backdrop_path']}",
//                           width: double.infinity,
//                           height: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                         Container(
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Colors.transparent, Colors.black],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Icon(
//                             Icons.play_circle_fill,
//                             color: Colors.white,
//                             size: 70.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Movie Details Section
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8.r),
//                               child: Image.network(
//                                 "$baseUrl${movie['poster_path']}",
//                                 width: 100.w,
//                                 height: 150.h,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(width: 16.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "${movie['release_date'].split('-')[0]} | ${movie['runtime']} min",
//                                     style: TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 14.sp,
//                                     ),
//                                   ),
//                                   SizedBox(height: 10.h),
//                                   Wrap(
//                                     spacing: 8.w,
//                                     children: List.generate(
//                                       movie['genres'].length,
//                                           (index) => Chip(
//                                         backgroundColor:
//                                         ColorsManager.bottomNavBar,
//                                         label: Text(
//                                           movie['genres'][index]['name'],
//                                           style: const TextStyle(
//                                               color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10.h),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.star,
//                                           color: ColorsManager.yellow),
//                                       SizedBox(width: 5.w),
//                                       Text(
//                                         movie['vote_average'].toString(),
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16.sp,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20.h),
//                         // Overview Section
//                         Text(
//                           movie['overview'],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                         SizedBox(height: 20.h),
//                         Text(
//                           "More Like This",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//
//                         FutureBuilder<List<dynamic>>(
//                           future: similarMovies,
//                           builder: (context, similarSnapshot) {
//                             if (similarSnapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             } else if (similarSnapshot.hasError) {
//                               return Center(
//                                   child: Text(
//                                       'Error: ${similarSnapshot.error}')
//                               );
//                             } else {
//                               return SizedBox(
//                                 height: 200.h,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: similarSnapshot.data!.length,
//                                   itemBuilder: (context, index) {
//                                     final similarMovie =
//                                     similarSnapshot.data![index];
//                                     return GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 MovieDetails(
//                                                     movieId:
//                                                     similarMovie['id']),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         width: 120.w,
//                                         margin: EdgeInsets.only(left: 16.w),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                               BorderRadius.circular(8.r),
//                                               child: Image.network(
//                                                 "$baseUrl${similarMovie['poster_path']}",
//                                                 height: 150.h,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5.h),
//                                             Text(
//                                               similarMovie['title'],
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                 fontSize: 14.sp,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }

