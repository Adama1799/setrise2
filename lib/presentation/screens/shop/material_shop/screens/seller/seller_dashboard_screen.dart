import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/orders_provider.dart';

// ─── Seller Product Model ─────────────────────────────────────
class SellerProduct {
  final String id, name, emoji;
  double price;
  int stock;
  final int sales;
  bool isActive;

  SellerProduct({required this.id, required this.name, required this.emoji, required this.price, required this.stock, required this.sales, this.isActive = true});
}

class SellerProductsNotifier extends StateNotifier<List<SellerProduct>> {
  SellerProductsNotifier() : super([
    SellerProduct(id: 'sp1', name: 'SteelSeries Arctis Pro Headset', emoji: '🎧', price: 185.00, stock: 12, sales: 34),
    SellerProduct(id: 'sp2', name: 'Mechanical Gaming Keyboard RGB',  emoji: '⌨️', price: 92.50,  stock: 8,  sales: 21),
    SellerProduct(id: 'sp3', name: 'Limited Edition Gaming Mouse',     emoji: '🖱️', price: 67.00,  stock: 25, sales: 56),
    SellerProduct(id: 'sp4', name: '4K Gaming Monitor 144Hz',          emoji: '🖥️', price: 310.00, stock: 3,  sales: 12),
    SellerProduct(id: 'sp5', name: 'Wireless Gaming Controller',       emoji: '🎮', price: 55.00,  stock: 18, sales: 29),
  ]);

  void delete(String id) => state = state.where((p) => p.id != id).toList();

  void toggleActive(String id) {
    state = [for (final p in state) if (p.id == id) SellerProduct(id: p.id, name: p.name, emoji: p.emoji, price: p.price, stock: p.stock, sales: p.sales, isActive: !p.isActive) else p];
  }

  void update(String id, {double? price, int? stock}) {
    state = [for (final p in state) if (p.id == id) SellerProduct(id: p.id, name: p.name, emoji: p.emoji, price: price ?? p.price, stock: stock ?? p.stock, sales: p.sales, isActive: p.isActive) else p];
  }

  void add(SellerProduct p) => state = [...state, p];
}

final sellerProductsProvider = StateNotifierProvider<SellerProductsNotifier, List<SellerProduct>>((_) => SellerProductsNotifier());

// ─── Weekly Sales Data (dummy) ───────────────────────────────
const _weeklySales = [1200.0, 980.0, 1450.0, 2100.0, 1750.0, 2400.0, 1890.0];
const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

