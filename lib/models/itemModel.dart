import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((dynamic x) {
      return Product.fromJson(x);
    }));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int? id;
  String? article;
  List<dynamic>? attributes;
  int? hierarchicalId;
  int? hierarchicalParent;
  bool? published;
  List<String>? images;
  String? name;
  //String? categories;
  int? cost;
  String? description;
  String? balance;

  static const String ARTICLE = "article";
  static const String ATTRIBUTES = "attributes";
  static const String BALANCE = "balance";
  static const String COST = "cost";
  static const String DESCRIPTION = "description";
  static const String ID = "id";
  static const String HIETARCHICALID = "hierarchicalId";
  static const String HIERARCHICALPARENT = "hierarchicalParent";
  static const String IMAGES = "images";
  static const String NAME = "name";
  static const String PUBLISHED = "published";

  Product({
    this.id,
    this.attributes,
    this.description,
    this.article,
    this.balance,
    this.cost,
    this.hierarchicalId,
    this.hierarchicalParent,
    this.images,
    this.name,
    this.published,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    //  print(json[IMAGES]);
    return Product(
        id: json[ID],
        article: json[ARTICLE],
        attributes: json[ATTRIBUTES],
        name: json[NAME],
        balance: json[BALANCE],
        cost: json[COST],
        description: json[DESCRIPTION],
        images: List<String>.from(json[IMAGES].map((x) => x)),
        published: json[PUBLISHED]);
    //tagList: List<dynamic>.from(json["tag_list"].map((x) => x)),
  }

  Map<String, dynamic> toJson() => {
        ARTICLE: article,
        ATTRIBUTES: attributes,
        ID: id,
        IMAGES: images,
        NAME: name,
        COST: cost,
        BALANCE: balance,
        DESCRIPTION: description,
        PUBLISHED: published
      };
}
