# =============================================================================
# 04_fit_diagnostics.R  --  final ARMA(1,1)-EGARCH model, Tables 4-6, Figure 4
# =============================================================================

fit_final <- fit_egarch(GARCH_ORDER)
print(fit_final)

# ---- Tables 4 and 5: coefficient estimates -----------------------------------------------
coef_table <- as.data.frame(fit_final@fit$matcoef)
names(coef_table) <- c("Estimate", "Std.Error", "t.value", "p.value")
coef_table$Parameter <- rownames(coef_table)
coef_table <- coef_table[, c("Parameter", "Estimate", "Std.Error", "t.value", "p.value")]
print(coef_table, digits = 4, row.names = FALSE)
write.csv(coef_table, file.path(OUT_DIR, "table4_5_coefficients.csv"), row.names = FALSE)

rob <- as.data.frame(fit_final@fit$robust.matcoef)
names(rob) <- c("Estimate", "Std.Error", "t.value", "p.value")
write.csv(cbind(Parameter = rownames(rob), rob),
          file.path(OUT_DIR, "coefficients_robust_se.csv"), row.names = FALSE)

# ---- sign-bias test (asymmetry) ------------------------------------------------------------
cat("\nSign-bias test:\n")
sb <- signbias(fit_final)
print(sb)

# ---- standardised residuals ------------------------------------------------------------------
res_std <- as.numeric(residuals(fit_final, standardize = TRUE))

# Table 6: Ljung-Box on residuals and on |residuals|
lb1 <- Box.test(res_std,      lag = LB_LAGS, type = "Ljung-Box")
lb2 <- Box.test(abs(res_std), lag = LB_LAGS, type = "Ljung-Box")
lb_table <- data.frame(
  Series = c("standardised residuals", "|standardised residuals|"),
  Chi2 = c(unname(lb1$statistic), unname(lb2$statistic)),
  df   = c(unname(lb1$parameter), unname(lb2$parameter)),
  p.value = c(lb1$p.value, lb2$p.value))
print(lb_table, digits = 4)
write.csv(lb_table, file.path(OUT_DIR, "table6_ljung_box.csv"), row.names = FALSE)

# remaining ARCH effects in the standardised residuals
arch_res <- FinTS::ArchTest(res_std, lags = ARCH_LAGS)
print(arch_res)

# ---- Figure 4: residual diagnostics -------------------------------------------------------------
png(file.path(OUT_DIR, "fig4_residual_acf_pacf.png"), width = 1800, height = 1600, res = 200)
par(mfrow = c(2, 2))
acf(res_std,       lag.max = 10, main = "ACF of standardised residuals",    col = "green")
pacf(res_std,      lag.max = 10, main = "PACF of standardised residuals",   col = "green")
acf(abs(res_std),  lag.max = 10, main = "ACF of |standardised residuals|",  col = "green")
pacf(abs(res_std), lag.max = 10, main = "PACF of |standardised residuals|", col = "green")
dev.off()

png(file.path(OUT_DIR, "fig5_residual_series_qq.png"), width = 1800, height = 900, res = 200)
par(mfrow = c(1, 2))
plot(res_std, type = "l", main = "Standardised residuals", ylab = "")
qqnorm(res_std, main = "Normal Q-Q plot"); qqline(res_std, col = "blue")
dev.off()

sink(file.path(OUT_DIR, "sessionInfo.txt")); print(sessionInfo()); sink()
cat("\nAll tables and figures were written to ", OUT_DIR, "/\n", sep = "")
