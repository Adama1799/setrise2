// lib/data/models/rize_model.dart

class RizePostModel {
  final String id;
  final String userId;           // ✅ جديد
  final String name;
  final String username;
  final String userAvatar;       // ✅ جديد
  final String title;
  final String body;
  final int upvotes;
  final int comments;
  final int shares;
  final int views;
  final bool isUpvoted;
  final bool hasMedia;
  final bool isBookmarked;
  final bool isFollowing;
  final List<String> mediaUrls;  // ✅ جديد
  final String mediaType;        // ✅ جديد ('image' أو 'video')
  final DateTime createdAt;

  RizePostModel({
    required this.id,
    required this.userId,          // ✅
    required this.name,
    required this.username,
    required this.userAvatar,      // ✅
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
    this.mediaUrls = const [],     // ✅ افتراضي قائمة فارغة
    this.mediaType = 'image',      // ✅ افتراضي صورة
    required this.createdAt,
  });

  RizePostModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? username,
    String? userAvatar,
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
    List<String>? mediaUrls,
    String? mediaType,
    DateTime? createdAt,
  }) {
    return RizePostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
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
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaType: mediaType ?? this.mediaType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static List<RizePostModel> getMockPosts() {
    return [
      RizePostModel(
        id: '1',
        userId: 'user1',
        name: 'Ahmed Codes',
        username: '@ahmed_codes',
        userAvatar: 'https://randomuser.me/api/portraits/men/1.jpg',
        title: 'Flutter 3.29 is amazing!',
        body: 'Just updated to Flutter 3.29 and the performance improvements are noticeable.',
        upvotes: 12400,
        comments: 340,
        shares: 1200,
        views: 45000,
        isUpvoted: false,
        hasMedia: true,
        isBookmarked: false,
        isFollowing: false,
        mediaUrls: [
          'https://picsum.photos/400/600?random=1',
          'https://picsum.photos/400/600?random=2',
        ],
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RizePostModel(
        id: '2',
        userId: 'user2',
        name: 'Flutter Dev',
        username: '@flutter_dev',
        userAvatar: 'https://randomuser.me/api/portraits/women/2.jpg',
        title: '10 Tips for Clean Flutter Code',
        body: '1. Use const constructors\n2. Extract widgets\n3. Use themes\n4. Avoid rebuilding',
        upvotes: 8900,
        comments: 210,
        shares: 890,
        views: 32000,
        isUpvoted: true,
        hasMedia: false,
        isBookmarked: true,
        isFollowing: true,
        mediaUrls: [],
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      RizePostModel(
        id: '3',
        userId: 'user3',
        name: 'Video Creator',
        username: '@video_maker',
        userAvatar: 'https://randomuser.me/api/portraits/women/3.jpg',
        title: 'My first short video!',
        body: 'Check out this amazing sunset 🌅',
        upvotes: 2300,
        comments: 87,
        shares: 340,
        views: 12000,
        isUpvoted: false,
        hasMedia: true,
        isBookmarked: false,
        isFollowing: false,
        mediaUrls: ['https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'],
        mediaType: 'video', // ✅ فيديو
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      // ... أضف بقية المنشورات بنفس النمط
    ];
  }
}
