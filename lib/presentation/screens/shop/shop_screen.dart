import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final Set<int> _cartItems = {};
  final Set<int> _wishlist = {};
  String? _selectedCategory;

  final List<String> _categories = ['🔥 All','📱 For You','👥 Following','👕 Fashion','📱 Tech','🏠 Home','💄 Beauty','🎮 Gaming','🎧 Audio'];

  final List<Map<String, dynamic>> _products = [
    {'name':'AirBeat Pro X','brand':'TechAudio','price':129.99,'oldPrice':179.99,'rating':4.8,'sold':12400,'color':const Color(0xFF0A1628),'category':'🎧 Audio','isHot':true},
    {'name':'Urban Hoodie Black','brand':'SetRise Wear','price':49.99,'oldPrice':null,'rating':4.6,'sold':8200,'color':const Color(0xFF1A1A1A),'category':'👕 Fashion','isHot':false},
    {'name':'SmartRing Gen 3','brand':'RizeTech','price':299.99,'oldPrice':399.99,'rating':4.9,'sold':3100,'color':const Color(0xFF1A0A2E),'category':'📱 Tech','isHot':true},
    {'name':'Glow Serum Set','brand':'NeoSkin','price':34.99,'oldPrice':null,'rating':4.7,'sold':19800,'color':const Color(0xFF2E0A1A),'category':'💄 Beauty','isHot':false},
    {'name':'GamerPad Ultra','brand':'ElitePlay','price':89.99,'oldPrice':119.99,'rating':4.5,'sold':6700,'color':const Color(0xFF0A1A0A),'category':'🎮 Gaming','isHot':true},
    {'name':'Minimal Desk Lamp','brand':'LightHome','price':44.99,'oldPrice':null,'rating':4.4,'sold':4200,'color':const Color(0xFF1A1A0A),'category':'🏠 Home','isHot':false},
    {'name':'Sport Runner Z','brand':'FlexWear','price':79.99,'oldPrice':99.99,'rating':4.7,'sold':15300,'color':const Color(0xFF0A2E2E),'category':'👕 Fashion','isHot':true},
    {'name':'LED Strip Kit','brand':'GlowRoom','price':19.99,'oldPrice':null,'rating':4.3,'sold':28000,'color':const Color(0xFF1A0A0A),'category':'🏠 Home','isHot':false},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == null || _selectedCategory == '🔥 All' || _selectedCategory == '📱 For You' || _selectedCategory == '👥 Following') return _products;
    return _products.where((p) => p['category'] == _selectedCategory).toList();
  }

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(children: [
            Expanded(child: Container(
              height: 36,
              decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(18)),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Row(children: [
                Icon(Icons.search, color: AppColors.grey2, size: 18), SizedBox(width: 8),
                Text('Search products...', style: TextStyle(color: AppColors.grey2, fontSize: 13, )),
              ]),
            )),
            const SizedBox(width: 10),
            Stack(children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.shopping_cart_outlined, color: AppColors.white, size: 20)),
              if (_cartItems.isNotEmpty)
                Positioned(top: 4, right: 4, child: Container(width: 14, height: 14,
                  decoration: const BoxDecoration(color: AppColors.shop, shape: BoxShape.circle),
                  child: Center(child: Text('${_cartItems.length}', style: const TextStyle(color: AppColors.black, fontSize: 8, fontWeight: FontWeight.bold))))),
            ]),
          ]),
        ),
        TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.shop,
          labelColor: AppColors.shop,
          unselectedLabelColor: AppColors.grey2,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, ),
          tabs: const [Tab(text: 'For You'), Tab(text: 'Following')],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final isSelected = (_selectedCategory == null && i == 0) || _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = i == 0 ? null : cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.shop : AppColors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(cat, style: TextStyle(color: isSelected ? AppColors.black : AppColors.white, fontSize: 12, fontWeight: FontWeight.w600, )),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72),
          itemCount: _filtered.length,
          itemBuilder: (_, i) {
            final p = _filtered[i];
            final idx = _products.indexOf(p);
            final inCart = _cartItems.contains(idx);
            final inWish = _wishlist.contains(idx);
            return GestureDetector(
              onTap: () => _openProduct(p, idx),
              child: Container(
                decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.grey.withOpacity(0.4))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(color: p['color'] as Color, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
                      child: Center(child: Icon(Icons.inventory_2_outlined, color: AppColors.white.withOpacity(0.2), size: 60)),
                    ),
                    if (p['isHot'] as bool)
                      Positioned(top: 8, left: 8, child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.neonRed, borderRadius: BorderRadius.circular(6)),
                        child: const Text('🔥 HOT', style: TextStyle(color: AppColors.white, fontSize: 9, fontWeight: FontWeight.bold)))),
                    if (p['oldPrice'] != null)
                      Positioned(top: 8, right: 36, child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.shop, borderRadius: BorderRadius.circular(6)),
                        child: Text('-${(((p['oldPrice'] as double) - (p['price'] as double)) / (p['oldPrice'] as double) * 100).round()}%',
                          style: const TextStyle(color: AppColors.black, fontSize: 9, fontWeight: FontWeight.bold)))),
                    Positioned(top: 8, right: 8, child: GestureDetector(
                      onTap: () => setState(() { inWish ? _wishlist.remove(idx) : _wishlist.add(idx); }),
                      child: Container(width: 28, height: 28,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                        child: Icon(inWish ? Icons.favorite : Icons.favorite_border, color: inWish ? AppColors.neonRed : AppColors.white, size: 16)))),
                  ])),
                  Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['name'], style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13, ), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(p['brand'], style: const TextStyle(color: AppColors.grey2, fontSize: 11, )),
                    const SizedBox(height: 6),
                    Row(children: [
                      Text('\$${p['price']}', style: const TextStyle(color: AppColors.shop, fontWeight: FontWeight.bold, fontSize: 14, )),
                      if (p['oldPrice'] != null) ...[const SizedBox(width: 4), Text('\$${p['oldPrice']}', style: const TextStyle(color: AppColors.grey2, fontSize: 11, decoration: TextDecoration.lineThrough))],
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() { inCart ? _cartItems.remove(idx) : _cartItems.add(idx); }),
                        child: Container(width: 28, height: 28,
                          decoration: BoxDecoration(color: inCart ? AppColors.shop : AppColors.grey, shape: BoxShape.circle),
                          child: Icon(inCart ? Icons.check : Icons.add, color: inCart ? AppColors.black : AppColors.white, size: 16))),
                    ]),
                  ])),
                ]),
              ),
            );
          },
        )),
      ],
    );
  }

  void _openProduct(Map p, int idx) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _ProductPage(product: p, idx: idx,
      inCart: _cartItems.contains(idx), onCart: () => setState(() { _cartItems.contains(idx) ? _cartItems.remove(idx) : _cartItems.add(idx); }))));
  }
}

