import 'package:hive/hive.dart';

class CacheService {
  static const String _videoCacheBox = 'video_cache';
  static const String _userCacheBox = 'user_cache';
  static const String _courseCacheBox = 'course_cache';
  
  static late Box<Map> _videoBox;
  static late Box<Map> _userBox;
  static late Box<Map> _courseBox;
  
  static Future<void> initialize() async {
    _videoBox = await Hive.openBox<Map>(_videoCacheBox);
    _userBox = await Hive.openBox<Map>(_userCacheBox);
    _courseBox = await Hive.openBox<Map>(_courseCacheBox);
  }
  
  // Video Cache
  static Future<void> cacheVideoMetadata(String videoId, Map<String, dynamic> metadata) async {
    await _videoBox.put(videoId, metadata as Map);
  }
  
  static Map? getVideoMetadata(String videoId) {
    return _videoBox.get(videoId);
  }
  
  static bool isVideoCached(String videoId) {
    return _videoBox.containsKey(videoId);
  }
  
  // User Cache
  static Future<void> cacheUserProfile(Map<String, dynamic> profile) async {
    await _userBox.put('profile', profile as Map);
  }
  
  static Map? getUserProfile() {
    return _userBox.get('profile');
  }
  
  // Course Cache
  static Future<void> cacheCourseData(String courseId, Map<String, dynamic> courseData) async {
    await _courseBox.put(courseId, courseData as Map);
  }
  
  static Map? getCourseData(String courseId) {
    return _courseBox.get(courseId);
  }
  
  static Future<void> clearAll() async {
    await _videoBox.clear();
    await _userBox.clear();
    await _courseBox.clear();
  }
}
