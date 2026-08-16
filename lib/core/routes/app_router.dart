import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

// Features Imports
import '../../features/splash/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/categories/screens/categories_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

import '../../features/products/screens/search_screen.dart';
import '../../features/products/screens/product_listing_screen.dart';
import '../../features/products/screens/product_details_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/checkout/screens/order_success_screen.dart';
import '../../features/orders/screens/order_details_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

import '../../features/cart/providers/cart_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Main Navigation Shell (Home, Categories, Cart, Orders, Profile)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          int currentIndex = 0;
          final location = state.uri.path;
          if (location.startsWith('/categories')) {
            currentIndex = 1;
          } else if (location.startsWith('/cart')) {
            currentIndex = 2;
          } else if (location.startsWith('/orders')) {
            currentIndex = 3;
          } else if (location.startsWith('/profile')) {
            currentIndex = 4;
          }

          final cartProvider = Provider.of<CartProvider>(context);

          return Scaffold(
            body: child,
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: currentIndex,
              cartBadgeCount: cartProvider.itemCount,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/categories');
                    break;
                  case 2:
                    context.go('/cart');
                    break;
                  case 3:
                    context.go('/orders');
                    break;
                  case 4:
                    context.go('/profile');
                    break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Standalone / Detail Routes
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/products',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProductListingScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailsScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-success/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return OrderSuccessScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/order-details/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return OrderDetailsScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/wishlist',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
