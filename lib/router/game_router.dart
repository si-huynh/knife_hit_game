import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:knife_hit_game/pages/equipments_page.dart';
import 'package:knife_hit_game/pages/game_playing_page.dart';
import 'package:knife_hit_game/pages/main_menu_page.dart';
import 'package:knife_hit_game/pages/main_page.dart';
import 'package:knife_hit_game/pages/settings_menu_page.dart';

part 'game_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class GameRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: MainRoute.page,
      children: [
        AutoRoute(page: MainMenuRoute.page, initial: true),
        AutoRoute(page: GamePlayingRoute.page),
      ],
    ),
    CustomRoute(
      page: SettingsMenuRoute.page,
      customRouteBuilder: <T>(context, child, page) {
        return ModalBottomSheetRoute(
          backgroundColor: Colors.transparent,
          builder: (context) => child,
          settings: page,
          isScrollControlled: true,
          useSafeArea: true,
        );
      },
    ),
    CustomRoute(
      page: EquipmentsRoute.page,
      customRouteBuilder: <T>(context, child, page) {
        return ModalBottomSheetRoute(
          backgroundColor: Colors.transparent,
          builder: (context) => child,
          settings: page,
          isScrollControlled: true,
          useSafeArea: true,
        );
      },
    ),
  ];
}
