// lib/data/datasources/remote/live_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/live_stream_model.dart';

abstract class LiveRemoteDataSource {
  Future<List<LiveStreamModel>> getLiveStreams();
  Future<LiveStreamModel> getLiveStream(String streamId);
  Future<LiveStreamModel> startLiveStream(String title, String description);
  Future<void> endLiveStream(String streamId);
  Future<LiveStreamModel> likeLiveStream(String streamId);
  Future<LiveStreamModel> unlikeLiveStream(String streamId);
  Future<void> followLiveHost(String hostId);
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final ApiClient apiClient;

  LiveRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<LiveStreamModel>> getLiveStreams() async {
    try {
      final response = await apiClient.get(ApiEndpoints.liveEndpoint);
      return (response as List)
          .map((e) => LiveStreamModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LiveStreamModel> getLiveStream(String streamId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.liveEndpoint}/$streamId');
      return LiveStreamModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LiveStreamModel> startLiveStream(String title, String description) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.liveEndpoint}/start',
        {'title': title, 'description': description},
      );
      return LiveStreamModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> endLiveStream(String streamId) async {
    try {
      await apiClient.post('${ApiEndpoints.liveEndpoint}/$streamId/end', {});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LiveStreamModel> likeLiveStream(String streamId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.liveEndpoint}/$streamId/like',
        {},
      );
      return LiveStreamModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LiveStreamModel> unlikeLiveStream(String streamId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.liveEndpoint}/$streamId/unlike',
        {},
      );
      return LiveStreamModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> followLiveHost(String hostId) async {
    try {
      await apiClient.post('${ApiEndpoints.liveEndpoint}/host/$hostId/follow', {});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
