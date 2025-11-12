import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/post_entity.dart';

class PostItemCard extends StatelessWidget {
  final PostEntity post;

  final VoidCallback onLikeTap;

  const PostItemCard({super.key, required this.post, required this.onLikeTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),

      child: InkWell(
        onTap: onLikeTap,
        borderRadius: BorderRadius.circular(12.r),

        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    post.body,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[700],
                    ),
                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Spacer(),

              Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                color: post.isLiked ? Colors.red : Colors.grey,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
