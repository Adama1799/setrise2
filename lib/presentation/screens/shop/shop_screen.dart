// lib/presentation/screens/shop/shop_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/auction_model.dart';
import '../../../data/models/seller_model.dart';
import '../../../data/services/mock_shop_service.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ScrollController _scrollController = ScrollController();
  final ShopController _controller = ShopController();

  @override
  void initState() {
    super.initState();
    _controller.fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      if (!_controller.isLoadingMore && _controller.hasMore) {
        _controller.fetchNextPage();
      }
    }
  }

  Future<void> _onRefresh() async {
    await _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text('Shop', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search_rounded, color: AppColors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.shopping_bag_outlined, color: AppColors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _buildStoriesRow(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < _controller.mixedItems.length) {
                  final item = _controller.mixedItems[index];
                  if (item is ProductModel) {
                    return _ProductCard(product: item);
                  } else if (item is AuctionModel) {
                    return _AuctionCard(auction: item);
                  } else if (item is SellerModel) {
                    return _SellerCard(seller: item);
                  }
                }
                if (_controller.isLoadingMore) {
                  return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                }
                return const SizedBox.shrink();
              },
              childCount: _controller.mixedItems.length + (_controller.isLoadingMore ? 1 : 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesRow() {
    return StreamBuilder<List<SellerModel>>(
      stream: _controller.sellersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (context, index) => _buildStoryShimmer(),
            ),
          );
        }
        final sellers = snapshot.data!;
        return Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sellers.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) return _SellButtonCard();
              return _SellerStoryCard(seller: sellers[index - 1]);
            },
          ),
        );
      },
    );
  }

  Widget _buildStoryShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey,
      highlightColor: AppColors.surface,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(width: 60, height: 60, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
            const SizedBox(height: 8),
            Container(width: 60, height: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _SellButtonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              color: AppColors.surface,
            ),
            child: Icon(Icons.add_rounded, color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: 8),
          Text('Sell', style: AppTextStyles.bodySmall.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}

class _SellerStoryCard extends StatelessWidget {
  final SellerModel seller;
  const _SellerStoryCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: seller.isVerified ? AppColors.success : AppColors.grey3, width: 2),
                image: DecorationImage(image: NetworkImage(seller.avatarUrl ?? ''), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(seller.storeName, style: AppTextStyles.bodySmall.copyWith(color: AppColors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(product.imageUrls.first, width: 80, height: 80, fit: BoxFit.cover)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.brand, style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                    const SizedBox(height: 4),
                    Text(product.name, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    if (product.oldPrice != null)
                      Row(
                        children: [
                          Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Text('\$${product.oldPrice!.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.grey2)),
                        ],
                      )
                    else
                      Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: product.isFavorite ? AppColors.error : AppColors.grey2),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuctionCard extends StatefulWidget {
  final AuctionModel auction;
  const _AuctionCard({required this.auction});

  @override
  State<_AuctionCard> createState() => _AuctionCardState();
}

class _AuctionCardState extends State<_AuctionCard> {
  late Timer _timer;
  String _timeLeft = '';

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimeLeft());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeLeft() {
    setState(() {
      _timeLeft = widget.auction.formattedTimeLeft;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(8)),
                  child: Text('LIVE', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Text(_timeLeft, style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.auction.name, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text('Current Bid: \$${widget.auction.currentBid.toStringAsFixed(2)}', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Place Bid', style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  final SellerModel seller;
  const _SellerCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(seller.avatarUrl ?? ''), radius: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(seller.storeName, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
                      if (seller.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified_rounded, color: AppColors.primary, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(children: [Icon(Icons.star_rounded, color: AppColors.warning, size: 16), const SizedBox(width: 4), Text(seller.rating.toStringAsFixed(1), style: AppTextStyles.bodySmall)]),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text('View Store', style: AppTextStyles.button.copyWith(fontSize: 14)),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text('Contact', style: TextStyle(color: AppColors.primary, fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShopController extends ChangeNotifier {
  final List<dynamic> _mixedItems = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final StreamController<List<SellerModel>> _sellersController = StreamController.broadcast();

  List<dynamic> get mixedItems => List.unmodifiable(_mixedItems);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  Stream<List<SellerModel>> get sellersStream => _sellersController.stream;

  Future<void> fetchInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _mixedItems.clear();
      _currentPage = 1;
      _hasMore = true;
      final sellers = await MockShopService.getTrendingSellers();
      _sellersController.add(sellers);
      await _fetchNextPage();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      await _fetchNextPage();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> _fetchNextPage() async {
    final products = await MockShopService.getFeaturedProducts();
    final auctions = await MockShopService.getLiveAuctions();
    if (products.isEmpty && auctions.isEmpty) {
      _hasMore = false;
      return;
    }
    final newItems = <dynamic>[];
    newItems.addAll(products.take(3));
    newItems.addAll(auctions.take(2));
    newItems.shuffle();
    _mixedItems.addAll(newItems);
    _currentPage++;
  }

  Future<void> refresh() async => await fetchInitialData();

  @override
  void dispose() {
    _sellersController.close();
    super.dispose();
  }
}
