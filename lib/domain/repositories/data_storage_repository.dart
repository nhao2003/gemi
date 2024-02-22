import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:gemi/core/errors/failure.dart';

abstract class DataStorageRepository {
  Future<Either<Failure, String>> uploadFile({
    required File file,
    required String path,
    required String bucketName,
    bool cacheFile = false,
  });

  Future<Either<Failure, List<String>>> uploadFiles({
    required List<File> files,
    required String path,
    required String bucketName,
    bool cacheFile = false,
  });

  Future<Either<Failure, String>> uploadBinary({
    required Uint8List fileBytes,
    required String path,
    required String bucketName,
    bool cacheFile = false,
  });

  Future<Either<Failure, List<String>>> uploadBinaries({
    required List<Uint8List> fileBytes,
    required String path,
    required String bucketName,
    bool cacheFile = false,
  });

  Future<Either<Failure, void>> emptyCache();

  Future<Either<Failure, File>> getSingleFile(String url);
  Future<Either<Failure, List<File>>> getFiles(List<String> urls);
  Future<Either<Failure, File?>> getFileFromCache(String url);
}
