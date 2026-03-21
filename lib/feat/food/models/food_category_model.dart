class FoodCategoryModel {
  final String id;
  final String name;
  final int sortOrder;
  final String imageUrl;

  FoodCategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sortOrder,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image_url': imageUrl,
      'sort_order': sortOrder,
    };
  }
}
