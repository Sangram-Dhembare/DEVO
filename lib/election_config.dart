import 'dart:convert';

import 'package:crypto/crypto.dart' show sha256;

enum ElectionMethod { plurality }

class ElectionConfig {
  ElectionConfig._({
    required this.electionId,
    required this.name,
    required List<ElectionPosition> positions,
    required this.rules,
    required this.votingWindow,
    required this.trustees,
    required this.voterRollRoot,
  }) : positions = List.unmodifiable(positions);

  final String electionId;
  final String name;
  final List<ElectionPosition> positions;
  final ElectionRules rules;
  final ElectionVotingWindow votingWindow;
  final ElectionTrustees trustees;
  final String voterRollRoot;

  factory ElectionConfig.decode(String source) {
    final decoded = jsonDecode(source);
    return ElectionConfig.fromJson(_object(decoded, 'election'));
  }

  factory ElectionConfig.fromJson(Map<String, Object?> json) {
    _rejectUnknownKeys(
      json,
      {
        'election_id',
        'name',
        'positions',
        'rules',
        'voting_window',
        'trustees',
        'voter_roll_root',
      },
      'election',
    );

    final rawPositions = _array(json['positions'], 'positions');
    if (rawPositions.isEmpty) {
      throw const FormatException('positions must contain at least one item.');
    }

    final positions = <ElectionPosition>[];
    final positionIds = <String>{};
    for (var index = 0; index < rawPositions.length; index++) {
      final position = ElectionPosition._fromJson(
        _object(rawPositions[index], 'positions[$index]'),
        'positions[$index]',
      );
      if (!positionIds.add(position.id)) {
        throw FormatException('positions[$index].id must be unique.');
      }
      positions.add(position);
    }

    final voterRollRoot = _requiredString(json, 'voter_roll_root', 'election');
    if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(voterRollRoot)) {
      throw const FormatException(
        'voter_roll_root must be a 64-character hexadecimal SHA-256 root.',
      );
    }

    return ElectionConfig._(
      electionId: _requiredString(json, 'election_id', 'election'),
      name: _requiredString(json, 'name', 'election'),
      positions: positions,
      rules: ElectionRules._fromJson(_object(json['rules'], 'rules')),
      votingWindow: ElectionVotingWindow._fromJson(
        _object(json['voting_window'], 'voting_window'),
      ),
      trustees:
          ElectionTrustees._fromJson(_object(json['trustees'], 'trustees')),
      voterRollRoot: voterRollRoot,
    );
  }

  Map<String, Object?> toJson() => {
        'election_id': electionId,
        'name': name,
        'positions': positions.map((position) => position.toJson()).toList(),
        'rules': rules.toJson(),
        'voting_window': votingWindow.toJson(),
        'trustees': trustees.toJson(),
        'voter_roll_root': voterRollRoot,
      };

  String get configHash =>
      sha256.convert(utf8.encode(jsonEncode(toJson()))).toString();
}

class ElectionPosition {
  ElectionPosition._({
    required this.id,
    required this.title,
    required this.seats,
    required this.eligibleVoters,
    required this.method,
    required List<ElectionCandidate> candidates,
  }) : candidates = List.unmodifiable(candidates);

  final String id;
  final String title;
  final int seats;
  final String eligibleVoters;
  final ElectionMethod method;
  final List<ElectionCandidate> candidates;

  factory ElectionPosition._fromJson(
    Map<String, Object?> json,
    String path,
  ) {
    _rejectUnknownKeys(
      json,
      {'id', 'title', 'seats', 'eligible_voters', 'method', 'candidates'},
      path,
    );

    final rawCandidates = _array(json['candidates'], '$path.candidates');
    if (rawCandidates.isEmpty) {
      throw FormatException('$path.candidates must contain at least one item.');
    }

    final candidates = <ElectionCandidate>[];
    final candidateCodes = <String>{};
    for (var index = 0; index < rawCandidates.length; index++) {
      final candidate = ElectionCandidate._fromJson(
        _object(rawCandidates[index], '$path.candidates[$index]'),
        '$path.candidates[$index]',
      );
      if (!candidateCodes.add(candidate.code)) {
        throw FormatException(
          '$path.candidates[$index].code must be unique within its position.',
        );
      }
      candidates.add(candidate);
    }

    final seats = _requiredInt(json, 'seats', path);
    if (seats < 1 || seats > candidates.length) {
      throw FormatException(
        '$path.seats must be between 1 and the number of candidates.',
      );
    }

    final methodValue = _requiredString(json, 'method', path);
    final method = switch (methodValue) {
      'plurality' => ElectionMethod.plurality,
      _ => throw FormatException(
          '$path.method "$methodValue" is not supported.',
        ),
    };

    return ElectionPosition._(
      id: _requiredString(json, 'id', path),
      title: _requiredString(json, 'title', path),
      seats: seats,
      eligibleVoters: _requiredString(json, 'eligible_voters', path),
      method: method,
      candidates: candidates,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'seats': seats,
        'eligible_voters': eligibleVoters,
        'method': method.name,
        'candidates':
            candidates.map((candidate) => candidate.toJson()).toList(),
      };
}

class ElectionCandidate {
  const ElectionCandidate._({required this.code, required this.name});

  final String code;
  final String name;

  factory ElectionCandidate._fromJson(
    Map<String, Object?> json,
    String path,
  ) {
    _rejectUnknownKeys(json, {'code', 'name'}, path);
    return ElectionCandidate._(
      code: _requiredString(json, 'code', path),
      name: _requiredString(json, 'name', path),
    );
  }

