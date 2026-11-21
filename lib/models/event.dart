class TimelineEvent {
  final String time;
  final String title;
  final String description;
  final String icon;

  const TimelineEvent({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class FestivalDay {
  final int day;
  final String date;
  final String title;
  final String pdfUrl;
  final List<TimelineEvent> events;

  const FestivalDay({
    required this.day,
    required this.date,
    required this.title,
    required this.pdfUrl,
    required this.events,
  });
}
