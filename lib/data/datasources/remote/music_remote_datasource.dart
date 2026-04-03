// lib/data/datasources/remote/music_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/music_track_model.dart';

abstract class MusicRemoteDataSource {
  Future<List<MusicTrackModel>> getTracks(int page);
  Future<List<MusicTrackModel>> getTrendingTracks();
  Future<MusicTrackModel> getTrack(String trackId);
  Future<List<MusicTrackModel>> searchTracks(String query);
  Future<List<MusicTrackModel>> getPlaylist(String playlistId);
  Future<MusicTrackModel> likeTrack(String trackId);
  Future<MusicTrackModel> unlikeTrack(String trackId);
  Future<List<MusicTrackModel>> getFavoriteTracks();
}

class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final ApiClient apiClient;

  MusicRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MusicTrackModel>> getTracks(int page) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.musicEndpoint}?page=$page&limit=${AppConstants.pageSize}',
      );
      return (response as List)
          .map((e) => MusicTrackModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MusicTrackModel>> getTrendingTracks() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.musicEndpoint}/trending');
      return (response as List)
          .map((e) => MusicTrackModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MusicTrackModel> getTrack(String trackId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.musicEndpoint}/$trackId');
      return MusicTrackModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MusicTrackModel>> searchTracks(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.musicEndpoint}/search?q=$query',
      );
      return (response as List)
          .map((e) => MusicTrackModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MusicTrackModel>> getPlaylist(String playlistId) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.musicEndpoint}/playlist/$playlistId',
      );
      return (response as List)
          .map((e) => MusicTrackModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MusicTrackModel> likeTrack(String trackId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.musicEndpoint}/$trackId/like',
        {},
      );
      return MusicTrackModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MusicTrackModel> unlikeTrack(String trackId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.musicEndpoint}/$trackId/unlike',
        {},
      );
      return MusicTrackModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MusicTrackModel>> getFavoriteTracks() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.musicEndpoint}/favorites');
      return (response as List)
          .map((e) => MusicTrackModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
