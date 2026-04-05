// class OTPInfo {
//   final OTPType type;
//   final String phone;
//
//   bool get isLogin => type == OTPType.login;
//   bool get isRegister => type == OTPType.register;
//
//   OTPInfo.login(this.phone): type = OTPType.login;
//   OTPInfo.register(this.phone): type = OTPType.register;
//   const OTPInfo({this.type = OTPType.login, this.phone = ""});
//
//   OTPInfo copyWith({
//     String? phone,
//     OTPType? type,
//     int? statusCode,
//   }) =>
//       OTPInfo(
//         phone: phone ?? this.phone,
//         type: type ?? this.type,
//       );
// }
//
// enum OTPType {
//   login,
//   register,
// }
//
// extension OTPTypeExtension on OTPType {
//   bool get isLogin => this == OTPType.login;
//   bool get isRegister => this == OTPType.register;
// }