// ===== PRODUCT DETAIL PAGE =====
class _ProductPage extends StatefulWidget {
  final Map product;
  final int idx;
  final bool inCart;
  final VoidCallback onCart;
  const _ProductPage({required this.product, required this.idx, required this.inCart, required this.onCart});
  @override
  State<_ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<_ProductPage> {
  int _qty = 1;
  bool _inCart = false;

  @override
  void initState() { super.initState(); _inCart = widget.inCart; }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount = p['oldPrice'] != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: AppColors.background,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20), onPressed: () => Navigator.pop(context)),
          actions: [
            IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.white), onPressed: () {}),
            Stack(children: [
              IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.white), onPressed: () {}),
              if (_inCart) Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.shop, shape: BoxShape.circle))),
            ]),
          ],
          expandedHeight: 320,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: p['color'] as Color,
              child: Center(child: Icon(Icons.inventory_2_outlined, color: AppColors.white.withOpacity(0.2), size: 120)),
            ),
          ),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (p['isHot'] as bool) ...[
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.neonRed, borderRadius: BorderRadius.circular(6)),
                child: const Text('🔥 HOT DEAL', style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
            ],
            Text(p['name'], style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold, )),
            Text(p['brand'], style: const TextStyle(color: AppColors.grey2, fontSize: 14, )),
            const SizedBox(height: 12),
            Row(children: [
              ...List.generate(5, (i) => Icon(Icons.star, color: i < (p['rating'] as double).floor() ? AppColors.neonYellow : AppColors.grey, size: 18)),
              const SizedBox(width: 8),
              Text('${p['rating']} · ${Formatters.formatCount(p['sold'] as int)} sold', style: const TextStyle(color: AppColors.grey2, fontSize: 13, )),
            ]),
            const SizedBox(height: 16),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('\$${p['price']}', style: const TextStyle(color: AppColors.shop, fontSize: 30, fontWeight: FontWeight.bold, )),
              if (hasDiscount) ...[
                const SizedBox(width: 12),
                Text('\$${p['oldPrice']}', style: const TextStyle(color: AppColors.grey2, fontSize: 18, decoration: TextDecoration.lineThrough)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.neonRed.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'Save ${(((p['oldPrice'] as double) - (p['price'] as double))).toStringAsFixed(0)}\$',
                    style: const TextStyle(color: AppColors.neonRed, fontSize: 12, fontWeight: FontWeight.bold))),
              ],
            ]),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Quantity:', style: TextStyle(color: AppColors.white, fontSize: 14, )),
              const SizedBox(width: 12),
              Row(children: [
                GestureDetector(onTap: () { if (_qty > 1) setState(() => _qty--); },
                  child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.remove, color: AppColors.white, size: 18))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('$_qty', style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold, ))),
                GestureDetector(onTap: () => setState(() => _qty++),
                  child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.add, color: AppColors.white, size: 18))),
              ]),
            ]),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.grey.withOpacity(0.4))),
              child: Row(children: [
                CircleAvatar(radius: 22, backgroundColor: p['color'] as Color, child: const Icon(Icons.store, color: AppColors.white, size: 22)),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p['brand'], style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14, )),
                  const Text('Official Store · ⭐ 4.9', style: TextStyle(color: AppColors.grey2, fontSize: 12, )),
                ]),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.shop), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Visit', style: TextStyle(color: AppColors.shop, fontSize: 12, ))),
              ]),
            ),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold, )),
            const SizedBox(height: 8),
            Text('High-quality ${p['name']} from ${p['brand']}. Rated ${p['rating']}/5 by ${Formatters.formatCount(p['sold'] as int)} customers. Free shipping on orders over \$50.',
              style: const TextStyle(color: AppColors.grey2, fontSize: 14, height: 1.5, )),
            const SizedBox(height: 100),
          ]),
        )),
      ]),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8, top: 12, left: 16, right: 16),
        decoration: BoxDecoration(color: AppColors.background, border: Border(top: BorderSide(color: AppColors.grey.withOpacity(0.4)))),
        child: Row(children: [
          GestureDetector(
            onTap: () { setState(() => _inCart = !_inCart); widget.onCart(); },
            child: Container(
              height: 52, width: 100,
              decoration: BoxDecoration(border: Border.all(color: AppColors.shop, width: 1.5), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(_inCart ? '✓ Cart' : 'Add Cart',
                style: TextStyle(color: _inCart ? AppColors.shop : AppColors.white, fontSize: 13, fontWeight: FontWeight.bold, ))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 52,
            decoration: BoxDecoration(color: AppColors.shop, borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text('Buy Now · \$${((p['price'] as double) * _qty).toStringAsFixed(2)}',
              style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.bold, ))))),
        ]),
      ),
    );
  }
}
