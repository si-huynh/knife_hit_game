import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knife_hit_game/blocs/user_session_bloc/user_session_bloc.dart';
import 'package:knife_hit_game/models/knife_item.dart';
import 'package:knife_hit_game/services/knife_subscription_service.dart';
import 'package:knife_hit_game/widgets/knife_category_grid.dart';
import 'package:knife_hit_game/widgets/notification_button.dart';
import 'package:knife_hit_game/widgets/subscription_status_card.dart';

@RoutePage()
class EquipmentsPage extends StatefulWidget {
  const EquipmentsPage({super.key});

  @override
  State<EquipmentsPage> createState() => _EquipmentsPageState();
}

class _EquipmentsPageState extends State<EquipmentsPage> {
  final subscriptionService = KnifeSubscriptionService();

  List<KnifeItem> knives = [];
  Map<String, List<KnifeItem>> categorizedKnives = {};
  List<String> categories = [
    'Starter',
    'Elite',
    'Luxury',
    'Premium',
    'Ultimate',
  ];

  // Track the selected knife
  KnifeItem? selectedKnife;

  // Subscription info
  bool isLoading = true;
  List<SubscriptionInfo> subscriptions = [];
  String currentUserId = '';
  Set<String> availableTiers = {'basic'};

  @override
  void initState() {
    _checkSubscription();
    super.initState();
  }

  Future<void> _checkSubscription() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the user ID from UserService (cached from deep link or default)
      final userId = context.read<UserSessionBloc>().state.userId;
      if (userId == null) {
        return;
      }
      currentUserId = userId.split(':')[1].trim(); // Store for display

      // Fetch all subscriptions
      subscriptions = await subscriptionService.getAllUserSubscriptions(
        currentUserId,
      );

      // Get all available tiers from subscriptions
      availableTiers = subscriptionService.getAllKnifeTiers(subscriptions);

