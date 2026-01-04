enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;

  bool get isPending => this == sending;
  bool get isDelivered => this == delivered || this == read;
  bool get hasFailed => this == failed;
}
