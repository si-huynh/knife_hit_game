// ignore_for_file: avoid_print

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knife_hit_game/blocs/user_session_bloc/user_session_bloc.dart';
import 'package:knife_hit_game/game_constants.dart';
import 'package:knife_hit_game/router/game_router.dart';
import 'package:video_player/video_player.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _wasVideoPlaying = false;
  bool _wasMusicPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAppLinks();
    _initializeVideo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App is in background or being closed
        // Save video state and pause it
        if (!Platform.isAndroid) {
          _wasVideoPlaying = _controller.value.isPlaying;
          if (_wasVideoPlaying) {
            _controller.pause();
          }
        }

        // Save music state and pause it
        _wasMusicPlaying = FlameAudio.bgm.isPlaying;
        if (_wasMusicPlaying) {
          FlameAudio.bgm.pause();
        }
        break;
      case AppLifecycleState.resumed:
        // App is in foreground and visible
        // Resume video if it was playing before
        if (!Platform.isAndroid) {
          if (_wasVideoPlaying) {
            _controller.play();
          }
        }

        // Resume music if it was playing before
        if (_wasMusicPlaying) {
          FlameAudio.bgm.resume();
        }
        break;
    }
  }

  void _initAppLinks() {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      print('URI: $uri');
      // knifegame://oauth?current_user=5bc6af3e-a40e-4ab4-94a2-77fde0c27a66
      if (uri.toString().contains(
        '${AuthConstants.DIRECT_AUTH_URL}?current_user=',
      )) {
        // Extract user ID from the URI
        final userIdParam = uri.queryParameters['current_user'];
        if (userIdParam != null && userIdParam.isNotEmpty) {
          // Save the user ID and update login state
          final userSessionBloc = context.read<UserSessionBloc>();
          userSessionBloc.add(UserSessionEvent.login(userIdParam));
          print('User logged in with ID: $userIdParam');
          context.router.push(const EquipmentsRoute());
        }
      }
    });
  }

  Future<void> _initializeVideo() async {
    if (Platform.isAndroid) {
      print('VideoBackground: skipping video initialization on Android');
      setState(() {
        _isInitialized = true;
      });
      return;
    }
    print('VideoBackground: initializing video controller');
    try {
      _controller = VideoPlayerController.asset('assets/videos/background.mp4');
      print('VideoBackground: controller created');

      await _controller.initialize();
      print(
        'VideoBackground: controller initialized, size: ${_controller.value.size}',
      );

      _controller.setLooping(true);
      _controller.play();
      print('VideoBackground: video playing');

      if (mounted) {
        setState(() {
          _isInitialized = true;
          print(
            'VideoBackground: state updated, is initialized: $_isInitialized',
          );
        });
      }
    } catch (e) {
      print('VideoBackground: Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    print('VideoBackground: disposing controller');
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(color: Colors.black);
    }

    return Stack(
      children: [
        if (Platform.isAndroid)
          Positioned.fill(
            child: Image.asset(
              'assets/images/layers/background.jpg',
              fit: BoxFit.cover,
            ),
          )
        else
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),
        Positioned.fill(
          child: AutoTabsRouter(
            lazyLoad: false,
            transitionBuilder:
                (_, child, animation) =>
                    FadeScaleTransition(animation: animation, child: child),
            routes: const [MainMenuRoute(), GamePlayingRoute()],
            navigatorObservers: () => [AutoRouteObserver()],
            builder: (context, child) {
              return child;
            },
          ),
        ),
      ],
    );
  }
}
