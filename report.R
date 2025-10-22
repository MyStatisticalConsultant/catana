# SPDX-License-Identifier: MIT
# Copyright (c) 2025 Zlatko J. Kovačić
# Report ----

# report.R
output$dwnlRep <- downloadHandler(
  filename = function() paste0("CatAna_", Sys.Date(), ".docx"),
  content  = function(file) {
    app_dir <- normalizePath(".", winslash = "/", mustWork = TRUE)
    rmd1 <- file.path(app_dir, "CatAna.Rmd")
    rmd2 <- file.path(app_dir, "www", "CatAna.Rmd")
    rmd  <- if (file.exists(rmd1)) rmd1 else rmd2
    if (!file.exists(rmd)) stop("CatAna.Rmd not found in app root or /www.")
    
    tmp_rmd <- tempfile(fileext = ".Rmd")
    if (!file.copy(rmd, tmp_rmd, overwrite = TRUE)) stop("Failed to stage CatAna.Rmd.")
    
    # normalize main data
    df_for_report <- dataForReport$data
    if (!is.null(df_for_report)) df_for_report <- as.data.frame(df_for_report)
    
    # safe getter for the full dataset expected by the Rmd
    get_rep_dataset <- function() {
      if (exists("repDataSetInput") && !is.null(repDataSetInput$data)) {
        return(repDataSetInput$data)
      }
      if (exists("datasetInput")) {
        # datasetInput is a reactive; call it if available
        return(tryCatch(datasetInput(), error = function(e) NULL))
      }
      NULL
    }
    
    params <- list(
      data = df_for_report,
      fv1  = input$fv1,
      fv2  = input$fv2,
      typeBar = input$typeBar,
      displayWithPie = input$displayWithPie,
      repDataSetInput = get_rep_dataset(),   # <-- robust
      obs = input$obs,
      factor = input$factor,
      dataInput = input$dataInput,
      numCounts = input$numCounts,
      numColumn = input$numColumn,
      numRow = input$numRow,
      fv3 = input$fv3,
      fv3a = input$fv3a,
      selectionLoglin = input$selectionLoglin,
      numSuccess = input$numSuccess,
      numTotal = input$numTotal,
      pNull = input$pNull,
      pAlter = input$pAlter,
      pConf = input$pConf,
      pCorrect = input$pCorrect,
      numSuccess1 = input$numSuccess1,
      numTotal1 = input$numTotal1,
      pNull1 = input$pNull1,
      pAlter1 = input$pAlter1,
      pConf1 = input$pConf1,
      name = input$name,
      # interpretations – graphs
      text_graphcat1 = input$text_graphcat1,
      text_graphcat2 = input$text_graphcat2,
      text_graphcat3 = input$text_graphcat3,
      text_graphcat4 = input$text_graphcat4,
      text_graphcat5 = input$text_graphcat5,
      text_graphcat6 = input$text_graphcat6,
      text_graphcat7 = input$text_graphcat7,
      # interpretations – tables
      text_tablecat1 = input$text_tablecat1,
      text_tablecat2 = input$text_tablecat2,
      text_tablecat3 = input$text_tablecat3,
      text_tablecat4 = input$text_tablecat4,
      text_tablecat5 = input$text_tablecat5,
      # interpretations – inference
      text_infercat1 = input$text_infercat1,
      text_infercat2 = input$text_infercat2,
      text_infercat3 = input$text_infercat3,
      text_infercat4 = input$text_infercat4,
      text_infercat5 = input$text_infercat5,
      text_infercat6 = input$text_infercat6,
      text_infercat7 = input$text_infercat7
    )
    
    rmarkdown::render(
      input         = tmp_rmd,
      output_file   = file,
      output_format = "word_document",
      params        = params,
      envir         = new.env(parent = globalenv()),
      encoding      = "UTF-8"
    )
  }
)

