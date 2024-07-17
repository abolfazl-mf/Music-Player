import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/playlist_repository.dart';
import '../services/service_locator.dart'; //

class PageManager {
  final _audioHandler = getIt<AudioHandler>();

  // final AudioPlayer _audioPlayer;

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
        current: Duration.zero, buffered: Duration.zero, total: Duration.zero),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
  final currentSongDetailNotifier = ValueNotifier<MediaItem>(const MediaItem(
    id: '-1',
    title: '',
  ));
  final playListNotifier = ValueNotifier<List<MediaItem>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatStateNotifier = RepeatStateNotifier();
  final volumeStateNotifier = ValueNotifier<double>(1);

  // late ConcatenatingAudioSource _playlist;

  PageManager() {
    _init();
  }

  void _init() async {
    _loadPlayList();
    _listenChangeInPlayList();
    _listenToPlayBackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToCurrentSong();
    // setInitialPlayList();
    // listenChangePlayState();
    // listenChangePositionStreamState();
    // listenChangeBufferedPositionStreamState();
    // listenChangeTotalPositionStreamState();
    // listenSequenceStateStream(); //حالت ها رو بر میگردونه مثلا اخرین اهنگ هست یا نه یا تکرار یا اولین اهنگ هست یا نه و..
  }

  Future _loadPlayList() async {
    final songRepository = getIt<PlayListRepository>();
    final playList = await songRepository.fetchMyPlayList();
    final mediaItems = playList
        .map(
          (song) =>
          MediaItem(
            id: song['id'] ?? '-1',
            title: song['title'] ?? '-1',
            artist: song['artist'],
            artUri: Uri.parse(
              song['artUri'] ?? '-1',
            ),
            extras: {'url': song['url']},
          ),
    ).toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  _listenChangeInPlayList() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        return;
      } //
      final newList = playlist..map((item) => item).toList();
      playListNotifier.value = newList;
    });
  }

  void _listenToPlayBackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  _listenToCurrentSong() {
    final playList = _audioHandler.queue.value;
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongDetailNotifier.value =
          mediaItem ?? const MediaItem(id: '-1', title: '');
      if (playList.isEmpty || mediaItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } //
      else {
        isFirstSongNotifier.value = playList.first == mediaItem;
        isLastSongNotifier.value = playList.last == mediaItem;
      }
    });
  }

  _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total);
    });
  }

  _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playBackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: playBackState.bufferedPosition,
          total: oldState.total);
    });
  }

  _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(current: oldState.current,
          buffered: oldState.buffered,
          total: mediaItem!.duration??Duration.zero);
    });
  }

  // void _setInitialPlayList() async {
  //   // const String _url =
  //   //     'https://dl.musicdel.ir/Music/1400/05/ckay_love_nwantiti%20128.mp3';
  //   // if (_audioPlayer.bufferedPosition == Duration.zero) {
  //   //   await _audioPlayer.setUrl(_url);
  //   // }
  //   // const prefiximage = 'asset/images';
  //   // final song1 = Uri.parse(
  //   //     'https://dl.musicdel.ir/Music/1400/05/ckay_love_nwantiti%20128.mp3');
  //   // final song2 = Uri.parse(
  //   //     'https://irsv.upmusics.com/99/Behnam%20Bani%20-%20Khoshhalam%20(320).mp3');
  //   // final song3 = Uri.parse(
  //   //     'https://irsv.upmusics.com/99/Mohsen%20Ebrahimzadeh%20-%20Doone%20Doone%202(320).mp3');
  //   // final song4 = Uri.parse(
  //   //     'https://dl.naslemusic.com/music/1395/04/Sina%20Hejazi%20-%20Zaar%20Nazan%20(128).mp3');
  //   // _playlist = ConcatenatingAudioSource(children: [
  //   //   AudioSource.uri(song1,
  //   //       tag: AudioMetaData(
  //   //           title: 'Love nwantiti',
  //   //           artist: 'Ckay',
  //   //           imageAddress: '$prefiximage/nwan.jpg')),
  //   //   AudioSource.uri(song2,
  //   //       tag: AudioMetaData(
  //   //           title: 'Khoshhalam',
  //   //           artist: 'Behnam Bani',
  //   //           imageAddress: '$prefiximage/bani.jpg')),
  //   //   AudioSource.uri(song3,
  //   //       tag: AudioMetaData(
  //   //           title: 'Doone Doone 2',
  //   //           artist: 'Mohsen Ebrahimzadeh',
  //   //           imageAddress: '$prefiximage/doone.jpg')),
  //   //   AudioSource.uri(song4,
  //   //       tag: AudioMetaData(
  //   //           title: 'Zaar Nazan',
  //   //           artist: 'Sina Hejazi',
  //   //           imageAddress: '$prefiximage/zaar.jpg')),
  //   // ]);
  //   if (_audioPlayer.bufferedPosition == Duration.zero) {
  //     _audioPlayer.setAudioSource(_playlist);
  //   }
  // }
  //
  // void _listenChangePlayState() {
  //   _audioPlayer.playerStateStream.listen((playerStream) {
  //     final playing = playerStream.playing;
  //     final processingState = playerStream.processingState;
  //     if (processingState == ProcessingState.loading ||
  //         processingState == ProcessingState.buffering) {
  //       buttonNotifier.value = ButtonState.loading;
  //     } //
  //     else if (!playing) {
  //       buttonNotifier.value = ButtonState.paused;
  //     } //
  //     else if (processingState == ProcessingState.completed) {
  //       _audioPlayer.stop();
  //     } else {
  //       buttonNotifier.value = ButtonState.playing;
  //     }
  //   });
  // }
  //
  // void _listenChangePositionStreamState() {
  //   _audioPlayer.positionStream.listen((position) {
  //     final oldState = progressNotifier.value;
  //     progressNotifier.value = ProgressBarState(
  //         current: position,
  //         buffered: oldState.buffered,
  //         total: oldState.total);
  //   });
  // }
  //
  // void _listenChangeBufferedPositionStreamState() {
  //   _audioPlayer.bufferedPositionStream.listen((position) {
  //     final oldState = progressNotifier.value;
  //     progressNotifier.value = ProgressBarState(
  //         current: oldState.current, buffered: position, total: oldState.total);
  //   });
  // }
  //
  // void _listenChangeTotalPositionStreamState() {
  //   _audioPlayer.durationStream.listen((position) {
  //     final oldState = progressNotifier.value;
  //     progressNotifier.value = ProgressBarState(
  //         current: oldState.current,
  //         buffered: oldState.buffered,
  //         total: position ?? Duration.zero);
  //   });
  // }
  //
  // void _listenSequenceStateStream() {
  //   _audioPlayer.sequenceStateStream.listen((sequenceState) {
  //     if (sequenceState == null) {
  //       return;
  //     }
  //     final currentItem = sequenceState.currentSource;
  //     final song = currentItem!.tag as AudioMetaData;
  //     currentSongDetailNotifier.value = song;
  //     final playList = sequenceState.effectiveSequence;
  //     final title = playList.map((song) {
  //       return song.tag as AudioMetaData;
  //     }).toList();
  //     playListNotifier.value = title;
  //     if (playList.isEmpty || currentItem == null) {
  //       isFirstSongNotifier.value = true;
  //       isFirstSongNotifier.value = true;
  //     } //
  //     else {
  //       isFirstSongNotifier.value = playList.first == currentItem;
  //       isLastSongNotifier.value = playList.last == currentItem;
  //     }
  //     //volume
  //     if (_audioPlayer.volume != 0) {
  //       volumeStateNotifier.value = 1;
  //     } else {
  //       volumeStateNotifier.value = 0;
  //     }
  //   });
  // }

  void onVolumePressed() {
    if (volumeStateNotifier.value != 0) {
      _audioHandler.androidSetRemoteVolume(0);
      volumeStateNotifier.value = 0;
    } else {
      _audioHandler.androidSetRemoteVolume(1);
      volumeStateNotifier.value = 1;
    }
  }

  void onRepeatPressed() {
    repeatStateNotifier.nextState();
    switch (repeatStateNotifier.value) {
      case repeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case repeatState.one:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case repeatState.all:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void onPreviousPressed() {
    _audioHandler.skipToPrevious();
  }

  void onNextPressed() {
    _audioHandler.skipToNext();
  }

  void play() {
    _audioHandler.play();
  }

  void pause() {
    _audioHandler.pause();
  }

  void seek(position) {
    _audioHandler.seek(position);
  }

  void playFromPlayList(index) {
    _audioHandler.skipToQueueItem(index);
  }
}

// class AudioMetaData {
//   final String title;
//   final String artist;
//   final String imageAddress;
//
//   AudioMetaData(
//       {required this.title, required this.artist, required this.imageAddress});
// }

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

enum ButtonState { paused, playing, loading }
enum repeatState { one, all, off }

class RepeatStateNotifier extends ValueNotifier<repeatState> {
  RepeatStateNotifier() : super(_initialValue);
  static const _initialValue = repeatState.off;

  void nextState() {
    var next = (value.index + 1) % repeatState.values.length;
    value = repeatState.values[next];
  }
}
