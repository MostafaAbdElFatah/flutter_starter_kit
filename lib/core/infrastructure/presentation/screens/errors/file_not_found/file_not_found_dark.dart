import '../../../../../core.dart';

class FileNotFoundDarkPage extends StatelessWidget {
  const FileNotFoundDarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.fileNotFoundError2,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 200,
            left: 30,
            child: Text(
              LocalizationKeys.fileNotFound,
              style: AppColors.white
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 30,
            child: Text(
              LocalizationKeys.fileNotFoundMessage,
              textAlign: TextAlign.start,
              style: Colors.white54
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 70,
            left: 30,
            right: 250,
            child: ReusableButton(
              label: LocalizationKeys.homeTitle,
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
