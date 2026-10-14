import 'package:flutter/material.dart';

void main() {
  runApp(const CampusVoteApp());
}

class CampusVoteApp extends StatelessWidget {
  const CampusVoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF17324D);
    const teal = Color(0xFF187C78);

    return MaterialApp(
      title: 'CampusVote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          primary: navy,
          secondary: teal,
          surface: const Color(0xFFF7F8FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FA),
          foregroundColor: navy,
          centerTitle: false,
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
        actions: const [
          _DemoBadge(),
          SizedBox(width: 20),
        ],
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
                        color: const Color(0xFF17324D),
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose a workspace to explore the first CampusVote app '
                  'prototype.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF5C6875),
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  'FEATURED ELECTION',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF66727E),
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
                        color: const Color(0xFF17324D),
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
                          builder: (_) => RoleLandingPage(role: role),
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
        actions: const [
          _DemoBadge(),
          SizedBox(width: 20),
        ],
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
                      color: const Color(0xFFE6F2F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: 76,
                      height: 76,
                      child: Icon(
                        role.icon,
                        size: 36,
                        color: const Color(0xFF187C78),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    role.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF17324D),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    role.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5C6875),
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

class _ElectionCard extends StatelessWidget {
  const _ElectionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFF17324D),
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
                    color: const Color(0xFFD2DDE6),
                  ),
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFF40566C), height: 1),
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
                  color: const Color(0xFFEAF1F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(role.icon, color: const Color(0xFF17324D)),
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
                            color: const Color(0xFF17324D),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF66727E),
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
                color: Color(0xFF687684),
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
        const Icon(Icons.how_to_vote_rounded, color: Color(0xFF187C78)),
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

class _DemoBadge extends StatelessWidget {
  const _DemoBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          'DEMO',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF17324D),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
        ),
      ),
    );
  }
}

class _ElectionStatus extends StatelessWidget {
  const _ElectionStatus();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFDBEEE8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          'UPCOMING',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF205B4D),
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
                color: const Color(0xFFD2DDE6),
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
