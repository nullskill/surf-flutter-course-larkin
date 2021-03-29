import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/settings_item.dart';

/// Диалог выбора картинки
class SelectPictureDialog extends StatelessWidget {
  const SelectPictureDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: transparentColor,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: allBorderRadius12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SettingsItem(
                      leading: SvgPicture.asset(
                        AppIcons.camera,
                        width: 24.0,
                        height: 24.0,
                        color:
                            Theme.of(context).colorScheme.appDialogLabelColor,
                      ),
                      title: addSightCamera,
                      isDialog: true,
                      paddingValue: 12.0,
                    ),
                    SettingsItem(
                      leading: SvgPicture.asset(
                        AppIcons.photo,
                        width: 24.0,
                        height: 24.0,
                        color:
                            Theme.of(context).colorScheme.appDialogLabelColor,
                      ),
                      title: addSightPicture,
                      isDialog: true,
                      paddingValue: 12.0,
                    ),
                    SettingsItem(
                      leading: SvgPicture.asset(
                        AppIcons.file,
                        width: 24.0,
                        height: 24.0,
                        color:
                            Theme.of(context).colorScheme.appDialogLabelColor,
                      ),
                      title: addSightFile,
                      isDialog: true,
                      isLast: true,
                      paddingValue: 12.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ActionButton(
                  label: cancelButtonLabel,
                  isDialogButton: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
