import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import '../controllers/page_manager.dart';

class MusicScreen extends StatelessWidget {
  MusicScreen(
    this.controller,
    this._pageManager, {
    Key? key,
  }) : super(key: key);
  final PageController controller;
  final PageManager _pageManager;

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ValueListenableBuilder(
            valueListenable: _pageManager.currentSongDetailNotifier,
            builder: (context, MediaItem value, child) {
              if (value.id == '-1') {
                return Image.asset(
                  'asset/images/default.jpg',
                  fit: BoxFit.cover,
                );
              } else {
                String image = value.artUri.toString();
                return SizedBox(
                    height: size.height,
                    width: size.width,
                    child: FadeInImage(
                      placeholder: const AssetImage('asset/images/default.jpg'),
                      image: NetworkImage(
                        image,
                      ),
                      fit: BoxFit.cover,
                    ));
              }
            }),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            color: Colors.grey[900]!.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.animateToPage(
                              0,
                              duration: const Duration(seconds: 2),
                              curve: Curves.linearToEaseOut,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable:
                                _pageManager.currentSongDetailNotifier,
                            builder: (context, MediaItem value, child) {
                              return Text(
                                'Now is ${value.title} playing',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _pageManager.currentSongDetailNotifier,
                      builder: (context, MediaItem value, child) {
                        if (value.id == '-1') {
                          return const CircleAvatar(
                            radius: 150,
                            backgroundImage:AssetImage(
                                'asset/images/default.jpg',
                          ),
                          );
                        } else {
                          String image = value.artUri.toString();
                          return CircleAvatar(
                            radius: 150,
                            backgroundImage:
                                const AssetImage('asset/images/default.jpg'),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: FadeInImage(
                                height: 295,
                                placeholder: const AssetImage(
                                    'asset/images/default.jpg'),
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      ValueListenableBuilder(
                          valueListenable:
                              _pageManager.currentSongDetailNotifier,
                          builder: (context, MediaItem value, child) {
                            String title = value.title;
                            String artist = value.artist ?? '';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artist,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 28),
                                ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                ),
                              ],
                            );
                          }),
                      const Spacer(),
                      const Icon(
                        Icons.favorite,
                        color: Colors.grey,
                        size: 39,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  ValueListenableBuilder<ProgressBarState>(
                      valueListenable: _pageManager.progressNotifier,
                      builder: (context, value, _) {
                        return ProgressBar(
                          progress: value.current,
                          total: value.total,
                          buffered: value.buffered,
                          bufferedBarColor: Colors.redAccent.withOpacity(0.5),
                          progressBarColor: Colors.red,
                          baseBarColor: Colors.grey,
                          thumbGlowColor: Colors.redAccent.withOpacity(0.5),
                          thumbColor: Colors.white,
                          timeLabelTextStyle: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          onSeek: _pageManager.seek,
                        );
                      }),
                  const SizedBox(
                    height: 36,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: _pageManager.repeatStateNotifier,
                          builder: (context, repeatState value, child) {
                            switch (value) {
                              case repeatState.off:
                                return IconButton(
                                  icon: const Icon(
                                    Icons.repeat,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.onRepeatPressed,
                                );
                              case repeatState.one:
                                return IconButton(
                                  icon: const Icon(
                                    Icons.repeat_one,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.onRepeatPressed,
                                );
                              case repeatState.all:
                                return IconButton(
                                  icon: const Icon(
                                    Icons.repeat,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.onRepeatPressed,
                                );
                            }
                          }),
                      ValueListenableBuilder(
                          valueListenable: _pageManager.isFirstSongNotifier,
                          builder: (context, bool value, child) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 35,
                              ),
                              color: Colors.white,
                              onPressed: value == true
                                  ? null
                                  : _pageManager.onPreviousPressed,
                            );
                          }),
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              colors: [
                                Colors.redAccent.withOpacity(0.8),
                                const Color(0xCC722520),
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                          ),
                          child: ValueListenableBuilder<ButtonState>(
                              valueListenable: _pageManager.buttonNotifier,
                              builder: (context, ButtonState value, _) {
                                switch (value) {
                                  case ButtonState.loading:
                                    return const CircularProgressIndicator();
                                  case ButtonState.playing:
                                    return Center(
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _pageManager.pause,
                                        icon: const Icon(
                                          Icons.pause,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  case ButtonState.paused:
                                    return Center(
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _pageManager.play,
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                }
                              })),
                      ValueListenableBuilder(
                          valueListenable: _pageManager.isLastSongNotifier,
                          builder: (context, bool value, child) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 35,
                              ),
                              color: Colors.white,
                              onPressed: value == true
                                  ? null
                                  : _pageManager.onNextPressed,
                            );
                          }),
                      ValueListenableBuilder(
                          valueListenable: _pageManager.volumeStateNotifier,
                          builder: (context, double value, child) {
                            if (value == 0) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.volume_off,
                                  size: 35,
                                ),
                                color: Colors.white,
                                onPressed: _pageManager.onVolumePressed,
                              );
                            } //
                            else {
                              return IconButton(
                                icon: const Icon(
                                  Icons.volume_up,
                                  size: 35,
                                ),
                                color: Colors.white,
                                onPressed: _pageManager.onVolumePressed,
                              );
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
