import 'package:flutter/material.dart';

import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/modules/home/domain/entities/blog_post.dart';
import 'package:reservation_workshop/modules/home/presentation/screens/blog_details_screen.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({
    super.key,
    required this.posts,
  });

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t(context, 'home.offers_news_title', ar: 'العروض والأخبار', en: 'OFFERS & NEWS'),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF050505),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final post = posts[index];
          return _BlogBannerTile(post: post);
        },
      ),
    );
  }
}

class _BlogBannerTile extends StatelessWidget {
  const _BlogBannerTile({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final title = post.title.trim();
    final content = post.content.trim();
    final imageUrl = (post.imageUrl ?? '').trim();

    final isEnglish = isLtr(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlogDetailsScreen(post: post),
          ),
        );
      },
      child: AppCard(
        padding: EdgeInsets.zero,
        backgroundColor: const Color(0xFF050505),
        borderRadius: 12,
        borderColor: const Color(0xFF0A0A0A),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey.shade200,
                    child: imageUrl.isEmpty
                        ? Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover)
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover),
                          ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t(context, 'home.news_chip', ar: 'أخبار', en: 'News'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglish ? (title.isEmpty ? '-' : title).toUpperCase() : (title.isEmpty ? '-' : title),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      height: 1.15,
                    ),
                  ),
                  if (content.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      isEnglish ? content.toUpperCase() : content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                        letterSpacing: 0.4,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
