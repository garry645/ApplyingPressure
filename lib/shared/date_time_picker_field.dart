import 'package:flutter/material.dart';

class DateTimePickerField extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateTimeChanged;
  final String label;

  const DateTimePickerField({
    super.key,
    required this.initialDate,
    required this.onDateTimeChanged,
    required this.label,
  });

  @override
  State<DateTimePickerField> createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDate;
  }

  Future<void> _pickDateTime() async {
    // Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    if (pickedDate == null) return;

    // Pick time
    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (pickedTime == null) return;

    // Combine date and time
    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDateTime = newDateTime;
    });

    widget.onDateTimeChanged(newDateTime);
  }

  String get _formattedDateTime {
    return '${_selectedDateTime.month}/${_selectedDateTime.day}/${_selectedDateTime.year} '
           '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.label}:',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                _formattedDateTime,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            ElevatedButton(
              onPressed: _pickDateTime,
              child: const Text("Select Date & Time"),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}