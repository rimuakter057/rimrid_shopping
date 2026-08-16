import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/empty_state_widget.dart';
import '../../../core/widgets/common/no_internet_widget.dart';
import '../../../core/widgets/fields/search_field.dart';
import '../../../core/widgets/loaders/loading_widget.dart';
import '../../products/providers/product_provider.dart';

enum CategoryViewMode { grid, list }

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  CategoryViewMode _viewMode = CategoryViewMode.grid;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.isLoading) {
      return const Scaffold(
        body: LoadingWidget(message: 'Loading Categories...'),
      );
    }

    if (productProvider.hasNetworkError) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'All Categories'),
        body: NoInternetWidget(
          message: productProvider.errorMessage,
          onRetry: () => productProvider.loadData(),
        ),
      );
    }

    final allCategories = productProvider.categories;
    final filteredCategories = allCategories.where((c) {
      if (_query.trim().isEmpty) return true;
      return c.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'All Categories',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(
              _viewMode == CategoryViewMode.grid
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
              color: AppColors.primary,
            ),
            tooltip: 'Switch View Mode',
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == CategoryViewMode.grid
                    ? CategoryViewMode.list
                    : CategoryViewMode.grid;
              });
              AppLogger.logEvent('CATEGORIES SCREEN', '👁️ Toggled View Mode to: ${_viewMode.name.toUpperCase()}');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => productProvider.refreshData(),
          color: AppColors.primary,
          child: Column(
            children: [
              // Search & Controls Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
                child: Column(
                  children: [
                    SearchField(
                      controller: _searchController,
                      hint: 'Search categories (e.g. Fashion, Electronics...)',
                      onChanged: (q) {
                        setState(() => _query = q);
                        AppLogger.logEvent('CATEGORIES SCREEN', '🔎 Searching categories for: "$q"');
                      },
                      onClear: () {
                        setState(() => _query = '');
                        AppLogger.logEvent('CATEGORIES SCREEN', '🧹 Cleared category search');
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${filteredCategories.length} Categories',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.grid_view_rounded,
                                size: 20,
                                color: _viewMode == CategoryViewMode.grid
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                              onPressed: () => setState(() => _viewMode = CategoryViewMode.grid),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.view_list_rounded,
                                size: 22,
                                color: _viewMode == CategoryViewMode.list
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                              onPressed: () => setState(() => _viewMode = CategoryViewMode.list),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Content Area (Grid or List)
              Expanded(
                child: filteredCategories.isEmpty
                    ? EmptyStateWidget(
                        title: 'No Categories Found',
                        description: 'No categories matched "$_query". Try another search term.',
                        icon: Icons.category_outlined,
                        buttonText: 'Show All Categories',
                        onButtonPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : _viewMode == CategoryViewMode.grid
                        ? _buildGridView(context, filteredCategories, padding, productProvider)
                        : _buildListView(context, filteredCategories, padding, productProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List categories,
    double padding,
    ProductProvider productProvider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = ResponsiveHelper.isDesktop(context);
        final isTablet = ResponsiveHelper.isTablet(context);
        final crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);

        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.25,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                AppLogger.logEvent('CATEGORIES SCREEN', '👆 Clicked category: "${category.name}"');
                productProvider.selectCategory(category.name);
                context.push('/products');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.radiusLg,
                  boxShadow: AppShadows.softShadowList,
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.radiusLg,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadius.radiusSm,
                        ),
                        child: Text(
                          '${category.itemCount} Items',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
    );
  }

  Widget _buildListView(
    BuildContext context,
    List categories,
    double padding,
    ProductProvider productProvider,
  ) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.radiusLg,
            boxShadow: AppShadows.softShadowList,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            onTap: () {
              AppLogger.logEvent('CATEGORIES SCREEN', '👆 Clicked category item: "${category.name}"');
              productProvider.selectCategory(category.name);
              context.push('/products');
            },
            leading: ClipRRect(
              borderRadius: AppRadius.radiusMd,
              child: Image.network(
                category.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.category_rounded, color: AppColors.primary),
                ),
              ),
            ),
            title: Text(
              category.name,
              style: AppTextStyles.title.copyWith(fontSize: 16),
            ),
            subtitle: Text(
              '${category.itemCount} Products Available',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
