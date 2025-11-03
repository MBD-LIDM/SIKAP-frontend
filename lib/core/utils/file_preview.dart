// lib/core/utils/file_preview.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FilePreview {
  /// Open attachment (image preview or PDF download)
  /// [kind] should be from backend response: "image" or "pdf"
  static Future<void> openAttachment(
    BuildContext context,
    String fileUrl,
    String fileName,
    String kind, // ← Backend-validated file type
  ) async {
    // Debug logging
    print('[FilePreview] Opening attachment:');
    print('[FilePreview] URL: $fileUrl');
    print('[FilePreview] Filename: $fileName');
    print('[FilePreview] Kind: $kind');
    
    // Validate URL
    if (fileUrl.isEmpty) {
      print('[FilePreview] ERROR: URL is empty');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL file kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if URL is valid
    try {
      final uri = Uri.parse(fileUrl);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        print('[FilePreview] ERROR: Invalid URL scheme: ${uri.scheme}');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL tidak valid: $fileUrl'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      print('[FilePreview] ERROR: Failed to parse URL: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL format salah: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Use backend-validated 'kind' field instead of file extension
      if (kind == 'image') {
        print('[FilePreview] Opening as image (backend-validated)');
        _showImagePreview(context, fileUrl, fileName);
      } else if (kind == 'pdf') {
        print('[FilePreview] Opening as PDF (backend-validated)');
        await _openPdf(fileUrl);
      } else {
        print('[FilePreview] Unsupported file type: $kind');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Format file tidak didukung: $kind'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('[FilePreview] ERROR: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error membuka file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show image in full-screen preview dialog
  static void _showImagePreview(BuildContext context, String imageUrl, String fileName) {
    print('[FilePreview] Showing image preview dialog');
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      print('[FilePreview] Image loaded successfully');
                      return child;
                    }
                    final progress = loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null;
                    print('[FilePreview] Loading image: ${progress != null ? "${(progress * 100).toStringAsFixed(0)}%" : "..."}');
                    
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            progress != null 
                                ? 'Loading ${(progress * 100).toStringAsFixed(0)}%'
                                : 'Loading...',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('[FilePreview] ERROR loading image: $error');
                    print('[FilePreview] StackTrace: $stackTrace');
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                              'Gagal memuat gambar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'File: $fileName',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${error.toString()}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'URL: $imageUrl',
                              style: const TextStyle(color: Colors.white54, fontSize: 10),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () {
                  print('[FilePreview] Closing image preview');
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  fileName,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Open PDF in browser/external viewer
  static Future<void> _openPdf(String pdfUrl) async {
    print('[FilePreview] Launching PDF URL: $pdfUrl');
    final uri = Uri.parse(pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      print('[FilePreview] PDF launched successfully');
    } else {
      print('[FilePreview] ERROR: Cannot launch PDF URL');
      throw Exception('Tidak bisa membuka URL: $pdfUrl');
    }
  }
}

