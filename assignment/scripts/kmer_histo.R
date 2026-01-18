#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

# Check if file provided
if (length(args) == 0) {
  stop("Usage: Rscript kmer_histo.R <histo_file>")
}

histo_file <- args[1]

# Read histogram
data <- read.table(histo_file, col.names = c("coverage", "count"))

output_plot <- sub(".histo$", "_kmer_histo.png", histo_file)

totKmers = sum(
            as.numeric(
                data[4:nrow(data), 1] * data[4:nrow(data), 2]
                )
        )

G = totKmers/10


png(output_plot)  # Open device FIRST
# Plot histogram
plot(data[2:60,], type='l', 
     xlab='K-mer Coverage', 
     ylab='Number of K-mers', 
     main=paste('K-mer Histogram from', histo_file),
     bty='n'
     )

# Save plot

# Add text annotations
mtext(paste("Total kmers:", totKmers), side = 3, line = 0.5)
mtext(paste("Estimated Genome Size (all kmers asuuming 10X coverage):", round(G/1000000, 2), "Mp"), side = 3, line = -0.5)



dev.off()