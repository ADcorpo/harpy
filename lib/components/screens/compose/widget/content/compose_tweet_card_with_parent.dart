import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

/// Builds the [ComposeTweetCard] with the [ComposeParentTweetCard] when
/// replying or quoting a tweet.
class ComposeTweetCardWithParent extends StatefulWidget {
  const ComposeTweetCardWithParent({
    this.inReplyToStatus,
    this.quotedTweet,
  }) : assert(inReplyToStatus == null || quotedTweet == null);

  final TweetData inReplyToStatus;
  final TweetData quotedTweet;

  @override
  _ComposeTweetCardWithParentState createState() =>
      _ComposeTweetCardWithParentState();
}

class _ComposeTweetCardWithParentState
    extends State<ComposeTweetCardWithParent> {
  ScrollController _controller;

  int _keyboardListenerId;
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    _keyboardListenerId = KeyboardVisibilityNotification().addNewListener(
      onHide: () => setState(() => _keyboardVisible = false),
      onShow: () async {
        // scroll to the start so the compose tweet card is fully visible
        _controller.animateTo(
          0,
          duration: kLongAnimationDuration,
          curve: Curves.easeOutCirc,
        );

        // wait for the show animation until the height changes to avoid it
        // to jump after the keyboard animation finished
        await Future<void>.delayed(const Duration(milliseconds: 300));
        setState(() => _keyboardVisible = true);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    KeyboardVisibilityNotification().removeListener(_keyboardListenerId);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        // the available height for the content
        // differs to constraints.maxHeight when the keyboard is showing
        final double height = mediaQuery.size.height -
            kToolbarHeight -
            mediaQuery.padding.top -
            mediaQuery.padding.bottom;

        return ListView(
          controller: _controller,
          padding: EdgeInsets.zero,
          children: <Widget>[
            AnimatedContainer(
              duration: kShortAnimationDuration,
              height: _keyboardVisible ? constraints.maxHeight : height / 2,
              child: const ComposeTweetCard(),
            ),
            defaultVerticalSpacer,
            if (widget.inReplyToStatus != null)
              ComposeParentTweetCard(
                parentTweet: widget.inReplyToStatus,
                text: 'replying to',
              )
            else if (widget.quotedTweet != null)
              ComposeParentTweetCard(
                parentTweet: widget.quotedTweet,
                text: 'quoting',
              ),
          ],
        );
      },
    );
  }
}
