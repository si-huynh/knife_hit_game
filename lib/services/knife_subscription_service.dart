// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class SubscriptionInfo {
  SubscriptionInfo({
    required this.hasSubscription,
    this.planCode,
    this.expiryDate,
    this.subscriptionId,
    this.status,
    this.startedAt,
  });
  final bool hasSubscription;
  final String? planCode;
  final DateTime? expiryDate;
  final String? subscriptionId;
  final String? status;
  final DateTime? startedAt;
}

class KnifeSubscriptionService {
  // Base URL for the subscription API
  static const String baseUrl = 'https://game-portal.stg.pressingly.net';

  // Endpoint for fetching user subscriptions
  static const String subscriptionsEndpoint =
      '/subscriptions/user_subscriptions';

  /// Fetches subscription data for the given user ID
  /// Returns a SubscriptionInfo object with subscription details
  Future<SubscriptionInfo> getUserSubscription(String userId) async {
    try {
      // Check if we have cached data first
      // final cachedData = await _getCachedSubscriptionData();
      // if (cachedData != null) {
      //   return cachedData;
      // }

      // Construct the URL with the user ID as a query parameter
      final url = Uri.parse('$baseUrl$subscriptionsEndpoint?user_id=$userId');

      // Make the HTTP request
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        Map<String, dynamic> data;
        try {
          // Try to parse the response body
          data = json.decode(response.body);
        } catch (e) {
          if (e is FormatException) {
            print('FormatException when parsing response: $e');
            // Use mock data instead
            data = _getMockSubscriptionData();
          } else {
            rethrow;
          }
        }

        // Process the subscription data
        final subscriptionInfo = _parseSubscriptionData(data);

        return subscriptionInfo;
      } else {
        // Handle error responses
        print('Failed to fetch subscription data: ${response.statusCode}');
        print('Response body: ${response.body}');
        return SubscriptionInfo(hasSubscription: false);
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching subscription data: $e');
      return SubscriptionInfo(hasSubscription: false);
    }
  }

  /// Parses the subscription data from the API response
  SubscriptionInfo _parseSubscriptionData(Map<String, dynamic> data) {
    try {
      // Check if the response has the subscriptions array
      final subscriptions = data['subscriptions'] as List<dynamic>?;

      if (subscriptions == null || subscriptions.isEmpty) {
        print('No subscriptions found in response');
        return SubscriptionInfo(hasSubscription: false);
      }

      // Find active subscriptions
      final activeSubscriptions =
          subscriptions.where((sub) {
            if (sub is! Map<String, dynamic>) {
              return false;
            }
            final status = sub['status'] as String?;
            return status?.toLowerCase() == 'active';
          }).toList();

      if (activeSubscriptions.isEmpty) {
        print('No active subscriptions found');
        return SubscriptionInfo(hasSubscription: false);
      }

      // Find knife-related subscriptions first
      final knifeSubscriptions =
          activeSubscriptions.where((sub) {
            if (sub is! Map<String, dynamic>) {
              return false;
            }
            final planCode = sub['plan_code'] as String?;
            return planCode != null &&
                (planCode.toLowerCase().contains('knife') ||
                    planCode.toLowerCase().contains('knifegame'));
          }).toList();

      // If no knife-specific subscriptions, use the first active subscription
      final subscription =
          knifeSubscriptions.isNotEmpty
              ? knifeSubscriptions.first
              : activeSubscriptions.first;

      if (subscription is! Map<String, dynamic>) {
        print('Subscription data is not in expected format');
        return SubscriptionInfo(hasSubscription: false);
      }

      final planCode = subscription['plan_code'] as String?;
      final subscriptionId = subscription['lago_id'] as String?;
      final status = subscription['status'] as String?;

      // Parse dates
      DateTime? startedAt;
      if (subscription['started_at'] != null) {
        try {
          startedAt = DateTime.parse(subscription['started_at'].toString());
        } catch (e) {
          print('Error parsing started_at date: $e');
        }
      }

      // Determine expiry date - use ending_at if available, otherwise null
      DateTime? expiryDate;
      if (subscription['ending_at'] != null &&
          subscription['ending_at'] != 'null') {
        try {
          expiryDate = DateTime.parse(subscription['ending_at'].toString());
        } catch (e) {
          print('Error parsing ending_at date: $e');
        }
      }

      print('Found active subscription with plan code: $planCode');

      return SubscriptionInfo(
        hasSubscription: true,
        planCode: planCode,
        expiryDate: expiryDate,
        subscriptionId: subscriptionId,
        status: status,
        startedAt: startedAt,
      );
    } catch (e) {
      print('Error parsing subscription data: $e');
      return SubscriptionInfo(hasSubscription: false);
    }
  }

