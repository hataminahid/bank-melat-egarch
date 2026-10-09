# =============================================================================
# 00_config.R  --  packages, paths, model settings
# =============================================================================
required_pkgs <- c("xts", "zoo", "forecast", "tseries", "FinTS", "rugarch", "moments")
missing_pkgs <- required_pkgs[!vapply(required_pkgs, requireNamespace,
                                      logical(1), quietly = TRUE)]
if (length(missing_pkgs) > 0) {
  stop("Missing packages: ", paste(missing_pkgs, collapse = ", "),
       "\nRun  Rscript install_packages.R  first.", call. = FALSE)
}
suppressPackageStartupMessages(invisible(lapply(required_pkgs, library, character.only = TRUE)))

# ---- paths ------------------------------------------------------------------
# CSV exported from tsetmc.com for the Bank Mellat symbol (see data/README.md)
DATA_FILE <- Sys.getenv("MELAT_CSV", unset = "data/melat.csv")
OUT_DIR   <- "results"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# ---- model settings -----------------------------------------------------------
ARMA_ORDER   <- c(1, 1)      # mean model  ARMA(p, q)
GARCH_ORDER  <- c(1, 2)      # EGARCH(alpha-order, beta-order) used in the report
GARCH_DIST   <- "std"        # Student-t innovations ("sstd" = skewed Student-t)
GARCH_ORDERS_TO_COMPARE <- list(c(1, 1), c(2, 1), c(1, 2), c(2, 2))   # Table 3
RETURN_SCALE <- 100          # returns are  diff(log(price) * RETURN_SCALE)
ARCH_LAGS    <- 10
LB_LAGS      <- 10

# Variables expected in the CSV (after header clean-up, see 01_prepare.R)
REQUIRED_COLS <- c("Date", "FIRST", "HIGH", "LOW", "CLOSE", "VALUE",
                   "VOL", "OPENINT", "OPEN", "LAST")
