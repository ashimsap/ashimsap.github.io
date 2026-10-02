import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/marketing_model.dart';

class CreativeGallery extends StatefulWidget {
  final List<CreativeArchiveItem> items;
  const CreativeGallery({super.key, required this.items});

  @override
  State<CreativeGallery> createState() => _CreativeGalleryState();
}

class _CreativeGalleryState extends State<CreativeGallery> {
  CreativeCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final filteredItems = _selectedCategory == null
        ? widget.items
        : widget.items.where((i) => i.category == _selectedCategory).toList();

    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Text(
                  "CREATIVE ARCHIVE",
                  style: GoogleFonts.robotoMono(
                    color: const Color(0xFF7E22CE),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.collections_outlined,
                  color: const Color(0xFF7C3AED), size: 18),
              const SizedBox(width: 6),
              Text(
                "MEDIA & GRAPHICS",
                style: GoogleFonts.robotoMono(
                  color: const Color(0xFF7C3AED),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "GRAPHIC DESIGN & CAMPAIGN ARCHIVE",
            style: GoogleFonts.syne(
              color: const Color(0xFF0F172A),
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Visual assets created across Canva, Adobe Photoshop, Meta ad campaigns, and short-form video reels.",
            style: GoogleFonts.outfit(
              color: const Color(0xFF475569),
              fontSize: isMobile ? 14 : 15,
            ),
          ),
          const SizedBox(height: 20),

          // Category Filter Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: "ALL CREATIVES",
                isSelected: _selectedCategory == null,
                onTap: () => setState(() => _selectedCategory = null),
              ),
              _FilterChip(
                label: "GRAPHICS",
                isSelected: _selectedCategory == CreativeCategory.graphics,
                onTap: () => setState(
                    () => _selectedCategory = CreativeCategory.graphics),
              ),
              _FilterChip(
                label: "SOCIAL MEDIA",
                isSelected: _selectedCategory == CreativeCategory.social,
                onTap: () => setState(
                    () => _selectedCategory = CreativeCategory.social),
              ),
              _FilterChip(
                label: "CAMPAIGNS",
                isSelected: _selectedCategory == CreativeCategory.campaigns,
                onTap: () => setState(
                    () => _selectedCategory = CreativeCategory.campaigns),
              ),
              _FilterChip(
                label: "VISUAL CONTENT",
                isSelected: _selectedCategory == CreativeCategory.visualContent,
                onTap: () => setState(
                    () => _selectedCategory = CreativeCategory.visualContent),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Items Grid / List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredItems.length,
            separatorBuilder: (c, i) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return _CreativeCard(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.robotoMono(
            color: isSelected ? Colors.white : const Color(0xFF475569),
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _CreativeCard extends StatelessWidget {
  final CreativeArchiveItem item;
  const _CreativeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDDD6FE)),
            ),
            child: Icon(
              item.category == CreativeCategory.graphics
                  ? Icons.palette_outlined
                  : item.category == CreativeCategory.social
                      ? Icons.share_rounded
                      : item.category == CreativeCategory.campaigns
                          ? Icons.campaign_outlined
                          : Icons.movie_creation_outlined,
              color: const Color(0xFF7C3AED),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.categoryLabel,
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF7E22CE),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      item.tool,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF64748B),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  style: GoogleFonts.syne(
                    color: const Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${item.contextCampaign} • ${item.role}",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
