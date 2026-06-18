import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Events
abstract class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoursesEvent extends CoursesEvent {
  const LoadCoursesEvent();
}

class LoadCourseDetailsEvent extends CoursesEvent {
  final String courseId;

  const LoadCourseDetailsEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

// States
abstract class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {
  const CoursesInitial();
}

class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

class CoursesLoaded extends CoursesState {
  final List<Map<String, dynamic>> courses;

  const CoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class CourseDetailsLoaded extends CoursesState {
  final Map<String, dynamic> courseData;
  final List<Map<String, dynamic>> videos;

  const CourseDetailsLoaded({
    required this.courseData,
    required this.videos,
  });

  @override
  List<Object?> get props => [courseData, videos];
}

class CoursesError extends CoursesState {
  final String message;

  const CoursesError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final SupabaseClient supabaseClient;

  CoursesBloc({required this.supabaseClient}) : super(const CoursesInitial()) {
    on<LoadCoursesEvent>(_onLoadCourses);
    on<LoadCourseDetailsEvent>(_onLoadCourseDetails);
  }

  Future<void> _onLoadCourses(
    LoadCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(const CoursesLoading());
    try {
      final courses = await supabaseClient
          .from('courses')
          .select('*')
          .order('created_at', ascending: false);

      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CoursesError('Failed to load courses: $e'));
    }
  }

  Future<void> _onLoadCourseDetails(
    LoadCourseDetailsEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(const CoursesLoading());
    try {
      final courseData = await supabaseClient
          .from('courses')
          .select('*')
          .eq('id', event.courseId)
          .single();

      final videos = await supabaseClient
          .from('videos')
          .select('*')
          .eq('course_id', event.courseId)
          .order('sequence', ascending: true);

      emit(CourseDetailsLoaded(
        courseData: courseData,
        videos: videos,
      ));
    } catch (e) {
      emit(CoursesError('Failed to load course details: $e'));
    }
  }
}
