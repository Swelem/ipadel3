class reelComment {
  final String userId;
  final String userName;
  final String commentText;
  final DateTime timestamp;

  reelComment({
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': userName,
      'commentText': commentText,
      'likeCount': 0,
      'timestamp': timestamp,
    };
  }
}
