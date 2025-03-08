import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:knife_hit_game/blocs/game_settings_bloc/game_settings_bloc.dart';
import 'package:knife_hit_game/blocs/game_stats_bloc/game_stats_bloc.dart';
import 'package:knife_hit_game/blocs/user_session_bloc/user_session_bloc.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/router/game_router.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(const AppGameWidget());
}

class AppGameWidget extends StatelessWidget {
  const AppGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameStatsBloc>(create: (context) => GameStatsBloc()),
        BlocProvider<GameSettingsBloc>(create: (context) => GameSettingsBloc()),
        BlocProvider<UserSessionBloc>(create: (context) => UserSessionBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: GameRouter().config(
          deepLinkBuilder: (deepLink) {
            if (kDebugMode) {
              print('deepLinkBuilder: ${deepLink.path}');
            }
            return DeepLink.defaultPath;
          },
        ),
        theme: ThemeData(
          fontFamily: GameConstants.primaryFontFamily,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
