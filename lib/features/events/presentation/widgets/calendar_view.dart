import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/event_model.dart';

class CalendarView extends StatefulWidget {
  final List<EventModel> events;

  const CalendarView({Key? key, required this.events}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return widget.events.where((e) => isSameDay(e.date, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];

    return Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: double.maxFinite,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Events Calendar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Calendar
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      eventLoader: _getEventsForDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay; 
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Color(0xFFE5E7EB),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        selectedDecoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const Divider(),

                    // Event List for Day
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _selectedDay == null 
                              ? 'Select a Day' 
                              : DateFormat('MMMM dd, yyyy').format(_selectedDay!),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ),

                    if (selectedDayEvents.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'No events scheduled for this day.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ...selectedDayEvents.map((evt) => InkWell(
                        onTap: () {
                          Navigator.of(context).pop(); // close modal
                          context.push('/events/${evt.id}');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      evt.title,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                    ),
                                    const Gap(4),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 12, color: Colors.grey),
                                        const Gap(4),
                                        Text(
                                          DateFormat('h:mm a').format(evt.date),
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            ],
                          ),
                        ),
                      )).toList(),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
