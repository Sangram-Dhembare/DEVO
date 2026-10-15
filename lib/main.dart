import 'package:flutter/material.dart';

class _AppColors {
  static const primary = Color(0xFF007AFF);
  static const secondary = Color(0xFF34C759);
  static const background = Color(0xFFF2F2F7);
  static const surface = Color(0xFFFFFFFF);
  static const label = Color(0xFF1C1C1E);
  static const secondaryLabel = Color(0xFF636366);
  static const tertiaryLabel = Color(0xFF8E8E93);
  static const separator = Color(0xFFD1D1D6);
  static const navy = Color(0xFF1C3557);
}

void main() {
  runApp(const CampusVoteApp());
}

class CampusVoteApp extends StatelessWidget {
  const CampusVoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusVote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: _AppColors.primary,
          secondary: _AppColors.secondary,
          surface: _AppColors.surface,
          onSurface: _AppColors.label,
        ),
        scaffoldBackgroundColor: _AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: _AppColors.background,
          foregroundColor: _AppColors.label,
          centerTitle: false,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: _AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _AppColors.separator, width: 0.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
      home: const RoleLauncherPage(),
    );
  }
}

class RoleLauncherPage extends StatelessWidget {
  const RoleLauncherPage({super.key});

  static const roles = <_AppRole>[
    _AppRole(
      title: 'Admin dashboard',
      description: 'Set up elections and prepare the voter roll.',
      icon: Icons.fact_check_outlined,
    ),
    _AppRole(
      title: 'Check-in desk',
      description: 'Verify a voter and begin the anonymous token flow.',
      icon: Icons.badge_outlined,
    ),
    _AppRole(
      title: 'Voting terminal',
      description: 'Guide a voter through a supervised ballot.',
      icon: Icons.how_to_vote_outlined,
    ),
    _AppRole(
      title: 'Trustee tool',
      description: 'Prepare for the offline key ceremony and tally.',
      icon: Icons.key_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _Brand(),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                Text(
                  'A clearer way to run campus elections.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: _AppColors.label,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose a workspace to explore the first CampusVote app '
                  'prototype.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _AppColors.secondaryLabel,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  'FEATURED ELECTION',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _AppColors.tertiaryLabel,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                ),
                const SizedBox(height: 10),
                const _ElectionCard(),
                const SizedBox(height: 28),
                Text(
                  'Workspaces',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _AppColors.label,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                for (final role in roles) ...[
                  _RoleCard(
                    role: role,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => role.title == 'Voting terminal'
                              ? const _VotingTerminalPage()
                              : RoleLandingPage(role: role),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 4),
                const _PrototypeNotice(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleLandingPage extends StatelessWidget {
  const RoleLandingPage({required this.role, super.key});

  final _AppRole role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(role.title),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8ED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: 76,
                      height: 76,
                      child: Icon(
                        role.icon,
                        size: 36,
                        color: _AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    role.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _AppColors.label,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    role.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _AppColors.secondaryLabel,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24),
                  const _PrototypeNotice(),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to workspaces'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VotingTerminalPage extends StatefulWidget {
  const _VotingTerminalPage();

  @override
  State<_VotingTerminalPage> createState() => _VotingTerminalPageState();
}

class _VotingTerminalPageState extends State<_VotingTerminalPage> {
  static const _presidentCandidates = [
    ('Avery Chen', 'Independent'),
    ('Jordan Patel', 'Campus Forward'),
    ('Morgan Rivera', 'Students First'),
    ('Taylor Brooks', 'Independent'),
  ];

  static const _vicePresidentCandidates = [
    ('Riley Kim', 'Campus Forward'),
    ('Casey Morgan', 'Students First'),
    ('Quinn Davis', 'Independent'),
    ('Jamie Singh', 'Campus Forward'),
  ];

  String? _presidentSelection;
  String? _vicePresidentSelection;

  @override
  Widget build(BuildContext context) {
    final selectedCount = [
      _presidentSelection,
      _vicePresidentSelection,
    ].where((selection) => selection != null).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Voting terminal')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                Text(
                  'Student Council 2026',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: _AppColors.label,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Example University · 2 positions',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _AppColors.secondaryLabel,
                      ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(value: selectedCount / 2),
                const SizedBox(height: 8),
                Text(
                  '$selectedCount of 2 positions selected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _AppColors.secondaryLabel,
                      ),
                ),
                const SizedBox(height: 24),
                _BallotPosition(
                  title: 'President',
                  candidates: _presidentCandidates,
                  groupValue: _presidentSelection,
                  onChanged: (candidate) {
                    setState(() => _presidentSelection = candidate);
                  },
                ),
                const SizedBox(height: 20),
                _BallotPosition(
                  title: 'Vice President',
                  candidates: _vicePresidentCandidates,
                  groupValue: _vicePresidentSelection,
                  onChanged: (candidate) {
                    setState(() => _vicePresidentSelection = candidate);
                  },
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: selectedCount == 2 ? _showReview : null,
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Review ballot'),
                ),
                const SizedBox(height: 16),
                const _PrototypeNotice(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReview() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review your selections'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReviewSelection(
              position: 'President',
              candidate: _presidentSelection!,
            ),
            const SizedBox(height: 12),
            _ReviewSelection(
              position: 'Vice President',
              candidate: _vicePresidentSelection!,
            ),
            const SizedBox(height: 20),
            const Text(
              'Prototype only. These selections are not submitted or saved.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back to ballot'),
          ),
        ],
      ),
    );
  }
}

class _BallotPosition extends StatelessWidget {
  const _BallotPosition({
    required this.title,
    required this.candidates,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final List<(String, String)> candidates;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _AppColors.label,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select one candidate',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _AppColors.secondaryLabel,
              ),
        ),
        const SizedBox(height: 10),
        for (final (name, affiliation) in candidates) ...[
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.antiAlias,
            child: RadioListTile<String>(
              value: name,
              groupValue: groupValue,
              onChanged: onChanged,
              title: Text(name),
              subtitle: Text('$affiliation · Example candidate'),
              activeColor: _AppColors.primary,
            ),
          ),
        ],
      ],
    );
  }
}

