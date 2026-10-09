# =============================================================================
# 03_model_selection.R  --  AIC / BIC for ARMA(1,1)-EGARCH(s,m) candidates (Table 3)
# =============================================================================

fit_egarch <- function(order, data = series1) {
  spec <- ugarchspec(
    variance.model = list(model = "eGARCH", garchOrder = order),
    mean.model     = list(armaOrder = ARMA_ORDER, include.mean = TRUE),
    distribution.model = GARCH_DIST)
  ugarchfit(spec = spec, data = data)
}

sel_rows <- lapply(GARCH_ORDERS_TO_COMPARE, function(o) {
  fit <- tryCatch(fit_egarch(o), error = function(e) NULL)
  if (is.null(fit)) {
    return(data.frame(Order = paste0("(", o[1], ",", o[2], ")"), AIC = NA, BIC = NA))
  }
  ic <- infocriteria(fit)
  data.frame(Order = paste0("(", o[1], ",", o[2], ")"),
             AIC = unname(ic["Akaike", 1]), BIC = unname(ic["Bayes", 1]))
})
sel_table <- do.call(rbind, sel_rows)
print(sel_table, digits = 5)
write.csv(sel_table, file.path(OUT_DIR, "table3_egarch_order_selection.csv"), row.names = FALSE)

best_aic <- sel_table$Order[which.min(sel_table$AIC)]
best_bic <- sel_table$Order[which.min(sel_table$BIC)]
chosen   <- paste0("(", GARCH_ORDER[1], ",", GARCH_ORDER[2], ")")
cat(sprintf("\nBest by AIC: %s | best by BIC: %s | order used in 04_fit_diagnostics.R: %s\n",
            best_aic, best_bic, chosen))
if (!(chosen %in% c(best_aic, best_bic))) {
  warning("GARCH_ORDER in 00_config.R is not the AIC/BIC minimiser - check the report.")
}
