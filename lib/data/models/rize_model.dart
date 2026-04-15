// lib/data/models/rize_model.dart

class RizePostModel {
  final String id;
  final String name;
  final String username;
  final String title;
  final String body;
  final int upvotes;
  final int comments;
  final int shares;
  final int views;
  final bool isUpvoted;
  final bool hasMedia;
  final bool isBookmarked;      // <-- الحقل المضاف حديثاً
  final bool isFollowing;
  final DateTime createdAt;

  RizePostModel({
    required this.id,
    required this.name,
    required this.username,
    required this.title,
    required this.body,
    this.upvotes = 0,
    this.comments = 0,
    this.shares = 0,
    this.views = 0,
    this.isUpvoted = false,
    this.hasMedia = false,
    this.isBookmarked = false,
    this.isFollowing = false,
    required this.createdAt,
  });

  RizePostModel copyWith({
    String? id,
    String? name,
    String? username,
    String? title,
    String? body,
    int? upvotes,
    int? comments,
    int? shares,
    int? views,
    bool? isUpvoted,
    bool? hasMedia,
    bool? isBookmarked,
    bool? isFollowing,
    DateTime? createdAt,
  }) {
    return RizePostModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      title: title ?? this.title,
      body: body ?? this.body,
      upvotes: upvotes ?? this.upvotes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      views: views ?? this.views,
      isUpvoted: isUpvoted ?? this.isUpvoted,
      hasMedia: hasMedia ?? this.hasMedia,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static List<RizePostModel> getMockPosts() {
    return [
      RizePostModel(
        id: '1',
        name: 'Ahmed Codes',
        username: '@ahmed_codes',
        title: 'Flutter 3.29 is amazing! The new features are game-changing.',
        body: 'Just updated to Flutter 3.29 and the performance improvements are noticeable. Impeller is now default on Android, and the new Cupertino widgets look fantastic. If you haven\'t upgraded yet, do it now!',
        upvotes: 12400,
        comments: 340,
        shares: 1200,
        views: 45000,
        isUpvoted: false,
        hasMedia: true,
        isBookmarked: false,
        isFollowing: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RizePostModel(
        id: '2',
        name: 'Flutter Dev',
        username: '@flutter_dev',
        title: '10 Tips for Clean Flutter Code',
        body: '1. Use const constructors\n2. Extract widgets\n3. Use themes\n4. Avoid rebuilding\n5. Use provider/riverpod\n6. Keep files small\n7. Use extensions\n8. Write tests\n9. Use lints\n10. Document your code',
        upvotes: 8900,
        comments: 210,
        shares: 890,
        views: 32000,
        isUpvoted: true,
        hasMedia: false,
        isBookmarked: true,
        isFollowing: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      RizePostModel(
        id: '3',
        name: 'UI Designer',
        username: '@ui_designer',
        title: 'Dark mode is not just black and white',
        body: 'When designing dark themes, avoid pure black (#000000) and pure white (#FFFFFF). Use dark gray (#121212) for surfaces and off-white (#E1E1E1) for text. This reduces eye strain and looks more professional.',
        upvotes: 5600,
        comments: 180,
        shares: 450,
        views: 21000,
        isUpvoted: false,
        hasMedia: true,
        isBookmarked: false,
        isFollowing: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      RizePostModel(
        id: '4',
        name: 'Meta Fan',
        username: '@meta_fan',
        title: 'Threads is now available in more countries!',
        body: 'Finally, Threads by Instagram is expanding globally. The app feels like a breath of fresh air compared to other social platforms. Clean UI, no ads (yet), and great engagement.',
        upvotes: 21000,
        comments: 1200,
        shares: 3400,
        views: 89000,
        isUpvoted: true,
        hasMedia: true,
        isBookmarked: false,
        isFollowing: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      RizePostModel(
        id: '5',
        name: 'Mobile Guru',
        username: '@mobile_guru',
        title: 'Why I switched from React Native to Flutter',
        body: 'After 3 years of React Native, I made the switch to Flutter. The developer experience is unmatched. Hot reload actually works, the widget system is intuitive, and performance is consistently smooth.',
        upvotes: 15300,
        comments: 890,
        shares: 2100,
        views: 67000,
        isUpvoted: false,
        hasMedia: false,
        isBookmarked: true,
        isFollowing: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RizePostModel(
        id: '6',
        name: 'Dart Lover',
        username: '@dart_lover',
        title: 'Dart 3.4 is here with new features!',
        body: 'The new Dart version brings improved type inference, better performance, and new language features. Pattern matching is getting even more powerful. Time to upgrade your SDK!',
        upvotes: 6700,
        comments: 230,
        shares: 560,
        views: 28000,
        isUpvoted: false,
        hasMedia: true,
        isBookmarked: false,
        isFollowing: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      RizePostModel(
        id: '7',
        name: 'Social App',
        username: '@social_app',
        title: 'Building a social app in 2026 - what you need to know',
        body: '1. Real-time features are expected\n2. Video is king\n3. AI integration is becoming standard\n4. Privacy first design\n5. Cross-platform is a must',
        upvotes: 4200,
        comments: 150,
        shares: 380,
        views: 19000,
        isUpvoted: true,
        hasMedia: false,
        isBookmarked: true,
        isFollowing: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
