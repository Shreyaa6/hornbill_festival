class PhotoSubmission {
  final String id;
  final String title;
  final String authorName;
  final String userEmail;
  final String photoUrl;
  final int votes;
  final String localDateString;
  final DateTime createdAt;

  PhotoSubmission({
    required this.id,
    required this.title,
    required this.authorName,
    required this.userEmail,
    required this.photoUrl,
    required this.votes,
    required this.localDateString,
    required this.createdAt,
  });
}
