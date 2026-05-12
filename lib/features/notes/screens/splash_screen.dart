import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/features/notes/screens/home_screen.dart';
import 'package:notes_app/core/constants/sizes.dart';
import 'package:notes_app/core/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _textFade;
  late final Animation<double> _creditFade;

  @override
  void initState() {
    super.initState();

    // Full immersive while on splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Icon: fade + subtle slide up  (0 → 45%)
    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
          ),
        );

    // Title + tagline: fade in after icon  (25 → 65%)
    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
    );

    // Credit line: last to appear  (60 → 100%)
    _creditFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    // Hold for 2.8 s total then cross-fade to home
    Future.delayed(const Duration(milliseconds: 1800), _navigateHome);
  }

  void _navigateHome() {
    if (!mounted) return;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Strictly black / white — no seed teal anywhere
    final Color bg = isDark
        ? AppColors.backgroundColorDark
        : AppColors.backgroundColorLight;
    final Color fg = isDark
        ? AppColors.backgroundColorLight
        : AppColors.backgroundColorDark;
    final Color fgMuted = fg.withValues(alpha: 0.30);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Stack(
            children: [
              // ── Centred logo + wordmark ──────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon box
                    SlideTransition(
                      position: _logoSlide,
                      child: FadeTransition(
                        opacity: _logoFade,
                        child: Container(
                          width: AppSize.splashLogoSize,
                          height: AppSize.splashLogoSize,
                          decoration: BoxDecoration(
                            color: fg,
                            borderRadius: BorderRadius.circular(
                              AppSize.xxl - 2,
                            ),
                          ),
                          child: Icon(
                            Icons.note_alt_rounded,
                            size: AppText.displayXl,
                            color: bg,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSize.xl),

                    // App name
                    FadeTransition(
                      opacity: _textFade,
                      child: Text(
                        'Notes',
                        style: TextStyle(
                          fontSize: AppText.displayXl,
                          fontWeight: FontWeight.w700,
                          color: fg,
                          letterSpacing: -1.5,
                          height: 1.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSize.xs + 2),

                    // Tagline
                    FadeTransition(
                      opacity: _textFade,
                      child: Text(
                        'Your thoughts, organized.',
                        style: TextStyle(
                          fontSize: AppText.caption + 1,
                          fontWeight: FontWeight.w600,
                          color: fgMuted,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom credit ────────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: AppSize.xxxl + AppSize.xs,
                child: FadeTransition(
                  opacity: _creditFade,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Thin hairline
                      Container(
                        width: AppSize.xxxl - AppSize.xs,
                        height: 1,
                        color: fgMuted,
                        margin: const EdgeInsets.only(bottom: AppSize.sm + 2),
                      ),
                      Text(
                        'By',
                        style: TextStyle(
                          fontSize: AppText.caption,
                          fontWeight: FontWeight.w500,
                          color: fgMuted,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: AppSize.xs),
                      Text(
                        'Sabiha Niaz',
                        style: TextStyle(
                          fontSize: AppText.body,
                          fontWeight: FontWeight.w600,
                          color: fgMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
