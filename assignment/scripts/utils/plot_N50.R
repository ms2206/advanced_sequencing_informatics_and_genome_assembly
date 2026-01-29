# Data: kmer_size and N50
kmer_size <- c(60, 64, 55, 66, 50, 68, 45, 70, 72, 40, 74, 76, 35, 78, 25)
N50 <- c(17822, 16151, 15018, 12179, 9965, 8653, 7561, 6459, 4350, 3338, 2632, 1611, 1559, 946, 67)

# Combine into a data frame
df <- data.frame(kmer_size, N50)

# Sort by kmer_size (optional)
df <- df[order(df$kmer_size), ]

# Save the plot as a PNG file
png("N50_vs_kmer_size.png")
barplot(
    height = df$N50,
    names.arg = df$kmer_size,
    main = "N50 vs K-mer Size",
    xlab = "K-mer Size",
    ylab = "N50",
    col = "steelblue"
)
dev.off()
