enum ConversationType {
  direct,
  group;

  bool get isDirect => this == direct;
  bool get isGroup => this == group;
}
