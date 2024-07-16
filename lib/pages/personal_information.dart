import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'Login_page.dart';

class personal_information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('個人資料'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(30.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 28.0), // Add some spacing between the avatar and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'User',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                      ),
                    ),
                    Text(
                      '123-456-7890',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.nightlight_round),
            title: Text('深色模式'),
            onTap: () {
              themeNotifier.toggleTheme();
            },
          ),
          ListTile(
            leading: Icon(Icons.mode),
            title: Text('修改密碼'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text('聯絡支援'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.output),
            title: Text('登出'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('支援服務'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text('歡迎來到支援服務頁面！', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
