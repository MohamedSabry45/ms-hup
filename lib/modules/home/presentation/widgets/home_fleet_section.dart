import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/modules/home/domain/entities/blog_post.dart';
import 'package:reservation_workshop/modules/home/presentation/cubit/blog_cubit.dart';
import 'package:reservation_workshop/modules/home/presentation/cubit/blog_state.dart';
import 'package:reservation_workshop/modules/home/presentation/screens/blog_details_screen.dart';

class HomeFleetSection extends StatelessWidget {
  const HomeFleetSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return BlocBuilder<BlogCubit, BlogState>(
      builder: (context, state) {
        if (state is BlogLoading) {
          return const SizedBox.shrink();
        }

        if (state is BlogError) {
          return const SizedBox.shrink();
        }

        final posts = state is BlogSuccess ? state.posts : const <BlogPost>[];
        if (posts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 64 : 96, horizontal: 16),
          child: Column(
            children: [
              Text(
                'home.fleet.title'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFB8942E)],
                ).createShader(bounds),
                child: Text(
                  'home.fleet.headline'.tr(),
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: isMobile ? 200 : 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Container(
                      width: isMobile ? 280 : 380,
                      margin: EdgeInsets.only(right: index < posts.length - 1 ? 20 : 0),
                      child: _BlogCard(post: post),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.post});

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
        borderColor: const Color(0xFFD4AF37).withOpacity(0.2),
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
            Expanded(
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
                    top: 12,
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
                          fontSize: 10,
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
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglish ? (title.isEmpty ? '-' : title).toUpperCase() : (title.isEmpty ? '-' : title),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
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