  Map<String, Object?> toJson() => {'code': code, 'name': name};
}

class ElectionRules {
  const ElectionRules._({
    required this.votesPerPosition,
    required this.abstainAllowed,
    required this.tieBreak,
    required this.revoteAllowed,
  });

  final int votesPerPosition;
  final bool abstainAllowed;
  final String tieBreak;
  final bool revoteAllowed;

  factory ElectionRules._fromJson(Map<String, Object?> json) {
    _rejectUnknownKeys(
      json,
      {
        'votes_per_position',
        'abstain_allowed',
        'tie_break',
        'revote_allowed',
      },
      'rules',
    );
    final votesPerPosition = _requiredInt(json, 'votes_per_position', 'rules');
    if (votesPerPosition != 1) {
      throw const FormatException(
        'rules.votes_per_position must be 1 for the supported ballot format.',
      );
    }
    return ElectionRules._(
      votesPerPosition: votesPerPosition,
      abstainAllowed: _requiredBool(json, 'abstain_allowed', 'rules'),
      tieBreak: _requiredString(json, 'tie_break', 'rules'),
      revoteAllowed: _requiredBool(json, 'revote_allowed', 'rules'),
    );
  }

  Map<String, Object?> toJson() => {
        'votes_per_position': votesPerPosition,
        'abstain_allowed': abstainAllowed,
        'tie_break': tieBreak,
        'revote_allowed': revoteAllowed,
      };
}

class ElectionVotingWindow {
  const ElectionVotingWindow._({
    required this.opensAt,
    required this.closesAt,
  });

  final String opensAt;
  final String closesAt;

  factory ElectionVotingWindow._fromJson(Map<String, Object?> json) {
    _rejectUnknownKeys(json, {'opens', 'closes'}, 'voting_window');
    final opensAt = _requiredString(json, 'opens', 'voting_window');
    final closesAt = _requiredString(json, 'closes', 'voting_window');
    final opens = _parseTimestamp(opensAt, 'voting_window.opens');
    final closes = _parseTimestamp(closesAt, 'voting_window.closes');
    if (!opens.isBefore(closes)) {
      throw const FormatException(
        'voting_window.opens must be earlier than voting_window.closes.',
      );
    }
    return ElectionVotingWindow._(opensAt: opensAt, closesAt: closesAt);
  }

  Map<String, Object?> toJson() => {'opens': opensAt, 'closes': closesAt};
}

class ElectionTrustees {
  const ElectionTrustees._({required this.total, required this.threshold});

  final int total;
  final int threshold;

  factory ElectionTrustees._fromJson(Map<String, Object?> json) {
    _rejectUnknownKeys(json, {'total', 'threshold'}, 'trustees');
    final total = _requiredInt(json, 'total', 'trustees');
    final threshold = _requiredInt(json, 'threshold', 'trustees');
    if (total < 1 || threshold < 1 || threshold > total) {
      throw const FormatException(
        'trustees must have total >= 1 and threshold between 1 and total.',
      );
    }
    return ElectionTrustees._(total: total, threshold: threshold);
  }

  Map<String, Object?> toJson() => {'total': total, 'threshold': threshold};
}

DateTime _parseTimestamp(String value, String path) {
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|[+-](?:0\d|1\d|2[0-3]):[0-5]\d)$',
  ).firstMatch(value);
  final parsed = DateTime.tryParse(value);
  if (match == null || parsed == null) {
    throw FormatException(
        '$path must be an ISO-8601 timestamp with a timezone.');
  }

  final components = [
    for (var index = 1; index <= 6; index++) int.parse(match.group(index)!),
  ];
  final calendarDate = DateTime.utc(
    components[0],
    components[1],
    components[2],
    components[3],
    components[4],
    components[5],
  );
  if (calendarDate.year != components[0] ||
      calendarDate.month != components[1] ||
      calendarDate.day != components[2] ||
      calendarDate.hour != components[3] ||
      calendarDate.minute != components[4] ||
      calendarDate.second != components[5]) {
    throw FormatException('$path is not a valid calendar timestamp.');
  }
  return parsed.toUtc();
}

void _rejectUnknownKeys(
  Map<String, Object?> json,
  Set<String> allowedKeys,
  String path,
) {
  final unknownKeys = json.keys.where((key) => !allowedKeys.contains(key));
  if (unknownKeys.isNotEmpty) {
    throw FormatException(
      '$path contains unsupported field(s): ${unknownKeys.join(', ')}.',
    );
  }
}

Map<String, Object?> _object(Object? value, String path) {
  if (value is! Map) {
    throw FormatException('$path must be a JSON object.');
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw FormatException('$path object keys must be strings.');
    }
    result[entry.key as String] = entry.value;
  }
  return result;
}

List<Object?> _array(Object? value, String path) {
  if (value is! List) {
    throw FormatException('$path must be a JSON array.');
  }
  return value;
}

String _requiredString(Map<String, Object?> json, String key, String path) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$path.$key must be a non-empty string.');
  }
  return value;
}

int _requiredInt(Map<String, Object?> json, String key, String path) {
  final value = json[key];
  if (value is! int) {
    throw FormatException('$path.$key must be an integer.');
  }
  return value;
}

bool _requiredBool(Map<String, Object?> json, String key, String path) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('$path.$key must be a boolean.');
  }
  return value;
}
