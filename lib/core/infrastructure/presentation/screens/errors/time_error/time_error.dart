import '../../../../../core.dart';

class TimeErrorPage extends StatelessWidget {
  const TimeErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Images.timeError,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              LocalizationKeys.somethingNotRight,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              LocalizationKeys.somethingNotRightMessage,
              textAlign: TextAlign.start,
              style: Colors.black38
                  .medium(fontSize: 16)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 30,
            right: 250,
            child: ReusableButton(
              label: LocalizationKeys.retry,
              buttonColor: AppColors.pastelIndigo,
              childTextColor: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
