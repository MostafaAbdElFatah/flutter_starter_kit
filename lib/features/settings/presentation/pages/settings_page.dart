import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

import '../../../../core/utils/app_locale.dart';
import '../../../../core/di/injection.dart' as injection;
import '../../../../core/assets/localization_keys.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../dialogs/delete_account_dialog.dart';
import '../../../environments_dev/presentation/dialogs/developer_login_dialog.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => injection.get<AuthCubit>()),
        // Uncomment when ready to use SettingsCubit
        // BlocProvider(create: (context) => di.get<SettingsCubit>()),
      ],
      child: SettingsPageContent(),
    );
  }
}

class SettingsPageContent extends StatefulWidget {
  const SettingsPageContent({super.key});

  @override
  State<SettingsPageContent> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageContent> {
  // Shake detection variables
  static const double _shakeThreshold = 2.7;
  static const int _minTimeBetweenShakes = 1000;
  int _lastShakeTime = 0;
  StreamSubscription? _accelerometerSubscription;

  // Tap detection variables
  int _tapCount = 0;
  static const int _requiredTaps = 7;
  static const int _tapResetTime = 2000; // 2 seconds to reset taps
  Timer? _tapResetTimer;

  bool _showHiddenMenu = false;

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid || Platform.isIOS) {
      _startListeningToAccelerometer();
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _tapResetTimer?.cancel();
    super.dispose();
  }

  void _startListeningToAccelerometer() {
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastShakeTime > _minTimeBetweenShakes) {
        final gX = event.x / 9.8;
        final gY = event.y / 9.8;
        final gZ = event.z / 9.8;

        // gForce will be close to 1 when there is no movement.
        final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        if (gForce > _shakeThreshold) {
          _lastShakeTime = now;
          _onShakeDetected();
        }
      }
    });
  }

  void _onShakeDetected() {
    _enableHiddenMenu();
  }

  void _onDeviceTapped() {
    _tapCount++;
    if (_tapCount >= _requiredTaps) {
      _enableHiddenMenu();
      _tapCount = 0;
      _tapResetTimer?.cancel();
    } else {
      _tapResetTimer?.cancel();
      _tapResetTimer = Timer(const Duration(milliseconds: _tapResetTime), () {
        _tapCount = 0;
      });
    }
  }

  void _enableHiddenMenu() {
    if (!_showHiddenMenu) {
      setState(() {
        _showHiddenMenu = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationKeys.developerModeEnabled)),
      );
    }
  }

  void _authStateListener(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      context.go('/');
    } else if (state is AuthError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: _authStateListener,
      child: Scaffold(
        appBar: AppBar(title: Text(LocalizationKeys.settings)),
        body: GestureDetector(
          onTap: _onDeviceTapped, // Detect taps on the background
          behavior: HitTestBehavior.translucent,
          child: ListView(
            children: [
              SettingsTile(
                icon: Icons.language,
                title: LocalizationKeys.changeLanguage,
                onTap: context.toggleLanguage,
              ),
              SettingsTile(
                icon: Icons.logout,
                title: LocalizationKeys.logout,
                onTap: AuthCubit.of(context).logout,
              ),
              SettingsTile(
                icon: Icons.delete_forever,
                title: LocalizationKeys.deleteAccount,
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () => showDeleteAccountDialog(
                  context,
                  deleteAccount: AuthCubit.of(context).deleteAccount,
                ),
              ),
              if (_showHiddenMenu) ...[
                const Divider(),
                SettingsTile(
                  icon: Icons.developer_mode,
                  title: LocalizationKeys.environmentConfig,
                  onTap: () => DeveloperLoginDialog.show(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
