import 'dart:convert';

import 'package:campusvote_app/election_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses and hashes a valid election configuration', () {
    final config = ElectionConfig.fromJson(_validConfig());

    expect(config.electionId, 'euc-council-2026');
    expect(config.positions, hasLength(1));
    expect(config.positions.single.method, ElectionMethod.plurality);
    expect(config.positions.single.candidates, hasLength(2));
    expect(config.trustees.total, 5);
    expect(config.trustees.threshold, 3);
    expect(
      config.configHash,
      '821605bdc7ae3cbfa16600c5d9a6e1c00d6f6cc90cec43614bd809f0ecadf48e',
    );
  });

  test('round-trips to canonical JSON with a stable configuration hash', () {
    final original = ElectionConfig.fromJson(_validConfig());
    final roundTrip = ElectionConfig.decode(jsonEncode(original.toJson()));

    expect(roundTrip.toJson(), original.toJson());
    expect(roundTrip.canonicalJson, original.canonicalJson);
    expect(roundTrip.configHash, original.configHash);
  });

  test('canonicalizes object key order and insignificant JSON whitespace', () {
    final original = ElectionConfig.fromJson(_validConfig());
    final reordered = ElectionConfig.fromJson(_reverseKeys(_validConfig()));
    final spaced = ElectionConfig.decode(
      ' \n${jsonEncode(_validConfig()).replaceAll(',', ', ')}\t ',
    );

    expect(reordered.canonicalJson, original.canonicalJson);
    expect(spaced.canonicalJson, original.canonicalJson);
    expect(reordered.configHash, original.configHash);
    expect(spaced.configHash, original.configHash);
  });

  test('valid field changes produce different configuration digests', () {
    final originalHash = ElectionConfig.fromJson(_validConfig()).configHash;
    final changes = <void Function(Map<String, Object?>)>[
      (json) {
        json['election_id'] = 'euc-council-2027';
      },
      (json) {
        json['name'] = 'Changed election name';
      },
      (json) {
        _changePosition(json, 'id', 'VP');
      },
      (json) {
        _changePosition(json, 'title', 'Vice President');
      },
      (json) {
        _changePosition(json, 'seats', 2);
      },
      (json) {
        _changePosition(json, 'eligible_voters', 'undergraduates');
      },
      (json) {
        _changeCandidate(json, 0, 'code', 'PRES-03');
      },
      (json) {
        _changeCandidate(json, 0, 'name', 'Changed candidate');
      },
      (json) {
        _changeRule(json, 'abstain_allowed', false);
      },
      (json) {
        _changeRule(json, 'tie_break', 'another tie-break rule');
      },
      (json) {
        _changeRule(json, 'revote_allowed', true);
      },
      (json) {
        _changeWindow(json, 'opens', '2026-11-05T10:00:00+05:30');
      },
      (json) {
        _changeWindow(json, 'closes', '2026-11-05T18:00:00+05:30');
      },
      (json) {
        _changeTrustee(json, 'total', 6);
      },
      (json) {
        _changeTrustee(json, 'threshold', 2);
      },
      (json) {
        json['voter_roll_root'] = List.filled(64, 'b').join();
      },
    ];

    for (final change in changes) {
      final changed = _copyConfig();
      change(changed);
      expect(ElectionConfig.fromJson(changed).configHash, isNot(originalHash));
    }
  });

  test('rejects malformed voter-roll roots', () {
    final config = _validConfig()..['voter_roll_root'] = 'not-a-merkle-root';

    expect(
      () => ElectionConfig.fromJson(config),
      throwsFormatException,
    );
  });

  test('rejects non-integer values for integer fields', () {
    final config = _validConfig();
    final position = config['positions']! as List<Object?>;
    (position.single! as Map<String, Object?>)['seats'] = 1.0;

    expect(
      () => ElectionConfig.fromJson(config),
      throwsFormatException,
    );
  });

  test('rejects duplicate position identifiers', () {
    final config = _validConfig();
    final positions = config['positions']! as List<Object?>;
    positions.add(Map<String, Object?>.from(positions.single! as Map));

    expect(
      () => ElectionConfig.fromJson(config),
      throwsFormatException,
    );
  });

  test('rejects unsupported fields rather than omitting them from the hash',
      () {
    final config = _validConfig()..['unexpected'] = true;

    expect(
      () => ElectionConfig.fromJson(config),
      throwsFormatException,
    );
  });

  test('rejects an invalid or reversed timezone-aware voting window', () {
    final config = _validConfig();
    config['voting_window'] = <String, Object?>{
      'opens': '2026-02-30T09:00:00+05:30',
      'closes': '2026-11-05T17:00:00+05:30',
    };

    expect(
      () => ElectionConfig.fromJson(config),
      throwsFormatException,
    );

    (config['voting_window']! as Map<String, Object?>)
      ..['opens'] = '2026-11-05T17:00:00+05:30'
      ..['closes'] = '2026-11-05T09:00:00+05:30';
    expect(
      () => ElectionConfig.fromJson(config),
      throwsFormatException,
    );
  });

  test('rejects trustee thresholds outside the trustee count', () {
    final config = _validConfig();
    config['trustees'] = <String, Object?>{'total': 5, 'threshold': 6};

    expect(
      () => ElectionConfig.fromJson(config),
      throwsFormatException,
    );
  });
}

