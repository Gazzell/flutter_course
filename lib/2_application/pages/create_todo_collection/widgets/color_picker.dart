import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

Future<bool> colorPickerDialog({
  required BuildContext context,
  required Function(Color) onColorChanged,
  Color? color,
}) async {
  return ColorPicker(
    // Use the dialogPickerColor as start color.
    color: color ?? Colors.orange,
    // Update the dialogPickerColor using the callback.
    onColorChanged: (Color newColor) => onColorChanged(newColor),
    width: 40,
    height: 40,
    borderRadius: 4,
    spacing: 5,
    runSpacing: 5,
    // wheelDiameter: 155,
    heading: Text(
      'Select color',
      style: Theme.of(context).textTheme.titleSmall,
    ),
    subheading: Text(
      'Select color shade',
      style: Theme.of(context).textTheme.titleSmall,
    ),
    wheelSubheading: Text(
      'Selected color and its shades',
      style: Theme.of(context).textTheme.titleSmall,
    ),
    // showMaterialName: true,
    // showColorName: true,
    // showColorCode: true,
    // copyPasteBehavior: const ColorPickerCopyPasteBehavior(
    //   longPressMenu: true,
    // ),
    materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: true,
      ColorPickerType.primary: false,
      ColorPickerType.accent: false,
      ColorPickerType.bw: false,
      ColorPickerType.custom: false,
      ColorPickerType.wheel: false,
    },
    // customColorSwatchesAndNames: colorsNameMap,
  ).showPickerDialog(
    context,
    // New in version 3.0.0 custom transitions support.
    transitionBuilder: (BuildContext context, Animation<double> a1,
        Animation<double> a2, Widget widget) {
      final double curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    constraints:
        const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
  );
}
