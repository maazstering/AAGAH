class Tweet {
  final String? date;
  final String? link;
  final String? text;
  final String? avatar;
  final String? username;

  Tweet({
    required this.date,
    required this.link,
    required this.text,
    required this.avatar,
    required this.username,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      date: json['date'] as String? ?? 'Date unknown',
      link: json['link'] as String? ?? '',
      text: json['text'] as String? ?? 'No description available',
      avatar: json['avatar'] as String? ?? 'https://via.placeholder.com/150',
      username: json['username'] as String? ?? 'Unknown user',
    );
  }
}
