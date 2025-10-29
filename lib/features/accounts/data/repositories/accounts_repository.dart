import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

import '../models/accounts_create_response.dart';
import '../models/accounts_detail_response.dart';
import '../models/accounts_list_response.dart';
import '../models/accounts_model.dart';

class AccountsRepository {
  final ApiClient apiClient;
  final AuthHeaderProvider auth;

  AccountsRepository({required this.apiClient, required this.auth});

  Future<AccountsCreateResponse> createAccount(
      Map<String, dynamic> data) async {
    final headers = await auth.build();
    final resp = await apiClient.post<Map<String, dynamic>>(
        '/api/accounts/register/', data,
        headers: headers, transform: (raw) => raw as Map<String, dynamic>);
    return AccountsCreateResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<AccountsDetailResponse> getAccountDetail(String id) async {
    final headers = await auth.build();
    final resp = await apiClient.get<Map<String, dynamic>>('/api/accounts/$id/',
        headers: headers, transform: (raw) => raw as Map<String, dynamic>);
    return AccountsDetailResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<AccountsListResponse> getAccountsList() async {
    final headers = await auth.build();
    final resp = await apiClient.get<List<dynamic>>('/api/accounts/',
        headers: headers, transform: (raw) => raw as List<dynamic>);
    return AccountsListResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<AccountsModel> updateAccount(
      String id, Map<String, dynamic> data) async {
    final headers = await auth.build();
    final resp = await apiClient.patch<Map<String, dynamic>>(
        '/api/accounts/$id/', data,
        headers: headers, transform: (raw) => raw as Map<String, dynamic>);
    return AccountsModel.fromJson(resp.data);
  }

  Future<bool> deleteAccount(String id) async {
    final headers = await auth.build();
    await apiClient.patch('/api/accounts/$id/delete/', {}, headers: headers);
    return true;
  }
}
