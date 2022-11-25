class Event {
  final String title;
  final String description;
  final String time;
  Event({required this.title, required this.description, required this.time});

  String toString() => '${this.title} - ${this.description} - ${this.time}';
}