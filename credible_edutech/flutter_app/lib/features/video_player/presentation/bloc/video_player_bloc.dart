import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Events
abstract class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();

  @override
  List<Object?> get props => [];
}

class LoadVideoEvent extends VideoPlayerEvent {
  final String videoId;

  const LoadVideoEvent(this.videoId);

  @override
  List<Object?> get props => [videoId];
}

class GenerateAccessTokenEvent extends VideoPlayerEvent {
  final String fileId;

  const GenerateAccessTokenEvent(this.fileId);

  @override
  List<Object?> get props => [fileId];
}

// States
abstract class VideoPlayerState extends Equatable {
  const VideoPlayerState();

  @override
  List<Object?> get props => [];
}

class VideoPlayerInitial extends VideoPlayerState {
  const VideoPlayerInitial();
}

class VideoPlayerLoading extends VideoPlayerState {
  const VideoPlayerLoading();
}

class VideoPlayerLoaded extends VideoPlayerState {
  final String videoUrl;
  final String title;
  final String description;

  const VideoPlayerLoaded({
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [videoUrl, title, description];
}

class VideoPlayerError extends VideoPlayerState {
  final String message;

  const VideoPlayerError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  final SupabaseClient supabaseClient;
  static const String _mediaVaultUrl = 'https://media-vault.your-domain.com/proxy';

  VideoPlayerBloc({required this.supabaseClient}) : super(const VideoPlayerInitial()) {
    on<LoadVideoEvent>(_onLoadVideo);
    on<GenerateAccessTokenEvent>(_onGenerateAccessToken);
  }

  Future<void> _onLoadVideo(
    LoadVideoEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(const VideoPlayerLoading());
    try {
      final videoData = await supabaseClient
          .from('videos')
          .select('*')
          .eq('id', event.videoId)
          .single();

      final fileId = videoData['google_drive_file_id'];
      final jwt = supabaseClient.auth.currentSession?.accessToken;

      // Construct proxy URL for video streaming
      final videoUrl = '$_mediaVaultUrl?fileId=$fileId&jwt=$jwt';

      emit(VideoPlayerLoaded(
        videoUrl: videoUrl,
        title: videoData['title'] ?? '',
        description: videoData['description'] ?? '',
      ));
    } catch (e) {
      emit(VideoPlayerError('Failed to load video: $e'));
    }
  }

  Future<void> _onGenerateAccessToken(
    GenerateAccessTokenEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    try {
      final jwt = supabaseClient.auth.currentSession?.accessToken;
      // The token is embedded in the proxy URL
      print('Access token generated for file: ${event.fileId}');
    } catch (e) {
      emit(VideoPlayerError('Failed to generate access token: $e'));
    }
  }
}
