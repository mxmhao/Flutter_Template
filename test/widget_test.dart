// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_template/template/templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('No Directionality widget found.', (WidgetTester tester) async {
    // 报错
    await tester.pumpWidget(Text(""));
    // 不报错
    await tester.pumpWidget(Container());
  });

  testWidgets('PopScopeDemo', (WidgetTester tester) async {
    await tester.pumpWidget(MyTestApp(testWidget: FractionallySizedBoxDemo()));
  });
}

class MyTestApp extends StatelessWidget {
  MyTestApp({super.key, this.testWidget});
  Widget? testWidget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 很多 Widget 不能直接放在 pumpWidget 里测试，必须包裹一层 XXXApp
      title: 'Flutter Widget Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: testWidget ?? Container(),
    );
  }
}