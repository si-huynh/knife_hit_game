class GameConstants {
  static const double cameraWidth = 430;
  static const double cameraHeight = 932;
  static const double knifeSpeed = -2000;

  static const background = 'layers/background.jpg';
  static const knives = 'layers/knives.png';
  static const timber = 'layers/timber.png';
  static const backButton = 'layers/back_button.png';
  static const backgroundMusic = 'background.mp3';
  static const primaryFontFamily = 'Permanent Marker';
}

class AuthConstants {
  static const AUTH_BASE_URL =
      'https://pinet-core.stg.pressingly.net/oauth/authorize';
  static const AUTH_CLIENT_ID = 'zAAGbSqhFhRiQx5E-SVGb2aGtKVhs7mGMv70PWduZ8M';
  static const AUTH_REDIRECT_URI =
      'https://game-portal.stg.pressingly.net/users/auth/openid_connect/callback';
  static const AUTH_STATE =
      'eyJsb2dpbl93aXRoX21vYmlsZV9hcHAiOnRydWUsInJldHVybl91bml2ZXJzYWxfbGluayI6ImtuaWZlZ2FtZTovL29pZGMifQ';
  static const AUTH_SCOPE =
      'openid%20moneta_id_token%20currency%20region%20name%20timezone';
  static const AUTH_URL =
      '$AUTH_BASE_URL?client_id=$AUTH_CLIENT_ID&state=$AUTH_STATE&redirect_uri=$AUTH_REDIRECT_URI&response_type=code&scope=$AUTH_SCOPE';
}
