# Volatility of the last traded price of Bank Mellat shares – ARMA(1,1)–EGARCH(1,2)

Daily data of the Tehran Stock Exchange (2015–2025). The percentage log-returns of
the last traded price are tested for stationarity (ADF) and ARCH effects
(ARCH-LM), and an ARMA(1,1) mean model with an EGARCH(1,2) variance model and
Student-t innovations is fitted with `rugarch`. Orders are compared by AIC/BIC and
the residuals are checked with Ljung–Box, ACF/PACF and a sign-bias test.

## 1. Data
See [`data/README.md`](data/README.md): export the daily history of the symbol
from tsetmc.com and save it as `data/melat.csv`.

## 2. Install and run
```bash
Rscript install_packages.R
Rscript run_all.R                         # uses data/melat.csv
MELAT_CSV=/path/to/melat.csv Rscript run_all.R
```
Runtime: a few minutes. Model settings (orders, distribution, scaling) are at the top
of `R/00_config.R`.

## 3. Scripts and outputs

| Script | Purpose | Outputs in `results/` |
|---|---|---|
| `R/01_prepare.R` | read data, descriptive statistics, log-returns, cleaning | `table1_descriptive.csv`, `fig1_*.png`, `fig2_returns_last.png` |
| `R/02_tests.R` | ADF, ARCH-LM, ACF/PACF of returns | `table2_adf_arch_tests.csv`, `fig3_acf_pacf_returns.png` |
| `R/03_model_selection.R` | AIC/BIC of EGARCH(1,1), (2,1), (1,2), (2,2) | `table3_egarch_order_selection.csv` |
| `R/04_fit_diagnostics.R` | final fit, coefficients, Ljung–Box, residual plots | `table4_5_coefficients.csv`, `table6_ljung_box.csv`, `fig4_*.png`, `fig5_*.png` |

Differences between the appendix code and the report (EGARCH order, Ljung–Box,
distribution, return scaling) are explained in [`../NOTES.md`](../NOTES.md).

---

## خلاصه‌ی فارسی

1. فایل داده‌ی روزانه‌ی نماد «وبملت» را از tsetmc.com دانلود و با نام `data/melat.csv` ذخیره کنید (جزئیات ستون‌ها در `data/README.md`).
2. `Rscript install_packages.R` و سپس `Rscript run_all.R`.
3. خروجی‌ها (جدول ۱ تا ۶ و شکل‌ها) در `results/` ساخته می‌شوند.
4. تنظیمات مدل (مرتبه‌ی EGARCH، توزیع خطا، مقیاس بازده) در ابتدای `R/00_config.R` است.
