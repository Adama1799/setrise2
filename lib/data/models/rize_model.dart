hereclass RizePostModel {
  final String id;
  final String userId;
  final String username;
  final String name;
  final String? avatar;
  final String title;
  final String body;
  final String? mediaUrl;
  final bool hasMedia;
  final int upvotes;
  final int comments;
  final int shares;
  final int views;
  final bool isUpvoted;
  final bool isFollowing;
  final DateTime createdAt;

  RizePostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.name,
    this.avatar,
    required this.title,
    required this.body,
    this.mediaUrl,
    this.hasMedia = false,
    required this.upvotes,
    required this.comments,
    required this.shares,
    required this.views,
    this.isUpvoted = false,
    this.isFollowing = false,
    required this.createdAt,
  });

  RizePostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? name,
    String? avatar,
    String? title,
    String? body,
    String? mediaUrl,
    bool? hasMedia,
    int? upvotes,
    int? comments,
    int? shares,
    int? views,
    bool? isUpvoted,
    bool? isFollowing,
    DateTime? createdAt,
  }) {
    return RizePostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      title: title ?? this.title,
      body: body ?? this.body,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      hasMedia: hasMedia ?? this.hasMedia,
      upvotes: upvotes ?? this.upvotes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      views: views ?? this.views,
      isUpvoted: isUpvoted ?? this.isUpvoted,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Mock Data
  static List<RizePostModel> getMockPosts() {
    return List.generate(
      20,
      (i) => RizePostModel(
        id: 'rize_$i',
        userId: 'user_$i',
        username: '@user_$i',
        name: 'User $i',
        title: 'This is an amazing post title that grabs attention',
        body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris. '
            'Nisi ut aliquip ex ea commodo consequat.',
        hasMedia: i % 3 == 0,
        upvotes: (i + 1) * 142,
        comments: (i + 1) * 34,
        shares: (i + 1) * 12,
        views: (i + 1) * 1230,
        createdAt: DateTime.now().subtract(Duration(hours: i)),
      ),
    );
  }
}
