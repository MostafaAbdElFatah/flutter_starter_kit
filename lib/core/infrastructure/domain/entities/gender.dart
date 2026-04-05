// import '../../../assets/images.dart';
// import '../../../assets/localization_keys.dart';
//
// /// Represents the gender categories used throughout the application.
// enum Gender {
//
//   /// Associated with internal ID 1.
//   male(1),
//
//   /// Associated with internal ID 2.
//   female(2);
//
//   /// The underlying integer identifier stored in databases or APIs.
//   final int id;
//
//   const Gender(this.id);
//
//   /// Throws a [StateError] if no match is found.
//   static Gender byId(int id) => Gender.values.byId(id);
//
//   /// Parses a cached gender value into [Gender].
//   ///
//   /// Returns `null` when the value is missing, invalid, or `Gender.unknown`
//   /// (unless [allowUnknown] is true).
//   static Gender? fromValue(Object? cached) {
//     if (cached is! String || cached.isEmpty) return null;
//     return Gender.values.byName(cached);
//   }
// }
//
// extension ListGenderX on List<Gender> {
//   /// Finds a [Gender] instance by its [id].
//   Gender byId(int id) => firstWhere((e) => e.id == id, orElse: () => Gender.male);
// }
//
// /// Provides UI-related helper properties and methods for the [Gender] enum.
// extension Genderx on Gender {
//   /// Quick check if the gender is male.
//   bool get isMale => this == Gender.male;
//
//   /// Quick check if the gender is female.
//   bool get isFemale => this == Gender.female;
//
//   /// Returns the localized display string for the gender.
//   String get title {
//     switch (this) {
//       case Gender.male:
//         return LocalizationKeys.man;
//       case Gender.female:
//         return LocalizationKeys.woman;
//     }
//   }
//
//   /// Returns the asset path for the gender icon based on its [isActive] state.
//   String getImage([bool isActive = true]) {
//     switch (this) {
//       case Gender.male:
//         return isActive ? Images.activeMan : Images.inactiveMan;
//       case Gender.female:
//         return isActive ? Images.activeWoman : Images.inactiveWoman;
//     }
//   }
// }
