server <- function(input, output) {
  plotInput <- function(){
    inFile <- input$file
    tlda.ct <- read.csv(inFile$datapath, header = T,row.names = 1,as.is=T)
    # tlda.ct <- read.csv("/Users/srnallan/Desktop/Book7.csv", header = T,row.names = 1, as.is = T)
    colanno <- data.frame(t(tlda.ct[1,]))
    tlda.ct <- data.frame(tlda.ct[-1,])
    
    if(all(colnames(tlda.ct) != rownames(colanno))) return("Please check the sample row names")
    colanno[,1] <- factor(colanno[,1])
    # colanno[,2] <- factor(colanno[,2])
    
    for( a in 1:ncol(tlda.ct)){
      tlda.ct[,a] <- as.integer(tlda.ct[,a])
    }
    
    # Normalization
    for(i in 1:nrow(tlda.ct)){
      for(j in 1:ncol(tlda.ct)){
        tlda.ct[i,j] <- ifelse(tlda.ct[i,j] >=34, 40, tlda.ct[i,j])
      }
    }
    
    # Internal control which is mean of Ref genes per sample/control
    tlda.ct[nrow(tlda.ct)+1,] <- NA
    rownames(tlda.ct)[[nrow(tlda.ct)]] <- "Int.Control"
    
    ref.genes <- c(input$header)
    
    # Calculate the internal controls mean for each sample
    for(i in 1:ncol(tlda.ct)){
      tlda.ct[nrow(tlda.ct),i] <- mean(tlda.ct[rownames(tlda.ct)%in%ref.genes,i])
    }
    
    # Subtract the Ct values with their respective internal controls
    tlda.ct.1 <- tlda.ct
    
    for (i in 1:(nrow(tlda.ct.1)-1)) {
      for(j in 1:ncol(tlda.ct.1)){
        tlda.ct.1[i,j] <- tlda.ct[i,j]-tlda.ct[nrow(tlda.ct),j]
      }
    }
    
    # Separate controls and samples
    cont.n <- length(colanno[colanno$Type=="Control",])
    control <- tlda.ct.1[,c(1:cont.n)]
    samples <- tlda.ct.1[,c((cont.n+1):ncol(tlda.ct.1))]
    
    # Mean of all Controls
    control$Mean.cq.Control <- rowMeans(control)
    control.1 <- control[1:nrow(control)-1,]
    
    # Actual value minus the mean value for each gene (CONTROLS)
    for(i in 1:nrow(control.1)){
      for(j in 1:(ncol(control.1)-1)){
        control.1[i,j] <- control[i,j]-control[i,ncol(control)]
        control.1[i,j] <- log2((2^(-control.1[i,j]))+1)
      }
    }
    
    # Actual value minus the mean value for each gene (SAMPLES)
    samples.1 <- samples[1:nrow(samples)-1,]
    for(i in 1:nrow(samples.1)){
      for(j in 1:ncol(samples.1)){
        samples.1[i,j] <- samples.1[i,j]-control[i,ncol(control)]
        samples.1[i,j] <- log2((2^(-samples.1[i,j]))+1)
      }
    }
    
    # Retrieve all samples
    Normalized.data <- cbind(control.1[,-ncol(control)], samples.1)
    
    # check the order
    if(all(colnames(Normalized.data) != rownames(colanno))) return("Please check the sample row names")
    
    # Heatmap
    colors.hm <- colorRampPalette(c("white","lightpink","red"))(100)
    pheatmap(Normalized.data ,color=colors.hm,fontsize_row = 12,
             annotation_col = colanno,fontsize_col = ifelse(ncol(Normalized.data)>20,12,15),
             cluster_cols = ifelse(input$select_class_1=="Yes", T, F),
             clustering_method = input$select_class_2,
             clustering_distance_rows = "correlation")
  }
  
  output$distPlot <- renderPlot({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    # read.csv(inFile$datapath, header = input$header)
    plotInput()
    
  },height=900, width=1500)
  
  output$export <- downloadHandler(
    filename = function() { paste(gsub(".csv","",input$file), " Clustering- ", input$select_class_2,' normalized heatmap.pdf', sep='') },
    content = function(file) {
      ggsave(file, plot = plotInput(), device = "pdf", width=15,height = 10)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
