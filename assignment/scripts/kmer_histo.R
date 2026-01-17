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
png(output_plot)  # Open device FIRST
# Plot histogram
plot(data[2:100,], type='l', 
     xlab='K-mer Coverage', 
     ylab='Number of K-mers', 
     main=paste('K-mer Histogram from', histo_file))

# Save plot

dev.off()  

