abstract class DropDrowAbstract {
  final String? name;
  DropDrowAbstract({
    this.name,
  });

  @override
  String toString() => 'DropDrowAbstract(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropDrowAbstract && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
