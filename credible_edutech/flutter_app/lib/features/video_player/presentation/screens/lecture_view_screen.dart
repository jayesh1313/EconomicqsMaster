import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:credible_edutech/features/video_player/presentation/bloc/video_player_bloc.dart';
import 'package:credible_edutech/features/quantitative/presentation/bloc/quantitative_bloc.dart';
import 'package:credible_edutech/shared/widgets/garch_chart_painter.dart';
import 'package:credible_edutech/shared/theme/app_theme.dart';

class LectureViewScreen extends StatefulWidget {
  final String courseId;

  const LectureViewScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<LectureViewScreen> createState() => _LectureViewScreenState();
}

class _LectureViewScreenState extends State<LectureViewScreen> {
  late BetterPlayerController _betterPlayerController;
  bool _showGARCH = false;

  // GARCH parameters
  late TextEditingController omegaController;
  late TextEditingController alphaController;
  late TextEditingController betaController;

  @override
  void initState() {
    super.initState();
    omegaController = TextEditingController(text: '0.00001');
    alphaController = TextEditingController(text: '0.1');
    betaController = TextEditingController(text: '0.88');

    _initializeVideoPlayer();
    context
        .read<VideoPlayerBloc>()
        .add(LoadVideoEvent(widget.courseId));
  }

  void _initializeVideoPlayer() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: false,
      looping: false,
      showPlaceholderUntilPlay: true,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
  }

  void _calculateGARCH() {
    // Sample returns data (in real app, this would come from actual data)
    final returns = List<double>.generate(100, (i) => 0.001 + (i * 0.00001));

    context.read<QuantitativeBloc>().add(
          CalculateGARCHEvent(
            returns: returns,
            omega: double.tryParse(omegaController.text) ?? 0.00001,
            alpha: double.tryParse(alphaController.text) ?? 0.1,
            beta: double.tryParse(betaController.text) ?? 0.88,
          ),
        );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    omegaController.dispose();
    alphaController.dispose();
    betaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video Player Section
            BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
              builder: (context, state) {
                if (state is VideoPlayerLoading) {
                  return Container(
                    color: Colors.black,
                    height: 200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (state is VideoPlayerLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BetterPlayer(
                        controller: _betterPlayerController,
                      ),
                      Padding(
                        padding: AppTheme.screenPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Container(
                  color: Colors.black,
                  height: 200,
                  child: Center(
                    child: Text(
                      state is VideoPlayerError ? state.message : 'Loading...',
                    ),
                  ),
                );
              },
            ),

            // Study Notes Section
            Padding(
              padding: AppTheme.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Study Notes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GARCH(1,1) Formula:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Math.tex(
                            r'\sigma^2_t = \omega + \alpha \epsilon^2_{t-1} + \beta \sigma^2_{t-1}',
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Where:',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• ω (omega): Long-term volatility',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '• α (alpha): Reaction to market shocks',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '• β (beta): Volatility persistence',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '• ε (epsilon): Returns',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // GARCH Calculator Section
            Padding(
              padding: AppTheme.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GARCH(1,1) Simulator',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showGARCH = !_showGARCH;
                          });
                        },
                        child: Icon(
                          _showGARCH
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                      ),
                    ],
                  ),
                  if (_showGARCH) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Parameters
                            TextField(
                              controller: omegaController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'ω (Omega)',
                                hintText: '0.00001',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: alphaController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'α (Alpha)',
                                hintText: '0.1',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: betaController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'β (Beta)',
                                hintText: '0.88',
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _calculateGARCH,
                                child: const Text('Calculate Volatility'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Results
                    const SizedBox(height: 16),
                    BlocBuilder<QuantitativeBloc, QuantitativeState>(
                      builder: (context, state) {
                        if (state is GARCHCalculated) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Volatility Chart',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 250,
                                    child: CustomPaint(
                                      painter: GARCHChartPainter(
                                        volatilityData: state.volatility,
                                      ),
                                      size: Size.infinite,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Current Volatility: ${(state.currentVolatility * 100).toStringAsFixed(2)}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF00D084),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is QuantitativeError) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Error: ${state.message}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFFFF5252),
                                    ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
