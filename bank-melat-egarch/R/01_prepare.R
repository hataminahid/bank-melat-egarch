# =============================================================================
# 01_prepare.R  --  read data, descriptive statistics (Table 1), log-returns
# Output (global): data1, xts_last, new_data1, clean_xts, series1
# =============================================================================

data1 <- read.csv(DATA_FILE, stringsAsFactors = FALSE)

# ---- header clean-up: "<LAST>" -> "LAST", "<DTYYYYMMDD>" -> "Date" -------------
nm <- toupper(gsub("[^A-Za-z]", "", names(data1)))
nm[nm %in% c("DATE", "DTYYYYMMDD")] <- "Date"
names(data1) <- nm
missing_cols <- setdiff(REQUIRED_COLS, names(data1))
if (length(missing_cols) > 0) {
  stop("Columns missing in ", DATA_FILE, ": ", paste(missing_cols, collapse = ", "),
       "\nFound: ", paste(names(data1), collapse = ", "))
}

# ---- dates: accept 20150103 or 2015-01-03 ---------------------------------------
data1$Date <- as.character(data1$Date)
if (all(grepl("^[0-9]{8}$", data1$Date))) {
  data1$Date <- paste0(substr(data1$Date, 1, 4), "-",
                       substr(data1$Date, 5, 6), "-",
                       substr(data1$Date, 7, 8))
}
data1$Date <- as.Date(data1$Date)
cat("Missing values in LAST:", sum(is.na(data1$LAST)), "\n")
data1 <- data1[order(data1$Date), ]      # oldest -> newest
print(head(data1))

# ---- multivariate xts (all price/volume variables) --------------------------------
num_cols <- setdiff(REQUIRED_COLS, "Date")
xts_data1 <- xts(data1[, num_cols], order.by = data1$Date)
cat("\nPeriodicity:\n"); print(periodicity(xts_data1))
print(summary(xts_data1))
cat("\nSkewness:\n");  print(moments::skewness(xts_data1))
cat("Kurtosis:\n");    print(moments::kurtosis(xts_data1))

# ---- Table 1: descriptive statistics of the last traded price -----------------------
xts_last <- xts(data1$LAST, order.by = data1$Date)
x <- as.numeric(xts_last)
desc_table <- data.frame(
  n = length(x), mean = mean(x), sd = sd(x), max = max(x), min = min(x),
  Q1 = unname(quantile(x, 0.25)), Q2 = unname(quantile(x, 0.50)),
  Q3 = unname(quantile(x, 0.75)),
  skewness = moments::skewness(x), kurtosis = moments::kurtosis(x))
print(desc_table)
write.csv(desc_table, file.path(OUT_DIR, "table1_descriptive.csv"), row.names = FALSE)

# ---- Figure 1: price series (one panel per variable + LAST alone) ---------------------
cols9 <- c("blue", "green", "red", "gold", "black", "purple", "pink", "brown", "green")
png(file.path(OUT_DIR, "fig1_all_variables.png"), width = 2000, height = 1600, res = 200)
par(mfrow = c(3, 3))
for (i in seq_along(num_cols)) {
  print(plot(xts_data1[, num_cols[i]], main = num_cols[i], col = cols9[i]))
}
dev.off()

png(file.path(OUT_DIR, "fig1_last_price.png"), width = 1800, height = 1000, res = 200)
print(plot(xts_last, main = "Bank Mellat - last traded price", col = "green"))
dev.off()

# ---- log-returns (in %) ---------------------------------------------------------------
ret <- function(x) diff(log(x) * RETURN_SCALE)

new_data1 <- data.frame(
  Date    = data1$Date[-1],
  B_FIRST = ret(data1$FIRST), B_HIGH = ret(data1$HIGH),
  B_LOW   = ret(data1$LOW),   B_CLOSE = ret(data1$CLOSE),
  VALUE   = data1$VALUE[-1],  VOL = data1$VOL[-1], OPENINT = data1$OPENINT[-1],
  B_OPEN  = ret(data1$OPEN),  B_LAST = ret(data1$LAST))

ret_cols <- c("B_FIRST", "B_HIGH", "B_LOW", "B_CLOSE", "VALUE", "VOL",
              "OPENINT", "B_OPEN", "B_LAST")
new_xts <- xts(new_data1[, ret_cols], order.by = new_data1$Date)

# +-Inf (log of zero) -> NA, then drop incomplete rows
m <- zoo::coredata(new_xts); m[!is.finite(m)] <- NA
new_xts   <- xts(m, order.by = zoo::index(new_xts))
clean_xts <- na.omit(new_xts)
cat("\nRows after cleaning:", nrow(clean_xts), "of", nrow(new_xts), "\n")
print(summary(clean_xts))

# ---- Figure 2: return series -------------------------------------------------------------
png(file.path(OUT_DIR, "fig2_returns_last.png"), width = 1800, height = 900, res = 200)
print(plot(clean_xts$B_LAST, main = "Log-returns of the last traded price (%)", col = "green"))
dev.off()

series1 <- as.numeric(clean_xts$B_LAST)
cat("Return series length (used for modelling):", length(series1), "\n")
