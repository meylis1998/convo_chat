enum MessageType {
  text,
  image,
  video,
  file,
  voice,
  system;

  bool get isMedia => this == image || this == video || this == voice || this == file;
  bool get isText => this == text || this == system;
}
