import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HeroCacheManager {
  static const String key = 'hero_images_cache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 1000,
    ),
  );
}
