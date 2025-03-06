import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knife_hit_game/blocs/user_session_bloc/user_session_bloc.dart';
import 'package:knife_hit_game/services/knife_subscription_service.dart';

class KnifeItem {
  KnifeItem({
    required this.imagePath,
    required this.name,
    required this.category,
    required this.price,
    this.isLocked = false,
  });
  final String imagePath;
  final String name;
  final String category;
  final int price;
  final bool isLocked;
}

@RoutePage()
class EquipmentsPage extends StatefulWidget {
  const EquipmentsPage({super.key, this.onKnifeSelected});
  final Function(String)? onKnifeSelected;

  @override
  State<EquipmentsPage> createState() => _EquipmentsPageState();
}

class _EquipmentsPageState extends State<EquipmentsPage> {
  // final MonetaAuthService authService = MonetaAuthService();
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
    } else {
      _showSubscriptionDialog(knife.category);
    }
  }

  Future<void> _applySelectedKnife() async {
    if (selectedKnife == null) {
      return;
    }

    // Save the selected knife to the UserSessionBloc
    context.read<UserSessionBloc>().add(
      UserSessionEvent.updateSelectedKnife(selectedKnife!.imagePath),
    );

    // Notify the parent if a callback was provided
    if (widget.onKnifeSelected != null) {
      widget.onKnifeSelected!(selectedKnife!.imagePath);
    }

    // Close the bottom sheet
    Navigator.pop(context);
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

    return Material(
      color: Colors.transparent,
      child: Container(
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
                : _buildInventoryContent(context, visibleCategories),
      ),
    );
  }

  Column _buildInventoryContent(
    BuildContext context,
    List<String> visibleCategories,
  ) {
    return Column(
      children: [
        // Handle and close button - Fixed at the top
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Drag handle
              const SizedBox(width: 40),
              const Text(
                'Knife Store',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        //Divider(color: Colors.white.withOpacity(0.2)),

        // Scrollable content area
        _buildScrollableContent(visibleCategories, context),
      ],
    );
  }

  Expanded _buildScrollableContent(
    List<String> visibleCategories,
    BuildContext context,
  ) {
    return Expanded(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent:
            1000, // Increase cache extent to prevent items from disappearing
        slivers: [
          // Selected knife display
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[600],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Image.asset(
                      selectedKnife?.imagePath ??
                          'assets/images/knives/basic.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedKnife?.name ?? 'Basic Knife',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _applySelectedKnife,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Use This Knife',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Subscription status display
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800]!.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getSubscriptionStatusText(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'User ID: ${currentUserId.length > 8 ? '${currentUserId.substring(0, 8)}...' : currentUserId}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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

          // Knife categories - restructured to avoid nested scrolling
          ...visibleCategories.expand((category) {
            if (!categorizedKnives.containsKey(category) ||
                categorizedKnives[category]!.isEmpty) {
              return <Widget>[];
            }

            // Determine the appropriate crossAxisCount based on screen width
            final screenWidth = MediaQuery.of(context).size.width;
            final crossAxisCount =
                screenWidth < 360 ? 3 : 4; // Use 3 columns on smaller screens

            return [
              // Category header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              // Category grid
              _buildListOfKnives(crossAxisCount, category),
              // Spacing after each category
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ];
          }),

          // Add some bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  SliverPadding _buildListOfKnives(int crossAxisCount, String category) {
    final knives = categorizedKnives[category]!;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= knives.length) {
            return const SizedBox.shrink();
          }
          return _buildKnifeCard(knives[index]);
          // ignore: require_trailing_commas
        }, childCount: knives.length),
      ),
    );
  }

  Widget _buildKnifeCard(KnifeItem knife) {
    final isSelected = selectedKnife?.name == knife.name;

    return GestureDetector(
      onTap: () => _selectKnife(knife),
      child: RepaintBoundary(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[600],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                ],
                border:
                    isSelected
                        ? Border.all(color: Colors.amber, width: 2)
                        : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        color:
                            Colors
                                .blueGrey[600], // Ensure background color is solid
                        padding: const EdgeInsets.all(6),
                        child:
                            knife.isLocked
                                ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.grey.withOpacity(0.7),
                                    BlendMode.saturation,
                                  ),
                                  child: Image.asset(
                                    knife.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                )
                                : Image.asset(
                                  knife.imagePath,
                                  fit: BoxFit.contain,
                                ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber : Colors.blueGrey[800],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        knife.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (knife.isLocked)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.lock, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
