import '../../../../../core.dart';

class ConnectionFailedPage extends StatelessWidget {
  const ConnectionFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.connectionFailedError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 100,
            child: Text(
              LocalizationKeys.connectionFailed,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 70,
            child: Text(
              LocalizationKeys.connectionFailedMessage,
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
              label: LocalizationKeys.retry,
              buttonColor: Colors.green,
              childTextColor: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
