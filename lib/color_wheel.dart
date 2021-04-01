import 'dart:math';
import 'package:flutter/material.dart';

class ColorCell {
  Color color;
  bool isSelected;
  Path path;
  Paint paint;

  ColorCell({
    this.color,
    this.isSelected,
    this.paint,
    this.path,
  });
}

class CustomColorWheel extends CustomPainter {
  final List<ColorCell> colorCells;
  final void Function(Color color) onColorSelected;
  final Color selectedColor;
  Path centerWhiteCircle;
  Offset lastPosition;

  CustomColorWheel(
      {this.colorCells,
      this.onColorSelected,
      this.selectedColor = Colors.white});

  @override
  bool hitTest(Offset position) {
    if (lastPosition == position) {
      return true;
    }
    lastPosition = position;

    if (centerWhiteCircle.contains(position)) {
      return true;
    }
    colorCells.forEach((item) {
      if (item.path.contains(position)) {
        onColorSelected(item.color);
        return true;
      } else {
        return false;
      }
    });
    return super.hitTest(position);
  }

  @override
  void paint(Canvas canvas, Size size) {
    List<Path> selectedPaths = [];
    Paint paint = Paint();

    double centerX = size.width / 2;
    double centerY = size.height / 1.44;

    int totalCell = colorCells.length;
    int cellInEachColumn = 5;
    double columns = getColumns(totalCell, cellInEachColumn);

    double startAngle = 5 * (pi / 6);
    double colorWheelAngle = 4 * (pi / 3);
    double sweepAngle = colorWheelAngle / columns;

    double cellHeight = size.width / 14;

    int counter = 0;

    for (int i = 0; i < columns; i++) {
      if (i != 0) {
        startAngle = startAngle + sweepAngle;
      }

      for (int j = 0; j < cellInEachColumn; j++) {
        if (counter == colorCells.length) {
          break;
        }

        double height = cellHeight;
        double extraHeight = height * 1.5;
        if (colorCells.elementAt(counter).isSelected) {
          extraHeight = extraHeight + 2;
        }

        double endInnerX;
        double endInnerY;

        double startOuterX;
        double startOuterY;

        double innerArcRadius;
        startOuterX =
            ((j + 1) * height + extraHeight) * cos(startAngle) + centerX;
        startOuterY =
            ((j + 1) * height + extraHeight) * sin(startAngle) + centerY;
        if (j == 0) {
          endInnerX = j * height * cos(startAngle + sweepAngle) + centerX;
          endInnerY = j * height * sin(startAngle + sweepAngle) + centerY;
          innerArcRadius = j * height;
        } else {
          endInnerX =
              ((j * height) + extraHeight) * cos(startAngle + sweepAngle) +
                  centerX;
          endInnerY =
              ((j * height) + extraHeight) * sin(startAngle + sweepAngle) +
                  centerY;
          innerArcRadius = j * height + extraHeight;
        }

        double outerArcRadius = (j + 1) * height + extraHeight;

        paint.color = colorCells.elementAt(counter).color;
        paint.style = PaintingStyle.fill;

        Path path = Path();

        path.arcTo(
            Rect.fromCircle(
                radius: outerArcRadius, center: Offset(centerX, centerY)),
            startAngle,
            sweepAngle,
            true);
        path.lineTo(endInnerX, endInnerY);

        path.arcTo(
            Rect.fromCircle(
                radius: innerArcRadius, center: Offset(centerX, centerY)),
            startAngle + sweepAngle,
            -sweepAngle,
            true);
        path.lineTo(startOuterX, startOuterY);

        canvas.drawPath(path, paint);
        paint.color = Colors.white;
        paint.strokeCap = StrokeCap.round;
        paint.strokeWidth = colorCells.elementAt(counter).isSelected ? 3 : 1;
        paint.style = PaintingStyle.stroke;
        canvas.drawPath(path, paint);

        if (colorCells.elementAt(counter).isSelected) {
          selectedPaths.add(path);
        }
        colorCells.elementAt(counter).paint = paint;
        colorCells.elementAt(counter).path = path;
        counter++;
      }
    }

    selectedPaths.forEach((path) {
      paint.color = Colors.white;
      paint.strokeCap = StrokeCap.round;
      paint.strokeWidth = 4;
      paint.style = PaintingStyle.stroke;
      canvas.drawShadow(path, Colors.grey[900].withOpacity(0.3), 2.0, false);
      canvas.drawPath(path, paint);
    });

    paint.color = Colors.white;
    paint.strokeWidth = 1.5;
    canvas.drawCircle(Offset(centerX, centerY), 30, paint);
    paint.style = PaintingStyle.fill;
    paint.color = selectedColor;
    centerWhiteCircle = Path();
    centerWhiteCircle
        .addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: 30));
    canvas.drawPath(centerWhiteCircle, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }
}

double getColumns(int totalCell, int cellInEachColumn) {
  double columns = (totalCell / cellInEachColumn).floorToDouble();

  if (totalCell % cellInEachColumn > 0) {
    columns++;
  }
  return columns;
}
