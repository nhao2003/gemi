import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:gemi/core/errors/failure.dart';
import 'package:gemi/data/data_source/local/local_data_storage/local_data_storage.dart';
import '../../domain/repositories/data_storage_repository.dart';
import '../data_source/remote/remote_data_storage/remote_data_storage.dart';

class DataStorageRepositoryImpl implements DataStorageRepository {
  final LocalDataStorage _localDataStorage;
  final RemoteDataStorage _remoteDataStorage;

  DataStorageRepositoryImpl(this._localDataStorage, this._remoteDataStorage);

  @override
  Future<Either<Failure, String>> uploadBinary({
    required Uint8List fileBytes,
    required String path,
    required String bucketName,
    bool cacheFile = false,
  }) async {
    try {
      final result = await _remoteDataStorage.uploadBinary(
          fileBytes: fileBytes, path: path, bucketName: bucketName);
      if (!cacheFile) {
        _localDataStorage
            .putFile(fileBytes, result)
            .catchError((e) => print(e));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile({
    required File file,
    required String path,
    required String bucketName,
    bool cacheFile = false,
  }) async {
    try {
      final result = await _remoteDataStorage.uploadFile(
          file: file, path: path, bucketName: bucketName);
      if (!cacheFile) {
        _localDataStorage
            .putFile(await file.readAsBytes(), result)
            .catchError((e) => print(e));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> emptyCache() async {
    try {
      await _localDataStorage.emptyCache();
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, File?>> getFileFromCache(String url) async {
    try {
      final result = await _localDataStorage.getFile(url);
      return Right(result?.file);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, File>> getSingleFile(String url) async {
    try {
      final result = await _localDataStorage.getSingleFile(url);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<File>>> getFiles(List<String> urls) async {
    try {
      final result = await Future.wait(urls.map((e) async {
        final file = await _localDataStorage.getSingleFile(e);
        return file;
      }).toList());
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadBinaries(
      {required List<Uint8List> fileBytes,
      required String path,
      required String bucketName,
      bool cacheFile = false}) {
    // TODO: implement uploadBinaries
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<String>>> uploadFiles(
      {required List<File> files,
      required String path,
      required String bucketName,
      bool cacheFile = false}) async {
    try {
      final result = await Future.wait(files.map((e) async {
        final res = await _remoteDataStorage.uploadFile(
            file: e, path: path, bucketName: bucketName);
        if (!cacheFile) {
          _localDataStorage
              .putFile(await e.readAsBytes(), res)
              .catchError((e) => print(e));
        }
        return res;
      }).toList());
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
