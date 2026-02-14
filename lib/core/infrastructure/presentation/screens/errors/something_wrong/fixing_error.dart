import '../../../../../core.dart';

class FixingErrorPage extends StatelessWidget {
  const FixingErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.fixingError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              LocalizationKeys.hmmm,
              style: AppColors.white
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              LocalizationKeys.fixingIssue,
              textAlign: TextAlign.start,
              style: Colors.white54
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 30,
            right: 250,
            child: ReusableButton(
              label: LocalizationKeys.tryAgain,
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
