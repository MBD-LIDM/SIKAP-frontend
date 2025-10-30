// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/features/screening/data/repositories/screening_repository.dart';

class StudentSurveyController {
  final ScreeningRepository repo;
  final BuildContext context;

  StudentSurveyController({required this.repo, required this.context});

  static StudentSurveyController withDefaults(BuildContext context) {
    final api = ApiClient();
    final auth = AuthHeaderProvider(
      loadUserToken: () async => null, // TODO: hook real token loader
      loadGuestToken: () async => null, // TODO: hook real guest token loader
    );
    final repo = ScreeningRepository(apiClient: api, auth: auth);
    return StudentSurveyController(repo: repo, context: context);
  }

  Future<void> submit(Map<String, dynamic> data, {bool asGuest = true}) async {
    try {
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI submitStudentSurvey called, dataKeys=${data.keys.toList()}');

      final resp = await repo.submitStudentSurvey(data, asGuest: asGuest);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey berhasil dikirim')),
      );
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI submitStudentSurvey success, responseKeys=${resp.data?.keys.toList()}');
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI submitStudentSurvey ApiException: ${e.message}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim survey: $e')),
      );
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI submitStudentSurvey ERROR: $e');
    }
  }

  Future<List<dynamic>> loadMySurveys({bool asGuest = false}) async {
    try {
      final resp = await repo.getMySurveys(asGuest: asGuest);
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI loadMySurveys loaded=${resp.data?.length ?? 0}');
      return resp.data ?? [];
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI loadMySurveys ApiException: ${e.message}');
      return [];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat riwayat: $e')),
      );
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI loadMySurveys ERROR: $e');
      return [];
    }
  }

  Future<List<dynamic>> loadTeacherSurveys({bool asGuest = false}) async {
    try {
      final resp = await repo.getTeacherSurveys(asGuest: asGuest);
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI loadTeacherSurveys loaded=${resp.data?.length ?? 0}');
      return resp.data ?? [];
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI loadTeacherSurveys ApiException: ${e.message}');
      return [];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat daftar: $e')),
      );
      // [DEBUG]
      // ignore: avoid_print
      print('[DEBUG] UI loadTeacherSurveys ERROR: $e');
      return [];
    }
  }
}
