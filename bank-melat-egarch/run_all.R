# Run the whole Bank Mellat pipeline.  Execute from THIS folder:
#   Rscript run_all.R
# Optional:  MELAT_CSV=/path/to/melat.csv Rscript run_all.R
set.seed(1404)
for (f in c("R/00_config.R", "R/01_prepare.R", "R/02_tests.R",
            "R/03_model_selection.R", "R/04_fit_diagnostics.R")) {
  cat("\n########## ", f, " ##########\n", sep = "")
  source(f, echo = FALSE)
}