// ─── Screen ──────────────────────────────────────────────────
class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final orders   = ref.watch(ordersProvider);
    final products = ref.watch(sellerProductsProvider);
    final revenue  = orders.fold<double>(0, (s, o) => s + o.total);
    final weekRevenue = _weeklySales.reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        title: Text('Seller Dashboard', style: AppTextStyles.headline3),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddProduct(context),
            icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.ctaPrimaryBg),
            label: Text('Add', style: AppTextStyles.bodySmall.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(AppDimensions.lg), child: Column(children: [
            // Stats Grid
            GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.7, crossAxisSpacing: AppDimensions.sm, mainAxisSpacing: AppDimensions.sm, children: [
              _StatCard('\$${revenue.toStringAsFixed(0)}', 'Total Revenue',  Icons.attach_money_rounded,     AppColors.success),
              _StatCard('${orders.length}',               'Orders',         Icons.receipt_long_rounded,      AppColors.ctaPrimaryBg),
              _StatCard('${products.length}',             'Products',       Icons.inventory_2_rounded,       const Color(0xFF9C27B0)),
              _StatCard('4.8 ⭐',                        'Avg Rating',     Icons.star_rounded,              AppColors.ratingFilled),
            ]),

            const SizedBox(height: AppDimensions.lg),

            // Weekly Sales Chart
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('Weekly Revenue', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('\$${weekRevenue.toStringAsFixed(0)} this week', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: AppDimensions.md),
                // Bar Chart
                SizedBox(height: 100, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(_weeklySales.length, (i) {
                  final max = _weeklySales.reduce((a, b) => a > b ? a : b);
                  final ratio = _weeklySales[i] / max;
                  final isToday = i == 5;
                  return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    if (isToday) Text('\$${(_weeklySales[i] / 1000).toStringAsFixed(1)}k', style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700, fontSize: 9)),
                    const SizedBox(height: 2),
                    AnimatedContainer(duration: Duration(milliseconds: 300 + i * 50), height: 80 * ratio, decoration: BoxDecoration(
                      color: isToday ? AppColors.ctaPrimaryBg : AppColors.ctaPrimaryBg.withOpacity(0.25),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    )),
                  ])));
                }))),
                const SizedBox(height: AppDimensions.xs),
                Row(children: List.generate(_weekDays.length, (i) => Expanded(child: Text(_weekDays[i], style: AppTextStyles.caption.copyWith(color: i == 5 ? AppColors.ctaPrimaryBg : AppColors.textQuaternary, fontWeight: i == 5 ? FontWeight.w700 : FontWeight.w400, fontSize: 10), textAlign: TextAlign.center)))),
              ]),
            ),

            const SizedBox(height: AppDimensions.md),

            // Quick Actions
            Row(children: [
              _ActionBtn(Icons.add_box_outlined,      'Add Product', AppColors.ctaPrimaryBg,    () => _showAddProduct(context)),
              const SizedBox(width: AppDimensions.sm),
              _ActionBtn(Icons.analytics_outlined,    'Analytics',   const Color(0xFF9C27B0),  () {}),
              const SizedBox(width: AppDimensions.sm),
              _ActionBtn(Icons.local_offer_outlined,  'Promotions',  AppColors.ratingFilled,   () {}),
              const SizedBox(width: AppDimensions.sm),
              _ActionBtn(Icons.settings_outlined,     'Settings',    AppColors.textTertiary,   () {}),
            ]),
          ]))),

          SliverToBoxAdapter(child: Container(color: Colors.white, child: TabBar(
            controller: _tab,
            indicatorColor: AppColors.ctaPrimaryBg,
            labelColor: AppColors.ctaPrimaryBg,
            unselectedLabelColor: AppColors.textTertiary,
            labelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Products (${products.length})'),
              Tab(text: 'Orders (${orders.length})'),
              const Tab(text: 'Reviews'),
            ],
          ))),
        ],
        body: TabBarView(controller: _tab, children: [

          // ── Products Tab ──
          ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.lg),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.sm),
            itemBuilder: (_, i) => _ProductRow(product: products[i],
              onEdit: () => _showEditProduct(context, products[i]),
              onDelete: () => _confirmDelete(context, products[i]),
              onToggle: () => ref.read(sellerProductsProvider.notifier).toggleActive(products[i].id),
            ),
          ),

          // ── Orders Tab ──
          orders.isEmpty
            ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textQuaternary), SizedBox(height: AppDimensions.sm), Text('No orders yet', style: TextStyle(color: AppColors.textTertiary, fontFamily: 'Inter'))]))
            : ListView.separated(
                padding: const EdgeInsets.all(AppDimensions.lg),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.sm),
                itemBuilder: (_, i) {
                  final o = orders[i];
                  return Container(padding: const EdgeInsets.all(AppDimensions.md), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
                    child: Row(children: [
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: const Icon(Icons.receipt_long_rounded, color: AppColors.ctaPrimaryBg, size: 20)),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(o.id, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                        Text('${o.items.length} items · ${o.createdAt?.day ?? '-'}/${o.createdAt?.month ?? '-'}', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                      ])),
                      Text('\$${o.total.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.success)),
                    ]),
                  );
                },
              ),

          // ── Reviews Tab ──
          const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('⭐', style: TextStyle(fontSize: 48)),
            SizedBox(height: AppDimensions.md),
            Text('4.8 Average Rating', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Inter', color: AppColors.textPrimary)),
            SizedBox(height: AppDimensions.xs),
            Text('Based on 243 reviews', style: TextStyle(color: AppColors.textTertiary, fontFamily: 'Inter')),
          ])),
        ]),
      ),
    );
  }

  void _showAddProduct(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final emojis = ['🎧', '⌨️', '🖱️', '🖥️', '🎮', '📱', '💡', '🎒'];
    String selEmoji = '📦';
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => StatefulBuilder(builder: (_, set) => Padding(
      padding: EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.lg, AppDimensions.lg, MediaQuery.of(context).viewInsets.bottom + AppDimensions.lg),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text('Add New Product', style: AppTextStyles.headline3), const Spacer(), GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: AppColors.textTertiary))]),
        const SizedBox(height: AppDimensions.lg),
        // Emoji picker
        Text('Icon', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(height: 44, child: ListView(scrollDirection: Axis.horizontal, children: emojis.map((e) => GestureDetector(onTap: () => set(() => selEmoji = e), child: AnimatedContainer(duration: const Duration(milliseconds: 150), width: 44, height: 44, margin: const EdgeInsets.only(right: AppDimensions.xs), decoration: BoxDecoration(color: selEmoji == e ? AppColors.statusActiveBg : AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm), border: Border.all(color: selEmoji == e ? AppColors.ctaPrimaryBg : Colors.transparent)), child: Center(child: Text(e, style: const TextStyle(fontSize: 22)))))).toList())),
        const SizedBox(height: AppDimensions.md),
        _Field(ctrl: nameCtrl,  label: 'Product Name', hint: 'e.g. Gaming Headset Pro',  icon: Icons.inventory_2_outlined),
        const SizedBox(height: AppDimensions.sm),
        Row(children: [
          Expanded(child: _Field(ctrl: priceCtrl, label: 'Price (\$)', hint: '0.00', icon: Icons.attach_money_rounded, keyboard: TextInputType.number)),
          const SizedBox(width: AppDimensions.sm),
          SizedBox(width: 120, child: _Field(ctrl: stockCtrl, label: 'Stock', hint: '0', icon: Icons.inventory_outlined, keyboard: TextInputType.number)),
        ]),
        const SizedBox(height: AppDimensions.lg),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
          onPressed: () {
            if (nameCtrl.text.isNotEmpty) {
              ref.read(sellerProductsProvider.notifier).add(SellerProduct(id: DateTime.now().toString(), name: nameCtrl.text, emoji: selEmoji, price: double.tryParse(priceCtrl.text) ?? 0, stock: int.tryParse(stockCtrl.text) ?? 0, sales: 0));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd))),
          child: Text('Add Product', style: AppTextStyles.buttonLabel),
        )),
      ]),
    )));
  }

  void _showEditProduct(BuildContext context, SellerProduct p) {
    final priceCtrl = TextEditingController(text: p.price.toStringAsFixed(2));
    final stockCtrl = TextEditingController(text: p.stock.toString());
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      title: Row(children: [Text(p.emoji, style: const TextStyle(fontSize: 24)), const SizedBox(width: AppDimensions.sm), Expanded(child: Text('Edit Product', style: AppTextStyles.headline3))]),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(p.name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: AppDimensions.md),
        _Field(ctrl: priceCtrl, label: 'Price (\$)', hint: '0.00', icon: Icons.attach_money_rounded, keyboard: TextInputType.number),
        const SizedBox(height: AppDimensions.sm),
        _Field(ctrl: stockCtrl, label: 'Stock',    hint: '0',    icon: Icons.inventory_outlined,    keyboard: TextInputType.number),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
        ElevatedButton(
          onPressed: () {
            ref.read(sellerProductsProvider.notifier).update(p.id, price: double.tryParse(priceCtrl.text), stock: int.tryParse(stockCtrl.text));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
          child: Text('Save', style: AppTextStyles.buttonLabel),
        ),
      ],
    ));
  }

  void _confirmDelete(BuildContext context, SellerProduct p) => showDialog(context: context, builder: (_) => AlertDialog(
    backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
    title: Text('Delete Product', style: AppTextStyles.headline3),
    content: Text('Remove "${p.name}" from your store?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
      TextButton(onPressed: () { ref.read(sellerProductsProvider.notifier).delete(p.id); Navigator.pop(context); HapticFeedback.mediumImpact(); }, child: Text('Delete', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w700))),
    ],
  ));
}

