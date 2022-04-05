import 'package:flutter/material.dart';
import 'package:pattern_setstate/models/post_model.dart';
import 'package:pattern_setstate/services/http_service.dart';
import 'package:pattern_setstate/services/util_service.dart';

class DetailPage extends StatefulWidget {
  static const String id = "/detail_page";
  final int? userId;
  final CRUD? type;

  const DetailPage({Key? key, this.userId, this.type}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();


  void _apiCreatePost() async {
    String title = titleController.text.trim().toString();
    String notes = notesController.text.trim().toString();

    if (title.isEmpty || notes.isEmpty) return;

    Post post = Post(title: title, body: notes,userId: title.hashCode);

    Network.POST(Network.API_CREATE, Network.paramsCreate(post));

    Navigator.pop(context,true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _apiCreatePost,
            child: const Text(
              "Save", style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextField(
                controller: titleController,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextField(
                controller: notesController,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Notes",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
