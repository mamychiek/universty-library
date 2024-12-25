// controller/post_controller.dart

// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:html/parser.dart';
import '../model/model.dart';
import 'package:blogger_api/api/blogger_api.dart';

class PostController {
  final String blogId;
  final String apiKey;

  PostController({required this.blogId, required this.apiKey});

  // Fetch all posts from Blogger API with pagination
  Future<List<PostModel>> getAllPosts() async {
    List<PostModel> allPosts = [];
    String? nextPageToken;

    try {
      do {
        // Make API call with optional pagination token
        final response = await BloggerAPI().getAllPostFromBlog(
          apiKey: apiKey,
          blogId: blogId,
          maxresult: 500, // Fetch up to 500 posts per request
        );

        if (response.items != null) {
          // Parse response and add posts to the list
          allPosts.addAll(PostModel.fromPostItems(response.items!));
        }

        // Update the nextPageToken for the next request
        nextPageToken = response as String?;
      } while (nextPageToken != null); // Continue fetching until no more pages
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching posts: $e');
      }
    }

    return allPosts;
  }

  // Extract the first valid URL from the post content (HTML)
  String? extractFirstLink(String content) {
    var document = parse(content);
    var linkElement = document.querySelector('a[href]');
    return linkElement?.attributes['href'];
  }

  // Extract Google Drive file ID from the URL
  String? extractGoogleDriveFileId(String url) {
    final regExp = RegExp(r'd\/(.*)\/view');
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  // Generate Google Drive direct download link
  String? generateGoogleDriveDirectLink(String googleDriveLink) {
    final fileId = extractGoogleDriveFileId(googleDriveLink);
    return fileId != null
        ? 'https://drive.google.com/uc?export=download&id=$fileId'
        : null;
  }

  // Download and save file locally
  Future<File?> downloadAndSaveFile(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
    }
    return null;
  }
}
