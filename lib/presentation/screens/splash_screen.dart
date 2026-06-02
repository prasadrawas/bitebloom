import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/app_logger.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    log.i('[Splash] Waiting for auth state...');
    // Wait for Firebase Auth to resolve the persisted session first
    final authFuture = ref.read(authServiceProvider).authStateChanges.first;
    // Run both in parallel — animation plays while auth resolves
    final results = await Future.wait([
      authFuture,
      Future.delayed(const Duration(seconds: 3)),
    ]);
    if (!mounted) return;

    final authState = results[0];

    if (authState == null) {
      log.i('[Splash] No user session → Login');
      _navigateTo('/login');
    } else {
      log.i('[Splash] User found: ${authState.uid}');
      log.d('[Splash] Email: ${authState.email}');
      final hasProfile =
          await ref.read(firestoreServiceProvider).hasProfile(authState.uid);
      if (hasProfile) {
        log.i('[Splash] Profile exists → Home');
        _navigateTo('/home');
      } else {
        log.i('[Splash] No profile → Onboarding');
        _navigateTo('/onboarding');
      }
    }
  }

  void _navigateTo(String route) {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo: plate/leaf morphing icon
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = _controller.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow behind icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGreen
                                .withOpacity(0.3 * progress),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    // Icon transition
                    Icon(
                      progress < 0.5
                          ? Icons.restaurant_menu
                          : Icons.check_circle_outline,
                      size: 80 + (20 * progress),
                      color: Color.lerp(
                        AppColors.accentGreen.withOpacity(0.6),
                        AppColors.accentGreen,
                        progress,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.accentGreen,
                    letterSpacing: 2,
                  ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 400.ms),
            const SizedBox(height: 8),
            Text(
              AppStrings.tagline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white54,
                  ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 800.ms),
            const SizedBox(height: 48),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.accentGreen.withOpacity(0.5),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 1200.ms),
          ],
        ),
      ),
    );
  }
}
