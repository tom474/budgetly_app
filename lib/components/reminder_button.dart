import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderButton extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime)? onDateSelected;
  final Function(TimeOfDay)? onTimeSelected;

  const ReminderButton({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
    this.onTimeSelected,
  }) : super(key: key);

  @override
  _ReminderButtonState createState() => _ReminderButtonState();
}

class _ReminderButtonState extends State<ReminderButton> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDateTime() async {
    final DateTime? chosenDateTime = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (chosenDateTime != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? chosenTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (chosenTime != null) {
        setState(
          () {
            _selectedDate = DateTime(
              chosenDateTime.year,
              chosenDateTime.month,
              chosenDateTime.day,
              chosenTime.hour,
              chosenTime.minute,
            );
            _selectedTime = chosenTime;
          },
        );
        widget.onDateSelected!(_selectedDate!);
      }
    }

    if (_selectedDate != null && widget.onDateSelected != null) {
      widget.onDateSelected!(_selectedDate!);
    } else if (widget.onDateSelected != null) {
      widget.onDateSelected!(widget.initialDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hintColor = _selectedDate != null && _selectedTime != null
        ? Colors.black // Color when date and time are selected
        : Colors.black38; // Color when date and time are not selected

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.access_time_outlined),
              onPressed: _selectDateTime,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _selectedDate != null
                    ? '${DateFormat('dd-MM-yyyy').format(_selectedDate!)} ${_selectedTime!.format(context)}'
                    : 'Select a reminder',
                style: TextStyle(
                  fontSize: 14,
                  color: hintColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      ),
    );
  }
}