// ─── Widgets ─────────────────────────────────────────────────
class _ProductRow extends StatelessWidget {
  final SellerProduct product;
  final VoidCallback onEdit, onDelete, onToggle;
  const _ProductRow({required this.product, required this.onEdit, required this.onDelete, required this.onToggle});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppDimensions.md),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Row(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: product.isActive ? AppColors.backgroundPrimary : AppColors.backgroundTertiary, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Center(child: Text(product.emoji, style: TextStyle(fontSize: 26, color: product.isActive ? null : Colors.grey)))),
      const SizedBox(width: AppDimensions.md),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(product.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: product.isActive ? AppColors.textPrimary : AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Row(children: [
          Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700)),
          const SizedBox(width: AppDimensions.sm),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: product.stock <= 5 ? AppColors.statusCancelledBg : AppColors.statusDeliveredBg, borderRadius: BorderRadius.circular(AppDimensions.radiusXs)), child: Text('Stock: ${product.stock}', style: AppTextStyles.caption.copyWith(color: product.stock <= 5 ? AppColors.error : AppColors.success, fontWeight: FontWeight.w600, fontSize: 10))),
          const SizedBox(width: AppDimensions.xs),
          Text('· ${product.sales} sold', style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary)),
        ]),
      ])),
      // Toggle active
      GestureDetector(onTap: onToggle, child: Container(width: 32, height: 18, decoration: BoxDecoration(color: product.isActive ? AppColors.success : AppColors.borderMedium, borderRadius: BorderRadius.circular(9)), child: AnimatedAlign(duration: const Duration(milliseconds: 200), alignment: product.isActive ? Alignment.centerRight : Alignment.centerLeft, child: Container(width: 14, height: 14, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))))),
      const SizedBox(width: AppDimensions.sm),
      GestureDetector(onTap: onEdit, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.statusActiveBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.ctaPrimaryBg))),
      const SizedBox(width: AppDimensions.xs),
      GestureDetector(onTap: onDelete, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.statusCancelledBg, borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error))),
    ]),
  );
}

class _StatCard extends StatelessWidget {
  final String value, label; final IconData icon; final Color color;
  const _StatCard(this.value, this.label, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(AppDimensions.md), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [Icon(icon, size: 18, color: color), const Spacer(), Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle))]),
      Text(value, style: AppTextStyles.priceMedium.copyWith(fontWeight: FontWeight.w800, color: color)),
      Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
    ]),
  );
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _ActionBtn(this.icon, this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => Expanded(child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: AppDimensions.md), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusMd), border: Border.all(color: color.withOpacity(0.2))),
    child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 22, color: color), const SizedBox(height: 4), Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 10), textAlign: TextAlign.center)]))));
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl; final String label, hint; final IconData icon; final TextInputType keyboard;
  const _Field({required this.ctrl, required this.label, required this.hint, required this.icon, this.keyboard = TextInputType.text});
  @override
  Widget build(BuildContext context) => TextField(controller: ctrl, keyboardType: keyboard, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
    decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon, size: 18, color: AppColors.textTertiary), labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textTertiary), hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary), filled: true, fillColor: AppColors.backgroundPrimary, contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.md),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: const BorderSide(color: AppColors.ctaPrimaryBg, width: 1.5))));
}
