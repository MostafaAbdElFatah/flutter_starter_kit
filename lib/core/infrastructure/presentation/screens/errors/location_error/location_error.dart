import '../../../../../core.dart';

class LocationErrorPage extends StatelessWidget {
  const LocationErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.locationError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 260,
            left: 120,
            child: Text(
              LocalizationKeys.locationAccess,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 190,
            left: 70,
            child: Text(
              LocalizationKeys.locationAccessMessage,
              textAlign: TextAlign.center,
              style: Colors.black38
                  .medium(fontSize: 16)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 130,
            right: 130,
            child: ReusableButton(
              label: 'Enable',
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
