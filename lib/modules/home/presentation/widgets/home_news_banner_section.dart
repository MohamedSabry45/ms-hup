import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/modules/home/domain/entities/blog_post.dart';
import 'package:reservation_workshop/modules/home/presentation/screens/blog_details_screen.dart';

class HomeNewsBannerSection extends StatelessWidget {
  const HomeNewsBannerSection({
    super.key,
    required this.posts,
    this.onViewAll,
  });

  final List<BlogPost> posts;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    final isEnglish = isLtr(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isEnglish
                      ? 'OFFERS & NEWS'
                      : t(context, 'home.offers_news_title', ar: 'العروض والأخبار', en: 'OFFERS & NEWS'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    height: 1.2,
                  ),
                ),
              ),
              InkWell(
                onTap: onViewAll,
                child: Row(
                  children: [
                    Text(
                      t(context, 'home.view_all', ar: 'عرض الكل', en: 'View All'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD4AF37),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFD4AF37),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 262,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _NewsBannerCard(post: posts[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _NewsBannerCard extends StatelessWidget {
  const _NewsBannerCard({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final title = post.title.trim();
    final content = post.content.trim();
    final imageUrl = (post.imageUrl ?? '').trim();

    final isEnglish = isLtr(context);

    return SizedBox(
      width: 220,
      child: InkWell(
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
          borderColor: Colors.white.withOpacity(0.08),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 128,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xFF0A0A0A),
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
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
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
                      (title.isEmpty ? '-' : title).toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.15,
                      ),
                    ),
                    if (content.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        isEnglish ? content.toUpperCase() : content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.6),
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
      ),
    );
  }
}
