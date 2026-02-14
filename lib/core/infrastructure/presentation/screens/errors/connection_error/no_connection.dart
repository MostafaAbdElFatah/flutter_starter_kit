import '../../../../../core.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.connectionLostError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 200,
            left: 30,
            child: Text(
              LocalizationKeys.noConnection,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 30,
            child: Text(
              LocalizationKeys.noConnectionMessage,
              textAlign: TextAlign.start,
              style: Colors.black38
                  .medium(fontSize: 16)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 40,
            right: 40,
            child: ReusableButton(
              label: LocalizationKeys.retry,
              buttonColor: Colors.blue[800]!,
              childTextColor: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
