import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

class DashboardAnalytics {
  DashboardAnalytics({
    required this.period,
    required this.summary,
    required this.statusBreakdown,
    required this.evidenceStats,
    required this.anonymityStats,
    required this.locationFrequency,
    required this.incidentTypeDistribution,
    required this.dailyCreated,
    required this.dailyResolved,
    required this.weeklyCreated,
    required this.weeklyResolved,
    required this.noData,
  });

  final String period;
  final DashboardSummary summary;
  final Map<String, int> statusBreakdown;
  final EvidenceStats evidenceStats;
  final AnonymityStats anonymityStats;
  final List<FrequencyEntry> locationFrequency;
  final List<TypeDistributionEntry> incidentTypeDistribution;
  final List<TimeBucket> dailyCreated;
  final List<TimeBucket> dailyResolved;
  final List<TimeBucket> weeklyCreated;
  final List<TimeBucket> weeklyResolved;
  final bool noData;

  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    final summary = DashboardSummary.fromJson(
      Map<String, dynamic>.from(json['summary'] ?? const {}),
    );
    final statusMap = <String, int>{};
    final rawStatus = json['status_breakdown'];
    if (rawStatus is Map) {
      rawStatus.forEach((key, value) {
        if (value is num) statusMap['$key'] = value.toInt();
      });
    }
    final evidence = EvidenceStats.fromJson(
      Map<String, dynamic>.from(json['evidence_stats'] ?? const {}),
    );
    final anonymity = AnonymityStats.fromJson(
      Map<String, dynamic>.from(json['anonymity_stats'] ?? const {}),
    );

