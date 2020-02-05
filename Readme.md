# Plot qPCR norm heatmap by just uploading a GeneXSample CT value .csv file

Link to app: https://svnallan.shinyapps.io/heatmap_shiny/

# Sample Annotations:
First row is for Sample IDs which will be header, second row for sample annotations e.g Tumor, Normal which will be taken as factors to annotate the heatmap.
Gene annotations (first column) are always followed by Control samples first e.g
Column1: Gene symbols
Column2: Control1
Column3: Control2
Column4: Tumor1
Column5: Tumor2

# Gene Annotations:
First column is for gene symbols/identifiers, cannot be duplicates. Housekeeping genes can be entered manually in the text-box assigned. e.g GAPDH.
