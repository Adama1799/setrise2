import 'package:dartz/dartz.dart';
import '../../../core/constants/api_endpoints.dart';  // ⬅️ أضف هذا
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../domain/entities/music/track_entity.dart';
import '../../../domain/entities/music/playlist_entity.dart';
import '../../models/music/track_model.dart';
import '../../models/music/playlist_model.dart';

abstract class MusicRemoteDataSource {
  Future<List<TrackEntity>> getTrendingTracks();
  Future<List<TrackEntity>> searchTracks(String query);
  Future<TrackEntity> getTrack(String trackId);
  Future<List<PlaylistEntity>> getUserPlaylists();
  Future<PlaylistEntity> getPlaylist(String playlistId);
  Future<void> likeTrack(String trackId);
  Future<void> unlikeTrack(String trackId);
  Future<List<TrackEntity>> getFavoriteTracks();
}

class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final DioClient apiClient;

  MusicRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TrackEntity>> getTrendingTracks() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.musicEndpoint}/trending');
      return (response.data as List)
          .map((track) => TrackModel.fromJson(track))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<TrackEntity>> searchTracks(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.musicEndpoint}/search',
        queryParameters: {'q': query},
      );
      return (response.data as List)
          .map((track) => TrackModel.fromJson(track))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TrackEntity> getTrack(String trackId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.musicEndpoint}/$trackId');
      return TrackModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PlaylistEntity>> getUserPlaylists() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.musicEndpoint}/playlists');
      return (response.data as List)
          .map((playlist) => PlaylistModel.fromJson(playlist))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PlaylistEntity> getPlaylist(String playlistId) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.musicEndpoint}/playlist/$playlistId',
      );
      return PlaylistModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> likeTrack(String trackId) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.musicEndpoint}/$trackId/like',
        data: {},
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> unlikeTrack(String trackId) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.musicEndpoint}/$trackId/unlike',
        data: {},
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<TrackEntity>> getFavoriteTracks() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.musicEndpoint}/favorites');
      return (response.data as List)
          .map((track) => TrackModel.fromJson(track))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
