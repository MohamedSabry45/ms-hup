class Branch {
  final int id;
  final String name;
  final int isCarStation;

  const Branch({
    required this.id,
    required this.name,
    this.isCarStation = 1,
  });
}
