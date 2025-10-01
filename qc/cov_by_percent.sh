#!/bin/bash
# Calculate coverage statistics for a single file




### file was deleted, this is the base idea ###


file="your_coverage_file.txt"

# Count total positions and positions with coverage < 5x
total_positions=$(wc -l < "$file")
under_5x=$(awk '$3 < 5' "$file" | wc -l)

# Calculate percentage
percentage=$(awk "BEGIN {printf \"%.2f\", ($under_5x/$total_positions)*100}")

echo "File: $file"
echo "Total positions: $total_positions"
echo "Positions under 5x: $under_5x"
echo "Percentage under 5x: $percentage%"