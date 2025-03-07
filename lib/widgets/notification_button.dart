import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton>
    with SingleTickerProviderStateMixin {
  int notificationCount = 3; // Total number of notifications
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PopupMenuButton<String>(
          offset: const Offset(0, 40), // Offset to position below the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.blueGrey[800],
          elevation: 8, // Add elevation for shadow
          shadowColor: Colors.black.withOpacity(0.5), // Custom shadow color
          icon: const Icon(Icons.notifications, color: Colors.white),
          onSelected: (value) {
            if (value == 'news') {
              _launchGamePortal();
              // Reduce notification count when user interacts with a notification
              setState(() {
                if (notificationCount > 0) {
                  notificationCount--;
                }
              });
            } else if (value == 'daily') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Daily reward claimed: +5 coins!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Reduce notification count when user interacts with a notification
              setState(() {
                if (notificationCount > 0) {
                  notificationCount--;
                }
              });
            } else if (value == 'friends') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Friend requests feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
              // Reduce notification count when user interacts with a notification
              setState(() {
                if (notificationCount > 0) {
                  notificationCount--;
                }
              });
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem<String>(
                  value: 'news',
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.campaign,
                          color: Colors.amber,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'News & Campaigns',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Check out the latest game updates!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'daily',
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          color: Colors.green,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daily Rewards',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Claim your daily knife bonus!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'friends',
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.people,
                          color: Colors.lightBlue,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Friend Requests',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '2 new requests waiting',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // Method to launch the game portal in external browser
  Future<void> _launchGamePortal() async {
    const url = 'https://game-portal.stg.pressingly.net';
    try {
      // Use url_launcher to open the external browser
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open browser: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
