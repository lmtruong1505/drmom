import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsConfig {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    _firebaseAnalytics.setAnalyticsCollectionEnabled(true);

    await _firebaseAnalytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
