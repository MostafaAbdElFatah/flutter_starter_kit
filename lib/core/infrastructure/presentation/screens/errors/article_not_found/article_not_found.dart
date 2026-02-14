import '../../../../../core.dart';

class ArticleNotFoundPage extends StatelessWidget {
  const ArticleNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.articleNotFoundError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 260,
            left: 100,
            child: Text(
              LocalizationKeys.articleNotFound,
              style: AppColors.black
                  .medium(fontSize: 25)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 190,
            left: 50,
            child: Text(
              LocalizationKeys.articleNotFoundMessage,
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
