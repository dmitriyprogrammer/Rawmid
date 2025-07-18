class ModerateStatus {
  static const String draft = 'черновик';
  static const String pending = 'на модерации';
  static const String published = 'опубликовано';
  static const String rejected = 'отклонено';

  final String? value;

  ModerateStatus(this.value);

  bool get isDraft => value == draft;
  bool get isPending => value == pending;
  bool get isPublished => value == published;
  bool get isRejected => value == rejected;

  bool get isEditable => isDraft || isRejected;
  bool get isReadonly => isPublished || isPending;

  static ModerateStatus from(String? value) => ModerateStatus(value?.toLowerCase().trim());
}