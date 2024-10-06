class CategoryModel {
  String? id, imageUrl, catTitle;

  CategoryModel(
      {required this.id, required this.imageUrl, required this.catTitle});

  CategoryModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    imageUrl = map['cat_img'] == "" ? "" : map["cat_img"];
    catTitle = map['cat_name'] == "" ? "" : map["cat_name"];
  }
}
