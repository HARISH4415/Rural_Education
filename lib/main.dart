import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/selection_screens.dart';
import 'screens/game_screens.dart' hide DrawingScreen;
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/level_map_screen.dart';
import 'screens/drawing_screen.dart';
import 'screens/book_viewer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('studentBox');
  await Hive.openBox('settingsBox');

  runApp(const KidsLearningApp());
}

class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B80F8)),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/auth':
            return MaterialPageRoute(builder: (_) => const AuthPage());
          case '/standard_selection':
            return MaterialPageRoute(
              builder: (_) => const StandardSelectionScreen(),
            );
          case '/avatar':
            final standard = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => AvatarSelectionScreen(standard: standard),
            );
          case '/home':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => HomeScreen(
                    standard: (args['std'] as int?) ?? 1,
                    avatar: (args['avatar'] as String?) ?? 'husky',
                  ),
            );
          case '/subject_selection':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => SubjectSelectionScreen(
                    standard: (args['std'] as int?) ?? 1,
                    mode: (args['mode'] as String?) ?? 'lessons',
                  ),
            );
          case '/games_list':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => GamesListScreen(
                    standard: (args['std'] as int?) ?? 1,
                    subject: (args['subject'] as String?) ?? 'Maths',
                  ),
            );
          case '/lessons_list':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => LessonsListScreen(
                    standard: (args['std'] as int?) ?? 1,
                    subject: (args['subject'] as String?) ?? 'Tamil',
                  ),
            );
          case '/game_lesson':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => LessonGameScreen(
                    title: (args['title'] as String?) ?? 'Lesson',
                    standard: (args['std'] as int?) ?? 1,
                    subject: (args['subject'] as String?) ?? 'Maths',
                  ),
            );
          case '/game_quantity':
            return MaterialPageRoute(
              builder: (_) => const QuantityGameScreen(),
            );
          case '/game_addition':
            return MaterialPageRoute(
              builder:
                  (_) => const LessonGameScreen(
                    title: 'Addition',
                    standard: 1,
                    subject: 'Maths',
                  ),
            );
          case '/game_shapes':
            return MaterialPageRoute(builder: (_) => const ShapesGameScreen());
          case '/game_subtraction':
            return MaterialPageRoute(
              builder: (_) => const SubtractionGameScreen(),
            );
          case '/game_multiplication':
            return MaterialPageRoute(
              builder: (_) => const MultiplicationGameScreen(),
            );
          case '/drawing':
            return MaterialPageRoute(builder: (_) => const DrawingScreen());
          case '/game_match':
            final data = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => MatchGameScreen(data: data),
            );
          case '/game_fill_blanks':
            final data = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => FillBlanksGameScreen(data: data),
            );
          case '/game_compare':
            final data = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => CompareGameScreen(data: data),
            );
          case '/game_drag_drop':
            final data = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => DragDropGameScreen(data: data),
            );
          case '/book_viewer':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => BookViewerScreen(
                    bookUrl: args['url'] as String,
                    title: args['title'] as String,
                  ),
            );
          case '/topics_list':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => TopicsListScreen(
                    standard: (args['std'] as int?) ?? 1,
                    subject: (args['subject'] as String?) ?? 'Maths',
                  ),
            );
          case '/level_map':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => LevelMapScreen(
                    topicName: (args['topicName'] as String?) ?? 'Discovery',
                    levels:
                        (args['levels'] as List<Map<String, dynamic>>?) ?? [],
                    subject: (args['subject'] as String?) ?? 'Science',
                    currentUnlockedLevel:
                        (args['currentUnlockedLevel'] as int?) ?? 1,
                    standard: (args['std'] as int?) ?? 1,
                  ),
            );
          default:
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
            );
        }
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
    _checkStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    // Keep splash for at least 3.5 seconds to show animations
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;

    final box = Hive.box('studentBox');
    final Map? student = box.get('currentStudent');

    if (student != null) {
      String stdText = student['standard'] ?? '';
      int stdInt = int.tryParse(stdText.replaceAll('Class ', '')) ?? 1;

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'std': stdInt, 'avatar': student['avatar'] ?? 'husky'},
      );
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: SvgPicture.asset(
                    'assets/Education-bro.svg',
                    height: 250,
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'ARIVU',
                        style: GoogleFonts.outfit(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF8B80F8),
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 4,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B80F8).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'EMPOWERING EDUCATION',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B).withOpacity(0.6),
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Loading indicator at bottom
            Positioned(
              bottom: 60,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF8B80F8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
