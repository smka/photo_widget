import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../photo_provider.dart';
import '../asset_widget.dart';
import 'pick_checkbox.dart';
import 'pick_color_mask.dart';

class PickAssetWidget extends StatelessWidget {
  final AssetEntity asset;
  final int thumbSize;
  final PickerDataProvider provider;
  final Function? onTap;
  final PickColorMaskBuilder pickColorMaskBuilder;
  final PickedCheckboxBuilder? pickedCheckboxBuilder;

  const PickAssetWidget({
    Key? key,
    required this.asset,
    required this.provider,
    this.thumbSize = 100,
    this.onTap,
    this.pickColorMaskBuilder = PickColorMask.buildWidget,
    this.pickedCheckboxBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pickMask = AnimatedBuilder(
      animation: provider,
      builder: (_, __) {
        final pickIndex = provider.pickIndex(asset);
        final picked = pickIndex >= 0;
        return pickColorMaskBuilder.call(context,
            picked); /*??
            PickColorMask(
              picked: picked,
            );*/
      },
    );

    final checkWidget = AnimatedBuilder(
      animation: provider,
      builder: (_, __) {
        final pickIndex = provider.pickIndex(asset);
        return pickedCheckboxBuilder?.call(context, pickIndex) ??
            PickedCheckbox(
              onClick: () {
                provider.pickEntity(asset);
              },
              checkIndex: pickIndex,
            );
      },
    );

    final videoIcon = AnimatedBuilder(
      animation: provider,
      builder: (_, __) {
        if (asset.type == AssetType.video) {
          return Positioned(
            child: Icon(
              Icons.videocam_outlined,
              color: Colors.purple.shade300,
              size: 24,
            ),
            bottom: -2,
            left: 4,
          );
        }
        return Container();
      },
    );

    final uploadedIcon = AnimatedBuilder(
      animation: provider.isUploadedNotifier,
      builder: (_, __) {
        if (provider.uploadedList.contains(asset)) {
          return Positioned(
            child: Icon(
              Icons.cloud_done_outlined,
              color: Colors.lightBlueAccent,
              size: 20,
            ),
            bottom: 0,
            right: 8,
          );
        }
        return Container();
      },
    );

    /// стак с изображением, и чекбоксом
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Hero(
              tag: asset,
              child: AssetWidget(
                asset: asset,
                thumbSize: thumbSize,
              ),
            ),
          ),
          pickMask,
          //Text(asset.id),
          videoIcon,
          uploadedIcon,
          checkWidget,
        ],
      ),
      onTap: onTap as void Function()?,
    );
  }
}