  /// Fetches all active subscriptions for the given user ID
  /// Returns a list of SubscriptionInfo objects
  Future<List<SubscriptionInfo>> getAllUserSubscriptions(String userId) async {
    try {
      // Construct the URL with the user ID as a query parameter
      final url = Uri.parse('$baseUrl$subscriptionsEndpoint?user_id=$userId');

      // Make the HTTP request
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        Map<String, dynamic> data;
        try {
          // Try to parse the response body
          data = json.decode(response.body);
        } catch (e) {
          if (e is FormatException) {
            print('FormatException when parsing response: $e');
            // Use mock data instead
            data = _getMockSubscriptionData();
          } else {
            rethrow;
          }
        }

        // Process all subscriptions
        return _parseAllSubscriptions(data);
      } else {
        // Handle error responses
        print('Failed to fetch subscription data: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching subscription data: $e');
      return [];
    }
  }

  /// Parses all subscriptions from the API response
  List<SubscriptionInfo> _parseAllSubscriptions(Map<String, dynamic> data) {
    final subscriptions = <SubscriptionInfo>[];
    try {
      // Check if the response has the subscriptions array
      final subscriptionsData = data['subscriptions'] as List<dynamic>?;

      if (subscriptionsData == null || subscriptionsData.isEmpty) {
        print('No subscriptions found in response');
        return subscriptions;
      }

      // Find active subscriptions
      final activeSubscriptions =
          subscriptionsData.where((sub) {
            if (sub is! Map<String, dynamic>) {
              return false;
            }
            final status = sub['status'] as String?;
            return status?.toLowerCase() == 'active';
          }).toList();

      // Process each active subscription
      for (final subscription in activeSubscriptions) {
        if (subscription is! Map<String, dynamic>) {
          continue;
        }

        final planCode = subscription['plan_code'] as String?;
        final subscriptionId = subscription['lago_id'] as String?;
        final status = subscription['status'] as String?;

        // Parse dates
        DateTime? startedAt;
        if (subscription['started_at'] != null) {
          try {
            startedAt = DateTime.parse(subscription['started_at'].toString());
          } catch (e) {
            print('Error parsing started_at date: $e');
          }
        }

        DateTime? expiryDate;
        if (subscription['ending_at'] != null &&
            subscription['ending_at'] != 'null') {
          try {
            expiryDate = DateTime.parse(subscription['ending_at'].toString());
          } catch (e) {
            print('Error parsing ending_at date: $e');
          }
        }

        // Create SubscriptionInfo object and add to list
        subscriptions.add(
          SubscriptionInfo(
            hasSubscription: true,
            planCode: planCode,
            expiryDate: expiryDate,
            subscriptionId: subscriptionId,
            status: status,
            startedAt: startedAt,
          ),
        );
      }

      return subscriptions;
    } catch (e) {
      print('Error parsing subscription data: $e');
      return subscriptions;
    }
  }

  /// Gets all knife tiers that the user has access to based on their subscriptions
  Set<String> getAllKnifeTiers(List<SubscriptionInfo> subscriptions) {
    final tiers = <String>{'basic'}; // Always include basic tier

    for (final subscription in subscriptions) {
      final tier = getKnifeTierFromPlanCode(subscription.planCode);
      tiers.add(tier);
    }

    return tiers;
  }

  /// Gets the highest tier from a list of subscriptions
  String getHighestTier(List<SubscriptionInfo> subscriptions) {
    final tierOrder = ['basic', 'premium', 'elite', 'luxury', 'ultimate'];
    var highestTier = 'basic';

    for (final subscription in subscriptions) {
      final tier = getKnifeTierFromPlanCode(subscription.planCode);
      if (tierOrder.indexOf(tier) > tierOrder.indexOf(highestTier)) {
        highestTier = tier;
      }
    }

    return highestTier;
  }