    List<FrequencyEntry> parseFrequency(List<dynamic>? raw) {
      if (raw == null) return const [];
      return raw
          .whereType<Map>()
          .map((item) => FrequencyEntry.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    List<TypeDistributionEntry> parseTypes(List<dynamic>? raw) {
      if (raw == null) return const [];
      return raw
          .whereType<Map>()
          .map((item) => TypeDistributionEntry.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    List<TimeBucket> parseBuckets(List<dynamic>? raw) {
      if (raw == null) return const [];
      return raw
          .whereType<Map>()
          .map((item) => TimeBucket.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    final trends = json['trends'] is Map ? Map<String, dynamic>.from(json['trends']) : const {};
    final daily = trends['daily'] is Map ? Map<String, dynamic>.from(trends['daily']) : const {};
    final weekly = trends['weekly'] is Map ? Map<String, dynamic>.from(trends['weekly']) : const {};

    return DashboardAnalytics(
      period: (json['period'] ?? 'week').toString(),
      summary: summary,
      statusBreakdown: statusMap,
      evidenceStats: evidence,
      anonymityStats: anonymity,
      locationFrequency: parseFrequency(json['frequency_by_location'] as List<dynamic>?),
      incidentTypeDistribution: parseTypes(json['incident_type_distribution'] as List<dynamic>?),
      dailyCreated: parseBuckets(daily['created'] as List<dynamic>?),
      dailyResolved: parseBuckets(daily['resolved'] as List<dynamic>?),
      weeklyCreated: parseBuckets(weekly['created'] as List<dynamic>?),
      weeklyResolved: parseBuckets(weekly['resolved'] as List<dynamic>?),
      noData: json['no_data'] == true,
    );
  }
}

class DashboardSummary {
  DashboardSummary({
    required this.totalIncidents,
    required this.backlog,
    required this.resolved,
    required this.resolutionRate,
    required this.withEvidence,
    required this.anonymousReports,
    required this.averageResolutionHours,
  });

  final int totalIncidents;
  final int backlog;
  final int resolved;
  final double resolutionRate;
  final int withEvidence;
  final int anonymousReports;
  final double? averageResolutionHours;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    double? parseNullableNum(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return DashboardSummary(
      totalIncidents: (json['total_incidents'] as num?)?.toInt() ?? 0,
      backlog: (json['backlog'] as num?)?.toInt() ?? 0,
      resolved: (json['resolved'] as num?)?.toInt() ?? 0,
      resolutionRate: parseNullableNum(json['resolution_rate']) ?? 0,
      withEvidence: (json['with_evidence'] as num?)?.toInt() ?? 0,
      anonymousReports: (json['anonymous_reports'] as num?)?.toInt() ?? 0,
      averageResolutionHours: parseNullableNum(json['average_resolution_hours']),
    );
  }
}

class EvidenceStats {
  EvidenceStats({
    required this.withEvidence,
    required this.withoutEvidence,
    required this.withEvidencePct,
  });

  final int withEvidence;
  final int withoutEvidence;
  final double withEvidencePct;

  factory EvidenceStats.fromJson(Map<String, dynamic> json) {
    double parsePct(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed ?? 0;
      }
      return 0;
    }

    return EvidenceStats(
      withEvidence: (json['with_evidence'] as num?)?.toInt() ?? 0,
      withoutEvidence: (json['without_evidence'] as num?)?.toInt() ?? 0,
      withEvidencePct: parsePct(json['with_evidence_pct']),
    );
  }
}

class AnonymityStats {
  AnonymityStats({
    required this.anonymous,
    required this.identified,
    required this.anonymousPct,
  });

  final int anonymous;
  final int identified;
  final double anonymousPct;

  factory AnonymityStats.fromJson(Map<String, dynamic> json) {
    double parsePct(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed ?? 0;
      }
      return 0;
    }

    return AnonymityStats(
      anonymous: (json['anonymous'] as num?)?.toInt() ?? 0,
      identified: (json['identified'] as num?)?.toInt() ?? 0,
      anonymousPct: parsePct(json['anonymous_pct']),
    );
  }
}

class FrequencyEntry {
  FrequencyEntry({required this.label, required this.count});

  final String label;
  final int count;

  factory FrequencyEntry.fromJson(Map<String, dynamic> json) {
    return FrequencyEntry(
      label: (json['location'] ?? '') as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class TypeDistributionEntry {
  TypeDistributionEntry({
    required this.incidentType,
    required this.count,
    required this.percentage,
  });

  final String incidentType;
  final int count;
  final double percentage;

  factory TypeDistributionEntry.fromJson(Map<String, dynamic> json) {
    double parsePct(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed ?? 0;
      }
      return 0;
    }

    return TypeDistributionEntry(
      incidentType: (json['incident_type'] ?? '') as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
      percentage: parsePct(json['percentage']),
    );
  }
}

class TimeBucket {
  TimeBucket({required this.bucketStart, required this.count});

  final DateTime bucketStart;
  final int count;

  factory TimeBucket.fromJson(Map<String, dynamic> json) {
    final raw = json['bucket_start'];
    DateTime? parsed;
    if (raw is String) {
      parsed = DateTime.tryParse(raw);
    }
    parsed ??= DateTime.fromMillisecondsSinceEpoch(0);
    return TimeBucket(
      bucketStart: parsed,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class DashboardRepository {
  DashboardRepository({
    required this.apiClient,
    required this.session,
    required this.auth,
  });

  final ApiClient apiClient;
  final SessionService session;
  final AuthHeaderProvider auth;

  Future<DashboardAnalytics> fetchAnalytics({String period = 'week', String? incidentType}) async {
    final headers = await auth.buildHeaders(asGuest: false);

    final query = <String, String>{'period': period};
    if (incidentType != null && incidentType.isNotEmpty) {
      query['incident_type'] = incidentType;
    }
    final qs = query.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    final path = qs.isEmpty ? '/api/bullying/analytics/' : '/api/bullying/analytics/?$qs';

    final response = await apiClient.get<DashboardAnalytics>(
      path,
      headers: headers,
      transform: (raw) {
        if (raw is! Map) {
          throw ApiException(
            message: 'Unexpected analytics payload',
            code: 500,
          );
        }
        return DashboardAnalytics.fromJson(Map<String, dynamic>.from(raw));
      },
    );
    return response.data;
  }
}

