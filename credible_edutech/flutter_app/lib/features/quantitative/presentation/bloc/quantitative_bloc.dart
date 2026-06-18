import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class QuantitativeEvent extends Equatable {
  const QuantitativeEvent();

  @override
  List<Object?> get props => [];
}

class CalculateGARCHEvent extends QuantitativeEvent {
  final List<double> returns;
  final double omega;
  final double alpha;
  final double beta;

  const CalculateGARCHEvent({
    required this.returns,
    required this.omega,
    required this.alpha,
    required this.beta,
  });

  @override
  List<Object?> get props => [returns, omega, alpha, beta];
}

// States
abstract class QuantitativeState extends Equatable {
  const QuantitativeState();

  @override
  List<Object?> get props => [];
}

class QuantitativeInitial extends QuantitativeState {
  const QuantitativeInitial();
}

class QuantitativeLoading extends QuantitativeState {
  const QuantitativeLoading();
}

class GARCHCalculated extends QuantitativeState {
  final List<double> volatility;
  final List<double> conditionalVariance;
  final double currentVolatility;

  const GARCHCalculated({
    required this.volatility,
    required this.conditionalVariance,
    required this.currentVolatility,
  });

  @override
  List<Object?> get props => [volatility, conditionalVariance, currentVolatility];
}

class QuantitativeError extends QuantitativeState {
  final String message;

  const QuantitativeError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class QuantitativeBloc extends Bloc<QuantitativeEvent, QuantitativeState> {
  QuantitativeBloc() : super(const QuantitativeInitial()) {
    on<CalculateGARCHEvent>(_onCalculateGARCH);
  }

  Future<void> _onCalculateGARCH(
    CalculateGARCHEvent event,
    Emitter<QuantitativeState> emit,
  ) async {
    emit(const QuantitativeLoading());
    try {
      final result = _garchSimulation(
        returns: event.returns,
        omega: event.omega,
        alpha: event.alpha,
        beta: event.beta,
      );

      emit(GARCHCalculated(
        volatility: result['volatility'],
        conditionalVariance: result['conditional_variance'],
        currentVolatility: result['current_volatility'],
      ));
    } catch (e) {
      emit(QuantitativeError('GARCH calculation failed: $e'));
    }
  }

  Map<String, dynamic> _garchSimulation({
    required List<double> returns,
    required double omega,
    required double alpha,
    required double beta,
  }) {
    if (returns.isEmpty) {
      throw Exception('Returns list cannot be empty');
    }

    // Initialize with sample variance
    double sigma2 = returns.fold(0, (sum, r) => sum + r * r) / returns.length;
    List<double> conditionalVariance = [sigma2];
    List<double> volatility = [sigma2.sqrt()];

    // GARCH(1,1) recursion: σ²_t = ω + α*ε²_{t-1} + β*σ²_{t-1}
    for (int i = 1; i < returns.length; i++) {
      final epsilon2 = returns[i - 1] * returns[i - 1];
      sigma2 = omega + (alpha * epsilon2) + (beta * sigma2);
      
      // Ensure positive variance
      sigma2 = sigma2 > 0 ? sigma2 : 1e-6;
      
      conditionalVariance.add(sigma2);
      volatility.add(sigma2.sqrt());
    }

    return {
      'volatility': volatility,
      'conditional_variance': conditionalVariance,
      'current_volatility': volatility.last,
    };
  }
}