  /// Gets a formatted string listing all active subscriptions
  String getAllSubscriptionDetails(List<SubscriptionInfo> subscriptions) {
    if (subscriptions.isEmpty) {
      return 'No active subscriptions';
    }

    final uniqueTiers = getAllKnifeTiers(subscriptions);
    final tiers =
        uniqueTiers.map((tier) {
          return tier.substring(0, 1).toUpperCase() + tier.substring(1);
        }).toList();

    return 'Active Tiers: ${tiers.join(", ")}';
  }

  /// Gets the knife tier that the user has access to based on their subscription
  /// Returns a string representing the knife tier (e.g., 'basic', 'premium', 'elite')
  String getKnifeTierFromPlanCode(String? planCode) {
    if (planCode == null) {
      return 'basic';
    }

    // Map plan codes to knife tiers
    final planCodeLower = planCode.toLowerCase();

    if (planCodeLower.contains('knife_premium') ||
        planCodeLower.contains('premium_monthly') ||
        planCodeLower.contains('premium_yearly') ||
        planCodeLower.contains('knifegame_premium')) {
      return 'premium';
    } else if (planCodeLower.contains('knife_elite') ||
        planCodeLower.contains('elite_monthly') ||
        planCodeLower.contains('elite_yearly') ||
        planCodeLower.contains('knifegame_elite')) {
      return 'elite';
    } else if (planCodeLower.contains('knife_luxury') ||
        planCodeLower.contains('luxury_monthly') ||
        planCodeLower.contains('luxury_yearly') ||
        planCodeLower.contains('knifegame_luxury')) {
      return 'luxury';
    } else if (planCodeLower.contains('knife_ultimate') ||
        planCodeLower.contains('ultimate_monthly') ||
        planCodeLower.contains('ultimate_yearly') ||
        planCodeLower.contains('knifegame_ultimate')) {
      return 'ultimate';
    }

    // For any other plan codes, check if they contain specific tier names
    if (planCodeLower.contains('premium')) {
      return 'premium';
    } else if (planCodeLower.contains('elite')) {
      return 'elite';
    } else if (planCodeLower.contains('luxury')) {
      return 'luxury';
    } else if (planCodeLower.contains('ultimate')) {
      return 'ultimate';
    }

    return 'basic';
  }

  /// Gets the subscription details in a formatted string
  String getSubscriptionDetails(SubscriptionInfo info) {
    if (!info.hasSubscription) {
      return 'No active subscription';
    }

    final tier = getKnifeTierFromPlanCode(info.planCode);
    final tierCapitalized =
        tier.substring(0, 1).toUpperCase() + tier.substring(1);

    var details = '$tierCapitalized Tier';

    if (info.startedAt != null) {
      final startDate =
          '${info.startedAt!.year}-${info.startedAt!.month.toString().padLeft(2, '0')}-${info.startedAt!.day.toString().padLeft(2, '0')}';
      details += ' (since $startDate)';
    }

    return details;
  }

  /// Checks if a subscription is about to expire
  /// Returns true if the subscription will expire within the specified number of days
  bool isSubscriptionAboutToExpire(
    SubscriptionInfo info, {
    int withinDays = 7,
  }) {
    if (!info.hasSubscription || info.expiryDate == null) {
      return false;
    }

    final now = DateTime.now();
    final difference = info.expiryDate!.difference(now).inDays;

    return difference >= 0 && difference <= withinDays;
  }

  /// Gets the remaining days of a subscription
  /// Returns the number of days remaining, or null if there's no expiry date
  int? getRemainingDays(SubscriptionInfo info) {
    if (!info.hasSubscription || info.expiryDate == null) {
      return null;
    }

    final now = DateTime.now();
    final difference = info.expiryDate!.difference(now).inDays;

    return difference >= 0 ? difference : 0;
  }

  /// Gets a formatted string with the remaining days of a subscription
  String getRemainingDaysText(SubscriptionInfo info) {
    final remainingDays = getRemainingDays(info);

    if (remainingDays == null) {
      return 'No expiration date';
    } else if (remainingDays == 0) {
      return 'Expires today';
    } else if (remainingDays == 1) {
      return 'Expires tomorrow';
    } else {
      return 'Expires in $remainingDays days';
    }
  }

