library input_slider;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An input widget that combines a [Slider] synchronized with a [TextField]
class InputSlider extends StatefulWidget {
  /// Called whenever the value changes by moving the slider or entering a value
  /// into the TextField
  final Function(double) onChange;

  /// Called whenever the user is done moving the slider.
  final Function(double)? onChangeEnd;

  /// Called whenever the user starts moving the slider.
  final Function(double)? onChangeStart;

  /// The minimum value. Every value smaller than this will be clamped.
  final double min;

  /// The maximum value. Every value greater than this will be clamped.
  final double max;

  /// The value of this InputSlider.
  final double value;

  /// The number of discrete divisions.
  final int? division;

  /// The color of the active (left) part of the slider.
  ///
  /// By default chooses a color based on the Theme.
  final Color? activeSliderColor;

  /// The color of the inactive (right) part of the slider.
  ///
  /// By default chooses a color based on the Theme.
  final Color? inactiveSliderColor;

  /// The amount of decimal places shown in the TextField.
  final int decimalPlaces;

  /// A leading Widget. This could be a Text or an Icon as a label.
  final Widget? leading;

  /// The [TextStyle] used in the TextField.
  final TextStyle? textFieldStyle;

  /// Whether the TextField is filled.
  /// Ignored if [inputDecoration] is non-null.
  final bool filled;

  /// The color with which the TextField is filled, if [filled] is true.
  /// Ignored if [inputDecoration] is non-null.
  ///
  /// By default chooses a color based on the Theme.
  final Color? fillColor;

  /// The border color of the TextField if not focused.
  /// Ignored if [inputDecoration] is non-null.
  ///
  /// By default chooses a color based on the Theme.
  final Color? borderColor;

  /// The border color of the TextField if focused.
  /// Ignored if [inputDecoration] is non-null.
  ///
  /// By default chooses a color based on the Theme.
  final Color? focusBorderColor;

  /// The border radius of the TextField.
  /// Ignored if [inputDecoration] is non-null.
  final BorderRadius? borderRadius;

  /// The [InputDecoration] used by the TextField. If null, use a default decoration.
  final InputDecoration? inputDecoration;

  const InputSlider(
      {required this.onChange,
      required this.min,
      required this.max,
      required this.value,
      this.onChangeEnd,
      this.onChangeStart,
      this.leading,
      this.decimalPlaces = 2,
      this.division,
      this.activeSliderColor,
      this.inactiveSliderColor,
      this.textFieldStyle,
      this.filled = false,
      this.fillColor,
      this.borderColor,
      this.focusBorderColor,
      this.borderRadius,
      this.inputDecoration})
      : super();

  @override
  _InputSliderState createState() => _InputSliderState(value: value);
}

class _InputSliderState extends State<InputSlider> {
  double value;
  TextEditingController _controller = TextEditingController();
  Size? textFieldSize;

  _InputSliderState({required this.value});

  @override
  void initState() {
    _controller = TextEditingController();
    _setControllerValue(value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (textFieldSize == null) _calculateTextFieldSize();

    return Row(
      children: [
        widget.leading ?? Container(),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
        ),
        SizedBox(
          width: textFieldSize!.width,
          height: textFieldSize!.height,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            style: widget.textFieldStyle ?? DefaultTextStyle.of(context).style,
            onSubmitted: (value) {
              double parsedValue = double.tryParse(value) ?? this.value;
              parsedValue = parsedValue.clamp(widget.min, widget.max);
              setState(() {
                this.value = parsedValue;
              });
              _setControllerValue(this.value);
            },
            textAlign: TextAlign.center,
            decoration: widget.inputDecoration ??
                InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: widget.borderColor ??
                              Theme.of(context).hintColor)),
                  border: OutlineInputBorder(
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: widget.borderColor ??
                              Theme.of(context).hintColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(8),
                      borderSide: BorderSide(
                          width: 2,
                          color: widget.focusBorderColor ??
                              Theme.of(context).primaryColor)),
                  filled: widget.filled,
                  contentPadding: EdgeInsets.only(top: 5),
                ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: widget.min,
            max: widget.max,
            divisions: widget.division,
            activeColor: widget.activeSliderColor,
            inactiveColor: widget.inactiveSliderColor,
            onChangeEnd: widget.onChangeEnd,
            onChanged: (double value) {
              setState(() {
                this.value = value;
              });
              _setControllerValue(value);
              widget.onChange.call(value);
            },
          ),
        )
      ],
    );
  }

  /// Calculates the size of the TextField input.
  void _calculateTextFieldSize() {
    TextStyle style =
        widget.textFieldStyle ?? DefaultTextStyle.of(context).style;
    String measureString = widget.max.toString() + ".";
    for (int i = 0; i < widget.decimalPlaces; i++) measureString += "9";
    final textSize = _textSize(measureString, style);
    textFieldSize = textSize + Offset(8, 4);
  }

  /// Sets the [_controller] to the String representation of [value], clamped and
  /// with max [widget.decimalPlaces].
  void _setControllerValue(double value) {
    value = value.clamp(widget.min, widget.max);
    setState(() {
      _controller.text = value.toStringAsFixed(widget.decimalPlaces);
    });
    widget.onChange.call(value);
  }

  /// Calculates the size of [text] in the [TextStyle] [style].
  ///
  /// Credits to Dmitry_Kovalov: https://stackoverflow.com/a/60065737
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
