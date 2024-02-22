import 'dart:io';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'remote_data_storage.dart';

class RemoteDataStorageImpl implements RemoteDataStorage {
  final SupabaseClient _supabaseClient;
  RemoteDataStorageImpl(this._supabaseClient);

  @override
  Future<String> uploadFile({
    required File file,
    required String path,
    required String bucketName,
  }) async {
    try {
      String finalPath = '$path/${file.path.split('/').last}';
      final res = await _supabaseClient.storage.from(bucketName).upload(
            finalPath,
            file,
          );
      String url =
          _supabaseClient.storage.from(bucketName).getPublicUrl(finalPath);
      return url;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadBinary({
    required String path,
    required String bucketName,
    required Uint8List fileBytes,
  }) async {
    try {
      final res = await _supabaseClient.storage.from(bucketName).uploadBinary(
            path,
            fileBytes,
          );
      String url = _supabaseClient.storage.from(bucketName).getPublicUrl(path);
      return url;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Uint8List> downloadFile({
    required String path,
    required String bucketName,
  }) async {
    try {
      final res = await _supabaseClient.storage.from(bucketName).download(path);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteFile({
    required String path,
    required String bucketName,
  }) async {
    try {
      await _supabaseClient.storage.from(bucketName).remove([path]);
    } catch (e) {
      rethrow;
    }
  }
}
