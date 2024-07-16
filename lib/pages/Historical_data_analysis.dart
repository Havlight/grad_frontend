import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_provider.dart';

class Historical_data extends StatefulWidget {
  @override
  _HistoricalDataState createState() => _HistoricalDataState();
}

class _HistoricalDataState extends State<Historical_data> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newNoteController = TextEditingController();

  void _addNewData(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false)
        .addNewData(_newTitleController.text, _newNoteController.text);
    _newTitleController.clear();
    _newNoteController.clear();
  }

  void _editTitle(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        var dataProvider = Provider.of<DataProvider>(context, listen: false);
        _titleController.text = dataProvider.data[index]["title"]!;
        _noteController.text = dataProvider.data[index]["note"]!;
        return AlertDialog(
          title: Text('編輯標題與備註'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: '標題'),
              ),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: '備註'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                dataProvider.editData(
                    index, _titleController.text, _noteController.text);
                Navigator.of(context).pop();
              },
              child: Text('確定'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  void _deleteData(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('刪除資料'),
          content: Text('確定要刪除這條資料嗎？'),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<DataProvider>(context, listen: false).removeData(index);
                Navigator.of(context).pop();
              },
              child: Text('確定'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("歷史資料分析"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dataProvider.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataProvider.data[index]["title"]!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataProvider.data[index]["note"]!),
                      Text(dataProvider.data[index]["date"]!),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTitle(context, index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteData(context, index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
