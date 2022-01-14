import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled1/scanner.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<Scaner>(create: (context){
          return Scaner();
        }
        )
      ],
      child: MaterialApp(home: Home())));
}

class Home extends StatefulWidget
{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Scan barcode",
            style: TextStyle(
              color: Colors.black,
            ),
          ),

          actions: [
            IconButton(
                onPressed: ()  {
                   FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT).then((value) async {
                      db.transaction((txn) async {
                        await txn.rawInsert(
                            'INSERT INTO DATA("ID","TITLE") VALUES("${value}","random")')
                            .then((value) {
                          print(value);
                        });
                      });
                      context.read<Scaner>().update(Data(value, "random"));
                  });
                },
                icon: const Icon(Icons.scanner,size: 25,color: Colors.black,)
            )
          ],
        ),



        //body: Container(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: const Text(
                          "ID",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),


                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(2),
                        child: const Text(
                          "TITLE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Column(
                children: context.watch<Scaner>().listData.map((e) => getContanier(e)).toList(),
              ),
            ],
          ),
        )
      ),
    );
  }



  @override
  void initState() {
    createDatabase();
    super.initState();
  }

  Future<void> createDatabase()
   async {
     db = await openDatabase('my_db.db',version: 1,onCreate: (Database db,int version) async {
       print("open");
     });


     db.execute("CREATE TABLE IF NOT EXISTS DATA (ID TEXT ,TITLE TEXT)").then((value) {
       print("created");
     });


     db.rawQuery('SELECT * FROM DATA').then((value){
       value.forEach((element) {
         print(element);
         Map v = element;
         context.read<Scaner>().update(Data(v['ID'],v['TITLE']));
       });
     });
   }

   Widget getContanier(Data data)
   {
     return Padding(
       padding: const EdgeInsets.all(5.0),
       child: Material(
         child: Container(
           width: MediaQuery.of(context).size.width,
           padding: EdgeInsets.all(10),


           child: Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [

               Expanded(
                 child: Container(
                   padding: EdgeInsets.all(5),
                   child: Text(
                     data.id,
                     style: const TextStyle(
                         color: Colors.deepPurple,
                         fontWeight: FontWeight.normal
                     ),
                   ),
                 ),
               ),


               Expanded(
                 child: Container(
                   alignment: Alignment.centerRight,
                   padding: EdgeInsets.all(2),
                   child: Text(
                     data.title,
                     style: const TextStyle(
                         fontWeight: FontWeight.normal
                     ),
                   ),
                 ),
               ),

             ],
           ),

         ),
       ),
     );
   }

  late Database db;
}



