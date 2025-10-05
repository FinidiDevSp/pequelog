import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// First-run onboarding experience that introduces the PequeLog brand.
class OnboardingPage extends StatelessWidget {
  /// Creates an onboarding screen that displays branding and the primary CTA.
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortestSide = constraints.biggest.shortestSide;
            final logoSize = shortestSide.isFinite && shortestSide > 0
                ? shortestSide * 0.35
                : 160.0;
            final resolvedLogoSize = logoSize.clamp(120.0, 220.0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Semantics(
                  label: l10n.onboardingLogoDescription,
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: resolvedLogoSize,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.appTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    l10n.onboardingDescription,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.72),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: ElevatedButton(
                    onPressed: () {
                      // El flujo de onboarding se conectara en futuras historias.
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: Text(l10n.onboardingCta),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
