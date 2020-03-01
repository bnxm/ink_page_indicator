import 'package:flutter/material.dart';
import 'package:ink_page_indicator/ink_page_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page Indicators',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /* appBar: AppBar(
          title: Text('Page Indicators'),
        ), */
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageIndicatorController controller;

  IndicatorShape shape;
  IndicatorShape activeShape;

  @override
  void initState() {
    super.initState();
    controller = PageIndicatorController();
  }

  List<Widget> _createChildren(int count) {
    final List<Widget> result = [];
    for (var i = 0; i < count; i++) {
      result.add(const SizedBox.expand());
    }
    return result;
  }

  Widget buildInkPageIndicator(InkStyle style) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkPageIndicator(
              gap: 32,
              padding: 16,
              shape: shape,
              activeShape: activeShape,
              inactiveColor: Colors.grey.shade500,
              activeColor: Colors.grey.shade700,
              inkColor: Colors.grey.shade400,
              controller: controller,
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = _createChildren(3);

    shape = IndicatorShape.circle(10);

    activeShape = IndicatorShape.circle(10);

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            buildInkPageIndicator(InkStyle.normal),
            /* buildInkPageIndicator(InkStyle.simple),
            buildInkPageIndicator(InkStyle.translate),
            buildInkPageIndicator(InkStyle.transition), */
            Expanded(
              child: LeapingPageIndicator(
                controller: controller,
                gap: 32,
                padding: 16,
                shape: shape,
                activeShape: activeShape,
                inactiveColor: Colors.grey.shade400,
                activeColor: Colors.grey.shade700,
              ),
            )
          ],
        ),
        InkWell(
          onTap: () => controller.animateToPage(
            controller.page != children.length - 1 ? children.length - 1 : 0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.ease,
          ),
          child: PageView(
            controller: controller,
            children: children,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
