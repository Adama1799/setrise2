import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class for all use cases
/// 
/// [Type] - The return type of the use case
/// [Params] - The parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

/// Use case with stream return type
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Synchronous use case
abstract class SyncUseCase<Type, Params> {
  Either<Failure, Type> call(Params params);
}

/// No parameters class
class NoParams {
  const NoParams();
}

/// Pagination parameters
class PaginationParams {
  final int page;
  final int limit;
  final String? searchQuery;
  final Map<String, dynamic>? filters;

  const PaginationParams({
    this.page = 1,
    this.limit = 20,
    this.searchQuery,
    this.filters,
  });

  PaginationParams copyWith({
    int? page,
    int? limit,
    String? searchQuery,
    Map<String, dynamic>? filters,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      if (searchQuery != null) 'search': searchQuery,
      if (filters != null) ...filters!,
    };
  }
}

/// ID parameter
class IdParams {
  final String id;

  const IdParams(this.id);
}

/// List of IDs parameter
class IdsParams {
  final List<String> ids;

  const IdsParams(this.ids);
}

/// Upload file parameters
class UploadFileParams {
  final String filePath;
  final String? fileName;
  final Map<String, dynamic>? additionalData;

  const UploadFileParams({
    required this.filePath,
    this.fileName,
    this.additionalData,
  });
}

/// Search parameters
class SearchParams {
  final String query;
  final int page;
  final int limit;
  final List<String>? filters;
  final String? sortBy;
  final bool ascending;

  const SearchParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
    this.filters,
    this.sortBy,
    this.ascending = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'page': page,
      'limit': limit,
      if (filters != null) 'filters': filters,
      if (sortBy != null) 'sort_by': sortBy,
      'ascending': ascending,
    };
  }
}
