import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pattern_setstate/models/post_model.dart';
import 'package:pattern_setstate/pages/detail_page.dart';
import 'package:pattern_setstate/pages/update_page.dart';
import 'package:pattern_setstate/services/http_service.dart';

class HomePage extends StatefulWidget {
  static const String id = "/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> posts = [];

  void _apiPostList() async {
    setState(() {
      isLoading = true;
    });

    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      if(response != null) {
        posts = Network.parsePostList(response);
      }else{
        posts = [];
      }
      isLoading = false;
    });
  }

  Future<bool> apiPostDelete(Post post) async {
    setState(() {
      isLoading = true;
    });

    var response = Network.DEL(Network.API_DELETE + post.id.toString(), Network.paramsEmpty());

    setState(() {
      isLoading = false;
    });

    return response != null;
  }

  void _apiUpdatePost(Post post) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdatePage(post: post,)));
    if(result != null) {
      posts.replaceRange(posts.indexOf(post), posts.indexOf(post) + 1, [result]);
      _apiPostList();
    }
  }

  void _apiCreatePost() async {
    var result = await Navigator.of(context).pushNamed(DetailPage.id);
    if (result != null && result == true) {
      _apiPostList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pattern Setstate",style: TextStyle(fontSize: 20),),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context,index){
              return Slidable(
                endActionPane:  ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) => _apiUpdatePost(posts[index]),
                      backgroundColor: const Color(0xFFFE6D49),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: (BuildContext context) => apiPostDelete(posts[index]),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(posts[index].title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      SizedBox(height: 10,),
                      Text(posts[index].body!,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                    ],
                  ),
                ),
              );
            },
          ),

          if(isLoading) const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _apiCreatePost,
        child: Icon(Icons.add,size: 30,),
      ),
    );
  }
}
