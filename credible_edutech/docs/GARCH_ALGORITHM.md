# GARCH(1,1) Algorithm Documentation

## Overview

**GARCH(1,1)** stands for **Generalized Autoregressive Conditional Heteroscedasticity (1,1)**.

It's a statistical model used to estimate volatility that:
- ✅ Captures time-varying volatility
- ✅ Models volatility clustering (high/low periods)
- ✅ Weighs recent information heavily
- ✅ Is computationally efficient

---

## Mathematical Formulation

### The GARCH(1,1) Model

$$\sigma^2_t = \omega + \alpha \epsilon^2_{t-1} + \beta \sigma^2_{t-1}$$

Where:
- **σ²ₜ**: Conditional variance (volatility squared) at time t
- **ω** (omega): Long-term average variance (constant term)
- **α** (alpha): Reaction to market shocks (ARCH term)
- **ε²ₜ₋₁**: Squared return at t-1 (market shock)
- **β** (beta): Persistence of volatility (GARCH term)
- **σ²ₜ₋₁**: Previous period's variance

### Volatility

$$\sigma_t = \sqrt{\sigma^2_t}$$

---

## Interpretation

### Parameters

| Parameter | Range | Interpretation |
|-----------|-------|-----------------|
| **ω** | (0, ∞) | Long-term volatility level; higher = higher base vol |
| **α** | (0, 1) | Shock sensitivity; higher = quick reaction to news |
| **β** | (0, 1) | Persistence; higher = vol stays elevated longer |
| **α + β** | (0, 1) | Model stationarity; <1 means mean-reversion |

### Intuition

```
σ²ₜ = Base Level + Recent Shock + Past Volatility
      └─ ω ──┘      └── α·ε²ₜ₋₁ ──┘   └── β·σ²ₜ₋₁ ──┘
```

**Example Scenario**:
- Market crash yesterday (large ε²ₜ₋₁)
- α·ε²ₜ₋₁ increases volatility today
- β·σ²ₜ₋₁ keeps volatility elevated
- Both gradually decay to ω (long-term average)

---

## Implementation

### Algorithm

```
INPUT: returns[] (historical log returns)
       omega (ω)
       alpha (α)
       beta (β)

OUTPUT: volatility[], conditional_variance[]

PROCEDURE GARCH_1_1():
    
    // Step 1: Initialize
    sigma_sq[0] = mean(returns²)  // Sample variance
    
    // Step 2: Recursion
    FOR t = 1 TO length(returns):
        epsilon_sq = returns[t-1]²
        
        sigma_sq[t] = omega + alpha * epsilon_sq + beta * sigma_sq[t-1]
        
        // Ensure positive variance (numerical stability)
        IF sigma_sq[t] <= 0:
            sigma_sq[t] = 1e-6
        END IF
        
        volatility[t] = sqrt(sigma_sq[t])
    
    END FOR
    
    RETURN {
        volatility: volatility[],
        conditional_variance: sigma_sq[],
        current_volatility: volatility[-1]
    }
```

### Dart Implementation

```dart
Map<String, dynamic> _garchSimulation({
  required List<double> returns,
  required double omega,
  required double alpha,
  required double beta,
}) {
  // Validation
  if (returns.isEmpty) {
    throw Exception('Returns list cannot be empty');
  }
  
  if (omega + alpha + beta > 1) {
    print('Warning: Non-stationary model (α + β > 1)');
  }

  // Initialize with sample variance
  double sigma2 = returns.fold(0, (sum, r) => sum + r * r) / returns.length;
  List<double> conditionalVariance = [sigma2];
  List<double> volatility = [sigma2.sqrt()];

  // GARCH(1,1) recursion
  for (int i = 1; i < returns.length; i++) {
    final epsilon2 = returns[i - 1] * returns[i - 1];
    
    // σ²ₜ = ω + α·ε²ₜ₋₁ + β·σ²ₜ₋₁
    sigma2 = omega + (alpha * epsilon2) + (beta * sigma2);
    
    // Ensure positive variance (numerical stability)
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
```

---

## Example Calculation

### Setup
```
ω (omega) = 0.00001
α (alpha) = 0.10
β (beta)  = 0.88

Returns (daily log returns):
r₀ = 0.01   (1% return)
r₁ = -0.02  (-2% return)
r₂ = 0.015  (1.5% return)
r₃ = 0.00   (0% return)
```

### Step-by-step Calculation

**Initial variance** (sample variance):
```
σ²₀ = (0.01² + 0.02² + 0.015² + 0.00²) / 4
    = (0.0001 + 0.0004 + 0.000225 + 0) / 4
    = 0.00015625
```

**Time t=1**:
```
ε²₀ = 0.01² = 0.0001

σ²₁ = ω + α·ε²₀ + β·σ²₀
    = 0.00001 + 0.10 × 0.0001 + 0.88 × 0.00015625
    = 0.00001 + 0.00001 + 0.0001375
    = 0.0001575

σ₁ = √0.0001575 = 0.01255 (1.255% volatility)
```

