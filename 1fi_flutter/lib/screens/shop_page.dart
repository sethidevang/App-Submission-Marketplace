import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/context_ext.dart';
import '../widgets/empty_state.dart';
import '../widgets/hero_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/search_field.dart';
import '../widgets/shop_tabs.dart';
// import '../widgets/theme_toggle_button.dart';
import 'product_detail_screen.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  ShopTab _tab = ShopTab.marketplace;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const HeroBanner(),
                      Transform.translate(
                        offset: const Offset(0, -16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ShopTabs(
                            active: _tab,
                            onChanged: (t) => setState(() => _tab = t),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ..._tabSlivers(context),
              ],
            ),
            // Positioned(
            //   top: 10,
            //   right: 12,
            //   child: const ThemeToggleButton(),
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tabSlivers(BuildContext context) {
    switch (_tab) {
      case ShopTab.brands:
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SearchField(hint: 'Search online stores…'),
                  const EmptyState(
                    icon: Icons.storefront_outlined,
                    title: 'Top Brands',
                    message:
                        'Curated brand storefronts are coming soon here. Explore the 1Fi Marketplace tab in the meantime.',
                  ),
                ],
              ),
            ),
          ),
        ];
      case ShopTab.nearby:
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SearchField(hint: 'Search stores…'),
                  const EmptyState(
                    icon: Icons.place_outlined,
                    title: 'Nearby Stores',
                    message:
                        'Store locator for in-person No-Cost EMI purchases is coming soon.',
                  ),
                ],
              ),
            ),
          ),
        ];
      case ShopTab.marketplace:
        return _marketplaceSlivers(context);
    }
  }

  List<Widget> _marketplaceSlivers(BuildContext context) {
    final app = context.watch<AppState>();
    final c = context.colors;

    if (app.status == ProductsStatus.loading) {
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _marketplaceHeader(context, showEmpty: true),
          ),
        ),
      ];
    }

    if (app.status == ProductsStatus.error) {
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                _sectionHead(context),
                EmptyState(
                  icon: Icons.storefront_outlined,
                  title: "Couldn't load products",
                  message: 'Check your internet connection and try again.',
                  action: FilledButton(
                    onPressed: () => app.loadProducts(),
                    style: FilledButton.styleFrom(
                      backgroundColor: c.accent500,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    final filtered = app.filteredProducts;

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(
                hint: 'Search products…',
                initialValue: app.query,
                onChanged: (v) => context.read<AppState>().setQuery(v),
              ),
              const SizedBox(height: 18),
              _sectionHead(context),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kCategories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = kCategories[i];
                    final active = app.category == cat;
                    return _CategoryChip(
                      label: cat,
                      active: active,
                      onTap: () => context.read<AppState>().setCategory(cat),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
      if (filtered.isEmpty)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No products match your search.',
                style: TextStyle(fontSize: 13, color: c.text3),
              ),
            ),
          ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.58,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = filtered[i];
                return ProductCard(
                  product: p,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: p),
                    ),
                  ),
                );
              },
              childCount: filtered.length,
            ),
          ),
        ),
    ];
  }

  Widget _sectionHead(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1Fi Marketplace',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: c.text,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Shop top products on No-Cost EMI',
          style: TextStyle(fontSize: 12.5, color: c.text2),
        ),
      ],
    );
  }

  Widget _marketplaceHeader(BuildContext context, {required bool showEmpty}) {
    return Column(
      children: [
        _sectionHead(context),
        if (showEmpty)
          const EmptyState(
            icon: Icons.storefront_outlined,
            title: 'Loading products…',
            message: 'Fetching the latest catalog from the 1Fi database.',
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CategoryChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? c.accent500 : c.surface,
          border: Border.all(color: active ? c.accent500 : c.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : c.text2,
          ),
        ),
      ),
    );
  }
}