class _ReviewSelection extends StatelessWidget {
  const _ReviewSelection({
    required this.position,
    required this.candidate,
  });

  final String position;
  final String candidate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          position,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _AppColors.tertiaryLabel,
              ),
        ),
        Text(
          candidate,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _AppColors.label,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _ElectionCard extends StatelessWidget {
  const _ElectionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: _AppColors.navy,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_outlined, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Example University',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const _ElectionStatus(),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Student Council 2026',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Polling · 5 Nov 2026 · 09:00–17:00',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFE5EAF1),
                  ),
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFF40536B), height: 1),
            const SizedBox(height: 14),
            const Wrap(
              spacing: 22,
              runSpacing: 10,
              children: [
                _ElectionDetail(value: '2', label: 'positions'),
                _ElectionDetail(value: '8', label: 'candidates'),
                _ElectionDetail(value: '3 of 5', label: 'trustees needed'),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF40536B), height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.hub_outlined,
                  size: 18,
                  color: Color(0xFFD7C4FF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ethereum integration',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sepolia testnet · proof of concept',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFE5EAF1),
                            ),
                      ),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E3159),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      'PLANNED',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFE0D2FF),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role, required this.onTap});

  final _AppRole role;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(role.icon, color: _AppColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _AppColors.label,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _AppColors.secondaryLabel,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: _AppColors.tertiaryLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrototypeNotice extends StatelessWidget {
  const _PrototypeNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2D79E)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Color(0xFF805B14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Prototype only. No sign-in, ballot submission, or election '
              'security features are connected.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF624A1D),
                    height: 1.45,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.how_to_vote_rounded, color: _AppColors.primary),
        const SizedBox(width: 8),
        Text(
          'CampusVote',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _ElectionStatus extends StatelessWidget {
  const _ElectionStatus();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          'UPCOMING',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF248A3D),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
        ),
      ),
    );
  }
}

class _ElectionDetail extends StatelessWidget {
  const _ElectionDetail({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFE5EAF1),
              ),
        ),
      ],
    );
  }
}

class _AppRole {
  const _AppRole({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
