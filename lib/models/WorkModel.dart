import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/objects/TODOItem.dart';

class WorksModel extends ChangeNotifier {
  final List<TODOItem> _works = [
    TODOItem('Default task', true),
  ];

  UnmodifiableListView<TODOItem> get works => UnmodifiableListView(_works);

  void add(TODOItem item) {
    _works.add(item);
    notifyListeners();
  }

  void remove(TODOItem item) {
    _works.remove(item);
    notifyListeners();
  }

  void removeAll() {
    _works.clear();
    notifyListeners();
  }
}