**Time t=2**:
```
ε²₁ = (-0.02)² = 0.0004 (large shock!)

σ²₂ = ω + α·ε²₁ + β·σ²₁
    = 0.00001 + 0.10 × 0.0004 + 0.88 × 0.0001575
    = 0.00001 + 0.00004 + 0.00013860
    = 0.00018860

σ₂ = √0.00018860 = 0.01373 (1.373% volatility - increased!)
```

**Time t=3**:
```
ε²₂ = 0.015² = 0.000225

σ²₃ = ω + α·ε²₂ + β·σ²₂
    = 0.00001 + 0.10 × 0.000225 + 0.88 × 0.00018860
    = 0.00001 + 0.0000225 + 0.00016597
    = 0.00019847

σ₃ = √0.00019847 = 0.01409 (1.409% volatility - further increase)
```

**Time t=4**:
```
ε²₃ = 0² = 0

σ²₄ = ω + α·ε²₃ + β·σ²₃
    = 0.00001 + 0 + 0.88 × 0.00019847
    = 0.00001 + 0.00017465
    = 0.00018465

σ₄ = √0.00018465 = 0.01359 (1.359% volatility - declining back to baseline)
```

### Observation
- Volatility **clusters**: After the -2% shock, volatility stays high
- **Mean reversion**: Over time, volatility returns to ω level
- **Shock impact**: α=0.10 means shocks have ~10% immediate impact
- **Persistence**: β=0.88 means 88% of past variance carries forward

---

## Parameter Estimation

### MLE (Maximum Likelihood Estimation)

In practice, GARCH parameters are estimated using MLE:

```
Objective: Maximize ℒ = Σ log(likelihood)

Where likelihood ∝ exp(-(r²ₜ)/(2σ²ₜ)) / σₜ

Subject to: α + β < 1 (stationarity)
            α, β, ω > 0
```

**Note**: Our simulator accepts **pre-specified** parameters for demonstration. 
In production, use libraries like `tseries` (R) or `arch` (Python).

### Typical Ranges (Financial Data)

| Asset | ω | α | β | α+β |
|-------|---|---|---|-----|
| Stocks | 0.00001 | 0.05-0.15 | 0.80-0.95 | 0.85-0.99 |
| Forex | 0.000005 | 0.03-0.10 | 0.85-0.96 | 0.88-0.99 |
| Crypto | 0.0001 | 0.05-0.20 | 0.70-0.90 | 0.80-0.95 |

---

## Properties

### ✅ Advantages
1. **Parsimony**: Only 3 parameters
2. **Interpretability**: Clear meaning for each term
3. **Efficiency**: Fast computation even with long series
4. **Empirical Success**: Works well for financial data
5. **Clustering**: Captures volatility clustering naturally

### ❌ Limitations
1. **Linear response**: α·ε² may not capture asymmetric shocks
2. **Positivity**: Requires α + β < 1 for stationarity
3. **Parameter stability**: Estimates may change over time
4. **Heavy tails**: Doesn't fully capture extreme events
5. **Multivariate**: Difficult to extend to multiple assets

---

## Extensions

### EGARCH (Exponential GARCH)
Captures asymmetric responses to positive/negative shocks:
$$\log(\sigma^2_t) = \omega + \alpha \frac{r_{t-1}}{σ_{t-1}} + β \log(σ^2_{t-1}) + γ \frac{|r_{t-1}|}{σ_{t-1}}$$

### GJR-GARCH
Alternative asymmetric model:
$$\sigma^2_t = \omega + (\alpha + \gamma I_{t-1}) \epsilon^2_{t-1} + β \sigma^2_{t-1}$$

### GARCH-M (in-mean)
Volatility affects returns:
$$r_t = μ + \lambda \sigma^2_t + \epsilon_t$$

---

## Applications

### 1. Risk Management
- Estimate Value-at-Risk (VaR)
- Stress testing
- Position sizing

### 2. Options Pricing
- Implied volatility forecasting
- Option Greeks calculation
- Volatility term structure

### 3. Portfolio Management
- Dynamic asset allocation
- Volatility-weighted indexing
- Volatility targeting strategies

### 4. Trading
- Volatility forecasting models
- Volatility arbitrage
- Stop-loss optimization

---

## Testing the Model

### Residual Analysis

After fitting GARCH, examine residuals:
$$\hat{u}_t = \frac{r_t}{\hat{\sigma}_t}$$

**Tests**:
1. **Normality**: Jarque-Bera test (residuals ~ N(0,1))
2. **Auto-correlation**: Ljung-Box test (no serial correlation)
3. **Heteroskedasticity**: ARCH-LM test (no remaining ARCH effects)

### Backtesting

Compare predicted volatility vs. realized:
```
Realized Vol = std(returns[t:t+k])
GARCH Forecast = σ̂ₜ

Metric: Mean Absolute Error (MAE)
```

---

## Quick Reference

### Copy-Paste Defaults (S&P 500)
```
ω = 0.000008
α = 0.08
β = 0.91
α + β = 0.99  (highly persistent)
```

### For High-Vol Assets (Crypto)
```
ω = 0.0001
α = 0.15
β = 0.80
α + β = 0.95  (faster mean reversion)
```

---

**GARCH is the workhorse of quantitative finance** 📊
