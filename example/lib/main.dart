import 'package:flutter/material.dart';
import 'package:ink_page_indicator/ink_page_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageIndicatorController controller;

  @override
  void initState() {
    super.initState();
    controller = PageIndicatorController();
  }

  List<Widget> _createChildren(int count) {
    final List<Widget> result = [];
    for (var i = 0; i < count; i++) {
      result.add(
        SizedBox.expand(
          child: Container(
            color: i.isOdd ? Colors.white : Colors.white,
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final children = _createChildren(5);

    return Stack(
      children: <Widget>[
        PageView(
          controller: controller,
          children: children,
        ),
        Align(
          alignment: Alignment.center,
          child: InkPageIndicator(
            gap: 32,
            padding: 16,
            shape: IndicatorShape.ofCircle(16),
            inActiveColor: Color(0xffC9C9C9),
            activeColor: Color(0xff636363),
            controller: controller,
            itemCount: children.length,
            style: InkStyle.modern,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FloatingActionButton(
              onPressed: () => controller.animateToPage(
                controller.page != children.length - 1 ? children.length - 1 : 0,
                duration: Duration(milliseconds: 800),
                curve: Curves.ease,
              ),
            ),
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
