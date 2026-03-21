class MenuItemModel {
  final String id;
  final String restaurantId;
  final String categoryId;
  final String name;
  final String description;
  final int price;
  final bool isAvailable;
  final String imageUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItemModel({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.imageUrl,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  /// FROM JSON (MongoDB)
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['_id'],
      restaurantId: json['restaurantId'],
      categoryId: json['categoryId'],
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: json['price'] as int,
      isAvailable: json['is_available'] as bool,
      imageUrl: json['image_url'] as String,
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
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'is_available': isAvailable,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