Map<String, Object?> _validConfig() => {
      'election_id': 'euc-council-2026',
      'name': 'Example University Student Council 2026',
      'positions': <Object?>[
        <String, Object?>{
          'id': 'PRES',
          'title': 'President',
          'seats': 1,
          'eligible_voters': 'all',
          'method': 'plurality',
          'candidates': <Object?>[
            <String, Object?>{'code': 'PRES-01', 'name': 'Aarav Sharma'},
            <String, Object?>{'code': 'PRES-02', 'name': 'Meera Iyer'},
          ],
        },
      ],
      'rules': <String, Object?>{
        'votes_per_position': 1,
        'abstain_allowed': true,
        'tie_break': 're-vote between tied candidates',
        'revote_allowed': false,
      },
      'voting_window': <String, Object?>{
        'opens': '2026-11-05T09:00:00+05:30',
        'closes': '2026-11-05T17:00:00+05:30',
      },
      'trustees': <String, Object?>{'total': 5, 'threshold': 3},
      'voter_roll_root': List.filled(64, 'a').join(),
    };

Map<String, Object?> _copyConfig() =>
    jsonDecode(jsonEncode(_validConfig())) as Map<String, Object?>;

Map<String, Object?> _reverseKeys(Map<String, Object?> object) {
  final reversed = <String, Object?>{};
  for (final entry in object.entries.toList().reversed) {
    final value = entry.value;
    if (value is Map<String, Object?>) {
      reversed[entry.key] = _reverseKeys(value);
    } else if (value is List<Object?>) {
      reversed[entry.key] = value
          .map((item) =>
              item is Map<String, Object?> ? _reverseKeys(item) : item)
          .toList();
    } else {
      reversed[entry.key] = value;
    }
  }
  return reversed;
}

void _changePosition(Map<String, Object?> config, String key, Object? value) {
  final positions = config['positions']! as List<Object?>;
  (positions.first! as Map<String, Object?>)[key] = value;
}

void _changeCandidate(
  Map<String, Object?> config,
  int index,
  String key,
  Object? value,
) {
  final positions = config['positions']! as List<Object?>;
  final position = positions.first! as Map<String, Object?>;
  final candidates = position['candidates']! as List<Object?>;
  (candidates[index]! as Map<String, Object?>)[key] = value;
}

void _changeRule(Map<String, Object?> config, String key, Object? value) {
  (config['rules']! as Map<String, Object?>)[key] = value;
}

void _changeWindow(Map<String, Object?> config, String key, Object? value) {
  (config['voting_window']! as Map<String, Object?>)[key] = value;
}

void _changeTrustee(Map<String, Object?> config, String key, Object? value) {
  (config['trustees']! as Map<String, Object?>)[key] = value;
}
