import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_image.dart';
import 'package:harpy/components/common/video_player/harpy_gif_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/timeline/media_timeline/model/media_timeline_model.dart';
import 'package:harpy/core/preferences/media_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:video_player/video_player.dart';

/// Builds the widget for a [MediaTimelineEntry] in the [HarpyMediaGallery]
/// for a [MediaTimeline].
class MediaTimelineGalleryWidget extends StatelessWidget {
  const MediaTimelineGalleryWidget({
    @required this.entry,
    @required this.initialIndex,
    @required this.index,
    this.videoPlayerModel,
  });

  final MediaTimelineEntry entry;
  final int initialIndex;
  final int index;

  /// Used to build the gif or video when the initial index is a playing gif
  /// or video.
  ///
  /// This is used to prevent having to re initialize the video or gif when it
  /// is already initialized.
  final HarpyVideoPlayerModel videoPlayerModel;

  Widget _buildImage() {
    return HarpyImage(imageUrl: entry.imageData.appropriateUrl);
  }

  Widget _buildGif() {
    if (initialIndex == index && videoPlayerModel != null) {
      return HarpyGifPlayer.fromModel(
        videoPlayerModel,
        thumbnail: entry.videoData.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData.aspectRatioDouble,
        autoplay: app<MediaPreferences>().shouldAutoplayMedia,
      );
    } else {
      return HarpyGifPlayer.fromController(
        VideoPlayerController.network(
          entry.videoData.appropriateUrl,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        thumbnail: entry.videoData.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData.aspectRatioDouble,
        autoplay: app<MediaPreferences>().shouldAutoplayMedia,
      );
    }
  }

  Widget _buildVideo() {
    if (initialIndex == index && videoPlayerModel != null) {
      return HarpyVideoPlayer.fromModel(
        videoPlayerModel,
        thumbnail: entry.videoData.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData.aspectRatioDouble,
      );
    } else {
      return HarpyVideoPlayer.fromController(
        VideoPlayerController.network(
          entry.videoData.appropriateUrl,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ),
        thumbnail: entry.videoData.thumbnailUrl,
        thumbnailAspectRatio: entry.videoData.aspectRatioDouble,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entry.isImage) {
      return _buildImage();
    } else if (entry.isGif) {
      return _buildGif();
    } else if (entry.isVideo) {
      return _buildVideo();
    } else {
      return const SizedBox();
    }
  }
}
