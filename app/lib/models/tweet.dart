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
      date: json['date'] as String?,
      link: json['link'] as String?,
      text: json['text'] as String?,
      avatar: json['user']?['avatar'] as String?,
      username: json['user']?['username'] as String?,
    );
  }
}
