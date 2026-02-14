import '../../../../../core.dart';

class NoSearchResultFoundPage extends StatelessWidget {
  const NoSearchResultFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            Images.noSearchResultError,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 260,
            left: 30,
            child: Text(
              LocalizationKeys.noResults,
              style: AppColors.white
                  .medium(fontSize: 35)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 30,
            child: Text(
              LocalizationKeys.noResultsMessage,
              textAlign: TextAlign.start,
              style: Colors.white54
                  .medium(fontSize: 16)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 30,
            right: 30,
            child: SizedBox(
              height: 60,
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: LocalizationKeys.search,
                  hintStyle: Colors.black45
                      .medium(fontSize: 16)
                      .copyWith(letterSpacing: 1),
                  suffixIcon: const Icon(Icons.search, color: Colors.black45),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
