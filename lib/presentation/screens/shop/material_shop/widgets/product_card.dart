// lib/presentation/screens/shop/material_shop/widgets/product_card.dart
//
// ═══ ملف البرميل (Barrel Export) ═══
//
// بدلاً من ملف واحد بـ 1225 سطر، أصبح المشروع مقسّماً هكذا:
//
//  ┌─────────────────────────────────────────────────────────┐
//  │  product_palette_utils.dart      80 سطر                 │
//  │  → دوال الألوان + productPaletteProvider                 │
//  ├─────────────────────────────────────────────────────────┤
//  │  product_detail_widgets.dart    268 سطر                 │
//  │  → ProductBadge, SmallBadge, DetailSection,              │
//  │    QtyButton, SpecRow, ReviewItem                        │
//  ├─────────────────────────────────────────────────────────┤
//  │  product_card_item.dart         261 سطر                 │
//  │  → ProductCard (بطاقة الشبكة)                           │
//  ├─────────────────────────────────────────────────────────┤
//  │  product_detail_selectors.dart  315 سطر                 │
//  │  → ColorPicker, SizePicker, SellerCard, QuantityRow     │
//  ├─────────────────────────────────────────────────────────┤
//  │  product_detail_tabs.dart       160 سطر                 │
//  │  → DescriptionTab, ReviewsTab                            │
//  ├─────────────────────────────────────────────────────────┤
//  │  product_detail_body.dart       242 سطر                 │
//  │  → ProductDetailBody, ProductInfoHeader                  │
//  ├─────────────────────────────────────────────────────────┤
//  │  product_detail_page.dart       529 سطر                 │
//  │  → ProductDetailPage (الصفحة الكاملة مع AppBar)         │
//  └─────────────────────────────────────────────────────────┘
//
// الاستخدام: import '.../widgets/product_card.dart';
// ──────────────────────────────────────────────────────────────

export 'product_palette_utils.dart';
export 'product_detail_widgets.dart';
export 'product_card_item.dart';
export 'product_detail_selectors.dart';
export 'product_detail_tabs.dart';
export 'product_detail_body.dart';
export 'product_detail_page.dart';
