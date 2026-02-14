import '../../../../../core.dart';

class SomethingWentWrongPage extends StatelessWidget {
  const SomethingWentWrongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.somethingWentWrongError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 160,
            child: Text(
              LocalizationKeys.ohNo,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 100,
            child: Text(
              LocalizationKeys.somethingWentWrong,
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
              label:  LocalizationKeys.tryAgain,
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
