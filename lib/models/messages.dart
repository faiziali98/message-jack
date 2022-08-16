class Messages {
  final String body;
  final String from;

  const Messages({
    required this.body,
    required this.from,
  });

  static Messages fromJson(Map<String, dynamic> json) => Messages(
    body: json['body'],
    from: json['from'],
  );

  Map<String, dynamic> toJson() => {
    'body': body,
    'from': from,
  };
}