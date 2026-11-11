class AppConfig {
  /// Logo
  static String appLogo = "assets/logos/app_icon.png";
  static String splashLogo = "assets/logos/app_icon.png";
  static String appName = "BetSocial";
  // Local API (Nest listens on 6001). Switch back to remote for device builds:
  // static const domainUrl = "https://flutter.pixelstack.cloud";
  static const domainUrl = "http://localhost:6001";

  /// true: guests are sent to login from the splash.
  /// false: guests can browse the main page (use `showAuthDialog` to gate
  /// protected actions).
  static const bool requireLogin = true;

  /// ProjectID
  static String projectID = "vendex-user-app";

  //Push Notification key

}
