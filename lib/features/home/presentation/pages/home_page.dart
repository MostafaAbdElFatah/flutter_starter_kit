import '../../../../core/core.dart';
import '../../../../core/di/injection.dart' as di;
import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../../../environments_dev/domain/use_cases/get_current_environment_use_case.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentEnv = di.get<GetCurrentEnvironmentUseCase>()(NoParams());

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationKeys.homeTitle).tr(),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).pushSettings(),
            icon: const Icon(Icons.settings),
          ),

          IconButton(
            onPressed: () => GoRouter.of(context).pushLogin(),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocalizationKeys.welcomeFlutterStarterKit).tr(),
            SizedBox(height: 10),
            Text('Environment ${currentEnv.name.toUpperCase()}'),
          ],
        ),
      ),
    );
  }
}
