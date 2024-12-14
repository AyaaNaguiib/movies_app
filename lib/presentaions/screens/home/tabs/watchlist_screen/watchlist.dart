import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/app_styles/app_syles.dart';
import 'movieItem.dart';

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

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Your watchlist is empty.'));
                }

                else {
                  final movies = snapshot.data!.docs;
                  return ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final movie = movies[index].data() as Map<String, dynamic>;
                      final imageUrl = movie['imageUrl'] ?? 'default_image_url';
                      final title = movie['title'] ?? 'Unknown Title';
                      final year = movie['runtime'] ?? 'Unknown Year';
                      final cast = movie['rating'] ?? 'Unknown Cast';

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




