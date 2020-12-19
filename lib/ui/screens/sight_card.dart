import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

import 'package:places/domain/sight.dart';

/// Виджет карточки интересного места.
class SightCard extends StatelessWidget {
  final Sight sight;

  const SightCard({Key key, this.sight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        height: 188.0,
        width: 328.0,
        child: Column(
          children: [
            _CardTop(sight: sight),
            _CardBottom(sight: sight),
          ],
        ),
      ),
    );
  }
}

class _CardTop extends StatelessWidget {
  const _CardTop({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: topBorderRadius16,
      child: Container(
        color: placeholderColor,
        width: double.infinity,
        height: 96.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _CardImage(imgUrl: sight.url),
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                sight.type,
                style: textBold14.copyWith(color: white),
              ),
            ),
            Positioned(
              top: 19,
              right: 18,
              child: Container(
                width: 20,
                height: 18,
                color: white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
      fit: BoxFit.cover,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent loadingProgress,
      ) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}

class _CardBottom extends StatelessWidget {
  const _CardBottom({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: bottomBorderRadius16,
        color: backgroundColor,
      ),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: 92.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sight.name,
            style: textMedium16.copyWith(
              height: 1.25,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            sight.details,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textRegular14.copyWith(
              height: 1.3,
              color: secondaryColor2,
            ),
          ),
        ],
      ),
    );
  }
}