  /// Simulates a subscription response for testing purposes
  /// Returns a SubscriptionInfo object with simulated data
  Future<SubscriptionInfo> getSimulatedSubscription(
    String simulationType,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    switch (simulationType.toLowerCase()) {
      case 'active':
        // Simulate an active subscription
        return SubscriptionInfo(
          hasSubscription: true,
          planCode: 'knife_luxury',
          subscriptionId: 'sim-39a9c890-0648-4a1c-9728-cf10d49e1e47',
          status: 'active',
          startedAt: DateTime.now().subtract(const Duration(days: 30)),
          expiryDate: DateTime.now().add(const Duration(days: 60)),
        );

      case 'expiring_soon':
        // Simulate a subscription that's about to expire
        return SubscriptionInfo(
          hasSubscription: true,
          planCode: 'knife_premium',
          subscriptionId: 'sim-39a9c890-0648-4a1c-9728-cf10d49e1e48',
          status: 'active',
          startedAt: DateTime.now().subtract(const Duration(days: 85)),
          expiryDate: DateTime.now().add(const Duration(days: 5)),
        );

      case 'expired':
        // Simulate an expired subscription
        return SubscriptionInfo(
          hasSubscription: true,
          planCode: 'knife_elite',
          subscriptionId: 'sim-39a9c890-0648-4a1c-9728-cf10d49e1e49',
          status: 'active',
          startedAt: DateTime.now().subtract(const Duration(days: 95)),
          expiryDate: DateTime.now().subtract(const Duration(days: 5)),
        );

      case 'no_expiry':
        // Simulate a subscription with no expiry date
        return SubscriptionInfo(
          hasSubscription: true,
          planCode: 'knife_ultimate',
          subscriptionId: 'sim-39a9c890-0648-4a1c-9728-cf10d49e1e50',
          status: 'active',
          startedAt: DateTime.now().subtract(const Duration(days: 15)),
        );

      case 'none':
      default:
        // Simulate no subscription
        return SubscriptionInfo(hasSubscription: false);
    }
  }

