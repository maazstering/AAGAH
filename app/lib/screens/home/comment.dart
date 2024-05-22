import 'package:app/components/widgets/appTheme.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentEmpty = true;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_checkCommentEmpty);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title:
            const Text('Comments', style: TextStyle(color: AppTheme.lightGreyColor)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual number of comments
              itemBuilder: (context, index) => commentItem(index),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

  void _postComment() {
    // Logic to post comment
    String comment = _commentController.text;
    // Reset comment text field after posting
    _commentController.clear();
    setState(() {
      _isCommentEmpty = true;
    });
  }

  Widget commentItem(int index) {
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
          const CircleAvatar(
            backgroundImage: AssetImage(
                '../assets/images/profile.jpg'), // Use actual user image
          ),
          Text(
            'Username $index', // Replace with actual username
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppTheme.lightGreyColor),
          ),
          const SizedBox(height: 4.0),
          Text(
            'This is a comment by user $index.', // Replace with actual comment
            style: const TextStyle(color: AppTheme.lightGreyColor),
          ),
        ],
      ),
    );
  }
}
