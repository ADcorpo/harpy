import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/cached_circle_avatar.dart';
import 'package:harpy/components/common/followers_count.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// The header for the [HomeDrawer].
class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader();

  void _onUserTap() {
    // todo: go to user screen
  }

  Widget _buildAvatarRow(BuildContext context, UserData user) {
    return GestureDetector(
      onTap: _onUserTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // circle avatar
          CachedCircleAvatar(
            radius: 32,
            imageUrl: user.profileImageUrlHttps,
          ),

          const SizedBox(width: 16),

          // name + username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.screenName}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserData user = AuthenticationBloc.of(context).authenticatedUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.of(context).padding.top, // + statusbar height
        16,
        8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatarRow(context, user),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FollowersCount(user),
          ),
        ],
      ),
    );
  }
}
