class SessionUser {
  final String name;
  final String userUUID;

  const SessionUser({
    this.name = '',
    this.userUUID = '',
  });

  SessionUser copyWith({
    String? name,
    String? userUUID,
  }) {
    return SessionUser(
      name: name ?? this.name,
      userUUID: userUUID ?? this.userUUID,
    );
  }

  @override
  String toString() {
    return 'SessionUser{name: $name, userUUID: $userUUID}';
  }
}