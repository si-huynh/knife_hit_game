class GameConstants {
  static const double cameraWidth = 430;
  static const double cameraHeight = 932;
  static const double knifeSpeed = -2000;

  // Difficulty constants
  static const int maxLevel = 30;
  static const int baseKnivesCount = 6;
  static const double baseTimberSpeed = 1.2;
  static const double maxTimberSpeedMultiplier = 3;
  static const double directionChangeBaseChance = 0.005;
  static const double speedChangeBaseChance = 0.01;
  static const double suddenAccelerationChance = 0.001;

  // Images
  static const background = 'layers/background.jpg';
  static const knives = 'layers/knives.png';
  static const timber = 'layers/timber.png';
  static const backButton = 'layers/back_button.png';

  // Music
  static const backgroundMusic = 'background.mp3';
  static const hitKnife = 'hit_knife.mp3';
  static const hitTimber = 'hit_timber.mp3';

  // Fonts
  static const primaryFontFamily = 'Permanent Marker';
}

class AuthConstants {
  static const AUTH_BASE_URL =
      'https://pinet-core.stg.pressingly.net/oauth/authorize';
  static const AUTH_CLIENT_ID = 'zAAGbSqhFhRiQx5E-SVGb2aGtKVhs7mGMv70PWduZ8M';
  static const AUTH_REDIRECT_URI =
      'https://game-portal.stg.pressingly.net/users/auth/openid_connect/callback';
  // static const AUTH_STATE =
  //     'eyJsb2dpbl93aXRoX21vYmlsZV9hcHAiOnRydWUsInJldHVybl91bml2ZXJzYWxfbGluayI6ImtuaWZlZ2FtZTovL29pZGMifQ';
  static const AUTH_STATE =
      'eyJsb2dpbl93aXRoX21vYmlsZV9hcHAiOnRydWUsInJldHVybl91bml2ZXJzYWxfbGluayI6Imh0dHBzOi8vZ2FtZS1wb3J0YWwuc3RnLnByZXNzaW5nbHkubmV0L2F1dGgva25pZmVnYW1lL2NhbGxiYWNrIn0=';
  static const AUTH_SCOPE =
      'openid%20moneta_id_token%20currency%20region%20name%20timezone';
  static const AUTH_URL =
      '$AUTH_BASE_URL?client_id=$AUTH_CLIENT_ID&state=$AUTH_STATE&redirect_uri=$AUTH_REDIRECT_URI&response_type=code&scope=$AUTH_SCOPE';

  // Direct OAuth URL for app links
  static const DIRECT_AUTH_URL =
      'https://game-portal.stg.pressingly.net/auth/knifegame/callback';
}
