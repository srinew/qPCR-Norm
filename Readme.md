# Plot and download qPCR normalized heatmap by uploading a GeneXSample raw CT value .csv file

Link to app: https://svnallan.shinyapps.io/heatmap_shiny/

# Sample Annotations:
First row is Sample IDs for header, second row for sample annotations e.g Tumor, Normal which will annotate the heatmap.
Gene annotations (first column) are always followed by Control samples first e.g

Column1: Gene symbols

Column2: Control1

Column3: Control2

Column4: Tumor1

Column5: Tumor2

# Gene Annotations:
First column is gene symbols/identifiers, cannot be duplicates. Housekeeping genes can be selected manually e.g ACTB, GAPDH, TUBB.

# Normalization:
log2(2^(-ddCT)+1)
