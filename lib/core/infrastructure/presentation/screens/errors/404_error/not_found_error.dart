import '../../../../../core.dart';

class NotFound404ErrorPage extends StatelessWidget {
  const NotFound404ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.notFound404Error,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              LocalizationKeys.deadEnd,
              style: Colors.white
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              LocalizationKeys.pageNotFoundMessage,
              style: Colors.white54
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
              textAlign: TextAlign.start,
            ),
          ),
          Positioned(
            bottom: 100,
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
