class Event {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String time;
  final String location;
  final int maxAttendees;
  final String category;
  final int price;

  Event({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.time,
    required this.location,
    required this.maxAttendees,
    required this.category,
    required this.price,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      maxAttendees: json['max_attendees'] ?? 0,
      category: json['category'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}
