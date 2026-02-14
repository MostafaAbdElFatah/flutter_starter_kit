import '../../../../../core.dart';

class RouterOfflinePage extends StatelessWidget {
  const RouterOfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.routerOfflineError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 120,
            child: Text(
              LocalizationKeys.routerOffline,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 70,
            child: Text(
              LocalizationKeys.routerOfflineMessage,
              textAlign: TextAlign.center,
              style: Colors.black38
                  .medium(fontSize: 16)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 130,
            right: 130,
            child: ReusableButton(
              label: 'Retry',
              buttonColor: Colors.white,
              childTextColor: Colors.black,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
