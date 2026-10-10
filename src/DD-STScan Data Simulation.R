# 1. Setup & Configuration -----------------------------------------------------
set.seed(12345)  # Set seed for reproducible dataset generation
n_sims     <- 1000
total_cases <- 6000

# Output directory relative to repository root
output_dir <- file.path("data", "simulated")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}
# Load population data
data_pop_summary <- read.csv("data_pop_summary.csv")

# Total population across all regions/years
pop <- data_pop_summary$total_population
N   <- sum(pop)

# 2. Define True Clusters ------------------------------------------------------
# Define single or multiple cluster region-year target values
target_clusters <- list(
  cluster_1 = c("")
)

# Extract row indices for all defined clusters
h_list <- lapply(target_clusters, function(targets) {
  data_pop_summary$row_number[data_pop_summary$pair_id %in% targets]
})

# Combined indices of all true clusters
h_all <- unlist(h_list)

# 3. Relative Risk Calculation Function ---------------------------------------
compute.rr <- function(h_indices, C_cases, population_vector, total_pop) {
  n  <- sum(population_vector[h_indices])
  m0 <- C_cases * n / total_pop
  v0 <- C_cases * n / total_pop * (total_pop - n) / total_pop
  k  <- qnorm(0.99) * sqrt(v0) + m0
  
  ma <- function(r) C_cases * n * r / (total_pop - n + n * r)
  va <- function(r) C_cases * n * r / (total_pop - n + n * r) * (total_pop - n) / (total_pop - n + n * r)
  f  <- function(r) abs((k - ma(r)) / sqrt(va(r)) - qnorm(0.001))
  
  rr <- optimize(f, c(0.001, 300))$minimum
  mua <- ma(rr)
  
  data.frame(
    size = length(h_indices),
    n    = n,
    mu0  = round(m0, 2), 
    mua  = round(mua, 2),
    rr   = round(rr, 2)
  )
}

# Calculate RR for defined cluster(s)
rr_df <- compute.rr(h_indices = h_all, C_cases = total_cases, population_vector = pop, total_pop = N)
cat("Calculated Relative Risk (RR):", rr_df$rr, "\n")

# 4. Multinomial Probability Vector Setup -------------------------------------
temp_prob <- rep(1, length(pop))
temp_prob[h_all] <- rr_df$rr

# Adjust probabilities by region population size
temp_prob <- temp_prob * pop / sum(pop)
temp_prob <- temp_prob / sum(temp_prob)

# 5. Dataset Generation Loop ---------------------------------------------------
cat("Generating", n_sims, "simulated datasets in:", output_dir, "\n")

for (i in seq_len(n_sims)) {
  # Draw synthetic case counts from multinomial distribution
  ysim <- as.numeric(t(rmultinom(1, size = total_cases, prob = temp_prob)))
  
  # Format dataset
  Result <- data.frame(
    region_year = data_pop_summary$pair_id,
    region      = data_pop_summary$county,
    year        = data_pop_summary$year,
    population  = pop,
    cases       = ysim,
    risk        = ysim / pop,
    in_cluster  = ifelse(seq_along(pop) %in% h_all, 1, 0)
  )
  
  # Export to CSV
  file_name <- file.path(output_dir, paste0("Testing", i, ".csv"))
  write.csv(Result, file = file_name, row.names = FALSE)
  
  if (i %% 100 == 0) {
    cat("Progress: Created", i, "/", n_sims, "datasets\n")
  }
}

cat("Dataset simulation complete!\n")