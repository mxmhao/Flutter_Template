import 'package:flutter/material.dart';
import 'dart:developer';

// PopScope 不放顶级，放子组件也行
class PopScopeSubwidget extends StatelessWidget {
  const PopScopeSubwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(runtimeType.toString()),
      ),
      body: Column(
        children: [
          // PopScope 不是非得套在顶层才有阻止 pop 效果，放在小部件中也行
          PopScope(canPop: false, child: Container(), onPopInvokedWithResult: (bool didPop, _) {
            log("onPopInvokedWithResult");
          }),
          Text("1"),
          Text("1"),
          Text("1"),
          Text("1"),
        ],
      ),
    );
  }
}

// Intrinsic 组件使用说明
class IntrinsicHeightSubwidget extends StatelessWidget {
  const IntrinsicHeightSubwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(runtimeType.toString()),
      ),
      body: Center(
        // IntrinsicHeight 用于把子组件Row固定到最小高度
        child: IntrinsicHeight(
          // Row 的最小高度为其子组件中最高组件的高度
          child: Row(
            // stretch 会把 Row 撑到它能的最大高度（其父组件的高度），所以外面套个 Intrinsic 卡死
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Intrinsic 和 stretch 的双层效果就是，固定了 Row 的子组件有相同的高度
              // 适用于有自动换行需求，但又要统一同级组件的高度时使用。
              // Intrinsic 可能会有性能问题，少用。最好是用 sizebox 之类的固定死高度
              Expanded(child: Container(
                color: Colors.green,
                child: Text("111111111111111111111111111111111111111"),
              )),
              SizedBox(width: 10),
              Expanded(child: Container(
                color: Colors.green,
                child: Text("2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222"),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
