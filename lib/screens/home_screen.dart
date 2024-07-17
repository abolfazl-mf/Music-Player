import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/controllers/page_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
    this.controller,
    this._pageManager, {
    Key? key,
  }) : super(key: key);
  final PageController controller;
  final PageManager _pageManager;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Container(
          height: 60,
          width: double.infinity,
          color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(
                Icons.music_note,
                size: 50,
              ),
              Center(
                child: Text(
                  'Play List',
                  style: TextStyle(color: Color(0xffff6ff00), fontSize: 26),
                ),
              ),
              Icon(
                Icons.music_note,
                size: 50,
              )
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: _pageManager.playListNotifier,
              builder: (context, List<MediaItem> song, child) {
                if (song.isEmpty) {
                  return const Text('No Data');
                }
                else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: song.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 1.5),
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                    fontSize: 18),
                              ),
                              radius: 14,
                            ),
                          ),
                          title: Text(song[index].title),
                          subtitle: Text(
                            song[index].artist ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          textColor: Colors.white,
                          tileColor: Color(0xFF051038),
                          trailing: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: const AssetImage('asset/images/default.jpg'),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: FadeInImage(
                                      height: 80,
                                      placeholder: const AssetImage(
                                          'asset/images/default.jpg'),
                                      image: NetworkImage(
                                          song[index].artUri!.toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          onTap: () {
                            controller.animateToPage(1,
                                duration: const Duration(seconds: 2),
                                curve: Curves.linearToEaseOut);
                            _pageManager.playFromPlayList(index);
                          },
                        ),
                      );
                    },
                  );
                }
              }),
        ),
        ValueListenableBuilder(
            valueListenable: _pageManager.currentSongDetailNotifier,
            builder: (context, MediaItem value, _) {
              if (value.id == '-1') {
                return Container();
              } else {
                return Container(
                  color: Colors.grey,
                  child: ListTile(
                    onTap: () {
                      controller.animateToPage(1,
                          duration: const Duration(seconds: 2),
                          curve: Curves.linearToEaseOut);
                    },
                    leading: CircleAvatar(
                      backgroundImage:
                          const AssetImage('asset/images/default.jpg'),
                      radius: 43,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(43),
                        child: FadeInImage(
                          height: 100,
                          placeholder:
                              const AssetImage('asset/images/default.jpg'),
                          image: NetworkImage(
                            value.artUri.toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      value.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      value.artist ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 23.0, bottom: 30),
                      child: ValueListenableBuilder(
                          valueListenable: _pageManager.buttonNotifier,
                          builder: (context, ButtonState value, child) {
                            switch (value) {
                              case ButtonState.loading:
                                return const CircularProgressIndicator(
                                  color: Colors.white,
                                );
                              case ButtonState.playing:
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.pause,
                                  icon: const Icon(
                                    Icons.pause_circle_outline_outlined,
                                    size: 55,
                                    color: Colors.black,
                                  ),
                                );
                              case ButtonState.paused:
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.play,
                                  icon: const Icon(
                                    Icons.play_circle_outline_outlined,
                                    size: 55,
                                    color: Colors.black,
                                  ),
                                );
                            }
                          }),
                    ),
                  ),
                );
              }
            }),
      ]),
    );
  }
}
