import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/app_styles/app_syles.dart';
import 'package:movies_app/core/colors_manager.dart';
import '../../../../../cubits_states/watchlist_cubit.dart';
import 'WatchListItem.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WatchlistCubit>().fetchWatchlist();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Text('WatchList', style: AppStyle.tabHeader),
          Expanded(
            child: BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WatchlistError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is WatchlistLoaded) {
                  final movies = state.movies;
                  if (movies.isEmpty) {
                    return const Center(child: Text('Your watchlist is empty.'));
                  }
                  return ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return WatchlistItem(
                        imageUrl: movie.imageUrl,
                        title: movie.title,
                        year: movie.runtime,
                        cast: movie.rating,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Divider(color: ColorsManager.dividerLine, height: 1),
                    itemCount: movies.length,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}


