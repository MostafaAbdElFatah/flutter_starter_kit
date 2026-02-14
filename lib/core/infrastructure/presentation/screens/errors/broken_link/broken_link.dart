import '../../../../../core.dart';

class BrokenLinkPage extends StatelessWidget {
  const BrokenLinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.brokenLinkError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              LocalizationKeys.brokenLink,
              style: Colors.black
                  .medium(fontSize: 16)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              LocalizationKeys.brokenLinkMessage,
              textAlign: TextAlign.start,
              style: Colors.black38
                  .medium(fontSize: 16)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: ReusableButton(
              label: LocalizationKeys.goBack,
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
