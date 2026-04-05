import '../../core.dart';

class DatePicker extends StatefulWidget {
  final String hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? prefixSVGIcon;
  final String? suffixSVGIcon;
  final DateTime? selectedDate;
  final Function(DateTime? date)? onSelectedDate;
  const DatePicker({
    super.key,
    required this.hintText,
    this.onSelectedDate,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixSVGIcon,
    this.suffixSVGIcon,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () => _dateController.text = widget.selectedDate?.yMMdd ?? "",
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDefaultDatePicker,
      child: CustomTextField(
        maxLines: 1,
        readOnly: true,
        enabled: false,
        hintText: widget.hintText,
        labelText: widget.hintText,
        controller: _dateController,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        suffixSVGIcon: widget.suffixSVGIcon,
        prefixSVGIcon: widget.prefixSVGIcon,
        keyboardType: TextInputType.datetime,
        textInputAction: TextInputAction.done,
        // validator: (value) {
        //  if (value == null || value.isEmpty) {
        //     return AppLocalized.kFieldNullError;
        //   }
        //   return null;
        // },
      ),
    );
  }

  void _showDefaultDatePicker() {
    showDatePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(DateTime.now().year - 100),
      lastDate: widget.lastDate ?? DateTime(DateTime.now().year + 100),
      initialDate: widget.selectedDate ??
          (widget.firstDate != null && widget.firstDate!.isAfter(DateTime.now())
              ? widget.firstDate!
              : DateTime.now()),
      //builder: (BuildContext context, Widget? child) => child!,
    ).then((selectedDate) {
      if (selectedDate != null) {
        _dateController.text = selectedDate.yMMdd;
        if (widget.onSelectedDate != null) {
          widget.onSelectedDate!(selectedDate);
        }
      }
    });
  }
}
