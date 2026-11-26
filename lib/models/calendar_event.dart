import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String month;
  final String days;
  final String year;
  final Color monthColor;
  final bool isConfirmed;
  final String tribe;
  final String location;
  final String dateRange;
  final String description;
  final int order;

  const CalendarEvent({
    this.id = '',
    required this.title,
    this.startDate,
    this.endDate,
    required this.month,
    required this.days,
    required this.year,
    required this.monthColor,
    required this.isConfirmed,
    required this.tribe,
    required this.location,
    required this.dateRange,
    required this.description,
    this.order = 0,
  });

  static const List<String> _shortMonths = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static const List<String> _fullMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    try {
      final dynamic d = raw;
      if (d.toDate != null && d.toDate is Function) {
        return d.toDate() as DateTime;
      }
    } catch (_) {}
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    final str = raw.toString().trim();
    if (str.isEmpty) return null;
    return DateTime.tryParse(str);
  }

  static String _formatDateRange(DateTime start, DateTime? end) {
    final endDt = end ?? start;
    if (start.year == endDt.year && start.month == endDt.month && start.day == endDt.day) {
      return '${start.day} ${_fullMonths[start.month - 1]} ${start.year}';
    }
    if (start.year == endDt.year && start.month == endDt.month) {
      return '${start.day} to ${endDt.day} ${_fullMonths[start.month - 1]} ${start.year}';
    }
    if (start.year == endDt.year) {
      return '${start.day} ${_fullMonths[start.month - 1]} to ${endDt.day} ${_fullMonths[endDt.month - 1]} ${start.year}';
    }
    return '${start.day} ${_fullMonths[start.month - 1]} ${start.year} to ${endDt.day} ${_fullMonths[endDt.month - 1]} ${endDt.year}';
  }

  Map<String, dynamic> toMap() {
    String? startStr;
    String? endStr;
    if (startDate != null) {
      startStr = '${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}';
    }
    if (endDate != null) {
      endStr = '${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}';
    }
    return {
      'title': title,
      if (startStr != null) 'startDate': startStr,
      if (endStr != null) 'endDate': endStr,
      'tribe': tribe,
      'location': location,
      'description': description,
      'isConfirmed': isConfirmed,
    };
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map, [String? docId]) {
    final title = (map['title'] ?? map['name'] ?? '').toString();
    final isConfirmed = map['isConfirmed'] == true ||
        map['confirmed'] == true ||
        map['is_confirmed'] == true;
    final tribe = (map['tribe'] ?? map['tribeName'] ?? map['tribe_name'] ?? '').toString();
    final location = (map['location'] ?? map['place'] ?? '').toString();
    final description = (map['description'] ?? map['desc'] ?? map['details'] ?? '').toString();

    final parsedStart = _parseDate(map['startDate'] ?? map['start_date']);
    final parsedEnd = _parseDate(map['endDate'] ?? map['end_date']) ?? parsedStart;

    String month;
    String days;
    String year;
    String dateRange;

    if (parsedStart != null) {
      month = _shortMonths[parsedStart.month - 1];
      year = parsedStart.year.toString();
      final endDt = parsedEnd ?? parsedStart;
      if (parsedStart.year == endDt.year &&
          parsedStart.month == endDt.month &&
          parsedStart.day != endDt.day) {
        days = '${parsedStart.day}-${endDt.day}';
      } else {
        days = '${parsedStart.day}';
      }
      dateRange = _formatDateRange(parsedStart, endDt);
    } else {
      month = (map['month'] ?? '').toString().toUpperCase();
      days = (map['days'] ?? '').toString();
      year = (map['year'] ?? '').toString();
      dateRange = (map['dateRange'] ?? map['dates'] ?? map['date_range'] ?? '').toString();
    }

    int parsedOrder = 0;
    if (map['order'] is num) {
      parsedOrder = (map['order'] as num).toInt();
    } else {
      parsedOrder = int.tryParse(map['order']?.toString() ?? '') ?? 0;
    }

    final parsedColor = _defaultColorForMonth(month);

    return CalendarEvent(
      id: docId ?? map['id']?.toString() ?? '',
      title: title,
      startDate: parsedStart,
      endDate: parsedEnd,
      month: month,
      days: days,
      year: year,
      monthColor: parsedColor,
      isConfirmed: isConfirmed,
      tribe: tribe,
      location: location,
      dateRange: dateRange,
      description: description,
      order: parsedOrder,
    );
  }

  static Color _defaultColorForMonth(String month) {
    switch (month.toUpperCase()) {
      case 'JAN':
        return const Color(0xFF0284C7);
      case 'FEB':
        return const Color(0xFFDC2626);
      case 'MAR':
        return const Color(0xFF0284C7);
      case 'APR':
        return const Color(0xFFDC2626);
      case 'MAY':
        return const Color(0xFF059669);
      case 'JUN':
        return const Color(0xFFD97706);
      case 'JUL':
        return const Color(0xFF20B08D);
      case 'AUG':
        return const Color(0xFF0284C7);
      case 'SEP':
        return const Color(0xFFD97706);
      case 'OCT':
        return const Color(0xFF20B08D);
      case 'NOV':
        return const Color(0xFFD97706);
      case 'DEC':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF20B08D);
    }
  }
}
