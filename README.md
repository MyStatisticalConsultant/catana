# Categorical Data Analysis – Shiny App

> Live app: **https://statisticar-catana.share.connect.posit.cloud**  
> Feedback: **Zlatko@MyStatisticalConsultant.com**

## Overview

A Shiny dashboard for **exploring categorical data**: interactive **graphs**, **tables**, and **inference** for categorical variables, with built-in text boxes for **your interpretations** and a one-click **Download report** (Word `.docx`) that bundles results + your notes.

**Key features**

- **Built-in example datasets** (Titanic, Hair/Eye Color, etc.) so you can try features instantly.  
- **Upload your own data**: `.csv`, `.tsv`, `.xlsx`, `.rds`  
  - Default size policy (configurable): **≤ 5,000 rows** and **≤ 10 columns**  
- **Charts**: bar (simple/grouped/stacked), pie (labels, counts, or %), **mosaic** (Pearson residual shading & legend), **association** (residual legend), **correspondence analysis**  
- **Tables & inference** for categorical variables  
- **Inline interpretations**: each result has an “Interpretation” text box  
- **Single Word report**: export all outputs + your interpretations into a `.docx`

> **Agreement plot rule:** rendered only when the two selected categorical variables have **identical categories (and order)**; otherwise a friendly note is shown.

---

## Run locally

### 1) Clone the repository

```bash
git clone https://github.com/YOUR-GITHUB-USER/catana-shiny.git
cd catana-shiny
```

### 2) Open in RStudio

- Open `app.R` in RStudio.
- (Optional) Place any test data in the project directory.

### 3) Install packages

```r
install.packages(c(
  "shiny", "shinydashboard", "readxl", "grid", "ggplot2", 
  "vcd", "ca", "MASS", "lattice", "car", "aplpack", "psych",
  "kableExtra", "knitr", "tidyr", "formattable", "rmarkdown"
))
```
> On Windows, ensure Pandoc is available (bundled with RStudio). The app writes Word reports via rmarkdown → pandoc.

### 4) Run the app

```r
shiny::runApp()    # o  click "Run App" in RStudio
```
The console will show a local URL (e.g., http://127.0.0.1:XXXX). Open it in your browser.

### 5) Using the app

1. *Choose Data source* (left sidebar):
   - *Use example data* → pick a dataset
   - *Upload your data* → choose a file and, for CSV/TSV, set header/separator/quote
2. *Select categorical variables* (the app auto-detects factors; ensure columns are factors or convertible)
3. Explore *Graphs, Tables, and Inference tabs*
4. Write your notes in each section’s *Interpretation* box
5. Click *Download report* to generate a *Word (.docx)* file with everything

#### Supported upload types

- `.csv`, `.tsv`, `.xlsx`, `.rds`

#### Default dataset limits

- Max *10 variables, 5,000 observations* (Adjust in `server` code if needed.)

### 6) Technical notes

- *Mosaic & Association plots* use `vcd` (grid graphics) for residual shading and legend; the app mirrors the report’s output.
- *Correspondence analysis* uses `ca` with a safe dimension choice.
- The report is rendered from `CatAna.Rmd` via `report.R` (download handler) and includes your interpretations.
- For Word output, chunk option `fig.align` is not used; alignment follows Word defaults (or switch to `officedown` for fine control).

### 7) Contributing / Feedback

Issues, ideas, and pull requests are welcome!

- Live app: https://statisticar-catana.share.connect.posit.cloud
- Email: Zlatko@MyStatisticalConsultant.com

Please include a small sample dataset and steps to reproduce any issue.

### 8) License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

<sub>© 2025 Zlatko J. Kovačić</sub>
