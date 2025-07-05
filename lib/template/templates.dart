import 'package:flutter/material.dart';
import 'dart:developer';

// PopScope 不放顶级，放子组件也行
class PopScopeDemo extends StatelessWidget {
  const PopScopeDemo({super.key});

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
class IntrinsicHeightDemo extends StatelessWidget {
  const IntrinsicHeightDemo({super.key});

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
              // Intrinsic 的性能开销较大,因为它需要在布局阶段计算所有子组件的高度，少用。
              // 最好是用 sizebox 之类的固定死高度
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

// FractionallySizedBox 可以设置 child 组件在父组件中的宽高占比
class FractionallySizedBoxDemo extends StatelessWidget {
  const FractionallySizedBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(runtimeType.toString()),
      ),
      body: Container(
        child: FractionallySizedBox(
          // FractionallySizedBox 可以设置 child 在父组件中的宽高占比
          widthFactor: 1,
          heightFactor: 0.25,
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
