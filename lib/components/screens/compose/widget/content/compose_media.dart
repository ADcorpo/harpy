import 'dart:io';

import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:video_player/video_player.dart';

class ComposeTweetMedia extends StatelessWidget {
  const ComposeTweetMedia();

  Widget _buildImages(ComposeState state) {
    return TweetMediaLayout(
      child: TweetImagesLayout(
        children: state.media
            .map((PlatformFile imageFile) => Image.file(
                  File(imageFile.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildGif(ComposeState state) {
    return TweetMediaLayout(
      child: TweetImagesLayout(
        children: <Widget>[
          Image.file(
            File(state.media.first.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ComposeBloc bloc = context.watch<ComposeBloc>();
    final ComposeState state = bloc.state;

    Widget child;

    switch (state.type) {
      case MediaType.image:
        child = _buildImages(state);
        break;
      case MediaType.gif:
        child = _buildGif(state);
        break;
      case MediaType.video:
        child = ComposeMediaVideo(
          bloc: bloc,
          key: Key(state.media.first.path),
        );
        break;
      default:
        child = const SizedBox();
        break;
    }

    return Padding(
      padding: DefaultEdgeInsets.all(),
      child: Stack(
        children: <Widget>[
          child,
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(defaultSmallPaddingValue),
              child: CircleButton(
                color: Colors.black45,
                onTap: () => bloc.add(const ClearComposedTweet()),
                child: const Icon(CupertinoIcons.xmark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComposeMediaVideo extends StatefulWidget {
  const ComposeMediaVideo({
    @required this.bloc,
    Key key,
  }) : super(key: key);

  final ComposeBloc bloc;

  @override
  _ComposeMediaVideoState createState() => _ComposeMediaVideoState();
}

class _ComposeMediaVideoState extends State<ComposeMediaVideo> {
  VideoPlayerController _controller;

  double get _aspectRatio => _controller?.value?.aspectRatio ?? 16 / 9;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(
      File(widget.bloc.state.media.first.path),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _initController();
  }

  Future<void> _initController() async {
    try {
      await _controller.initialize();

      if (_controller.value.duration > const Duration(seconds: 140)) {
        // video too long
        widget.bloc.add(const ClearComposedTweet());
        app<MessageService>().show(
          'video must be shorter than 140 seconds',
        );
      } else if (_controller.value.duration <
          const Duration(milliseconds: 500)) {
        // video too short
        widget.bloc.add(const ClearComposedTweet());
        app<MessageService>().show('video must be longer than 0.5 seconds');
      } else {
        setState(() {});
      }
    } catch (e) {
      // invalid video
      widget.bloc.add(const ClearComposedTweet());
      app<MessageService>().show('invalid video');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweetMediaLayout(
      isImage: false,
      videoAspectRatio: _aspectRatio,
      child: ClipRRect(
        key: ValueKey<VideoPlayerController>(_controller),
        clipBehavior: Clip.hardEdge,
        borderRadius: kDefaultBorderRadius,
        child: HarpyVideoPlayer.fromController(
          _controller,
          allowVerticalOverflow: true,
        ),
      ),
    );
  }
}
