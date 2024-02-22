import 'dart:io';
import 'dart:typed_data';

abstract class RemoteDataStorage {
  Future<String> uploadFile({
    required File file,
    required String path,
    required String bucketName,
  });

  Future<String> uploadBinary({
    required String path,
    required String bucketName,
    required Uint8List fileBytes,
  });

  Future<Uint8List> downloadFile({
    required String path,
    required String bucketName,
  });

  Future<void> deleteFile({
    required String path,
    required String bucketName,
  });
}