      // Load knives with locked status based on subscriptions
      _loadKnives();
    } catch (e) {
      // Load knives with default access (basic only)
      subscriptions = [];
      availableTiers = {'basic'};
      _loadKnives();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadKnives() {
    // Populate the knives list with data
    knives = [
      KnifeItem(
        imagePath: 'assets/images/knives/basic.png',
        name: 'Basic Knife',
        category: 'Starter',
        price: 0,
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/elite1.png',
        name: 'Elite I',
        category: 'Elite',
        price: 100,
        isLocked: !_hasAccessToCategory('Elite'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/elite2.png',
        name: 'Elite II',
        category: 'Elite',
        price: 150,
        isLocked: !_hasAccessToCategory('Elite'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/elite3.png',
        name: 'Elite III',
        category: 'Elite',
        price: 200,
        isLocked: !_hasAccessToCategory('Elite'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/elite4.png',
        name: 'Elite IV',
        category: 'Elite',
        price: 250,
        isLocked: !_hasAccessToCategory('Elite'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/lux1.png',
        name: 'Luxury I',
        category: 'Luxury',
        price: 300,
        isLocked: !_hasAccessToCategory('Luxury'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/lux2.png',
        name: 'Luxury II',
        category: 'Luxury',
        price: 350,
        isLocked: !_hasAccessToCategory('Luxury'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/lux3.png',
        name: 'Luxury III',
        category: 'Luxury',
        price: 400,
        isLocked: !_hasAccessToCategory('Luxury'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/lux4.png',
        name: 'Luxury IV',
        category: 'Luxury',
        price: 450,
        isLocked: !_hasAccessToCategory('Luxury'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/pre1.png',
        name: 'Premium I',
        category: 'Premium',
        price: 500,
        isLocked: !_hasAccessToCategory('Premium'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/pre2.png',
        name: 'Premium II',
        category: 'Premium',
        price: 550,
        isLocked: !_hasAccessToCategory('Premium'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/pre3.png',
        name: 'Premium III',
        category: 'Premium',
        price: 600,
        isLocked: !_hasAccessToCategory('Premium'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/pre4.png',
        name: 'Premium IV',
        category: 'Premium',
        price: 650,
        isLocked: !_hasAccessToCategory('Premium'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/ulti1.png',
        name: 'Ultimate I',
        category: 'Ultimate',
        price: 700,
        isLocked: !_hasAccessToCategory('Ultimate'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/ulti2.png',
        name: 'Ultimate II',
        category: 'Ultimate',
        price: 750,
        isLocked: !_hasAccessToCategory('Ultimate'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/ulti3.png',
        name: 'Ultimate III',
        category: 'Ultimate',
        price: 800,
        isLocked: !_hasAccessToCategory('Ultimate'),
      ),
      KnifeItem(
        imagePath: 'assets/images/knives/ulti4.png',
        name: 'Ultimate IV',
        category: 'Ultimate',
        price: 850,
        isLocked: !_hasAccessToCategory('Ultimate'),
      ),
    ];

    // Categorize knives
    categorizedKnives = {};
    for (final knife in knives) {
      if (!categorizedKnives.containsKey(knife.category)) {
        categorizedKnives[knife.category] = [];
      }
      categorizedKnives[knife.category]!.add(knife);
    }

    // Load previously selected knife or set Basic Knife as default
    _loadSelectedKnife();
  }

  // Helper method to check if a category is accessible
  bool _hasAccessToCategory(String category) {
    final categoryLower = category.toLowerCase();
    return availableTiers.contains(categoryLower);
  }

  // Get visible categories based on subscriptions
  List<String> _getVisibleCategories() {
    return categories.where((category) {
      if (category.toLowerCase() == 'starter') {
        return true;
      }
      return _hasAccessToCategory(category.toLowerCase());
    }).toList();
  }

  // Get subscription status text
  String _getSubscriptionStatusText() {
    if (subscriptions.isEmpty) {
      return 'No active subscriptions';
    }
    return subscriptionService.getAllSubscriptionDetails(subscriptions);
  }

  Future<void> _loadSelectedKnife() async {
    // Get the knife path from the UserSessionBloc
    final userSessionState = context.read<UserSessionBloc>().state;
    final savedKnifePath = userSessionState.selectedKnifePath;

    if (savedKnifePath.isNotEmpty) {
      try {
        // Find the knife with the saved path
        final knife = knives.firstWhere(
          (knife) => knife.imagePath == savedKnifePath,
          orElse:
              () => knives.firstWhere((knife) => knife.name == 'Basic Knife'),
        );

        // Only select the knife if it's not locked
        if (!knife.isLocked) {
          selectedKnife = knife;
        } else {
          // If the previously selected knife is now locked, default to Basic Knife
          selectedKnife = knives.firstWhere(
            (knife) => knife.name == 'Basic Knife',
          );

          // Update the UserSessionBloc with the default knife
          context.read<UserSessionBloc>().add(
            UserSessionEvent.updateSelectedKnife(selectedKnife!.imagePath),
          );
        }
      } catch (e) {
        selectedKnife = knives.firstWhere(
          (knife) => knife.name == 'Basic Knife',
        );

        // Update the UserSessionBloc with the default knife
        context.read<UserSessionBloc>().add(
          UserSessionEvent.updateSelectedKnife(selectedKnife!.imagePath),
        );
      }
    } else {
      selectedKnife = knives.firstWhere((knife) => knife.name == 'Basic Knife');

      // Update the UserSessionBloc with the default knife
      context.read<UserSessionBloc>().add(
        UserSessionEvent.updateSelectedKnife(selectedKnife!.imagePath),
      );
    }

    setState(() {});
  }

  void _selectKnife(KnifeItem knife) {
    // Only allow selection of unlocked knives
    if (!knife.isLocked) {
      setState(() {
        selectedKnife = knife;
      });

      // Immediately apply the selected knife
      context.read<UserSessionBloc>().add(
        UserSessionEvent.updateSelectedKnife(knife.imagePath),
      );

      // Show a snackbar to confirm selection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${knife.name} selected!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      _showSubscriptionDialog(knife.category);
    }
  }

  void _showSubscriptionDialog(String category) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Subscription Required'),
            content: Text(
              'You need a ${category.toLowerCase()} subscription to use this knife. '
              'Would you like to upgrade your subscription?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Not Now'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Here you would navigate to your subscription page
                  // For example: Navigator.pushNamed(context, '/subscribe');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const Text('Subscribe'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get visible categories based on subscriptions
    final visibleCategories = _getVisibleCategories();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(180),
          border: Border.all(color: Colors.orange, width: 4),
          borderRadius: const BorderRadius.all(Radius.circular(64)),
        ),
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                )
                : _buildStoreContent(visibleCategories),
      ),
    );
  }

  Widget _buildStoreContent(List<String> visibleCategories) {
    return Column(
      children: [
        _buildStoreHeader(),
        _buildKnifeCollectionContent(visibleCategories),
      ],
    );
  }

  Widget _buildStoreHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.router.pop(),
            icon: Image.asset(
              'assets/images/layers/back_button.png',
              width: 48,
              height: 48,
            ),
          ),
          const Text(
            'Knife Store',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Notification button
          const NotificationButton(),
        ],
      ),
    );
  }

  Widget _buildKnifeCollectionContent(List<String> visibleCategories) {
    return Expanded(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent:
            1000, // Increase cache extent to prevent items from disappearing
        slivers: [
          // Subscription status display
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SubscriptionStatusCard(
                statusText: _getSubscriptionStatusText(),
                userId: currentUserId,
              ),
            ),
          ),

          // Knife collection header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Knife Collection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Knife categories
          ...visibleCategories.map((category) {
            if (!categorizedKnives.containsKey(category) ||
                categorizedKnives[category]!.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }

            // Determine the appropriate crossAxisCount based on screen width
            final screenWidth = MediaQuery.of(context).size.width;
            final crossAxisCount =
                screenWidth < 360 ? 3 : 4; // Use 3 columns on smaller screens

            return SliverToBoxAdapter(
              child: KnifeCategoryGrid(
                category: category,
                knives: categorizedKnives[category]!,
                selectedKnife: selectedKnife,
                onKnifeSelected: _selectKnife,
                crossAxisCount: crossAxisCount,
              ),
            );
          }),

          // Add some bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Logout button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle logout
  void _handleLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text(
              'Are you sure you want to log out? You will only have access to the basic knife after logging out.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Reset the user session state
                  context.read<UserSessionBloc>().add(
                    const UserSessionEvent.logout(),
                  );

                  // Close the dialog
                  Navigator.pop(context);

                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have been logged out'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );

                  // Navigate back to the previous screen
                  context.router.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
