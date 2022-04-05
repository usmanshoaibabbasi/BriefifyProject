class EditPostArgument {
  int? postId;
  int? userId;
  String? heading;
  String? summary;
  String? videolink;
  String? ariclelink;
  // String? category;
  EditPostArgument({
    this.userId,
    this.postId,
    this.heading,
    this.summary,
    this.videolink,
    this.ariclelink,
    // this.category,
  });
}