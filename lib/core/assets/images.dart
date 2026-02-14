/// This class is used to store all the image assets paths.
///
/// By using this class, we can avoid using hardcoded strings in the code.
/// This makes it easier to manage and update the image assets paths.
///
/// Example:
/// ```dart
/// Image.asset(Images.logo);
/// ```
abstract class Images {
  // Private constructor to prevent instantiation.
  Images._();


  static const String logo = 'assets/images/logo.png';

  // ===========================================================================
  // Base paths
  // ===========================================================================

  static const String _imagesBasePath = 'assets/images';
  static const String _errorsPath = '$_imagesBasePath/errors';

  // ===========================================================================
  // errors
  // ===========================================================================

  static const String notFound404Error = '$_errorsPath/404_error.png';
  static const String articleNotFoundError = '$_errorsPath/article_not_found.png';
  static const String brokenLinkError = '$_errorsPath/broken_link.png';
  static const String connectionFailedError = '$_errorsPath/connection_failed.png';
  static const String connectionLostError = '$_errorsPath/connection_lost.png';
  static const String wrongConnectionError = '$_errorsPath/wrong_connection.png';
  static const String fileNotFoundError = '$_errorsPath/file_not_found.png';
  static const String fileNotFoundError2 = '$_errorsPath/file_not_found2.png';
  static const String locationError = '$_errorsPath/location_error.png';
  static const String locationError2 = '$_errorsPath/location_error2.png';
  static const String noCameraAccessError = '$_errorsPath/no_camera_access.png';
  static const String noSearchResultError = '$_errorsPath/no_search_result.png';
  static const String paymentFailedError = '$_errorsPath/payment_fail.png';
  static const String routerOfflineError = '$_errorsPath/router_offline.png';
  static const String certainError = '$_errorsPath/certain_error.png';
  static const String fixingError = '$_errorsPath/fixing_error.png';
  static const String somethingWentWrongError = '$_errorsPath/something_went_wrong.png';
  static const String somethingWrongError = '$_errorsPath/something_wrong.png';
  static const String storageNotEnoughError = '$_errorsPath/storage_not_enough.png';
  static const String timeError = '$_errorsPath/time_error.png';
}
