class Tweet {
  final String date;
  final String link;
  final String text;
  final String avatar;
  final String username;

  Tweet({
    required this.date,
    required this.link,
    required this.text,
    required this.avatar,
    required this.username,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      date: json['date'],
      link: json['link'],
      text: json['text'],
      avatar: json['user']['avatar'],
      username: json['user']['username'],
    );
  }
}
