import 'package:bookrim/admob_banner.dart';
import 'package:bookrim/view/view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controller/controller.dart';
import '../model/model.dart';

class PostView extends StatefulWidget {
  final String blogId;
  final String apiKey;

  const PostView({super.key, required this.blogId, required this.apiKey});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late PostController controller;
  bool isLoading = false;
  List<String> categories = [];
  String? selectedCategory;
  List<PostModel>? allPosts;
  List<PostModel>? filteredPosts;
  TextEditingController searchController = TextEditingController();

  // Color Palette
  final Color primaryColor = const Color(0xFF8A7CA3);
  final Color accentColor = const Color(0xFF1ABC9C);
  final Color backgroundColor = const Color(0xFFF5E6D3);

  @override
  void initState() {
    super.initState();
    controller = PostController(blogId: widget.blogId, apiKey: widget.apiKey);
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      setState(() => isLoading = true);
      final posts = await controller.getAllPosts();
      final uniqueLabels = <String>{};
      for (var post in posts) {
        if (post.labels != null) {
          uniqueLabels.addAll(post.labels!);
        }
      }
      setState(() {
        categories = uniqueLabels.toList();
        allPosts = posts;
        filteredPosts = posts;
        isLoading = false;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void filterPosts(String label) {
    setState(() {
      selectedCategory = label;
      filteredPosts = label.isEmpty
          ? allPosts
          : allPosts
              ?.where((post) => post.labels?.contains(label) ?? false)
              .toList();
    });
  }

  void searchPosts(String query) {
    setState(() {
      filteredPosts = allPosts?.where((post) {
        final titleLower = post.title?.toLowerCase() ?? '';
        return titleLower.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> openPDFView(String url) async {
    setState(() => isLoading = true);
    try {
      String? downloadUrl = url.contains("drive.google.com")
          ? controller.generateGoogleDriveDirectLink(url)
          : url.endsWith('.pdf')
              ? url
              : null;

      if (downloadUrl != null) {
        final file = await controller.downloadAndSaveFile(
            downloadUrl, 'downloaded_pdf.pdf');
        setState(() => isLoading = false);

        if (file != null) {
          _navigateToPDFView(file.path);
        } else {
          _showSnackbar('Failed to open PDF');
        }
      } else {
        setState(() => isLoading = false);
        _showSnackbar('Invalid PDF link');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackbar('Error opening PDF');
    }
  }

  void fetchAllPosts() async {
    setState(() {
      isLoading = true;
    });
    // Assuming you have a method to get all posts
    filteredPosts = await controller.getAllPosts();
    setState(() {
      isLoading = false;
    });
  }

  void _navigateToPDFView(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfessionalPDFViewPage(filePath: filePath),
      ),
    );
  }

  void _showSnackbar(String message) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'University Archive',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: primaryColor),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: primaryColor,
                size: 50,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories Section with Enhanced Design
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (ctx, index) {
                      final label = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: selectedCategory == label,
                          selectedColor: accentColor.withOpacity(0.2),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selectedCategory == label
                                ? accentColor
                                : Colors.grey[700],
                          ),
                          onSelected: (selected) {
                            filterPosts(selected ? label : '');
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Posts List Section with Improved Styling
                Expanded(
                  child: filteredPosts == null
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: primaryColor,
                            size: 50,
                          ),
                        )
                      : filteredPosts!.isEmpty
                          ? Center(
                              child: Text(
                                'No posts found',
                                style: TextStyle(color: primaryColor),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filteredPosts!.length,
                              separatorBuilder: (context, index) => Divider(
                                color: primaryColor.withOpacity(0.2),
                              ),
                              itemBuilder: (ctx, index) {
                                final post = filteredPosts![index];
                                return ListTile(
                                  title: Text(
                                    post.title ?? 'No Title',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    post.labels?.join(', ') ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('View'),
                                    onPressed: () {
                                      final firstLink = controller
                                          .extractFirstLink(post.content ?? '');
                                      if (firstLink != null) {
                                        openPDFView(firstLink);
                                      } else {
                                        _showSnackbar(
                                            'No valid PDF link found');
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                ),
                AdMobBanner(), // Placeholder for existing content
              ],
            ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Search Posts',
            style: TextStyle(color: primaryColor),
          ),
          content: TextField(
            controller: searchController,
            onChanged: (query) {
              searchPosts(query);
            },
            decoration: InputDecoration(
              hintText: 'Enter search term...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: accentColor),
              ),
            ),
            cursorColor: accentColor,
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
