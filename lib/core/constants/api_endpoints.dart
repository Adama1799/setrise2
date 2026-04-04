/// API endpoints configuration
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - Change this to your actual API URL
  static const String baseUrl = 'https://api.setrise.com';
  static const String apiVersion = '/api/v1';
  
  // Full base URL with version
  static String get fullBaseUrl => '$baseUrl$apiVersion';

  // Authentication endpoints
  static const String authEndpoint = '/auth';
  static const String loginEndpoint = '$authEndpoint/login';
  static const String registerEndpoint = '$authEndpoint/register';
  static const String logoutEndpoint = '$authEndpoint/logout';
  static const String refreshTokenEndpoint = '$authEndpoint/refresh';
  static const String forgotPasswordEndpoint = '$authEndpoint/forgot-password';
  static const String resetPasswordEndpoint = '$authEndpoint/reset-password';
  static const String verifyEmailEndpoint = '$authEndpoint/verify-email';
  static const String changePasswordEndpoint = '$authEndpoint/change-password';

  // User endpoints
  static const String usersEndpoint = '/users';
  static const String currentUserEndpoint = '$usersEndpoint/me';
  static const String updateProfileEndpoint = '$usersEndpoint/profile';
  static const String uploadAvatarEndpoint = '$usersEndpoint/avatar';
  
  // User interactions
  static String followUserEndpoint(String userId) => '$usersEndpoint/$userId/follow';
  static String unfollowUserEndpoint(String userId) => '$usersEndpoint/$userId/unfollow';
  static String getUserFollowersEndpoint(String userId) => '$usersEndpoint/$userId/followers';
  static String getUserFollowingEndpoint(String userId) => '$usersEndpoint/$userId/following';
  static String blockUserEndpoint(String userId) => '$usersEndpoint/$userId/block';
  static String unblockUserEndpoint(String userId) => '$usersEndpoint/$userId/unblock';
  static String reportUserEndpoint(String userId) => '$usersEndpoint/$userId/report';

  // Posts endpoints (Set/Rize)
  static const String postsEndpoint = '/posts';
  static const String createPostEndpoint = postsEndpoint;
  static const String feedEndpoint = '$postsEndpoint/feed';
  static const String trendingEndpoint = '$postsEndpoint/trending';
  static const String exploreEndpoint = '$postsEndpoint/explore';
  
  static String getPostEndpoint(String postId) => '$postsEndpoint/$postId';
  static String updatePostEndpoint(String postId) => '$postsEndpoint/$postId';
  static String deletePostEndpoint(String postId) => '$postsEndpoint/$postId';
  static String likePostEndpoint(String postId) => '$postsEndpoint/$postId/like';
  static String unlikePostEndpoint(String postId) => '$postsEndpoint/$postId/unlike';
  static String sharePostEndpoint(String postId) => '$postsEndpoint/$postId/share';
  static String bookmarkPostEndpoint(String postId) => '$postsEndpoint/$postId/bookmark';
  static String reportPostEndpoint(String postId) => '$postsEndpoint/$postId/report';

  // Threads endpoints
  static const String threadsEndpoint = '/threads';
  static const String createThreadEndpoint = threadsEndpoint;
  static const String threadsFeedEndpoint = '$threadsEndpoint/feed';
  
  static String getThreadEndpoint(String threadId) => '$threadsEndpoint/$threadId';
  static String deleteThreadEndpoint(String threadId) => '$threadsEndpoint/$threadId';
  static String likeThreadEndpoint(String threadId) => '$threadsEndpoint/$threadId/like';
  static String replyThreadEndpoint(String threadId) => '$threadsEndpoint/$threadId/reply';
  static String getThreadRepliesEndpoint(String threadId) => '$threadsEndpoint/$threadId/replies';

  // Comments endpoints
  static const String commentsEndpoint = '/comments';
  
  static String getPostCommentsEndpoint(String postId) => '$postsEndpoint/$postId/comments';
  static String createCommentEndpoint(String postId) => '$postsEndpoint/$postId/comments';
  static String updateCommentEndpoint(String commentId) => '$commentsEndpoint/$commentId';
  static String deleteCommentEndpoint(String commentId) => '$commentsEndpoint/$commentId';
  static String likeCommentEndpoint(String commentId) => '$commentsEndpoint/$commentId/like';
  static String replyCommentEndpoint(String commentId) => '$commentsEndpoint/$commentId/reply';

  // Stories endpoints
  static const String storiesEndpoint = '/stories';
  static const String createStoryEndpoint = storiesEndpoint;
  static const String viewStoryEndpoint = '$storiesEndpoint/view';
  
  static String getUserStoriesEndpoint(String userId) => '$usersEndpoint/$userId/stories';
  static String deleteStoryEndpoint(String storyId) => '$storiesEndpoint/$storyId';

  // Chat/Messages endpoints
  static const String conversationsEndpoint = '/conversations';
  static const String messagesEndpoint = '/messages';
  
  static String getUserConversationsEndpoint(String userId) => '$usersEndpoint/$userId/conversations';
  static String getConversationMessagesEndpoint(String conversationId) => '$conversationsEndpoint/$conversationId/messages';
  static String sendMessageEndpoint(String receiverId) => '$usersEndpoint/$receiverId/message';
  static String markMessageAsReadEndpoint(String messageId) => '$messagesEndpoint/$messageId/read';
  static String deleteMessageEndpoint(String messageId) => '$messagesEndpoint/$messageId';
  static String startTypingEndpoint(String conversationId) => '$conversationsEndpoint/$conversationId/typing';

  // Dating endpoints
  static const String datingEndpoint = '/dating';
  static const String discoverProfilesEndpoint = '$usersEndpoint/dating/discover';
  static const String datingMatchesEndpoint = '$datingEndpoint/matches';
  
  static String getDatingProfileEndpoint(String profileId) => '$usersEndpoint/dating/$profileId';
  static String createDatingProfileEndpoint = '$usersEndpoint/dating/profile';
  static String updateDatingProfileEndpoint = '$usersEndpoint/dating/profile';
  static String likeProfileEndpoint(String profileId) => '$usersEndpoint/dating/$profileId/like';
  static String passProfileEndpoint(String profileId) => '$usersEndpoint/dating/$profileId/pass';
  static String superLikeProfileEndpoint(String profileId) => '$usersEndpoint/dating/$profileId/super-like';
  static String sendMessageToMatchEndpoint(String profileId) => '$usersEndpoint/dating/$profileId/message';

  // Live streaming endpoints
  static const String liveEndpoint = '/live';
  static const String createLiveStreamEndpoint = '$liveEndpoint/create';
  static const String activeLiveStreamsEndpoint = '$liveEndpoint/active';
  
  static String joinLiveStreamEndpoint(String streamId) => '$liveEndpoint/$streamId/join';
  static String endLiveStreamEndpoint(String streamId) => '$liveEndpoint/$streamId/end';
  static String sendLiveCommentEndpoint(String streamId) => '$liveEndpoint/$streamId/comment';
  static String sendGiftEndpoint(String streamId) => '$liveEndpoint/$streamId/gift';

  // Music endpoints
  static const String musicEndpoint = '/music';
  static const String tracksEndpoint = '$musicEndpoint/tracks';
  static const String playlistsEndpoint = '$musicEndpoint/playlists';
  static const String albumsEndpoint = '$musicEndpoint/albums';
  static const String artistsEndpoint = '$musicEndpoint/artists';
  
  static String getTrackEndpoint(String trackId) => '$tracksEndpoint/$trackId';
  static String likeTrackEndpoint(String trackId) => '$tracksEndpoint/$trackId/like';
  static String createPlaylistEndpoint = playlistsEndpoint;
  static String addToPlaylistEndpoint(String playlistId) => '$playlistsEndpoint/$playlistId/add';

  // Shop/Marketplace endpoints
  static const String shopEndpoint = '/shop';
  static const String productsEndpoint = '$shopEndpoint/products';
  static const String categoriesEndpoint = '$shopEndpoint/categories';
  static const String ordersEndpoint = '$shopEndpoint/orders';
  static const String cartEndpoint = '$shopEndpoint/cart';
  
  static String getProductEndpoint(String productId) => '$productsEndpoint/$productId';
  static String createProductEndpoint = productsEndpoint;
  static String updateProductEndpoint(String productId) => '$productsEndpoint/$productId';
  static String deleteProductEndpoint(String productId) => '$productsEndpoint/$productId';
  static String addToCartEndpoint(String productId) => '$productsEndpoint/$productId/cart';
  static String createOrderEndpoint = ordersEndpoint;

  // Notifications endpoints
  static const String notificationsEndpoint = '/notifications';
  static const String markAsReadEndpoint = '$notificationsEndpoint/read';
  static const String markAllAsReadEndpoint = '$notificationsEndpoint/read-all';
  
  static String deleteNotificationEndpoint(String notificationId) => '$notificationsEndpoint/$notificationId';

  // Search endpoints
  static const String searchEndpoint = '/search';
  static const String searchUsersEndpoint = '$searchEndpoint/users';
  static const String searchPostsEndpoint = '$searchEndpoint/posts';
  static const String searchThreadsEndpoint = '$searchEndpoint/threads';
  static const String searchProductsEndpoint = '$searchEndpoint/products';
  static const String searchTracksEndpoint = '$searchEndpoint/tracks';

  // Upload endpoints
  static const String uploadEndpoint = '/upload';
  static const String uploadImageEndpoint = '$uploadEndpoint/image';
  static const String uploadVideoEndpoint = '$uploadEndpoint/video';
  static const String uploadAudioEndpoint = '$uploadEndpoint/audio';
  static const String uploadFileEndpoint = '$uploadEndpoint/file';

  // Analytics endpoints
  static const String analyticsEndpoint = '/analytics';
  static const String trackEventEndpoint = '$analyticsEndpoint/event';
  static const String getUserAnalyticsEndpoint = '$analyticsEndpoint/user';
  static const String getPostAnalyticsEndpoint = '$analyticsEndpoint/post';

  // Settings endpoints
  static const String settingsEndpoint = '/settings';
  static const String privacySettingsEndpoint = '$settingsEndpoint/privacy';
  static const String notificationSettingsEndpoint = '$settingsEndpoint/notifications';
  static const String accountSettingsEndpoint = '$settingsEndpoint/account';
  static const String deleteAccountEndpoint = '$settingsEndpoint/delete-account';

  // Admin endpoints (if applicable)
  static const String adminEndpoint = '/admin';
  static const String adminUsersEndpoint = '$adminEndpoint/users';
  static const String adminPostsEndpoint = '$adminEndpoint/posts';
  static const String adminReportsEndpoint = '$adminEndpoint/reports';
}
