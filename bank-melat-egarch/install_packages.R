pkgs <- c("xts", "zoo", "forecast", "tseries", "FinTS", "rugarch", "moments")
need <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(need)) install.packages(need)
cat("All packages installed.\n")
