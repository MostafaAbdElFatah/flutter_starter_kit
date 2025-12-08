import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart' as di;
import '../../../../core/assets/localization_keys.dart';
import '../../../../core/validators/url_validator.dart';
import '../../domain/entities/environment.dart';
import '../dialogs/environment_changed_dialog.dart';
import '../widgets/base_url_type_segmented_button.dart';
import '../widgets/environment_dropdown_button.dart';
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
  final _baseUrlController = TextEditingController();
  final _environmentNotifier = ValueNotifier<Environment>(Environment.dev);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 100),
      EnvironmentCubit.of(context).init,
    );
    ;
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    // Save environment (this also clears custom base URL in ConfigService)
    await EnvironmentCubit.of(
      context,
    ).updateConfiguration(baseUrl: _baseUrlController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationKeys.configurationSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationKeys.environmentConfig),
        actions: [
          ValueListenableBuilder<Environment>(
            valueListenable: _environmentNotifier,
            builder: (context, value, _) {
              return EnvironmentSwitcher(
                currentEnvironment: value,
                onEnvironmentSelected: (environment) {
                  EnvironmentCubit.of(
                    context,
                  ).switchEnvironmentConfiguration(environment);

                  // Show dialog to restart
                  if (context.mounted) {
                    showEnvironmentChangedDialog(
                      context,
                      envName: environment.name,
                      onRestart: () {},
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EnvironmentCubit, EnvironmentState>(
        listener: (context, state) {
          if (state is EnvironmentLoaded) {
            Future.delayed(Duration(milliseconds: 100), () {
              _baseUrlController.text = state.config.baseUrl;
              _environmentNotifier.value = state.config.environment;
            });
          }
        },
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
                  BaseUrlTypeSegmentedButton(
                    key: GlobalKey(),
                    selectedBaseUrlType: state.config.baseUrlConfig.type,
                    onSelectionChanged: (newSelection) => EnvironmentCubit.of(
                      context,
                    ).onBaseUrlTypeChanged(newSelection.first),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: GlobalKey(),
                    controller: _baseUrlController,
                    enabled: state.config.baseUrlConfig.isCustom,
                    decoration: InputDecoration(
                      labelText: LocalizationKeys.baseUrl,
                      border: OutlineInputBorder(),
                    ),
                    validator: UrlValidator.validateUrl,
                  ),
                  const SizedBox(height: 16),
                  EnvironmentDropdownButtonFormField(
                    key: GlobalKey(),
                    initialValue: state.config.environment,
                    onChanged: (environment) => EnvironmentCubit.of(
                      context,
                    ).switchEnvironmentConfiguration(environment),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () => _saveConfig(),
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
