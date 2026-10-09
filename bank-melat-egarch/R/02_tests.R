# =============================================================================
# 02_tests.R  --  ADF stationarity test, ARCH-LM test, ACF/PACF (Table 2, Fig 3)
# =============================================================================

# ---- ADF and ARCH-LM for every variable of the cleaned data set --------------------------
test_rows <- lapply(colnames(clean_xts), function(v) {
  z <- as.numeric(clean_xts[, v])
  adf <- suppressWarnings(tseries::adf.test(z))
  arc <- FinTS::ArchTest(z, lags = ARCH_LAGS)
  data.frame(Variable = v,
             ADF_stat = unname(adf$statistic), ADF_pvalue = adf$p.value,
             ARCH_chi2 = unname(arc$statistic), ARCH_df = unname(arc$parameter),
             ARCH_pvalue = arc$p.value)
})
test_table <- do.call(rbind, test_rows)
print(test_table, digits = 4)
write.csv(test_table, file.path(OUT_DIR, "table2_adf_arch_tests.csv"), row.names = FALSE)
cat("\nNote: tseries::adf.test truncates p-values to [0.01, 0.99]; ",
    "'0.01' means p <= 0.01.\n", sep = "")

# ---- Figure 3: ACF / PACF of returns and of absolute returns ---------------------------------
r <- new_data1$B_LAST[is.finite(new_data1$B_LAST)]
png(file.path(OUT_DIR, "fig3_acf_pacf_returns.png"), width = 1800, height = 1600, res = 200)
par(mfrow = c(2, 2))
acf(r,        main = "ACF of returns",           col = "forestgreen")
pacf(r,       main = "PACF of returns",          col = "forestgreen")
acf(abs(r),   main = "ACF of |returns|",         col = "lightgreen")
pacf(abs(r),  main = "PACF of |returns|",        col = "lightgreen")
dev.off()
