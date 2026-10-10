# ---- Poisson log-likelihood ratio statistic (NA-safe) ----
stat_poisson_adj_R <- function(yin, ty, logein, logeout, min.cases = 1) {
  # skip clusters with too few cases
  if (sum(yin) < min.cases) return(0)
  
  Oin <- sum(yin)
  Oout <- ty - Oin
  Ein <- sum(exp(logein))
  Eout <- sum(exp(logeout))
  
  # avoid division by zero or log(0)
  if (Oin <= 0 || Oout <= 0 || Ein <= 0 || Eout <= 0) return(0)
  
  llr <- Oin * log(Oin / Ein) + Oout * log(Oout / Eout)
  
  # ensure numeric
  if (is.nan(llr) || is.infinite(llr)) return(0)
  
  llr
}

# ---- Adjacency-only PreCoG simulation function ----
Newprecog.sim.w <- function(nsim = 1, zones, ty, ex, w, pop,
                            max_pop, logein, logeout,
                            cl = NULL, tol_prob = 0.90,
                            ysim = NULL) {
  
  if (is.null(ysim)) {
    # simulate counts under null (multinomial)
    ysim <- t(stats::rmultinom(nsim, size = ty, prob = ex))
  }
  
  n_zones <- length(zones)
  
  # Compute statistics for each simulated data set
  stats_null <- sapply(1:nsim, function(i) {
    simcases <- ysim[i, ]
    yin <- zones.sum(zones, simcases)
    stat_poisson_adj(yin, ty, logein, logeout, min.cases = 1)
  })
  
  # Ensure stats_null is a matrix: rows = candidate zones, columns = simulations
  if (is.vector(stats_null)) {
    stats_null <- matrix(stats_null, ncol = nsim)
  }
  
  # Compute tolerance envelopes for each region (NA-safe)
  tol_envelopes <- apply(stats_null, 1, function(x) stats::quantile(x, prob = tol_prob, na.rm = TRUE))
  
  # Filter candidate zones exceeding tolerance
  cc_keep <- apply(stats_null, 2, function(tobs) {
    which(tobs > tol_envelopes)
  }, simplify = FALSE)
  
  # Determine maximum statistic for each simulated dataset
  max_stats2_null <- pbapply::pblapply(seq_along(cc_keep), function(i) {
    keep <- cc_keep[[i]]
    if (length(keep) > 0) {
      # adjacency for candidate regions
      ccw <- w[keep, keep, drop = FALSE]
      # generate neighbors list from adjacency
      neighbors_list <- lapply(seq_along(keep), function(j) {
        which(ccw[j, ] == 1)
      })
      
      # run MST expansion using adjacency
      tall <- mst.all(
        neighbors_list,
        cases = ysim[i, keep],
        pop = pop[keep],
        w = ccw,
        ex = ex[keep],
        ty = ty,
        max_pop = max_pop,
        type = "maxonly",
        early = FALSE,
        nlinks = "one",
        progress = FALSE
      )
      return(max(tall))
    } else {
      return(0L)
    }
  }, cl = cl)
  
  # Reformat test statistics
  tsim <- unlist(max_stats2_null, use.names = FALSE)
  
  # Return simulation information
  return(list(
    tsim = tsim,
    tol_envelopes = tol_envelopes
  ))
}
