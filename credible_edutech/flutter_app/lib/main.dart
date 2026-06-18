import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:credible_edutech/core/service_locator.dart';
import 'package:credible_edutech/shared/theme/app_theme.dart';
import 'package:credible_edutech/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:credible_edutech/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:credible_edutech/features/video_player/presentation/bloc/video_player_bloc.dart';
import 'package:credible_edutech/features/quantitative/presentation/bloc/quantitative_bloc.dart';
import 'package:credible_edutech/shared/presentation/screens/deep_link_landing_screen.dart';
import 'package:credible_edutech/shared/presentation/screens/auth_screen.dart';
import 'package:credible_edutech/shared/presentation/screens/course_dashboard_screen.dart';

const String supabaseUrl = 'https://your-project.supabase.co';
const String supabaseAnonKey = 'your-anon-key';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Setup service locator
  await setupServiceLocator(Supabase.instance.client);

  runApp(const CredibleEdutech());
}

class CredibleEdutech extends StatefulWidget {
  const CredibleEdutech({Key? key}) : super(key: key);

  @override
  State<CredibleEdutech> createState() => _CredibleEdutechState();
}

class _CredibleEdutechState extends State<CredibleEdutech> {
  @override
  void initState() {
    super.initState();
    _setupDeepLinking();
  }

  void _setupDeepLinking() {
    // Handle deep links from YouTube descriptions
    // Example: app://economicqsmaster.com/course/{id}
    // Implementation depends on your deep linking setup
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            supabaseClient: Supabase.instance.client,
          )..add(const AuthCheckStatusEvent()),
        ),
        BlocProvider(
          create: (context) => CoursesBloc(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        BlocProvider(
          create: (context) => VideoPlayerBloc(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        BlocProvider(
          create: (context) => QuantitativeBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CredibleEdutech - Economicqsmaster',
        theme: AppTheme.darkTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return const CourseDashboardScreen();
            } else {
              return const AuthScreen();
            }
          },
        ),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/courses': (context) => const CourseDashboardScreen(),
          '/deeplink': (context) => const DeepLinkLandingScreen(),
        },
      ),
    );
  }
}
