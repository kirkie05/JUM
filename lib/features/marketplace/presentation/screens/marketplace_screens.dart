import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../data/models/product_model.dart';
import '../../data/models/order_model.dart';
import '../../data/providers/marketplace_providers.dart';

// -------------------------------------------------------------
// PRODUCT LIST SCREEN (MARKETPLACE)
// -------------------------------------------------------------
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Digital', 'Physical'];

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'JUM Marketplace',
          style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded, color: AppColors.accent),
            tooltip: 'My Purchases',
            onPressed: () => context.push('/profile/orders'),
          ),
        ],
      ),
      body: Column(
        children: [
          // CATEGORIES HORIZONTAL SCROLL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg, vertical: AppSizes.paddingMd),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isActive = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isActive,
                      selectedColor: AppColors.accent,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isActive ? Colors.black : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = cat);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // PRODUCTS GRID
          Expanded(
            child: productsAsync.when(
              data: (productsList) {
                final filtered = _selectedCategory == 'All'
                    ? productsList
                    : productsList.where((p) => p.type.toUpperCase() == _selectedCategory.toUpperCase()).toList();

                if (filtered.isEmpty) {
                  return const JumEmptyState(
                    title: 'No products found',
                    subtitle: 'There are currently no products available in this category.',
                    icon: Icons.shopping_bag_outlined,
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.paddingMd,
                    mainAxisSpacing: AppSizes.paddingMd,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    final isDigital = product.isDigital;

                    return InkWell(
                      onTap: () => context.push('/marketplace/${product.id}'),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      child: JumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.surface2,
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
                                    ),
                                    child: Center(
                                      child: product.imageUrl != null
                                          ? Image.network(
                                              product.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(
                                                isDigital ? Icons.menu_book_rounded : Icons.shopping_bag_rounded,
                                                size: 48,
                                                color: AppColors.primaryLight,
                                              ),
                                            )
                                          : Icon(
                                              isDigital ? Icons.menu_book_rounded : Icons.shopping_bag_rounded,
                                              size: 48,
                                              color: AppColors.primaryLight,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isDigital ? AppColors.info.withOpacity(0.9) : AppColors.success.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        product.type.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppSizes.paddingMd),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    product.title,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Gap(4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        product.stock > 0 ? 'In Stock' : 'Out of Stock',
                                        style: AppTextStyles.caption.copyWith(
                                          color: product.stock > 0 ? AppColors.success : AppColors.error,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(12),
                                  SizedBox(
                                    height: 32,
                                    child: JumButton(
                                      label: 'Buy Now',
                                      isFullWidth: true,
                                      variant: JumButtonVariant.secondary,
                                      onPressed: product.stock > 0
                                          ? () => context.push('/marketplace/${product.id}')
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// PRODUCT DETAIL SCREEN
// -------------------------------------------------------------
class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: productAsync.when(
        data: (product) {
          final isDigital = product.isDigital;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              isDigital ? Icons.menu_book_rounded : Icons.shopping_bag_rounded,
                              size: 96,
                              color: AppColors.accent,
                            ),
                          )
                        : Icon(
                            isDigital ? Icons.menu_book_rounded : Icons.shopping_bag_rounded,
                            size: 96,
                            color: AppColors.accent,
                          ),
                  ),
                ),
                const Gap(24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDigital ? AppColors.info.withOpacity(0.2) : AppColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.type.toUpperCase(),
                        style: TextStyle(
                          color: isDigital ? AppColors.info : AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Gap(12),
                    _buildStockIndicator(product.stock),
                  ],
                ),
                const Gap(16),
                Text(
                  product.title,
                  style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.h2.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
                const Gap(24),
                Text(
                  'Description',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                Text(
                  product.description,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                ),
                const Gap(32),
                JumButton(
                  label: 'Proceed to Checkout',
                  isFullWidth: true,
                  onPressed: product.stock > 0
                      ? () => _startStripeCheckout(context, ref, product)
                      : null,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
      ),
    );
  }

  Widget _buildStockIndicator(int stock) {
    String label;
    Color color;

    if (stock == 0) {
      label = 'Out of Stock';
      color = AppColors.error;
    } else if (stock < 5) {
      label = 'Low Stock ($stock left)';
      color = AppColors.warning;
    } else {
      label = 'In Stock';
      color = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _startStripeCheckout(BuildContext context, WidgetRef ref, ProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stripe Checkout',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Gap(16),
              const Divider(color: AppColors.border),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Product', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  Text(product.title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                ],
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                ],
              ),
              const Gap(24),
              JumButton(
                label: 'Pay Now with Stripe',
                isFullWidth: true,
                onPressed: () async {
                  Navigator.pop(context); // Close bottom sheet
                  
                  // Show processing dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                  );

                  // Perform actual purchase via riverpod BuyProductNotifier
                  final order = await ref.read(buyProductNotifierProvider.notifier).buy(product);
                  
                  if (context.mounted) {
                    Navigator.pop(context); // Close processing dialog
                    
                    if (order != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Purchase of ${product.title} successful!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      context.push('/profile/orders');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment failed. Please try again.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------
// MY ORDERS SCREEN
// -------------------------------------------------------------
class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Purchases'),
      ),
      body: ordersAsync.when(
        data: (ordersList) {
          if (ordersList.isEmpty) {
            return JumEmptyState(
              title: 'No purchases yet',
              subtitle: 'Any products you purchase from our marketplace will show up here.',
              icon: Icons.receipt_long_rounded,
              actionLabel: 'Go to Marketplace',
              onAction: () => context.push('/marketplace'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              final order = ordersList[index];
              final product = order.product;
              final isDigital = product?.isDigital ?? true;
              final formattedDate = '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                child: JumCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          ),
                          child: product?.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                  child: Image.network(
                                    product!.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      isDigital ? Icons.menu_book_rounded : Icons.shopping_bag_rounded,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                )
                              : Icon(
                                  isDigital ? Icons.menu_book_rounded : Icons.shopping_bag_rounded,
                                  color: AppColors.accent,
                                ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.title ?? 'Product Purchase',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                'Purchased on $formattedDate',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                              ),
                              const Gap(4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${(order.product?.price ?? 0.0).toStringAsFixed(2)}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      order.status.toUpperCase(),
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (isDigital) ...[
                                const Gap(12),
                                SizedBox(
                                  height: 32,
                                  child: JumButton(
                                    label: 'Download Product',
                                    isFullWidth: true,
                                    variant: JumButtonVariant.secondary,
                                    onPressed: () {
                                      _startDownloadAnimation(context, product?.title ?? 'Digital Product');
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.error))),
      ),
    );
  }

  void _startDownloadAnimation(BuildContext context, String productTitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _DownloadDialog(productTitle: productTitle);
      },
    );
  }
}

class _DownloadDialog extends StatefulWidget {
  final String productTitle;
  const _DownloadDialog({Key? key, required this.productTitle}) : super(key: key);

  @override
  State<_DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<_DownloadDialog> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _simulateDownload();
  }

  void _simulateDownload() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return false;
      setState(() {
        _progress += 0.1;
      });
      if (_progress >= 1.0) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.productTitle} downloaded successfully to your device!'),
            backgroundColor: AppColors.success,
          ),
        );
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Downloading Product', style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.productTitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const Gap(16),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.border,
            color: AppColors.accent,
          ),
          const Gap(8),
          Text(
            '${(_progress * 100).toInt()}% completed',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
