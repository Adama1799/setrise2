here// lib/features/stories/domain/usecases/get_feed_stories_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/story_entity.dart';
import '../repositories/story_repository.dart';

// ─── Get Feed Stories ───────────────────────────────────────────────────────

class GetFeedStoriesUseCase implements NoParamsUseCase<List<StoryEntity>> {
  final StoryRepository repository;
  const GetFeedStoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<StoryEntity>>> call() =>
      repository.getFeedStories();
}

// ─── Get User Stories ────────────────────────────────────────────────────────

class GetUserStoriesUseCase implements UseCase<List<StoryEntity>, IdParams> {
  final StoryRepository repository;
  const GetUserStoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<StoryEntity>>> call(IdParams params) =>
      repository.getUserStories(params.id);
}

// ─── Create Story ────────────────────────────────────────────────────────────

class CreateStoryParams {
  final String mediaPath;
  final StoryMediaType mediaType;

  const CreateStoryParams({
    required this.mediaPath,
    required this.mediaType,
  });
}

class CreateStoryUseCase implements UseCase<StoryEntity, CreateStoryParams> {
  final StoryRepository repository;
  const CreateStoryUseCase(this.repository);

  @override
  Future<Either<Failure, StoryEntity>> call(CreateStoryParams params) =>
      repository.createStory(
        mediaPath: params.mediaPath,
        mediaType: params.mediaType,
      );
}

// ─── Delete Story ────────────────────────────────────────────────────────────

class DeleteStoryUseCase implements UseCase<bool, IdParams> {
  final StoryRepository repository;
  const DeleteStoryUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IdParams params) =>
      repository.deleteStory(params.id);
}

// ─── View Story ───────────────────────────────────────────────────────────────

class ViewStoryUseCase implements UseCase<bool, IdParams> {
  final StoryRepository repository;
  const ViewStoryUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IdParams params) =>
      repository.viewStory(params.id);
}
