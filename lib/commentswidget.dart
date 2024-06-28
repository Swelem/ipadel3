import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'reelService.dart'; // Import your reels service
import '/upload_reels/upload_reels_screen.dart';
import 'package:get/get.dart';
import 'comment.dart';
import 'package:intl/intl.dart';

class CommentsWidget extends StatefulWidget {
  final String reelId;
  final User? user;

  CommentsWidget({required this.reelId, required this.user});

  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  TextEditingController _commentController = TextEditingController();
  List<reelComment> _comments = []; // List to store comments

  @override
  void initState() {
    super.initState();
    // Load comments for the given reelId
    loadComments();
  }

  void loadComments() async {
    // Load comments from Firestore or your preferred database
    List<reelComment> comments = await fetchCommentsForReel(widget.reelId);
    setState(() {
      _comments = comments;
    });
  }

  void addComments() async {
    if (_commentController.text.isNotEmpty && widget.user != null) {
      reelComment newComment = reelComment(
        userId: widget.user!.uid,
        userName: widget.user!.displayName ?? 'Anonymous',
        commentText: _commentController.text.trim(),
        timestamp: DateTime.now(),
      );

      // Save new comment to Firestore or your preferred database
      await addComment(widget.reelId, newComment);

      // Update the UI
      setState(() {
        _comments.insert(
            0, newComment); // Add new comment to the top of the list
        _commentController.clear(); // Clear the input field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              reelComment comment = _comments[index];
              return ListTile(
                title: Text(comment.userName),
                subtitle: Text(comment.commentText),
                trailing:
                    Text(DateFormat.yMd().add_jm().format(comment.timestamp)),
              );
            },
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: addComments,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
