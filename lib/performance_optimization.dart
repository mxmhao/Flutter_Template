// 性能优化专区。此文件中的事例全是为了性能优化
import 'package:flutter/material.dart';

// repaintBoundary
void repaintBoundary() {
  // setState() 本身不会直接导致 RepaintBoundary 内部内容的重绘，但是如果 setState() 影响到了 RepaintBoundary 内部的组件，那么 RepaintBoundary 里面的内容就会被重绘。
  SingleChildScrollView(
    child: Column(
      children: [
        Text("WidgetA"),
        Text("WidgetB"),
        RepaintBoundary(
          // -> 外层嵌套 RepaintBoundary ，当页面进行滚动时，CustomPaint 不会进行重绘。
          child: CustomPaint(),
        ),
      ],
    ),
  );
}
