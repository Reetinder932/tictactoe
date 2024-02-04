class Player {
  final String username;
  final String socketID;
  final double points;
  final String playerType;

  Player({
    required this.username,
    required this.socketID,
    required this.points,
    required this.playerType,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'socketID': socketID,
      'points': points,
      'playerType': playerType,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      username: map['username'] ?? '',
      socketID: map['socketID'] ?? '',
      points: map['points'] ?? 0,
      playerType: map['playerType'] ?? '',
    );
  }

  Player copyWith({
    String? username,
    String? socketID,
    double? points,
    String? playerType,
  }) {
    return Player(
      username: username ?? this.username,
      socketID: socketID ?? this.socketID,
      points: points ?? this.points,
      playerType: playerType ?? this.playerType,
    );
  }
}
