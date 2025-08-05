import 'dart:typed_data';

import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

import 'package:image/image.dart' as img;

// PopScope 不放顶级，放子组件也行
class PopScopeDemo extends StatelessWidget {
  PopScopeDemo({super.key});
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(runtimeType.toString()),
      ),
      body: Column(
        children: [
          // PopScope 不是非得套在顶层才有阻止 pop 效果，放在小部件中也行，child 最好用Container()，其他的可能导致白屏
          PopScope(canPop: false, child: Container(), onPopInvokedWithResult: (bool didPop, _) {
            log("onPopInvokedWithResult");
            if (didPop) {
              // StatelessWidget 里做一些释放。取巧
              controller?.dispose();
            }
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

// 使用的 dart_pdf_reader 库
// PDFPageObjectNode page = pages.getPageAtIndex(0);
// _parseBarcode(page);
// 此提取的是pdf中的资源，有些图像非资源，无法用此方法提取
// 解析 页面中的 barcode
Future<void> parseBarcode(PDFPageObjectNode page) async {
  // 获取资源
  final resources = await page.resources;
  final xObject = resources?[PDFNames.xObject];
  if (null == xObject || xObject is! PDFDictionary) {
    return;
  }

  Uint8List? imageData;
  PDFObject? streamObject;
  PDFObject? filter;
  PDFNumber width;
  PDFNumber height;
  final entries = xObject.entries.entries;
  for (var entry in entries) {
    streamObject = entry.value;
    if (streamObject is! PDFObjectReference) {
      continue;
    }

    streamObject = await page.objectResolver.resolve(streamObject);
    if (streamObject is! PDFStreamObject || streamObject.dictionary[PDFNames.subtype] != PDFNames.image) {
      continue;
    }
    // final imageRaw = await streamObject.readRaw();
    // Log.d('resource: ${imageRaw.length}');
    // final imageData = await read(streamObject, page.objectResolver);

    try {
      imageData = await streamObject.read(page.objectResolver);
    } catch (e) {
      // Log.e("无法解码的图片: $e");
      continue;
    }
    filter = streamObject.dictionary[PDFNames.filter];
    // dctDecode 是未解码的jpg图片
    if (filter == PDFNames.dctDecode || (filter is PDFArray && filter.contains(PDFNames.dctDecode))) {
      // Log.d('resource: ${imageData.length}');
      // JPG 解码
      final image = img.decodeImage(imageData);
      imageData = image?.data?.buffer.asUint8List();
    }
    if (null == imageData || imageData.isEmpty) return;

    // 宽高
    width = streamObject.dictionary[PDFNames.width] as PDFNumber;
    height = streamObject.dictionary[PDFNames.height] as PDFNumber;
    // Log.d('imageData: ${imageData.length}, ${width.toInt()}, ${height.toInt()}');
  }
}