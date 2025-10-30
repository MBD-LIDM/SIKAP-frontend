import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import '../models/student_survey_submit_response.dart';
import '../models/student_survey_list_response.dart';

class ScreeningRepository {
  final ApiClient apiClient;
  final AuthHeaderProvider auth;

  ScreeningRepository({required this.apiClient, required this.auth});

  /// POST /api/screenings/student-surveys/
  /// Submit student survey data. Pass asGuest=true for guest submissions.
  Future<StudentSurveySubmitResponse> submitStudentSurvey(
    Map<String, dynamic> data, {
    bool asGuest = true,
  }) async {
    final headers = await auth.build(asGuest: asGuest);
    // [DEBUG]
    // ignore: avoid_print
    print('[DEBUG] submitStudentSurvey() payload=${data.keys.toList()} asGuest=$asGuest');

    final resp = await apiClient.post<Map<String, dynamic>>(
      '/api/screenings/student-surveys/',
      data,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
    );

    // [DEBUG]
    // ignore: avoid_print
    print('[DEBUG] submitStudentSurvey() response keys=${resp.data.keys.toList()}');

    return StudentSurveySubmitResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }

  /// GET /api/screenings/student-surveys/my/
  Future<StudentSurveyListResponse> getMySurveys({bool asGuest = false}) async {
    final headers = await auth.build(asGuest: asGuest);
    // [DEBUG]
    // ignore: avoid_print
    print('[DEBUG] getMySurveys() asGuest=$asGuest');

    final resp = await apiClient.get<List<dynamic>>(
      '/api/screenings/student-surveys/my/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );

    // [DEBUG]
    // ignore: avoid_print
    print('[DEBUG] getMySurveys() count=${resp.data.length}');

    return StudentSurveyListResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }

  /// GET /api/screenings/student-surveys/teacher/list/
  Future<StudentSurveyListResponse> getTeacherSurveys({bool asGuest = false}) async {
    final headers = await auth.build(asGuest: asGuest);
    // [DEBUG]
    // ignore: avoid_print
    print('[DEBUG] getTeacherSurveys() asGuest=$asGuest');

    final resp = await apiClient.get<List<dynamic>>(
      '/api/screenings/student-surveys/teacher/list/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );

    // [DEBUG]
    // ignore: avoid_print
    print('[DEBUG] getTeacherSurveys() count=${resp.data.length}');

    return StudentSurveyListResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }
}
