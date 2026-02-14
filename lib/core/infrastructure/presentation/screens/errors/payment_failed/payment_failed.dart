import '../../../../../core.dart';

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.paymentFailedError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 230,
            left: 30,
            child: Text(
              LocalizationKeys.paymentFailed,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 30,
            child: Text(
              LocalizationKeys.paymentFailedMessage,
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
              label: 'Try Again',
              buttonColor: const Color(0xff00A2A5), childTextColor: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
