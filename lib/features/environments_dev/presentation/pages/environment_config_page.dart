import 'package:flutter/material.dart';
import '../../../../core/assets/localization_keys.dart';
import '../../data/datasources/storage/env_config_service.dart';
import '../../../../core/di/di.dart';
import '../../../../core/utils/validators/url_validator.dart';
import '../widgets/environment_switcher.dart';

class EnvironmentConfigPage extends StatefulWidget {
  const EnvironmentConfigPage({super.key});

  @override
  State<EnvironmentConfigPage> createState() => _EnvironmentConfigPageState();
}

class _EnvironmentConfigPageState extends State<EnvironmentConfigPage> {
  late Environment _selectedEnv;
  late ConfigService _configService;
  final _formKey = GlobalKey<FormState>();
  Set<int> _selectedMode = {0}; // 0: Default, 1: Custom
  final _baseUrlController = TextEditingController();
  final environmentNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _configService = get<ConfigService>();
    _initAppConfig(_configService.currentConfig);
  }

  _initAppConfig(AppConfig appConfig) {
    _selectedEnv = appConfig.environment;
    _baseUrlController.text = appConfig.baseUrl;
    _selectedMode = {appConfig.baseUrlConfig.type.index};
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    BaseUrlConfig baseUrlConfig = BaseUrlConfig.defaultUrl();
    // If custom mode is selected, set the custom base URL
    if (_selectedMode.contains(1)) {
      baseUrlConfig = BaseUrlConfig.custom(_baseUrlController.text);
    }

    // Save environment (this also clears custom base URL in ConfigService)
    await _configService.setEnvironment(
      _selectedEnv,
      baseUrlConfig: baseUrlConfig,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationKeys.configurationSaved)),
      );
    }

    environmentNotifier.value = !environmentNotifier.value; // trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationKeys.environmentConfig),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: environmentNotifier,
            builder: (context, value, _) {
              return EnvironmentSwitcher(
                environmentChanged: () {
                  setState(() => _initAppConfig(_configService.currentConfig));
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
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
                    _baseUrlController.text = _configService.getAppConfig(_selectedEnv).baseUrl;
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
              DropdownButtonFormField<Environment>(
                initialValue: _selectedEnv,
                decoration: InputDecoration(
                  labelText: LocalizationKeys.environment,
                  border: OutlineInputBorder(),
                ),
                items: Environment.values.map((env) {
                  return DropdownMenuItem(
                    value: env,
                    child: Text(env.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedEnv = value;
                      _initAppConfig(_configService.getAppConfig(_selectedEnv));
                    });
                  }
                },
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: _saveConfig,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(LocalizationKeys.saveAndRestart),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
