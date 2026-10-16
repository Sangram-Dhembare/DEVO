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
    expect(roundTrip.configHash, original.configHash);
  });

  test('rejects malformed voter-roll roots', () {
    final config = _validConfig()..['voter_roll_root'] = 'not-a-merkle-root';

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
