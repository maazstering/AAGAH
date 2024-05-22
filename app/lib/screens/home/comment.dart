import 'package:app/widgets/variables.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CommentPage extends StatefulWidget {
  final String postId;

  const CommentPage({super.key, required this.postId});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentEmpty = true;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_checkCommentEmpty);
    fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _checkCommentEmpty() {
    setState(() {
      _isCommentEmpty = _commentController.text.isEmpty;
    });
  }

  Future<void> fetchComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      final uri =
          Uri.parse('${Variables.address}/social/${widget.postId}comments');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          comments = (jsonData['comments'] as List)
              .map((data) => Comment.fromJson(data))
              .toList();
        });
      } else {
        print('Failed to load comments: ${response.statusCode}');
      }
    } else {
      print('Token is null');
    }
  }

  Future<void> _postComment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      final uri =
          Uri.parse('${Variables.address}/social/${widget.postId}comments');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'content': _commentController.text,
        }),
      );

      if (response.statusCode == 201) {
        _commentController.clear();
        fetchComments();
      } else {
        print('Failed to post comment: ${response.statusCode}');
      }
    } else {
      print('Token is null');
    }
  }

  Future<void> _editComment(String commentId, String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      final uri = Uri.parse('${Variables.address}/social/comments$commentId');
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        fetchComments();
      } else {
        print('Failed to edit comment: ${response.statusCode}');
      }
    } else {
      print('Token is null');
    }
  }

  Future<void> _deleteComment(String commentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      final uri = Uri.parse('${Variables.address}/social/comments$commentId');
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        fetchComments();
      } else {
        print('Failed to delete comment: ${response.statusCode}');
      }
    } else {
      print('Token is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title: const Text('Comments',
            style: TextStyle(color: AppTheme.lightGreyColor)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) => commentItem(index, context),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: const BoxDecoration(
              color: AppTheme.bgColor,
              border: Border(
                top: BorderSide(color: AppTheme.greyColor, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(color: AppTheme.lightGreyColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isCommentEmpty ? null : _postComment,
                  color: _isCommentEmpty
                      ? AppTheme.greyColor
                      : AppTheme.periwinkleColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget commentItem(int index, BuildContext context) {
    final comment = comments[index];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: AppTheme.bgColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.greyColor, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage(
                    '../assets/images/profile.jpg'), // Use actual user image
              ),
              const SizedBox(width: 10.0),
              Text(
                comment.author.name, // Replace with actual username
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightGreyColor),
              ),
              Spacer(),
              if (comment.isOwnComment) ...[
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.lightGreyColor),
                  onPressed: () => _showEditCommentDialog(comment),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.delete, color: AppTheme.lightGreyColor),
                  onPressed: () => _deleteComment(comment.id),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            comment.content, // Replace with actual comment
            style: const TextStyle(color: AppTheme.lightGreyColor),
          ),
        ],
      ),
    );
  }

  void _showEditCommentDialog(Comment comment) {
    final TextEditingController _editCommentController =
        TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Comment'),
          content: TextField(
            controller: _editCommentController,
            decoration: const InputDecoration(
              hintText: 'Edit your comment',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _editComment(comment.id, _editCommentController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Comment {
  final String id;
  final String content;
  final Author author;
  final bool isOwnComment;

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.isOwnComment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      content: json['content'],
      author: Author.fromJson(json['author']),
      isOwnComment: json['isOwnComment'] ?? false,
    );
  }
}

class Author {
  final String id;
  final String email;
  final String name;

  Author({
    required this.id,
    required this.email,
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
