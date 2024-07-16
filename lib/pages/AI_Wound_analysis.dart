import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' show join;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'data_provider.dart';
class AI_Wound_analysis extends StatefulWidget {
  @override
  _AI_Wound_analysisState createState() => _AI_Wound_analysisState();
}

class _AI_Wound_analysisState extends State<AI_Wound_analysis> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeCamera();
  }

  Future<void> _requestPermissions() async {
    await Permission.photos.request();
    await Permission.storage.request();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller =
        CameraController(_cameras[_selectedCameraIndex], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void _switchCamera() {
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
      _initializeCamera();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _uploadImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final uri = Uri.parse('http://10.0.2.2:8000/api/yolo/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['user'] = 'test_user'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    final result_num = responseData['num_detected_objects'];
    final result_class = responseData['class_names'];
    print('num is :');
    print(result_num);
    print('class is :');
    print(result_class);

    if (response.statusCode == 200) {
      print('上传成功 ${response.reasonPhrase}');
      _showDialog(context, '圖片上傳成功\n辨識到${result_num}個物件\n物件類別為${result_class}');
      Provider.of<DataProvider>(context, listen: false).addNewData(
          "辨識結果",
          "辨識到${result_num}個物件\n物件類別為${result_class}"
      );
    } else {
      print('上传失败: ${response.statusCode}');
      _showDialog(context, '圖片上傳失敗');
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('上傳結果'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('確定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI傷口分析"),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Container(
                width: 300,
                height: 500, // 相機預覽大小
                child: CameraPreview(_controller),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();

              // 獲取圖片
              final directory = await getApplicationDocumentsDirectory();
              final imagePath = join(directory.path, '${DateTime.now()}.png');
              final imageFile = File(image.path);

              // 圖片保存路徑
              await imageFile.copy(imagePath);

              // 把圖片放置相簿
              await GallerySaver.saveImage(imagePath);

              print('拍攝的照片路徑: ${image.path}');
              print('已保存到相簿的路徑: $imagePath');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已保存到相簿')),
              );
              // 上传图片到后端
              await _uploadImage(imageFile);
              print('拍攝的照片路徑: ${image.path}');
            } catch (e) {
              print(e);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('出错')),
              );
            }
          },
          heroTag: 'btn1',
          child: Icon(Icons.camera_alt),
        ),
        FloatingActionButton(
          onPressed: _switchCamera,
          heroTag: 'btn2',
          child: Icon(Icons.album),
        ),
      ],
    );
  }
}