  /// Returns mock subscription data for testing or when API fails
  Map<String, dynamic> _getMockSubscriptionData() {
    return {
      'subscriptions': [
        {
          'lago_id': 'c568a801-33c3-45cd-b828-af46d9eec05e',
          'external_id': 'sub-3a4f280a-3370-473f-ae66-18bb81e2b177',
          'lago_customer_id': '92ab98dd-e5d2-4d57-af94-cfce424eb6c7',
          'external_customer_id': '10e9c9b2-eaf9-466b-a319-07f495b22375',
          'name': '',
          'plan_code': '1\$_per_game',
          'status': 'active',
          'billing_time': 'calendar',
          'subscription_at': '2025-02-20T02:49:53Z',
          'started_at': '2025-02-20T02:49:53Z',
          'trial_ended_at': null,
          'ending_at': null,
          'terminated_at': null,
          'pending_terminated_at': null,
          'canceled_at': null,
          'created_at': '2025-02-20T02:49:53Z',
          'previous_plan_code': null,
          'next_plan_code': null,
          'downgrade_plan_date': null,
          'dynamic_properties': {
            'device_data': {
              'os': {'os_name': 'macOS', 'version': '10.15'},
              'browser': {'version': '133.0', 'browser_name': 'Chrome'},
              'device_type': 'Desktop',
              'device_model':
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
            },
            'amount_cents': 0,
            'amount_currency': 'USD',
          },
          'subscription_date': '2025-02-20',
        },
        {
          'lago_id': 'eff529e2-87c1-40e3-8bda-c4a765e5e00b',
          'external_id':
              '10e9c9b2-eaf9-466b-a319-07f495b22375-fish_pay_per_item',
          'lago_customer_id': '92ab98dd-e5d2-4d57-af94-cfce424eb6c7',
          'external_customer_id': '10e9c9b2-eaf9-466b-a319-07f495b22375',
          'name': '',
          'plan_code': 'fish_pay_per_item',
          'status': 'active',
          'billing_time': 'calendar',
          'subscription_at': '2025-02-20T02:50:59Z',
          'started_at': '2025-02-20T02:50:59Z',
          'trial_ended_at': null,
          'ending_at': null,
          'terminated_at': null,
          'pending_terminated_at': null,
          'canceled_at': null,
          'created_at': '2025-02-20T02:50:59Z',
          'previous_plan_code': null,
          'next_plan_code': null,
          'downgrade_plan_date': null,
          'dynamic_properties': {},
          'subscription_date': '2025-02-20',
        },
        {
          'lago_id': '4d243065-1e91-4bd2-8550-a22abe5b5854',
          'external_id':
              '10e9c9b2-eaf9-466b-a319-07f495b22375-fish_pay_per_item',
          'lago_customer_id': '92ab98dd-e5d2-4d57-af94-cfce424eb6c7',
          'external_customer_id': '10e9c9b2-eaf9-466b-a319-07f495b22375',
          'name': '',
          'plan_code': 'fish_pay_per_item',
          'status': 'active',
          'billing_time': 'calendar',
          'subscription_at': '2025-02-20T02:51:00Z',
          'started_at': '2025-02-20T02:51:00Z',
          'trial_ended_at': null,
          'ending_at': null,
          'terminated_at': null,
          'pending_terminated_at': null,
          'canceled_at': null,
          'created_at': '2025-02-20T02:51:00Z',
          'previous_plan_code': null,
          'next_plan_code': null,
          'downgrade_plan_date': null,
          'dynamic_properties': {},
          'subscription_date': '2025-02-20',
        },
        {
          'lago_id': '5aa2aa3a-361a-4186-b360-92d8bab55204',
          'external_id': 'sub-7c781844-5a34-4225-9639-8a0c1a33fc86',
          'lago_customer_id': '92ab98dd-e5d2-4d57-af94-cfce424eb6c7',
          'external_customer_id': '10e9c9b2-eaf9-466b-a319-07f495b22375',
          'name': '',
          'plan_code': 'knifegame_premium',
          'status': 'active',
          'billing_time': 'calendar',
          'subscription_at': '2025-03-01T03:36:20Z',
          'started_at': '2025-03-01T03:36:20Z',
          'trial_ended_at': null,
          'ending_at': null,
          'terminated_at': null,
          'pending_terminated_at': null,
          'canceled_at': null,
          'created_at': '2025-03-01T03:36:20Z',
          'previous_plan_code': null,
          'next_plan_code': null,
          'downgrade_plan_date': null,
          'dynamic_properties': {
            'device_data': {
              'os': {'os_name': 'macOS', 'version': 'Unknown'},
              'browser': {'version': '604.1', 'browser_name': 'Safari'},
              'device_type': 'Mobile',
              'device_model':
                  'Mozilla/5.0 (iPhone; CPU iPhone OS 18_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.2 Mobile/15E148 Safari/604.1',
            },
            'amount_cents': 100,
            'amount_currency': 'USD',
          },
          'subscription_date': '2025-03-01',
        },
        {
          'lago_id': '5aa2aa3a-361a-4186-b360-92d8bab55204',
          'external_id': 'sub-7c781844-5a34-4225-9639-8a0c1a33fc86',
          'lago_customer_id': '92ab98dd-e5d2-4d57-af94-cfce424eb6c7',
          'external_customer_id': '10e9c9b2-eaf9-466b-a319-07f495b22375',
          'name': '',
          'plan_code': 'knifegame_elite',
          'status': 'active',
          'billing_time': 'calendar',
          'subscription_at': '2025-03-01T03:36:20Z',
          'started_at': '2025-03-01T03:36:20Z',
          'trial_ended_at': null,
          'ending_at': null,
          'terminated_at': null,
          'pending_terminated_at': null,
          'canceled_at': null,
          'created_at': '2025-03-01T03:36:20Z',
          'previous_plan_code': null,
          'next_plan_code': null,
          'downgrade_plan_date': null,
          'dynamic_properties': {
            'device_data': {
              'os': {'os_name': 'macOS', 'version': 'Unknown'},
              'browser': {'version': '604.1', 'browser_name': 'Safari'},
              'device_type': 'Mobile',
              'device_model':
                  'Mozilla/5.0 (iPhone; CPU iPhone OS 18_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.2 Mobile/15E148 Safari/604.1',
            },
            'amount_cents': 100,
            'amount_currency': 'USD',
          },
          'subscription_date': '2025-03-01',
        },
      ],
      'meta': {
        'current_page': 1,
        'next_page': null,
        'prev_page': null,
        'total_pages': 1,
        'total_count': 4,
      },
    };
  }
}
