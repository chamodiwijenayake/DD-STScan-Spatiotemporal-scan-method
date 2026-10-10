# 1. Load Libraries ------------------------------------------------------------
library(smerc)
library(scanstatistics)

# 2. Configuration & Directory Setup -------------------------------------------
n_sims      <- 1000 
alpha_level <- 0.10

# Relative directory paths relative to the project root
input_dir   <- file.path("data", "simulated")
output_dir  <- file.path("results")

# Ensure output directory exists before running
if (nzchar(output_dir) && !dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Define the true cluster
h <- ("")

# 3. Pre-computation -----------------------------------------------------------
# Pre-calculate spatial adjacency zones once to avoid repeating in loop
zones <- apply((adj_matrix + diag(nrow(adj_matrix))) == 1, 1, which, simplify = FALSE)

# Pre-calculate baseline population denominator for sensitivity (true cluster h)
n1 <- sum(pop[h])

# Initialize vectors to store performance metrics
sen <- numeric(n_sims)  
PPV <- numeric(n_sims)

# 4. Simulation Loop -----------------------------------------------------------
cat("Starting simulation evaluation across", n_sims, "datasets...\n")

for (i in seq_len(n_sims)) {
  
  # Load dataset
  file_name <- file.path(input_dir, paste0("Testing", i, ".csv"))
  if (!file.exists(file_name)) {
    warning("File not found: ", file_name)
    next
  }
  
  Result <- read.csv(file_name, stringsAsFactors = FALSE)
  
  # Calculate expectations and baseline statistics
  ex      <- sum(Result$cases) / sum(Result$population) * Result$population
  ty      <- sum(Result$cases)
  max_pop <- 0.5 * sum(Result$population)
  
  ein     <- zones.sum(zones, ex)
  logein  <- log(ein)
  eout    <- ty - ein
  logeout <- log(eout)
  
  yin  <- zones.sum(zones, Result$cases)
  tobs <- stat_poisson_adj(yin, ty, logein, logeout)
  
  # Null envelope simulation
  precog_null_info <- Newprecog.sim.w(
    nsim     = 499, 
    zones    = zones, 
    ty       = ty, 
    ex       = ex,
    w        = adj_matrix, 
    pop      = Result$population, 
    max_pop  = max_pop,
    logein   = logein, 
    logeout  = logeout,
    cl       = NULL, 
    tol_prob = 0.90, 
    ysim     = NULL
  )
  
  # Candidate region filter
  keep <- which(tobs > precog_null_info$tol_envelopes)
  ccw  <- adj_matrix[keep, keep, drop = FALSE]
  
  # Minimum spanning tree search on candidate subset
  tall <- Newmst.all.w(
    cases    = Result$cases[keep],
    pop      = Result$population[keep],
    w        = ccw,
    ex       = ex[keep],
    ty       = ty,
    max_pop  = max_pop,
    type     = "all",
    early    = FALSE,
    nlinks   = "one",
    progress = FALSE
  )
  
  nn2     <- lgetElement(tall, name = "locids")
  tobs_nn <- lgetElement(tall, name = "loglikrat")
  
  # Non-overlapping cluster refinement
  noc_info        <- noc_nn(nn2, tobs_nn)
  noc_info$clusts <- lapply(noc_info$clusts, function(x) keep[x])
  tobs            <- noc_info$tobs
  tsim            <- precog_null_info[[1]]
  
  # P-value calculation and significance pruning
  p_value <- mc_pvalue(tobs, tsim)
  pruned  <- sig_prune(
    tobs   = tobs,
    zones  = noc_info$clusts,
    pvalue = p_value,
    alpha  = alpha_level
  )
  
  # Identify significant detected zones
  significant_indices <- which(pruned$pvalue <= alpha_level)
  l2 <- if (length(significant_indices) > 0) unlist(pruned$zones[significant_indices]) else NULL
  
  # Performance Evaluation (Sensitivity & PPV)
  l1 <- intersect(h, l2)
  
  n2 <- if (length(l1) > 0) sum(data_pop_summary$total_population[l1]) else 0
  n3 <- if (length(l2) > 0) sum(data_pop_summary$total_population[l2]) else 0
  
  sen[i] <- n2 / n1
  PPV[i] <- if (n3 > 0) (n2 / n3) else 0  # Prevents Division by Zero (NaN)
  
  if (i %% 100 == 0) message("Completed simulation: ", i, " / ", n_sims)
}

# 5. Output Summary & Save Results ---------------------------------------------
results_df <- data.frame(
  simulation  = seq_len(n_sims),
  sensitivity = sen,
  PPV         = PPV
)

# Generate output path dynamically
output_file <- file.path(output_dir, "simulation_results_metrics.csv")
write.csv(results_df, file = output_file, row.names = FALSE)

# Calculate summary metrics
avg_sen <- mean(results_df$sensitivity, na.rm = TRUE)
avg_ppv <- mean(results_df$PPV, na.rm = TRUE)

cat("\n================ Summary ================\n")
cat("Results saved to:", output_file, "\n")
cat("Average Sensitivity:", round(avg_sen, 4), "\n")
cat("Average PPV:        ", round(avg_ppv, 4), "\n")
cat("=========================================\n")