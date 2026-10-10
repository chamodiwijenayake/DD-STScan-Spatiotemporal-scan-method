Newmst.all.w <- function(cases, pop, w, ex, ty, max_pop,
                      type = "maxonly", nlinks = "one",
                      early = FALSE, cl = NULL, progress = FALSE) {
  # build neighbor list directly from adjacency matrix
  neighbors <- lapply(seq_len(nrow(w)), function(i) {
    which(w[i, ] == 1)
  })
  
  # same logic as original
  if (!progress) {
    max_zones <- lapply(seq_along(cases), function(i) {
      mst.seq(
        i, neighbors[[i]], cases,
        pop, w, ex, ty, max_pop, type,
        nlinks, early
      )
    })
  } else {
    max_zones <- pbapply::pblapply(seq_along(cases), function(i) {
      mst.seq(
        i, neighbors[[i]], cases,
        pop, w, ex, ty, max_pop, type,
        nlinks, early
      )
    }, cl = cl)
  }
  
  if (type == "maxonly") {
    return(unlist(max_zones, use.names = FALSE))
  } else {
    return(max_zones)
  }
}
