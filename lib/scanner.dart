import 'package:flutter/cupertino.dart';

class Scaner extends ChangeNotifier
{
  List<Data> listData = [];

  update(Data d)
  {
    listData.add(d);
    notifyListeners();
  }
}


class Data
{
  String id;
  String title;

  Data(this.id, this.title);

}