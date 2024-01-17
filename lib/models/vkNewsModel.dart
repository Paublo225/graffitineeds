import 'package:json_annotation/json_annotation.dart';

class VkApiResponse {
  final List<VkItem>? items;
  VkApiResponse({required this.items});

  factory VkApiResponse.fromMap(Map<String, dynamic> json) => VkApiResponse(
          items: List<VkItem>.from(json["items"].map((x) {
        return VkItem.fromMap(x);
      })));
  Map<String, dynamic> toMap() => {
        "items": List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}

class VkItem {
  final List<dynamic> attachments;
  final int date;
  final int id;
  final String text;

  VkItem({
    required this.attachments,
    required this.date,
    required this.id,
    required this.text,
  });

  factory VkItem.fromMap(Map<String, dynamic> json) => VkItem(
      attachments: json["attachments"],
      date: json["date"],
      id: json["id"],
      text: json["text"]);

  Map<String, dynamic> toMap() =>
      {"attachments": attachments, "date": date, "id": id, "text": text};
}
