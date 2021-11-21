import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_study/newPage.dart';

void main() {
  CustomFlutterBinding();
  runApp(MyApp());
}

class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ///路由表
  static Map routerMap = {
    'homePage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) {
            return MyHomePage(title: 'Flutter HomePage');
          });
    },
    'newPage': (settings, uniqueId) {
      return MaterialPageRoute(settings: settings, builder: (_) => NewPage());
      // return PageRouteBuilder<dynamic>(
      //     settings: settings,
      //     pageBuilder: (_, __, ___) {
      //       return NewPage();
      //     });
    },
  };

  Route<dynamic> routeFactory(RouteSettings settings, String uniqueId) {
    print('routeFactory =========== $settings');
    FlutterBoostRouteFactory func = routerMap[settings.name];
    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(routeFactory, appBuilder: appBuilder);
  }

  Widget appBuilder(Widget home) {
    return MaterialApp(home: home, debugShowCheckedModeBanner: false);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       // This is the theme of your application.
  //       //
  //       // Try running your application with "flutter run". You'll see the
  //       // application has a blue toolbar. Then, without quitting the app, try
  //       // changing the primarySwatch below to Colors.green and then invoke
  //       // "hot reload" (press "r" in the console where you ran "flutter run",
  //       // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
  //       // counter didn't reset back to zero; the application is not restarted.
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: MyHomePage(title: 'Flutter Demo Home Page'),
  //   );
  // }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with PageVisibilityObserver {
  int _counter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///注册监听器
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    // 移除监听器
    PageVisibilityBinding.instance.removeObserver(this);
    super.dispose();
  }

  // lifeCycle
  @override
  void onPageShow() {
    print('onPageShow');
  }

  @override
  void onPageHide() {
    print('onPageHide');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                return Container(
                    color: Colors.blueGrey,
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(left: 5),
                  );
              }), 
            ),
            TextButton(
                onPressed: () {
                  // Navigator.push(context,
                  //         MaterialPageRoute(builder: (_) => NewPage()));
                  // BoostNavigator.instance.push('newPage',
                  //     arguments: {'animated': true}, withContainer: true);
                      BoostNavigator.instance.push('newPage',
                      arguments: {'animated': true}, withContainer: false);
                },
                child: Text('jump to Flutter')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  test1() {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container();
    });
  }
}

class A {
  final int numA;
  A(this.numA);
  runA() {
    print('A run');
  }
}

class B implements A {
  @override
  // TODO: implement numA
  int get numA => throw UnimplementedError();

  @override
  runA() {
    // TODO: implement runA
    throw UnimplementedError();
  }
  
}

abstract class C {
  int numC = 0;
  runC();
}

class D implements A,C {
  @override
  int numC;

  @override
  // TODO: implement numA
  int get numA => throw UnimplementedError();

  @override
  runA() {
    // TODO: implement runA
    throw UnimplementedError();
  }

  @override
  runC() {
    // TODO: implement runC
    throw UnimplementedError();
  }
}

mixin E {
  int numE = 0;
  runE() {
    print('mixin runE');
  }
  play();
}

class F with E{
  @override
  play() {
    // TODO: implement play
    throw UnimplementedError();
  }

}

mixin Mixin1 {
  log() {
    print('Mixin1');
  }
}

mixin Mixin2 {
  log() {
    print('Mixin2');
  }
}

class Imp {
  log() {
    print('Imp');
  }
}

class Ext {
  int a = 0;
  log() {
    print('Ext');
  }
  ext() {

  }
}

// 我们发现了一个奇怪的现象：虽然我们加上了implements，但是Dart居然没让我们实现Imp.log()方法！
// 这是因为在这种情况下，它识别到我们从with和extends中获得了log()方法的能力，因此调用的是Mixins2.log()。
class Test extends Ext with Mixin1, Mixin2 implements Imp{
  @override
  ext() {
    return super.ext();
  }
}