class CategoryModel {
  final String id;
  final String restaurantId;
  final String name;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  /// FROM JSON (MongoDB)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      restaurantId: json['restaurantId'],
      name: json['name'] as String,
      sortOrder: json['sort_order'] as int,
      createdAt: json['createdAt'] is Map
          ? DateTime.parse(json['createdAt'])
          : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] is Map
          ? DateTime.parse(json['updatedAt'])
          : DateTime.parse(json['updatedAt']),
    );
  }

  /// TO JSON (API / cache friendly)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurantId': restaurantId,
      'name': name,
      'sort_order': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
