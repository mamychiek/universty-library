// IconButton(
//   icon: const Icon(Icons.share, color: Colors.white),
//   tooltip: 'Share App',
//   onPressed: () {
//     Share.share(
//       'Check out this app on Google Play: https://play.google.com/store/apps/details?id=com.example.myapp',
//     );
//   },
// )

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

import '../admob_banner.dart';

class ProfessionalPDFViewPage extends StatefulWidget {
  final String filePath;
  final String documentTitle;

  const ProfessionalPDFViewPage(
      {super.key,
      required this.filePath,
      this.documentTitle = 'Academic Document'});

  @override
  State<ProfessionalPDFViewPage> createState() =>
      _ProfessionalPDFViewPageState();
}

class _ProfessionalPDFViewPageState extends State<ProfessionalPDFViewPage> {
  late PDFViewController pdfController;
  int currentPage = 0;
  int totalPages = 0;
  bool isDarkMode = false;
  double zoomLevel = 1.0;

  final TextEditingController pageController = TextEditingController();

  // Professional color scheme
  final _lightTheme = ThemeData(
    primaryColor: const Color(0xFF8A7CA3),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Color(0xFF8A7CA3),
      elevation: 4,
    ),
  );

  final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF8A7CA3),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
      elevation: 4,
    ),
  );

  @override
  void initState() {
    super.initState();
    pageController.text = '1';
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // Professional metadata extraction
  Map<String, String> _extractDocumentMetadata() {
    return {
      'File Name': path.basename(widget.filePath),
      'Document Type':
          path.extension(widget.filePath).toUpperCase().replaceFirst('.', ''),
      'Last Accessed': DateTime.now().toString().substring(0, 16),
    };
  }

  // Enhanced contact dialog
  void _showProfessionalContactDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'University Support',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            _buildContactInfo(
              icon: Icons.email,
              text: 'mamybhwr@gmail.com',
              isDark: isDarkMode,
            ),
            const SizedBox(height: 10),
            _buildContactInfo(
              icon: Icons.phone,
              text: '+222 34664141',
              isDark: isDarkMode,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF8A7CA3)),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? _darkTheme : _lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.documentTitle,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            // Metadata Information
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                // Show document metadata
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Document Metadata'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _extractDocumentMetadata()
                          .entries
                          .map((entry) => Text('${entry.key}: ${entry.value}'))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            // Contact Button
            IconButton(
              icon: const Icon(Icons.contact_support, color: Colors.white),
              tooltip: 'Contact Support',
              onPressed: _showProfessionalContactDialog,
            ),
            // Theme Toggle
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              tooltip: 'Toggle Theme',
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Zoom and Navigation Controls
            Container(
              color: isDarkMode ? Colors.grey[850] : Colors.indigo[50],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            // PDF View
            Expanded(
              child: Transform.scale(
                scale: zoomLevel,
                child: PDFView(
                  filePath: widget.filePath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageFling: true,
                  onViewCreated: (controller) {
                    pdfController = controller;
                    controller.getPageCount().then((count) {
                      setState(() {
                        totalPages = count ?? 0;
                        pageController.text = '1';
                      });
                    });
                  },
                  onPageChanged: (page, _) {
                    setState(() {
                      currentPage = page ?? 0;
                      pageController.text = (currentPage + 1).toString();
                    });
                  },
                ),
              ),
            ),
            AdMobBanner(), // Placeholder for existing content
          ],
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: BottomAppBar(
          color: isDarkMode ? Colors.grey[850] : const Color(0xFF8A7CA3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                tooltip: 'Share Document',
                onPressed: () {
                  Share.share(
                    'Check out this app on Google Play: https://play.google.com/store/apps/details?id=com.nkt.boorim',
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                tooltip: 'Back to Home',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
