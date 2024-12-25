import 'package:blogger_api/models/postitem.model.dart';

class PostModel {
  final String? title;
  final String? content;
  final List<String>? labels;

  PostModel({this.title, this.content, this.labels});

  // Convert from PostItemModel to PostModel
  static List<PostModel> fromPostItems(List<PostItemModel> items) {
    return items
        .map((item) => PostModel(
              title: item.title,
              content: item.content,
              labels: item.labels ?? [], // Ensure labels are handled correctly
            ))
        .toList();
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      content: json['content'],
      labels: json['labels'] != null
          ? List<String>.from(
              json['labels']) // Convert labels from dynamic list
          : [], // Default to an empty list if no labels are present
    );
  }
}
