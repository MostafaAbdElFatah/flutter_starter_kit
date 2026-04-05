import 'package:dropdown_search/dropdown_search.dart';

import '../../core.dart';

enum DropdownType {
  menu,
  bottomSheet;

  bool get isMenu => this == menu;
  bool get isBottomSheet => this == bottomSheet;
}

class Dropdown<T> extends StatelessWidget {
  final FlexFit? fit;
  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final DropdownType type;
  final FormFieldSetter<T>? onSaved;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final DropdownSearchCompareFn<T> compareFn;
  final DropdownSearchItemAsString<T> itemAsString;
  final DropdownSearchBuilder<T>? dropdownBuilder;
  final DropdownSearchPopupItemBuilder<T>? itemBuilder;
  const Dropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.compareFn,
    required this.itemAsString,
    required this.type,
    this.selectedItem,
    this.fit,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.dropdownBuilder,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final TextFieldProps searchFieldProps = TextFieldProps(
      style: AppColors.white.medium(fontSize: 14),
      decoration: InputDecoration(
        hintText: LocalizationKeys.search,
        labelText: LocalizationKeys.search,
        hintStyle: AppColors.spunPearl.medium(fontSize: 14),
      ),
    );
    return LiquidGlassContainer(
      child: DropdownSearch<T>(
        selectedItem: selectedItem,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        compareFn: compareFn,
        itemAsString: itemAsString,
        items: (filter, infiniteScrollProps) => items,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        dropdownBuilder: dropdownBuilder,
        popupProps: type.isMenu
            ? PopupProps.menu(
                showSelectedItems: true,
                itemBuilder: itemBuilder,
                fit: fit ?? FlexFit.loose,
                constraints: BoxConstraints(),
                searchFieldProps: searchFieldProps,
                containerBuilder: (ctx, popupWidget) {
                  return LiquidGlassContainer(
                    child: popupWidget,
                  );
                },
              )
            : PopupProps.modalBottomSheet(
                showSearchBox: true,
                showSelectedItems: true,
                itemBuilder: itemBuilder,
                fit: fit ?? FlexFit.tight,
                searchFieldProps: searchFieldProps,
                modalBottomSheetProps: ModalBottomSheetProps(),
                containerBuilder: (ctx, popupWidget) {
                  return LiquidGlassContainer(
                    padding: const EdgeInsets.all(10),
                    child: popupWidget,
                  );
                },
              ),
      ),
    );
  }
}
