import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart' as di;
import '../../../../core/assets/localization_keys.dart';
import '../../../../core/utils/validators/url_validator.dart';
import '../../domain/entities/base_url_config.dart';
import '../../domain/entities/environment.dart';
import '../dialogs/environment_changed_dialog.dart';
import '../widgets/environment_switcher.dart';
import '../cubit/environment_cubit.dart';

class EnvironmentConfigPage extends StatelessWidget {
  const EnvironmentConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.get<EnvironmentCubit>(),
      child: _EnvironmentConfigPage(),
    );
  }
}

class _EnvironmentConfigPage extends StatefulWidget {
  const _EnvironmentConfigPage();

  @override
  State<_EnvironmentConfigPage> createState() => _EnvironmentConfigPageState();
}

class _EnvironmentConfigPageState extends State<_EnvironmentConfigPage> {
  final _formKey = GlobalKey<FormState>();
  Set<int> _selectedMode = {0}; // 0: Default, 1: Custom
  final _baseUrlController = TextEditingController();
  final environmentNotifier = ValueNotifier<Environment>(Environment.dev);

  @override
  void initState() {
    super.initState();
    EnvironmentCubit.of(context).init();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig(Environment env) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    BaseUrlConfig baseUrlConfig = BaseUrlConfig.defaultUrl();
    // If custom mode is selected, set the custom base URL
    if (_selectedMode.contains(1)) {
      baseUrlConfig = BaseUrlConfig.custom(_baseUrlController.text);
    }

    // Save environment (this also clears custom base URL in ConfigService)
    await EnvironmentCubit.of(
      context,
    ).updateConfiguration(environment: env, baseUrlConfig: baseUrlConfig);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationKeys.configurationSaved)),
      );
    }

    environmentNotifier.value = env; // trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationKeys.environmentConfig),
        actions: [
          ValueListenableBuilder<Environment>(
            valueListenable: environmentNotifier,
            builder: (context, value, _) {
              return EnvironmentSwitcher(
                currentEnvironment: value,
                onEnvironmentSelected: (env) {
                  EnvironmentCubit.of(
                    context,
                  ).updateConfiguration(environment: env);
                  // Show dialog to restart
                  if (context.mounted) {
                    showEnvironmentChangedDialog(
                      context,
                      envName: env.name,
                      onRestart: () {},
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EnvironmentCubit, EnvironmentState>(
        builder: (context, state) {
          if (state is! EnvironmentLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    LocalizationKeys.baseUrlConfiguration,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<int>(
                    segments: [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text(LocalizationKeys.defaultMode),
                        icon: Icon(Icons.check_circle_outline),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text(LocalizationKeys.customMode),
                        icon: Icon(Icons.edit),
                      ),
                    ],
                    selected: _selectedMode,
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        _selectedMode = newSelection;
                        _baseUrlController.text = state.config.baseUrl;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _baseUrlController,
                    enabled: _selectedMode.contains(1),
                    decoration: InputDecoration(
                      labelText: LocalizationKeys.baseUrl,
                      border: OutlineInputBorder(),
                    ),
                    validator: UrlValidator.validateUrl,
                  ),
                  const SizedBox(height: 16),
                  //   _initAppConfig(AppConfig appConfig) {
                  // _selectedEnv = appConfig.environment;
                  // _baseUrlController.text = appConfig.baseUrl;
                  // _selectedMode = {appConfig.baseUrlConfig.type.index};
                  // }
                  DropdownButtonFormField<Environment>(
                    initialValue: state.config.environment,
                    decoration: InputDecoration(
                      labelText: LocalizationKeys.environment,
                      border: OutlineInputBorder(),
                    ),
                    items: Environment.values.map((env) {
                      return DropdownMenuItem(
                        value: env,
                        child: Text(
                          env.toString().split('.').last.toUpperCase(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        EnvironmentCubit.of(
                          context,
                        ).switchEnvironmentConfiguration(value);
                      }
                    },
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () => _saveConfig(state.config.environment),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(LocalizationKeys.saveAndRestart),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
