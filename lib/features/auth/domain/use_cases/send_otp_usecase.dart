import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/use_cases/usecase.dart';
import '../repository/auth_repository.dart';

/// A use case for requesting a One-Time Password (OTP).
///
/// This class handles the business logic for triggering an OTP delivery
/// to a user's mobile device via the [AuthRepository].
@lazySingleton
class SendOtpUseCase extends AsyncUseCase<AuthRepository, void, String> {
  /// Creates an instance of [SendOtpUseCase].
  ///
  /// Requires an [AuthRepository] to manage the remote communication.
  SendOtpUseCase(super.repository);

  /// Executes the OTP request.
  ///
  /// Takes the user's [phone] number as input and initiates the
  /// verification process.
  ///
  /// Returns a [Future] that completes successfully if the OTP was
  /// accepted for delivery, or throws an [Exception] if the request fails.
  @override
  Future<void> call(String phone) => repository.sendOtp(phone);
}