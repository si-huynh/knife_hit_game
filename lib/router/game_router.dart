import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:knife_hit_game/pages/main_game_page.dart';
import 'package:knife_hit_game/pages/settings_menu_page.dart';
part 'game_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class GameRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainGameRoute.page, initial: true),
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
  ];
}
