import 'package:flutter/material.dart';

class ArtikelInfoPage extends StatefulWidget {
  const ArtikelInfoPage({super.key});

  @override
  State<ArtikelInfoPage> createState() => _ArtikelInfoPageState();
}

class _ArtikelInfoPageState extends State<ArtikelInfoPage> {
  String selectedCategory = 'Kesehatan Mental dan Kesejahteraan';

  final List<String> categories = [
    'Kesehatan Mental dan Kesejahteraan',
    'Memahami Bullying',
    'Mendapatkan Bantuan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7F55B1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Artikel & Info',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'serif',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Akses beragam konten tentang kesehatan mental.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Category Section
              Row(
                children: [
                  const Text(
                    'Kategori:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                    ? const Color(0xFFF5F5DC) // Light beige when selected
                                    : const Color(0xFFE6D7FF), // Light purple when not selected
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected 
                                      ? const Color(0xFF7F55B1)
                                      : const Color(0xFF7F55B1).withValues(alpha: 0.7),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF7F55B1),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Article Cards Section
              Expanded(
                child: ListView(
                  children: [
                    _buildArticleCard(
                      title: '10 Cara Mengendalikan Stres Saat Sekolah Terasa Berat',
                      category: 'Kesehatan Mental dan Kesejahteraan',
                      date: 'Diposting pada 15 Agustus 2025',
                      illustration: _buildStressIllustration(),
                    ),
                    const SizedBox(height: 16),
                    _buildArticleCard(
                      title: 'Bukan Salahmu: Memahami Apa Itu Bullying dan Mengapa Itu Terjadi',
                      category: 'Memahami Bullying',
                      date: 'Diposting pada 6 Agustus 2025',
                      illustration: _buildBullyingIllustration(),
                    ),
                    const SizedBox(height: 16),
                    _buildArticleCard(
                      title: 'Kapan dan Bagaimana Mencari Bantuan Profesional',
                      category: 'Mendapatkan Bantuan',
                      date: 'Diposting pada 20 Juli 2025',
                      illustration: _buildHelpIllustration(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
        ),
        ),
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String category,
    required String date,
    required Widget illustration,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
        children: [
          // Illustration Section
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5DC), // Light beige
              // Top radius handled by ClipRRect
            ),
            child: Center(child: illustration),
          ),
          // Content Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFE6D7FF), // Light purple
              // Bottom radius handled by ClipRRect
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F55B1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                // Date
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildStressIllustration() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.psychology,
        size: 40,
        color: Colors.red,
      ),
    );
  }

  Widget _buildBullyingIllustration() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.warning,
        size: 40,
        color: Colors.orange,
      ),
    );
  }

  Widget _buildHelpIllustration() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.support_agent,
        size: 40,
        color: Colors.green,
      ),
    );
  }
}
