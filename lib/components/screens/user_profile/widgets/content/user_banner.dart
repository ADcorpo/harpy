import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds the user banner image as the background for a [HarpySliverAppBar].
class UserBanner extends StatelessWidget {
  const UserBanner(this.bloc);

  final UserProfileBloc bloc;

  /// Builds the profile banner for a [HeroDialogRoute] when the user taps on
  /// the banner.
  Widget _buildDialogImage() {
    final String url = bloc.user.appropriateUserBannerUrl;

    return CustomDismissible(
      onDismissed: () => app<HarpyNavigator>().state.maybePop(),
      child: Center(
        child: Hero(
          tag: url,
          child: HarpyImage(
            imageUrl: url,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bloc.user?.hasBanner == true) {
      final String url = bloc.user.appropriateUserBannerUrl;

      return GestureDetector(
        onTap: () {
          app<HarpyNavigator>().pushRoute(HeroDialogRoute<void>(
            onBackgroundTap: () => app<HarpyNavigator>().state.maybePop(),
            builder: (BuildContext context) => _buildDialogImage(),
          ));
        },
        child: Hero(
          tag: url,
          placeholderBuilder:
              (BuildContext context, Size heroSize, Widget child) => child,
          child: HarpyImage(
            imageUrl: url,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
