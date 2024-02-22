import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LocalDataStorage {
  final CacheManager _cacheManager;
  LocalDataStorage(this._cacheManager);

  ///Get the file from the cache and/or online, depending on availability and age. Downloaded form [url], [headers] can be used for example for authentication. When a file is cached and up to date it is return directly, when the cached file is too old the file is downloaded and returned after download. When a cached file is not available the newly downloaded file is returned.
  Future<File> getSingleFile(
    String url, {
    String? key,
    Map<String, String>? headers,
  }) async {
    try {
      final file =
          await _cacheManager.getSingleFile(url, key: key, headers: headers);
      return file;
    } catch (e) {
      rethrow;
    }
  }

  ///Put a file in the cache with the given [url] and [fileBytes]. The file is stored in the cache and returned. When the file is already in the cache it is returned directly.
  Future<File> putFile(Uint8List fileBytes, String url) async {
    try {
      return await _cacheManager.putFile(url, fileBytes);
    } catch (e) {
      rethrow;
    }
  }

  ///Remove the file with the given [url] from the cache.
  Future<void> removeFile(String url) async {
    try {
      await _cacheManager.removeFile(url);
    } catch (e) {
      rethrow;
    }
  }

  ///Empty the cache.
  Future<void> emptyCache() async {
    try {
      await _cacheManager.emptyCache();
    } catch (e) {
      rethrow;
    }
  }

  // Get file from cache
  Future<FileInfo?> getFile(String url) async {
    try {
      return await _cacheManager.getFileFromCache(url);
    } catch (e) {
      rethrow;
    }
  }
}
