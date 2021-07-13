import 'package:flutter/material.dart';
import 'package:todo_app_flutter/objects/TODOItem.dart';
import 'package:todo_app_flutter/models/WorkModel.dart';

void main() => runApp(TODOApp());

class TODOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App with Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TODO App written in Dart + Flutter'),
        ),
        body: TODOList(),
      ),
    );
  }
}

class TODOList extends StatefulWidget {
  @override
  _TODOListState createState() => _TODOListState();
}

class _TODOListState extends State<TODOList> {
  final TextEditingController inputValue = TextEditingController();
  final model = WorksModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text('Hint: to change status tap on item. To remove it long press on it.'),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Expanded(child: _buildInput()),
              _buildButton()
            ]
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: _buildTODOList()
        )
      ]
    );
  }

  Widget _buildTODOList() {
    // overall count of list with items
    int length = model.works.length;

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: length,
      itemBuilder: (BuildContext _context, int i) {
        return _buildRows(model.works[i]);
      },
      separatorBuilder: (BuildContext context, int i) => Divider(
        color: Colors.black12,
      ),
    );
  }

  Widget _buildRows(TODOItem item) {
    IconData statusIcon = item.isDone == true ? Icons.done : Icons.timelapse;
    return ListTile(
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      trailing: Icon(
          statusIcon
      ),
      onTap: () {
        setState(() {
          item.isDone = !item.isDone;
        });
      },
      onLongPress: () {
        _showMyDialog(item);
      },
    );
  }

  Widget _buildInput() {
    return TextField(
      controller: inputValue,
      decoration: InputDecoration(
          hintText: 'Title of work to do'
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(100, 40),
        ),
        child: Text('Add'),
        onPressed: () {
          setState(() {
            model.add(TODOItem(inputValue.text, false));
          });
        },
      ),
    );
  }

  Future<void> _showMyDialog(TODOItem item) async {
    String trueStatus = item.isDone ? "done" : "in progress";

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to remove task "${item.title}"?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Status: $trueStatus', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                setState(() {
                  model.remove(item);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() {
                          model.add(TODOItem(item.title, item.isDone));
                        });
                      },
                    ),
                    content: const Text('Task removed successfully'),
                    duration: const Duration(milliseconds: 1500),
                    width: 280.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}