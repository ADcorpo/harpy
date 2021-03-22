import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class MediaSettingsScreen extends StatefulWidget {
  const MediaSettingsScreen();

  static const String route = 'media_settings';

  @override
  _MediaSettingsScreenState createState() => _MediaSettingsScreenState();
}

class _MediaSettingsScreenState extends State<MediaSettingsScreen> {
  final MediaPreferences mediaPreferences = app<MediaPreferences>();

  List<Widget> _buildSettings(ThemeData theme) {
    return <Widget>[
      RadioDialogTile(
        leading: CupertinoIcons.wifi,
        title: 'Media quality on wifi',
        description: 'change the media quality when using wifi',
        value: mediaPreferences.wifiMediaQuality,
        items: const <String>['high', 'medium', 'small'],
        onChanged: (int value) {
          setState(() => mediaPreferences.wifiMediaQuality = value);
        },
      ),
      RadioDialogTile(
        leading: CupertinoIcons.wifi_slash,
        title: 'Media quality on mobile data',
        description: 'change the media quality when using mobile data',
        value: mediaPreferences.nonWifiMediaQuality,
        items: const <String>['high', 'medium', 'small'],
        onChanged: (int value) {
          setState(() => mediaPreferences.nonWifiMediaQuality = value);
        },
      ),
      ListTile(
        leading: const SizedBox(),
        title: Row(
          children: <Widget>[
            Icon(CupertinoIcons.info, color: theme.accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'media is always downloaded in the best quality',
                style: theme.textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
      RadioDialogTile(
        leading: CupertinoIcons.play_circle,
        title: 'Autoplay gifs',
        description: 'change when gifs should automatically play',
        value: mediaPreferences.autoplayMedia,
        items: const <String>[
          'always autoplay',
          'only on wifi',
          'never autoplay',
        ],
        onChanged: (int value) {
          setState(() => mediaPreferences.autoplayMedia = value);
        },
      ),
      RadioDialogTile(
        leading: CupertinoIcons.play_circle,
        title: 'Autoplay videos',
        description: 'change when videos should automatically play',
        value: mediaPreferences.autoplayVideos,
        items: const <String>[
          'always autoplay',
          'only on wifi',
          'never autoplay',
        ],
        onChanged: (int value) {
          setState(() => mediaPreferences.autoplayVideos = value);
        },
      ),
      SwitchListTile(
        secondary: const Icon(CupertinoIcons.link),
        title: const Text('Always open links externally'),
        subtitle: const Text('coming soon!'),
        value: mediaPreferences.openLinksExternally,
        onChanged: null,
        // todo: implement
        // onChanged: (bool value) {
        //   setState(() => mediaPreferences.openLinksExternally = value);
        // },
      ),
    ];
  }

  /// Builds the actions for the 'reset to default' button as a [PopupMenuItem].
  List<Widget> _buildActions() {
    return <Widget>[
      CustomPopupMenuButton<void>(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onSelected: (_) => setState(mediaPreferences.defaultSettings),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<void>>[
            const HarpyPopupMenuItem<void>(
              value: 0,
              text: Text('reset to default'),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return HarpyScaffold(
      title: 'media settings',
      actions: _buildActions(),
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _buildSettings(theme),
      ),
    );
  }
}