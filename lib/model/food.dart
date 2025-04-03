class Food {
  final String id;
  final String name;
  final double price;

  Food({required this.id, required this.name, required this.price});

  @override
  bool operator ==(Object other) {
    return other is Food && other.id == id;
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode;
}
