import 'package:color_picker_wheel/color_wheel.dart';
import 'package:flutter/material.dart';

class ColorPickerWheel extends StatefulWidget {
  final ValueChanged<Color> colorListener;

  ColorPickerWheel({@required this.colorListener});

  @override
  _ColorPickerWheelState createState() => _ColorPickerWheelState();
}

class _ColorPickerWheelState extends State<ColorPickerWheel> {
  double _shadeSliderPosition;
  Color _currentColor;
  Color _shadedColor;
  final List<ColorCell> colorCells = [
    ColorCell(color: Color(0xFFFF0000), isSelected: false),
    ColorCell(color: Color(0xFFDC143C), isSelected: false),
    ColorCell(color: Color(0xFFB22222), isSelected: false),
    ColorCell(color: Color(0xFFCD5C5C), isSelected: false),
    ColorCell(color: Color(0xFFF08080), isSelected: false),
    ColorCell(color: Color(0xFFFF1493), isSelected: false),
    ColorCell(color: Color(0xFFC71585), isSelected: false),
    ColorCell(color: Color(0xFFFF69B4), isSelected: false),
    ColorCell(color: Color(0xFFFFB6C1), isSelected: false),
    ColorCell(color: Color(0xFFFFC0CB), isSelected: false),
    ColorCell(color: Color(0xFFFFA500), isSelected: false),
    ColorCell(color: Color(0xFFFF8C00), isSelected: false),
    ColorCell(color: Color(0xFFFF6347), isSelected: false),
    ColorCell(color: Color(0xFFFF7F50), isSelected: false),
    ColorCell(color: Color(0xFFFFA07A), isSelected: false),
    ColorCell(color: Color(0xFFFFFF00), isSelected: false),
    ColorCell(color: Color(0xFFFFD700), isSelected: false),
    ColorCell(color: Color(0xFFBDB76B), isSelected: false),
    ColorCell(color: Color(0xFFF0E68C), isSelected: false),
    ColorCell(color: Color(0xFFEEE8AA), isSelected: false),
    ColorCell(color: Color(0xFF008000), isSelected: false),
    ColorCell(color: Color(0xFF2E8B57), isSelected: false),
    ColorCell(color: Color(0xFF3CB371), isSelected: false),
    ColorCell(color: Color(0xFF90EE90), isSelected: false),
    ColorCell(color: Color(0xFFADFF2F), isSelected: false),
    ColorCell(color: Color(0xFF0000FF), isSelected: false),
    ColorCell(color: Color(0xFF4169E1), isSelected: false),
    ColorCell(color: Color(0xFF6495ED), isSelected: false),
    ColorCell(color: Color(0xFF00BFFF), isSelected: false),
    ColorCell(color: Color(0xFF87CEFA), isSelected: false),
    ColorCell(color: Color(0xFFA52A2A), isSelected: false),
    ColorCell(color: Color(0xFF8B4513), isSelected: false),
    ColorCell(color: Color(0xFFCD853F), isSelected: false),
    ColorCell(color: Color(0xFFDAA520), isSelected: false),
    ColorCell(color: Color(0xFFF4A460), isSelected: false),
    ColorCell(color: Color(0xFF808080), isSelected: false),
    ColorCell(color: Color(0xFFA9A9A9), isSelected: false),
    ColorCell(color: Color(0xFFC0C0C0), isSelected: false),
    ColorCell(color: Color(0xFFD3D3D3), isSelected: false),
    ColorCell(color: Color(0xFFDCDCDC), isSelected: false),
  ];

  Color selectedColor = Colors.white;
  double width = 300;

  @override
  initState() {
    super.initState();
    _shadeSliderPosition = width / 2;
    _shadedColor = _calculateShadedColor(_shadeSliderPosition);
  }

  _shadeChangeHandler(double position) {
    if (position > width) position = width;
    if (position < 0) position = 0;
    _shadeSliderPosition = position;
    _shadedColor = _calculateShadedColor(_shadeSliderPosition);
    selectedColor = _shadedColor;
    widget.colorListener(selectedColor);
    setState(() {});
  }

  Color _calculateShadedColor(double position) {
    double ratio = position / width;
    if (ratio > 0.5) {
      int redVal = _currentColor.red != 255
          ? (_currentColor.red +
                  (255 - _currentColor.red) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      int greenVal = _currentColor.green != 255
          ? (_currentColor.green +
                  (255 - _currentColor.green) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      int blueVal = _currentColor.blue != 255
          ? (_currentColor.blue +
                  (255 - _currentColor.blue) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else if (ratio < 0.5) {
      int redVal = _currentColor.red != 0
          ? (_currentColor.red * ratio / 0.5).round()
          : 0;
      int greenVal = _currentColor.green != 0
          ? (_currentColor.green * ratio / 0.5).round()
          : 0;
      int blueVal = _currentColor.blue != 0
          ? (_currentColor.blue * ratio / 0.5).round()
          : 0;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else {
      //return the base color
      return _currentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.width),
            painter: CustomColorWheel(
                colorCells: colorCells,
                selectedColor: selectedColor,
                onColorSelected: (color) {
                  selectedColor = color;
                  _currentColor = selectedColor;
                  _shadeChangeHandler(_shadeSliderPosition);
                  setState(() {
                    colorCells.forEach((element) {
                      element.isSelected = false;
                    });
                    colorCells
                        .firstWhere((element) => element.color == color)
                        .isSelected = true;
                  });
                }),
          ),
        ),
        if (_currentColor != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
            },
            onTapDown: (TapDownDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
            },
            child: Padding(
              padding: EdgeInsets.all(15).copyWith(top: 0),
              child: Container(
                width: width,
                height: 15,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        colors: [Colors.black, _currentColor, Colors.white])),
                child: CustomPaint(
                  painter: _SliderIndicatorPainter(
                      _shadeSliderPosition, selectedColor),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  final Color color;

  _SliderIndicatorPainter(this.position, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.black;
    canvas.drawCircle(Offset(position, size.height / 2), 12, paint);
    paint.color = color;
    canvas.drawCircle(Offset(position, size.height / 2), 9.5, paint);
  }

  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}
