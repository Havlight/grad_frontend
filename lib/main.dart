import 'package:developmentapp/pages/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/AI_Wound_analysis.dart';
import 'pages/Historical_data_analysis.dart';
import 'pages/personal_information.dart';
import 'pages/Login_page.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeNotifier()),
      ChangeNotifierProvider(create: (context) => DataProvider()),
    ],
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.amber,
              unselectedItemColor: Colors.black,
              selectedLabelStyle: TextStyle(color: Colors.amber),
              unselectedLabelStyle: TextStyle(color: Colors.black),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.amber,
              unselectedItemColor: Colors.white,
              selectedLabelStyle: TextStyle(color: Colors.amber),
              unselectedLabelStyle: TextStyle(color: Colors.white),
            ),
          ),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: LoginPage(), // 設置登入頁面為首頁
        );
      },
    );
  }
}

class BottomNavigationController extends StatefulWidget {
  BottomNavigationController({Key? key}) : super(key: key);

  @override
  _BottomNavigationControllerState createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  int _currentIndex = 0;
  final pages = [AI_Wound_analysis(), Historical_data(), personal_information()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('褥瘡分析'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'AI 傷口分析'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '歷史資料分析'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '個人資料',),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        type: BottomNavigationBarType.fixed, // 固定底部導航欄項目
        showSelectedLabels: true, // 顯示被選中時的標籤
        showUnselectedLabels: true, // 顯示未被選中時的標籤
        selectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
        onTap: _onItemClick,
      ),
    );
  }

  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
