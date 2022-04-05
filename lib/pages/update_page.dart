import 'package:flutter/material.dart';
import 'package:pattern_setstate/models/post_model.dart';
import 'package:pattern_setstate/services/http_service.dart';

class UpdatePage extends StatefulWidget {
  static const String id = "/update_post";
  final Post? post;

  const UpdatePage({Key? key,this.post}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  Post? oldPost;

  _getOldPost() {
    setState(() {
      oldPost = widget.post;
      titleController.text = oldPost!.title!;
      notesController.text = oldPost!.body!;
    });
  }

  _apiCreatePost() async {
    String title = titleController.text.trim().toString();
    String notes = notesController.text.trim().toString();

    Post post = Post(title: title,body: notes,id: oldPost!.id,userId: oldPost!.userId);

    Network.PUT(Network.API_UPDATE,Network.paramsUpdate(post));

    Navigator.pop(context,post);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOldPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update",style: TextStyle(fontSize: 20),),
        actions: [
          TextButton(
            onPressed: _apiCreatePost,
            child: Text(
              "Save", style: TextStyle(color: Colors.white, fontSize: 18),),
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
                maxLines: null,
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
