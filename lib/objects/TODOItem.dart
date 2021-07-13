class TODOItem {
  String title;
  bool isDone;

  TODOItem(this.title, this.isDone);

  Map<String, dynamic> toJson(obj) => {
    'title': title,
    'isDone': isDone,
  };
}