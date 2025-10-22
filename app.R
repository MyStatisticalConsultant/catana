###########################################
#            SHINY APP FOR  
#        CATEGORICAL VARIABLES
###########################################
library(shiny)
library(shinydashboard)
library(vcd)
library(car)
library(lattice)
library(aplpack)
library(psych)
library(MASS)
library(ca)
library(grid)
library(ggplot2)
library(tidyr)
library(formattable)
library(readxl)
library(knitr)
library(kableExtra)
library(markdown)

# #####################################
#               B O D Y 
# #####################################

# e.g. max 10 MB file size (optional; this is bytes)
options(shiny.maxRequestSize = 10 * 1024^2)

body <- dashboardBody(

  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  tags$style(type="text/css",
             ".shiny-output-warning { visibility: hidden; }",
             ".shiny-output-warning:before { visibility: hidden; }"
  ),  
  tabItems(
#
# Intro tab contains information about topic/method/model or example. 
#
    tabItem("intro",		
            tabBox(
              title = "Introduction",
              # The id lets us use input$tabset1 on the server to find the current tab
              id = "tabset1", width = NULL, 
              
			  tabPanel("About the application", 
			           tags$div(tags$p(" "), tags$br(), tags$h2("About the", tags$i("Categorical Data Analysis"), "application"), tags$h4("The", tags$i("Categorical Data Analysis"), "is an interactive application which allows you to conduct statistical analysis with categorical/qualitative variables."),tags$p("The", tags$i("Categorical Data Analysis"), "makes it easy to:"),
                 tags$ol(tags$li("Upload your data and download example datasets"),tags$li("Visualise frequencies and relationships among categorical data"),tags$li("Display data and results in a tabular format"), tags$li("Test hypotheses about independence in  contingency tables"), tags$li("Save the results in a report format"), tags$li("Learn R codes used to generate results.")), tags$p("Start analysis by selecting either example data or by uploading your own data on the left sidebar. This will display the selected dataset, a list of categorical variables and three tabs:", tags$i("Graphs,"), tags$i("Tables"), "and", tags$i("Inference."), "The", tags$i("Example data"), "tab at the top of the screen contains detailed information about each of the example dataset in this application."), tags$p("Click the plus sign (+) to open the box with detailed information about the", tags$i("Categorical Data Analysis"), "application features.")  
              ),

			  fluidRow(
			  box(
                title=tagList(shiny::icon("upload"), "Upload and download data"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("Uploading your data and downloading example dataset"),
				HTML("<ul>
  <li>The <em>Categorical Data Analysis</em> application permits the user to upload a .csv file that contains data to be  displayed. Instructions are given on the <em>Uploading  data</em> panel. </li>
  <li>There are a few built-in example datasets which can be used to conduct  analysis with categorical variables. </li>
  <li>This application also permits the user to download each example dataset. </li>
</ul>")
              )),			  
			  box(
                title=tagList(shiny::icon("bar-chart"), "Graphs tab"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$h4("Content of the", tags$i("Graphs"), "tab"),
                tags$p("Click on the", tags$i("Graphs"), "tab on the left sidebar to reveal the following options at the top of the main panel:"), tags$br(), 
				HTML("<table border='0'>
  <tr>
    <td valign='top'><p><strong>Bar chart</strong></p></td>
    <td valign='top'><p>This tab displays a bar chart for the selected categorical variable. <br />
      If the selected dataset has more than one categorical variable then the second variable could be used to generate stacked or grouped bar charts. </p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Dotplot</strong></p></td>
    <td valign='top'><p>Displays a dotplot for the selected categorical variable using the <a href='https://cran.r-project.org/web/packages/lattice/index.html'>lattice</a> package in R. <br />
      If the selected dataset has more than one categorical variable then the second variable could be used to generate dotplot for each category of the second categorical variable. </p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Pie chart</strong></p></td>
    <td valign='top'><p>Displays a pie chart for the selected categorical variable. <br />
      Sample size or percentage can be inserted by each slice after the category name. </p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Mosaic plot</strong></p></td>
    <td valign='top'><p>Displays a mosaic plot for two categorical variables using <a href='https://cran.r-project.org/web/packages/vcd/index.html'>vcd</a> package    in R. </p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Association plot</strong></p></td>
    <td valign='top'><p>Displays an association plot for two categorical variables using <a href='https://cran.r-project.org/web/packages/vcd/index.html'>vcd</a> package in R.</p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Agreement plot</strong></p></td>
    <td valign='top'><p>Displays an agreement plot for two categorical variables using <a href='https://cran.r-project.org/web/packages/vcd/index.html'>vcd</a> package in R.</p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Correspondence plot</strong></p></td>
    <td valign='top'><p>Displays the correspondence analysis 2D plot for two categorical variable using <a href='https://cran.r-project.org/web/packages/ca/index.html'>ca</a> package in R. </p></td>
  </tr>
</table>")
               )
              )),  #fluid row

			  fluidRow(
			  box(
                title=tagList(shiny::icon("table"), "Tables tab"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("Content of the", tags$i("Tables"), "tab"),
                tags$p("Click on the", tags$i("Tables"), "tab on the left sidebar to reveal the following options at the top of the main panel:"), tags$br(), HTML("<table border='0'>
  <tr>
    <td valign='top'><p><strong>Datasets</strong></p></td>
    <td valign='top'><ul>
      <li>This tab displays all the variables in the selected dataset. </li>
      <li>        Download a selected example dataset as a csv file. </li>
	  <li>A simple random sample from a selected dataset could be generated here.</li>
    </ul></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Descriptive statistics</strong></p></td>
    <td valign='top'><ul>
      <li>Two sets of descriptive statistics are provided. First, from the  base R package and the second, from <a href='https://cran.r-project.org/web/packages/psych/index.html'>psych</a> package. </li>
      <li> Psych package could generate descriptive statistics by grouping/categorical variable. </li>
    </ul>      </td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Frequency tables</strong></p></td>
    <td valign='top'><ul>
      <li>All possible frequency and contingency tables are provided here, including marginal frequencies and tables of proportions. </li>
    </ul></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Association statistics</strong></p></td>
    <td valign='top'><ul>
      <li>Using the <a href='https://cran.r-project.org/web/packages/vcd/index.html'>vcd</a> package in R the following measures of association in the contingency table are calculated: phi coefficient, contingency coefficient and Cramer&rsquo;s V. </li>
      <li> In addition to these measures of association Cohen&rsquo;s kappa and weighted kappas for a confusion matrix are calculated. </li>
    </ul>      </td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Correspondence analysis</strong></p></td>
    <td valign='top'><ul>
      <li>Using the <a href='https://cran.r-project.org/web/packages/ca/index.html'>ca</a> package in R correspondence analysis is conducted for two selected  categorical variables. Summary output of a correspondence analysis is presented here. </li>
    </ul></td>
  </tr>
</table>")
              )),			  
			  box(
                title=tagList(shiny::icon("calculator"), "Inference tab"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$h4("Content of the", tags$i("Inference"), "tab"),
                tags$p("Click on the", tags$i("Inference"), "tab on the left sidebar to reveal the following options at the top of the main panel:"), HTML("<table border='1'>
  <tr>
    <td valign='top'><p><strong>Chi-squared test</strong></p></td>
    <td valign='top'><p>This tab performs the chi-squared test of independence of the row and    column variables in two-way contingency tables. </p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Fisher exact test</strong></p></td>
    <td valign='top'><p>This test provides an exact test of independence in a two-dimensional    contingency table. </p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Mantel-Haenszel test</strong></p></td>
    <td valign='top'><p>This test provides test of conditional independence between two    nominal variables in each stratum of a three-dimensional contingency table. </p></td>
  </tr>
  <tr>
    <td valign='top'><p><strong>Log-linear model tests</strong></p></td>
    <td valign='top'><p>This tab contains four tests for log-linear models based on a    three-way contingency table.</p></td>
  </tr>
</table>")
               )
              )),
			  
			  fluidRow(
			  box(
				title=tagList(shiny::icon("download"), "Save results"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,
                tags$h5("To save results in a report:", tags$p(" "), tags$ol(tags$li("Enter your name in the textbox (at the top of the sidebar)."), tags$li("Select a document format (PDF, HTML or Word)."),tags$li("Type any comments you may have about the results in the textbox labelled Interpretation."), tags$li("Press", tags$i("Download Report"), "button."), tags$li("Save the report on your disc.")))
              ),			  
			  box(
                title=tagList(shiny::icon("code"), "R codes"), status="primary", solidHeader=TRUE, collapsible = TRUE,  collapsed = TRUE,
                tags$h5("R codes used to generate results:", tags$p(" "), tags$ol(tags$li("List of basic R functions used in this application is given here."), tags$li("To learn more about specific R function and its arguments type the question mark followed by the function name (e.g. ?table) in the RStudio console.")))
               ) #Box
              )  # fluid row
			  ),  # tabPanel
              
			  tabPanel("Uploading data", tags$div(tags$h2("Instructions how to prepare and upload your data"), tags$h4("This application permits user to upload data in different formats: csv, tsv, xlsx and rds. Detail instructions how to structure and upload data in csv format is given here. It is very important to follow the instructions given below.")),
				
				

			  fluidRow(
			  box(
                title=tagList("STEP 1: Check 'Upload your data'"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("STEP 1: Check 'Upload your data' radio button"), tags$img(src='Menu_Start.jpg')
              )),			  
			  box(
                title=tagList("STEP 2: Click 'Browse ...'"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("STEP 2: Click 'Browse ...' button"),
				tags$p("The first row in the .csv file should contain the variable names (a 'header'). If a .csv file is uploaded without a header (and this is indicated by unchecking the entry box on the sidebar), the variables to choose from will be listed as V1, V2, V3, etc., depending on their position in the .csv file. It is best to use .csv files that include variable names as a header row."), 
                tags$img(src='Menu_Upload.jpg'),
				tags$br(),
				tags$p("If a spreadsheet was used to enter the data as illustrated below, then leave the default selections of radio buttons in the", tags$i("Separator"), "and", tags$i("Quote"), "sections.")
               )
              )),  #fluid row

			  fluidRow(
			  box(
                title=tagList("STEP 3: Enter your data"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("STEP 3: Enter your data in a spreadsheet"),
                tags$p("The best approach would begin by creating a file in a spreadsheet such as this:"), 
				tags$img(src='Data_csv.jpg')
              )),			  
			  box(
                title=tagList("STEP 4: Save it as a .csv file"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$h4("STEP 4: Save it as a .csv file"), tags$img(src='Data_save.jpg'))
              )),
			  
			  fluidRow(
			  box(
				title=tagList("STEP 5: Open the .csv file"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,
				tags$div(tags$h4("STEP 5: Open the .csv file in a text editor"), tags$p("Open the .csv file in a text editor (e.g. Notepad) and it should look like this:", tags$p(" "), tags$img(src='Data_notepad.jpg'))
              )
              )  # fluid row				
			  )),
              tabPanel("Example data", tags$div(tags$h2("Description of example datasets"), HTML("<p>This  application contains 9 datasets: </p>
<ol>
  <li> Survival  of passengers on the Titanic</li>
  <li> Hair and eye colour of statistics students</li>
  <li> Survey results of gym visitors</li>
  <li> Examination scores of statistics students</li>
  <li> Chicken diet</li>
  <li> Driving offences</li>
  <li> Pine trees</li>
  <li> Countries</li>
  <li> Marketing</li>
</ol>
<p>  The  first two datasets and the last contain categorical variables only. The rest of the datasets  have at least one categorical variable. Please notice that some of the graphical methods, tables and tests require more than one or two categorical variables and will not generate output if this is not the case. </p><p>Click the plus sign (<b>+</b>) to open the box with detailed information about the dataset.</p>")), 
			  fluidRow(
			  box(
                title=tagList(shiny::icon("database"), "Titanic dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("Survival of passengers on the Titanic"),
                tags$p("This dataset provides information on the fate of passengers on the fatal maiden voyage of the ocean liner ‘Titanic’, summarised according to economic status (class), sex, age and survival."), tags$p("There are 2201 observations on 4 variables. The variables and their levels are as follows:"), tags$br(), HTML("<table border='1' width='70%'>
  <tr>
    <td><b align='right'>No </b></td>
    <td><b>Name </b></td>
    <td><b>Levels</b></td>
  </tr>
  <tr>
    <td><p align='right'>1 </p></td>
    <td><p>Class </p></td>
    <td><p>1st,    2nd, 3rd, Crew</p></td>
  </tr>
  <tr>
    <td><p align='right'>2 </p></td>
    <td><p>Sex </p></td>
    <td><p>Male,    Female</p></td>
  </tr>
  <tr>
    <td><p align='right'>3 </p></td>
    <td><p>Age </p></td>
    <td><p>Child,    Adult</p></td>
  </tr>
  <tr>
    <td><p align='right'>4 </p></td>
    <td><p>Survived </p></td>
    <td><p>No, Yes </p></td>
  </tr>
</table>"), tags$br(), HTML("<strong>Source</strong>
<p>
Dawson,  Robert J. MacG. (1995). The &lsquo;unusual episode&rsquo; data revisited. <em>Journal of  Statistics Education</em>, <em>3</em>. <a href='http://www.amstat.org/publications/jse/v3n3/datasets.dawson.html'>http://www.amstat.org/publications/jse/v3n3/datasets.dawson.html</a></p>
<p>  The  source provides a dataset recording class, sex, age, and survival status for  each person on board of the Titanic, and is based on data originally collected  by the British Board of Trade and reprinted in: </p>
<p> British  Board of Trade (1990). <em>Report on the loss of the &lsquo;Titanic&rsquo; (S.S.)</em>.  British Board of Trade Inquiry Report (reprint). Gloucester, UK: Allan Sutton  Publishing. </p>")
              )),			  
			  box(
                title=tagList(shiny::icon("eye"), "Hair and eye colour dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$h4("Hair and eye colour of statistics students"),
                tags$p("This dataset provides information on hair, eye colour and sex in 592 statistics students."), tags$p("There are 592 observations on 3 variables. The variables and their levels are as follows:"), tags$br(), 
				HTML("<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
	spacing: 2px;
}
</style><table border='1' width='70%'>
  <tr>
    <td><b align='right'>No </b></td>
    <td><b>Name </b></td>
    <td><b>Levels </b></td>
  </tr>
  <tr>
    <td><p align='right'>1 </p></td>
    <td><p>Hair </p></td>
    <td><p>Black,    Brown, Red, Blond </p></td>
  </tr>
  <tr>
    <td><p align='right'>2 </p></td>
    <td><p>Eye </p></td>
    <td><p>Brown,    Blue, Hazel, Green </p></td>
  </tr>
  <tr>
    <td><p align='right'>3 </p></td>
    <td><p>Sex </p></td>
    <td><p>Male,    Female </p></td>
  </tr>
</table>"), tags$br(), HTML("<b>Source</b><p>Snee, R.  D. (1974). Graphical display of two-way contingency tables. <em>The American  Statistician</em>, <em>28</em>, 9–12. <br />
Friendly,  M. (1992a). Graphical methods for categorical data. <em>SAS User Group  International Conference Proceedings</em>, <em>17</em>, 190-200. <a href='http://www.math.yorku.ca/SCS/sugi/sugi17-paper.html'>http://www.math.yorku.ca/SCS/sugi/sugi17-paper.html</a></p>")
               )
              )),  #fluid row

			  fluidRow(
			  box(
                title=tagList(shiny::icon("futbol"), "Gym survey dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("Survey results of the gym visitors"),
                tags$p("This dataset provides information on survey results of gym visitors."), tags$p("There are 24 observations on 6 variables. The variables and their domains (for numeric variables) and levels (for categorical variable) are as follows:"), tags$br(), HTML("<table border='1' width='70%'>
  <tr>
    <td><strong>No</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Description &amp; Domain/Level</strong></td>
  </tr>
  <tr>
    <td>1</td>
    <td>ID</td>
    <td>Visitor    identification (from 1 to 24)</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Gender</td>
    <td>Female, Male</td>
  </tr>
  <tr>
    <td>3</td>
    <td>Age</td>
    <td>Full years at the    moment of survey (from 31 to 43)</td>
  </tr>
  <tr>
    <td>4</td>
    <td>Exercise</td>
    <td>Exercise hours:    average number of sport activities per week (from 1 hour to 8 hours)</td>
  </tr>
  <tr>
    <td>5</td>
    <td>Diet</td>
    <td>Diet    type (Low calorie, Normal, High calorie)</td>
  </tr>
  <tr>
    <td>6</td>
    <td>BMI</td>
    <td>Body    mass index measured at the time of survey (from 16.1kg/m<sup>2</sup> to 34.8 kg/m<sup>2</sup>)</td>
  </tr>
</table>"), tags$br(), HTML("<strong>Source</strong>
<p>
Course data.</p>")
              )),			  
			  box(
                title=tagList(shiny::icon("graduation-cap"), "Examination scores dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$h4("Examination scores of statistics students"),
                tags$p("This dataset provides information on assignments and overall scores of 45 statistics students."), tags$p("There are 45 observations on 4 variables. The variables and their domains (for numeric variables) and levels (for categorical variable) are as follows:"), tags$br(), 
				HTML("<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
	spacing: 2px;
}
</style><table border='1' width='70%'>
  <tr>
    <td><strong>No</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Description &amp; Domain/Level</strong></td>
  </tr>
  <tr>
    <td>1</td>
    <td>Gender</td>
    <td>Categorical variable with two categories: Female, Male.</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Overall</td>
    <td>Numeric variable: Overall course mark (from 42% to 74%).</td>
  </tr>
  <tr>
    <td>3</td>
    <td>Assignment1</td>
    <td>Numeric variable: Assignment 1 mark (from 49% to 93%).</td>
  </tr>
  <tr>
    <td>4</td>
    <td>Assignment2</td>
    <td>Numeric variable: Assignment 2 mark (from 42% to 88%).</td>
  </tr>
</table>"), tags$br(), HTML("<b>Source</b><p>Course data.</p>")
               )
              )), # fluid row
			  fluidRow(
			  box(
                title=tagList(shiny::icon("pie-chart"), "Chicken diet dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$h4("Chicken diet experiment dataset"),
                tags$p("The dataset presents the results of an experiment that was conducted to assess the effect of weight gain when three food components were included in the chickens’ diet."), tags$p("There are 60 observations on 2 variables. The variables and their domain (for numeric variable) and levels (for categorical variable) are as follows:"), tags$br(), 
				HTML("<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
	spacing: 2px;
}
</style><table border='1' width='70%'>
  <tr>
    <td><strong>No</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Description &amp; Domain/Level</strong></td>
  </tr>
  <tr>
    <td>1</td>
    <td>Weight</td>
    <td>Numeric variable: chicken's weight (measured in grams) (from 108 grams to 423 grams).</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Feed</td>
    <td>Categorical variable with the following categories: linseed, soybean, sunflower.</td>
  </tr>
</table>"), tags$br(), HTML("<b>Source</b><p>Course data.</p>")
               )),			  
			  box(
                title=tagList(shiny::icon("car"), "Driving offences dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("Survey results on drivers"),
                tags$p("This dataset provides information on survey results on drivers with a registered driving offence over the last five years."), tags$p("There are 125 observations on 2 variables. The variables and their domain (for numeric variable) and levels (for categorical variable) are as follows:"), tags$br(), HTML("<table border='1' width='70%'>
  <tr>
    <td><strong>No</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Description &amp; Domain/Level</strong></td>
  </tr>
  <tr>
    <td>1</td>
    <td>Experience</td>
    <td>Level of driver's experience. Categorical variable with three categories: 0-5yrs, 6-11yrs, 12+yrs.</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Offence</td>
    <td>Number of driving offences over the last five years. Numeric variable: from 1 to 6.</td>
  </tr>
</table>"), tags$br(), HTML("<strong>Source</strong>
<p>
Course data.</p>")
              ))), # fluid row
			  fluidRow(
			  box(
                title=tagList(shiny::icon("tree"), "Pine trees dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("Observations of pine trees"),
                tags$p("This dataset provides information on observations of pine trees in three growing areas within a nursery, all planted at the same time."), tags$p("There are 63 observations on 2 variables. The variables and their domain (for numeric variable) and levels (for categorical variable) are as follows:"), tags$br(), HTML("<table border='1' width='70%'>
  <tr>
    <td><strong>No</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Description &amp; Domain/Level</strong></td>
  </tr>
  <tr>
    <td>1</td>
    <td>Area</td>
    <td>Categorical variable: Growing areas within a nursery: A, B and C. </td>
  </tr>
  <tr>
    <td>2</td>
    <td>Height</td>
    <td>Numeric variable: Height of pine tree measured in centimeters (from 4 to 62).</td>
  </tr>
</table>"), tags$br(), HTML("<strong>Source</strong>
<p>
Course data.</p>")
              )),
			  box(
                title=tagList(shiny::icon("map"), "Countries dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$h4("Countries GDP per capita and CO2 emissions"),
                tags$p("This dataset provides information about GDP per capita and CO2 emissions for 187 countries in the world."), tags$p("There are 187 observations on 3 variables. The variables and their domains (for numeric variables) are as follows:"), tags$br(), 
				HTML("<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
	spacing: 2px;
}
</style><table border='1' width='70%'>
  <tr>
    <td><strong>No</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Description &amp; Domain/Level</strong></td>
  </tr>
  <tr>
    <td>1</td>
    <td>Country</td>
    <td>Not a variable, but just a label for the cases in this dataset.</td>
  </tr>
  <tr>
    <td>2</td>
    <td>GDPpc</td>
    <td>Numeric variable: GDP per capita based on purchasing power parity (PPP). (from $617 to $134,117).</td>
  </tr>
  <tr>
    <td>3</td>
    <td>CO2</td>
    <td>Numeric variable: CO2 emissions (metric tons per capita) (from 0.02 to 44.02).</td>
  </tr>
</table>"), tags$br(), HTML("<b>Source</b><p>World Bank.</p>")
               )
              )
), # fluid row

			  fluidRow(
			  box(
                title=tagList(shiny::icon("line-chart"), "Marketing dataset"), status="primary", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$h4("Marketing survey results"),
                tags$p("This dataset provides information on marketing survey results."), tags$p("There are 356 observations on 2 variables. The variables and their levels are as follows:"), tags$br(), HTML("<table border='1' width='70%'>
  <tr>
    <td><strong>No</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Description &amp; Domain/Level</strong></td>
  </tr>
  <tr>
    <td>1</td>
    <td>Marketing</td>
    <td>Categorical variable with three categories: Current, Former and Never. </td>
  </tr>
  <tr>
    <td>2</td>
    <td>Growth</td>
    <td>Categorical variable with three categories: Low, Middle, High.</td>
  </tr>
</table>"), tags$br(), HTML("<strong>Source</strong>
<p>
Course data.</p>")
              ))			  
			  
			  ) # fluid row
		  
			  ) # tabPanel (Example data)
         )   
    ),

##############################################################################
#
#   GRAPHS SECTION Categorical
#
##############################################################################
#
# Bar charts (graph)
#####################
    tabItem("graphsCat", 
            tabBox(
              title = "Graphs",
              # The id lets us use input$tabset5 on the server to find the current tab
              id = "tabset5", 
              width = NULL,	
              tabPanel("Bar chart", tags$div(tags$h2("Bar chart"), tags$h4("A bar chart is a graphical representation of the distribution of qualitative data (i.e. categorical variable)."), 
                HTML("<em>Bar chart</em> is a form of graphical  representation of categorical variables. It displays data classified into a  number of (usually unordered) categories. Equal-width rectangular bars are constructed  over each category with height equal to the observed frequency of the category. </p><p><em>Stacked (component) bar  chart</em> shows the component parts as sectors of the bar with lengths in  proportion to the relative size. </p><p><em>Grouped (clustered) bar  chart</em> shows information about different sub-groups of the main categories. A separate  bar represents each of the sub-groups (usually coloured or shaded differently  to distinguish between them. In such cases, a legend or key is provided. ")
              ),
			  fluidRow(
			  box(
                title="About a bar chart", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("All bars have the same width."), tags$li("Bars can be shown vertically or horizontally."), tags$li("The categories are shown on one of the axes."), tags$li("The frequency of the data in category is represented by the height/length of the bar."), tags$li("Titles and labels for both axes should be included."), tags$li("A legend should be included for stacked and grouped bar charts."), tags$li("There is an explanatory title or caption underneath the graph.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("Is the order of categories important? In some cases alphabetical ordering or some other arrangement might be used to produce more useful graphical display."), tags$li("Which is the modal or most frequent category?")))  
              )),
			  fluidRow(
              box(
                title="Bar chart", status="primary", solidHeader=TRUE, collapsible = TRUE,  
                textOutput("textBar"),

                plotOutput("barGraph")
              ),
              box(
                title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE, 
			    uiOutput("selectBar")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_bar.md")
               )			  
			  ),
              textInput("text_graphcat1", label="Interpretation", value="", placeholder="Enter text ...")
              ),
###################
# Dotplots (graph)
###################
              tabPanel("Dotplot", tags$div(tags$h2("Dotplot"), tags$h4("A dotplot is a type of graphic display used to compare frequency counts within categories or groups."), tags$p("Dotplots are an alternative to bar charts or pie charts, and look somewhat like a horizontal bar chart where the bars are replaced by a dot at the frequency associated with each category. Optionally, horizontal lines are also included connecting dots with the vertical axis. ")
              ),
			  fluidRow(
			  box(
                title="About a dotplot", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("Dotplots are less cluttered than the bar charts."), tags$li("Compared to other types of graphic display, dotplots are used most often to plot frequency counts within a small number of categories, usually with small sets of data."), tags$li("Titles and labels for both axes should be included."), tags$li("Title for the horizontal axis is", tags$i("Frequency"), "or", tags$i("Count.")), tags$li("There is an explanatory title or caption underneath the graph.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("Multi-panel side-by-side display might be used for comparing several contrasting or similar cases. Use same scales for the horizontal axis across different panels."), tags$li("Consider ordering categories by frequencies represented, for more accurate perception.")))  
              )),
			  fluidRow(
			  box(
                title="Dotplot", status="primary", solidHeader=TRUE, collapsible = TRUE,				
                plotOutput("dotPlot")
              ), 
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_dotplot.md")
               )
			  ),
              textInput("text_graphcat2", label="Interpretation", value="", placeholder="Enter text ...")
              ),
###################
# Pie chart (graph)
###################
			  tabPanel("Pie chart", tags$div(tags$h2("Pie chart"), tags$h4("Pie chart is a graphical technique for presenting relative frequencies associated with the observed values of a categorical variable."), tags$p("The pie chart consists of a circle subdivided into sectors (sometimes called slices) whose sizes are proportional to the quantities they represent. Such displays are popular in the media but have little relevance for serious scientific work when other graphics are generally far more useful (e.g. bar chart and dot plot). ") 
              ),
			  fluidRow(
			  box(
                title="About a pie chart", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$ol(tags$li("Slices have to be mutually exclusive; by definition, they cannot overlap."), tags$li("There are two features that let us read the values on a pie chart: the angle a slice covers (compared to the full circle), and the area of a slice (compared to the entire circle)."), tags$li("Use of 3D pie charts is not recommended. Firstly, it makes it more difficult to read the chart. Secondly, different software my produce different 3D charts. A third problem with 3D charts is that they suggest we know more about the data than we really do. In case of pie charts adding unnecessary dimensions or adding perspective to the pies distorts the data."),tags$li("Legend should be included or each slice should have its own label. Number or percentage in each slice can also be shown."), tags$li("There is an explanatory title or caption underneath the chart.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("We are not very good at measuring angles, but we recognize 90 and 180 degree angles with very high precision. Slices that cover half or a quarter of the circle will therefore stand out. Others can be compared with some success, but reading actual numbers from a pie chart is next to impossible."), tags$li("Do the parts make up a meaningful whole? If not, use a different chart."), tags$li("Do we want to compare the parts to each other or the parts to the whole? If the main purpose is to compare between the parts, use a different chart. The main purpose of the pie chart is to show part-whole relationships."), tags$li("How many parts do we have? If there are more than five to seven, use a different chart. Pie charts with lots of slices (or slices of very different size) are hard to read.")))  
              )),			  
			  fluidRow(
			  box(
                title="Pie chart", status="primary", solidHeader=TRUE, collapsible = TRUE, 
			     plotOutput("pieChart")
              ),			  
			  box(
                title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE
				,
                uiOutput("displayPie")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_pie.md")
               )				  
			  ),
			  textInput("text_graphcat3", label="Interpretation", value="", placeholder="Enter text ...")
              ),  
#######################
# Mosaic plots (graph)
#######################
              tabPanel("Mosaic plot", tags$div(tags$h2("Mosaic plot"), tags$h4("A mosaic plot is a graphical display that allows examination of the relationship among two or more categorical variables."), 
                tags$p("The mosaic plot is a graphical representation of the two-way frequency table or contingency table. A mosaic plot is divided into rectangles, so that the vertical length of each rectangle represents the proportions of the Y variable at each level of the X variable.")
              ),
			  fluidRow(
			  box(
                title="About a mosaic plot", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("The displayed variables are categorical or ordinal scales."), tags$li("The plot is of at least two variables. There is no upper limit on the number of variables, but too many variables may be confusing in graphic form."), tags$li("The surfaces of the rectangular fields that are available for a combination of features are proportional to the number of observations that have this combination of features."), tags$li("Independence is shown when the boxes across categories all have the same areas."), tags$li("The significance of different frequencies of the various characteristic values cannot be observed visually."), tags$li("The colours represent the level of the residual for that cell / combination of levels. The legend is presented at the plot's right. Blue means there are more observations in that cell than would be expected under the independence. Red means there are fewer observations than would have been expected. This is showing you which cells are contributing to the significance of the chi-squared test result."), 
                tags$li("For", tags$i("Hair and eye colour"), "dataset the mosaic plot indicates that there are more blue-eyed blond students than expected under independence and too few brown-eyed blond students.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("Variables that represent an exposure or treatment status should usually represent the first split (i.e. division into rectangles) and variables that represent an outcome should represent the second split."), tags$li("The categorical variables should be sorted first. Then each variable is assigned to an axis. Another order of categorical variables will result in a different mosaic plot, i.e., as in all multivariate plots, the order of variables plays a role.")))  
              )),	
			  fluidRow(
			  box(
                title="Mosaic plot", status="primary", solidHeader=TRUE, collapsible = TRUE
				,  
                textOutput("textMosaic"),
				plotOutput("mosaic")
              ), 
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_mosaic.md")
               )	
			  ),
              textInput("text_graphcat4", label="Interpretation", value="", placeholder="Enter text ...")
              ),

###########################
# Association plots (graph)
###########################
              tabPanel("Association plot", tags$div(tags$h2("Association plot"), tags$h4("An association plot indicates deviations from a specified independence model in a possibly high-dimensional contingency table.")
              ),
			  fluidRow(
			  box(
                title="About an association plot", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("The rectangles for each row in the table are positioned relative to a baseline representing independence shown by a dotted line."), tags$li("Cells with an observed frequency greater than the expected frequency (assuming independence) rise above the line and are coloured blue; cells that contain less than the expected frequency fall below it and are shaded red."), tags$li("The main purpose of the shading is not to visualize significance but the", tags$i("pattern"), "of deviation from independence.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("Variables that represent an exposure or treatment status should usually represent the first split (i.e. division into rectangles) and variables that represent an outcome should represent the second split."), tags$li("The categorical variables should be sorted first. Then each variable is assigned to an axis. Another order of categorical variables will result in a different mosaic plot, i.e., as in all multivariate plots, the order of variables plays a role.")))  
              )),
			  fluidRow(
			  box(
                title="Association plot", status="primary", solidHeader=TRUE, collapsible = TRUE,  
                textOutput("textAssoc"),
                plotOutput("assocPlot")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_assoc.md")
               )				  
			  ),
              textInput("text_graphcat5", label="Interpretation", value="", placeholder="Enter text ...")
              ),
##########################
# Agreement plots (graph)
##########################
              tabPanel("Agreement plot", tags$div(tags$h2("Agreement plot"), tags$h4("An agreement plot provides a simple graphic representation of the strength of agreement in a contingency table, and a measure of strength of agreement with an intuitive interpretation."), tags$p("Inter-observer agreement is often used as a method of assessing the reliability of a subjective classification or assessment procedure. For example, two (or more) clinical psychologists might classify patients on a scale with categories: normal, mildly impaired, severely impaired. ")
              ),
			  fluidRow(
			  box(
                title="About an agreement plot", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("The agreement chart is constructed as an", tags$i("n"), "x", tags$i("n"), "square, where", tags$i("n"), "is the total sample size."), tags$li("Black squares show observed agreement. These are positioned within larger rectangles"), tags$li("The large rectangle shows the maximum possible agreement, given the marginal totals.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("Observers' ratings can be strongly associated without strong agreement."), tags$li("If observers tend to use the categories with different frequency, this will affect measures of agreement.")))  
              )),
			  fluidRow(
			  box(
                title="Agreement plot", status="primary", solidHeader=TRUE, collapsible = TRUE, 
                textOutput("textAgree"),
                plotOutput("agreePlot")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_agree.md")
               )				  
			  ),
              textInput("text_graphcat6", label="Interpretation", value="", placeholder="Enter text ...")
              ),
##################################
# Correspondence analysis (graph)
##################################
			  tabPanel("Correspondence plot", tags$div(tags$h2("Correspondence analysis plot"), tags$h4("Graphical display of the relationship between categorical variables in a type of scatterplot diagram."), 
                tags$p("Two categorical variables are displayed in the form of a contingency table, i.e. two-way table. From a contingency table a set of coordinate values representing the row and column categories are derived. A small number of these derived coordinate values (usually two) are then used to allow the table to be displayed graphically. ")
              ),
			  fluidRow(
			  box(
                title="About a correspondence plot", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$ol(tags$li("The row profile is defined as the counts in a row divided by the total count for that row. If two rows have very similar row profiles, their points in the correspondence analysis plot are close together."), tags$li("The coordinates are analogous to those resulting from a principal component analysis of continuous variables."), tags$li("They involve a partition of a chi-squared statistic rather than the total variance.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("Column and row profiles are alike because the problem is defined symmetrically."), tags$li("The distance between a row point and a column point has no meaning."), tags$li("The directions of columns and rows from the origin are meaningful, and the relationships help interpret the plot.")))  
              )),
			  fluidRow(
              box(
                title="Correspondence plot", status="primary", solidHeader=TRUE, collapsible = TRUE, 
                textOutput("textCorrespond1"),
                plotOutput("correspond")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_correspond.md")
               )				  
			  ),
              textInput("text_graphcat7", label="Interpretation", value="", placeholder="Enter text ...")
              )
			  
            )
    ),  
# ##########################
#   T A B L E S Categorical
# ##########################
    tabItem("tablesCat", 
            tabBox(
              title = "Tables",
              # The id lets us use input$tabset6 on the server to find the current tab
              id = "tabset6", 
              width = NULL,	
######################################################
# Display raw dataset with downloading option (table)
######################################################
			  tabPanel("Dataset", tags$div(tags$h2("Display and download dataset"), tags$h4("Display the dataset selected and download the file with the example dataset used. Take a simple random sample from the dataset used. "), HTML("<ol><li>To  take a simple random sample from a dataset, select the check box labelled <em>Take a simple random sample</em>. </li><li>Set the  <em>Sample size</em> to the required number of observations. </li><li>Change the seed if a new sample is required. When the same number is used for a seed, the sample generated will be the same each time. </li><li>Select the check box labelled <em>Take a sample with replacement</em> if a sample with replacement is wanted. </li><li>Click <em>Download sample</em> button to download a generated sample and save it on a hard drive. </li><li>To analyse a sample upload the saved .csv file and continue using the application. </li>
</ol>")), 
              fluidRow(
			  box(
                title = "Dataset", status="primary", solidHeader=TRUE, collapsible = TRUE, width =6,
                uiOutput('downl'), tags$p(" "),
				numericInput("obs", label="Number of observations to view", 5),
                tableOutput("view")
              ),
			   box(
                 title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE, 
                 uiOutput("samplingBut"), 
				 uiOutput("sampleSize"),
                 uiOutput("seed"),				
				 uiOutput("replacement"),
				 uiOutput("actionBut"), tags$p(" "),
				 uiOutput('downSampleBut')
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_dataset.md")
               )				  
			  ),
              textInput("text_tablecat1", label="Interpretation", value="", placeholder="Enter text ...")	
              ),
########################################################
# Two different lists of descriptive statistics (table)
########################################################
			  tabPanel("Descriptive statistics", tags$div(tags$h2("Descriptive statistics"), tags$h4("We summarise categorical variable basically by counting occurrences to give us a frequency. If the categories are coded then the psych package provides also mean values and standard deviations.")
              ),
			  		  
              fluidRow(
			  box(
                title = "Descriptive statistics (base package)", status="primary", solidHeader=TRUE, collapsible = TRUE,
                width = 12
				,	
                verbatimTextOutput("summary")
              )),
              fluidRow(
			  box(
                title = "Descriptive statistics (psych package)", status="primary", solidHeader=TRUE, collapsible = TRUE,
                width = 12
				,
                uiOutput("facCheckBox"),				
                verbatimTextOutput("summary1")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_desc.md")
               )				  
			  ),
              textInput("text_tablecat2", label="Interpretation", value="", placeholder="Enter text ...")
              ),
#########################
# Two-way tables (table)
#########################
              tabPanel("Frequency tables", tags$div(tags$h2("Frequency tables"), tags$h4("We summarise categorical variable by counting up frequencies and by counting occurrences to give us proportions and percentages."), 
                    tags$p("The frequency distribution of a categorical variable is a summary of the data occurrence in a collection of non-overlapping categories. The relative frequency distribution of a categorical variable is a summary of the frequency proportion in a collection of non-overlapping categories.")
              ),	  
              fluidRow(
			  box(
                title="Frequency table", status="primary", solidHeader=TRUE, collapsible = TRUE,
                tableOutput("twoWayTable")
              ), 
			  	box(
                title="Cell percentages", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTableCP")
              )),
              fluidRow(
			  box(
                title="Expected frequencies", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTableExpect")
              ), 
			  	box(
                title="Expected frequencies (relative)", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTableExpectRel")
              )),
              fluidRow(
			  box(
                title="Marginal frequencies (1st variable)", status="primary", solidHeader=TRUE, collapsible = TRUE,
				htmlOutput("twoWayTableMA")
              ),
			  	box(
                title="Marginal frequencies (2nd variable)", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTableMB")
              )),
              fluidRow(
			  box(
                title="Marginal percentages (1st variable)", status="primary", solidHeader=TRUE, collapsible = TRUE,
				htmlOutput("twoWayTableMPA")
              ),
			  	box(
                title="Marginal percentages (2nd variable)", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTableMPB")
              )),			  
              fluidRow(
			  box(
                title="Row percentages", status="primary", solidHeader=TRUE, collapsible = TRUE,
				htmlOutput("twoWayTablePR")
              ),
			  	box(
                title="Column percentages", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTablePC")
              ), 
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_freq.md")
               )				  
			  ),				  
              textInput("text_tablecat3", label="Interpretation", value="", placeholder="Enter text ...")
              ),
##################################
# Measures of Association (tables)
##################################
			  tabPanel("Association Statistics", tags$div(tags$h2("Measures of Association"), tags$h4("Computes the Pearson chi-squared test, the likelihood ratio chi-squared test, the phi coefficient, the contingency coefficient and Cramer’s V.")
              ),
			  fluidRow(
			  box(
                title="About the association statistics", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$ol(tags$li("Pearson's chi-squared test is a statistical test applied to sets of categorical data to evaluate how likely it is that any observed difference between the sets arose by chance."), tags$li("The likelihood ratio chi-square builds on the likelihood of the data under the null hypothesis relative to the maximum likelihood. This is the usual statistic for log-linear analyses."), tags$li("The phi coefficient is a measure of association for two binary variables. This measure is similar to the Pearson correlation coefficient in its interpretation."), tags$li("The contingency coefficient is an adjustment to the phi coefficient, intended to adapt it to tables larger than 2x2."), tags$li("Cramer's V is the most popular of the chi-square-based measures of nominal association because it is designed so that the attainable upper limit is always 1.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$ol(tags$li("The phi coefficient is often used as a measure of association in 2x2 tables formed by true dichotomies."), tags$li("The contingency coefficient will be always less than 1 and will be approaching 1.0 only for large tables. The larger the contingency coefficient the stronger the association. Some researchers recommend it only for 5x5 tables or larger. For smaller tables it will underestimated the level of association."), tags$li("In the case of a 2×2 contingency table Cramér's V is equal to the phi coefficient.")))  
              )),
              fluidRow(
			  box(
                title="Association statistics", status="primary", solidHeader=TRUE, collapsible = TRUE,
				textOutput("textTblAssoc"),
				verbatimTextOutput("tblAssoc")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_assoctab.md")
               )				  
			  ),					  
              textInput("text_tablecat4", label="Interpretation", value="", placeholder="Enter text ...")
              ),
#################################
# Correspondence Analysis (table)
#################################
			  tabPanel("Correspondence analysis", tags$div(tags$h2("Correspondence analysis"), tags$h4("Correspondence analysis is one of a wide range of alternative ways of handling and representing the relationships between categorical data.")
              ),
			  fluidRow(
			  box(
                title="About the correspondence analysis", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$ol(tags$li("The correspondence analysis results provide information which is similar to that produced by principal components analysis or factor analysis."), tags$li("The multivariate treatment of the data through multiple categorical variables is an important feature of correspondence analysis."), tags$li("It has the advantage of revealing relationships which couldn't be detected during a series of pair wise comparisons of variables.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$ol(tags$li("The correspondence analysis is an exploratory technique."), tags$li("There are no statistical significance tests that are customarily applied to the results of a correspondence analysis."), tags$li("The primary purpose of the technique is to produce a simplified (low- dimensional) representation of the information in a large frequency table (or tables with similar measures of correspondence).")))  
              )),
              fluidRow(
			  box(
                title="Correspondence analysis", status="primary", solidHeader=TRUE, collapsible = TRUE,
				textOutput("textCorrespond2"),
				verbatimTextOutput("tblCorrespond")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_correspondtab.md")
               )				  
			  ),			  
              textInput("text_tablecat5", label="Interpretation", value="", placeholder="Enter text ...")
              )
)
    ), #tables

#
# ################################
#   I N F E R E N C E categorical
# ################################
#    
    tabItem("inferenceCat", 
            tabBox(
              title = "Inference",
              # The id lets us use input$tabset7 on the server to find the current tab
              id = "tabset7", 
              width = NULL,	
############################
# Chi-squared test raw data
############################
			  tabPanel("Chi-squared test (raw data)", tags$div(tags$h2("Chi-squared test (raw data)"), tags$h4("The chi-squared test is used to test independence of the row and column variables in the two-way/contingency tables.")
			  ),
			  fluidRow(
			  box(
                title="About the chi-squared test", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("Null hypothesis is that there is no association between the row and column classifications. Alternative hypothesis is that there is association between the row and column classifications."), tags$li("Chi-squared test statistic compares the entire set of observed counts with the set of counts expected if there was no association."), tags$li("The chi-squared statistic is a measure of how much the observed cell counts in a two-way table diverge from the expected cell counts.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$ol(tags$li("The large values of the chi-squared statistic provide evidence against the null hypothesis."), tags$li("Under the assumption that null hypothesis is true the sampling distribution follows the chi-squared distribution."), tags$li("The chi-squared test always uses the upper tail of the chi-squared distribution."), tags$li("For 2x2 tables, all expected cell counts should be 5 or greater."), tags$li("For larger tables, the average expected cell count should be 5 or greater and all expected cell counts are 1 or greater.")))  
              )),
			  fluidRow(
			  box(
                title="Chi-squared test", status="primary", solidHeader=TRUE, collapsible = TRUE
				,
                #textOutput("textChisqTest"),
 				 verbatimTextOutput("chisqTest")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_chi.md")
               )				  
			  
			  ),
              textInput("text_infercat1", label="Interpretation", value="", placeholder="Enter text ...")
              ),
###################################
# Chi-squared test aggregated data
###################################
			  tabPanel("Chi-squared test (aggregated data)", tags$div(tags$h2("Chi-squared test (aggregated data)"), tags$h4("The chi-squared test is used to test independence of the row and column variables in the two-way/contingency tables.")
			  ),
			  fluidRow(
			  box(
                title="About the chi-squared test", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("Null hypothesis is that there is no association between the row and column classifications. Alternative hypothesis is that there is association between the row and column classifications."), tags$li("Chi-squared test statistic compares the entire set of observed counts with the set of counts expected if there was no association."), tags$li("The chi-squared statistic is a measure of how much the observed cell counts in a two-way table diverge from the expected cell counts.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$ol(tags$li("The large values of the chi-squared statistic provide evidence against the null hypothesis."), tags$li("Under the assumption that null hypothesis is true the sampling distribution follows the chi-squared distribution."), tags$li("The chi-squared test always uses the upper tail of the chi-squared distribution."), tags$li("For 2x2 tables, all expected cell counts should be 5 or greater."), tags$li("For larger tables, the average expected cell count should be 5 or greater and all expected cell counts are 1 or greater.")))  
              )),
			  fluidRow(
			  box(
                title="Chi-squared test", status="primary", solidHeader=TRUE, collapsible = TRUE
				,
                textOutput("textChisqTest1"),
 				verbatimTextOutput("chisqTest1")
              ),
			  box(
                title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE,
				numericInput("numRow", label="Number of rows:", value=2, step=1, min=2, max=6), 
				numericInput("numColumn", label="Number of columns:", value=2, step=1, min=2, max=6), 
				textInput("numCounts", label="Frequencies in the two-way table by rows separated by commas:", value="100,200,55,75"), 
				actionButton("goaggButton","Run the test!")
              )), 
              fluidRow(
			  box(
                title="Expected frequencies", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTableExpect1")
              ), 
			  	box(
                title="Expected frequencies (relative)", status="primary", solidHeader=TRUE, collapsible = TRUE,
                htmlOutput("twoWayTableExpectRel1")
              )),			  
			  fluidRow(
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_chi.md")
               )				  
			  ),
              textInput("text_infercat2", label="Interpretation", value="", placeholder="Enter text ...")
              ),
#####################
# Fisher exact test
#####################
			  tabPanel("Fisher's exact test", tags$div(tags$h2("Fisher exact test"), tags$h4("Fisher's exact test provides an exact test of independence of the row and column variables in the two-way/contingency tables.") 
              ),
			  fluidRow(
			  box(
                title="About the Fisher's exact test", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$ol(tags$li("Null hypothesis is that there is no association between the row and column classifications. Alternative hypothesis is that there is association between the row and column classifications."), tags$li("The", tags$i("p"), "-value provided by this test is correct no matter what the sample size."), tags$li("The", tags$i("p"), "-value for Fisher's exact test is considerably different to the", tags$i("p"), "-value from the", tags$i("z"),"test and therefore chi-squared test.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("The Fisher’s exact test is used when the sample size is small to avoid using an approximation that is known to be unreliable for small samples."), tags$li("For 2x2 tables, the null hypothesis of conditional independence is equivalent to the hypothesis that the odds ratio equals one."))) 
              )),
			  fluidRow(
			  box(
                title="Fisher's exact test", status="primary", solidHeader=TRUE, collapsible = TRUE
				,
                textOutput("textFisher"),
 				 verbatimTextOutput("fisherTest")
              ),
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_fisher.md")
               )	
			  ),			  
              textInput("text_infercat3", label="Interpretation", value="", placeholder="Enter text ...")
              ),
#######################
# Mantel-Haenszel test
#######################
			  tabPanel("Mantel-Haenszel test", tags$div(tags$h2("Mantel-Haenszel test"), tags$h4("Mantel-Haenszel chi-squared test is used to test the null hypothesis that two nominal variables are conditionally independent in each stratum."), 
                tags$p("This test assumes that there is no three-way interaction. Input into this test is a 3-dimensional contingency table, where the last dimension refers to the strata.")
              ),
			  fluidRow(
			  box(
                title="Features of the Mantel-Haenszel test", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("The null hypothesis is that the relative proportions of one variable are independent of the other variable within the repeats; in other words, there is no consistent difference in proportions in the 2×2 tables."), tags$li("Technically, the null hypothesis of the Mantel-Haenszel test is that the odds ratios within each repetition are equal to 1. The odds ratio is equal to 1 when the proportions are the same, and the odds ratio is different from 1 when the proportions are different from each other.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$ol(tags$li("The most common situation when we use this test is when we have multiple 2×2 tables of independence, and we've done the experiment multiple times or at multiple locations. There are three nominal variables: the two variables of the 2×2 test of independence, and the third nominal variable that identifies the repeats (such as different times, different locations, or different studies).")))  
              )),
			  fluidRow(
			  box(
                title="Mantel-Haenszel test", status="primary", solidHeader=TRUE, collapsible = TRUE
				,
                textOutput("textMantel"),
 				verbatimTextOutput("mantelTest")
              ),
			  box(
                title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE
				,
				uiOutput('fv3')
              )),
			  fluidRow(			  
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_mantel.md")
               )				  
			  ),				  
              textInput("text_infercat4", label="Interpretation", value="", placeholder="Enter text ...")
              ),
##########################
# Log-linear model tests
##########################
			  tabPanel("Log-linear model tests", tags$div(tags$h2("Log-linear model tests"), tags$h4("For a log-linear models based on a three-dimensional contingency tables the following tests are performed: mutual, partial, and conditional independence and no three-way interaction.")
              ),
			  fluidRow(
			  box(
                title="About the log-linear model tests", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("Log-linear analysis is an extension of the two-way contingency table where the conditional relationship between two or more discrete, categorical variables is analysed by taking the natural logarithm of the cell frequencies within a contingency table."), tags$li("They are more commonly used to evaluate multi-way contingency tables that involve three or more variables."), tags$li("The variables investigated by log-linear models are all treated as “response variables”. In other words, no distinction is made between independent and dependent variables. Therefore, log-linear models only demonstrate association between variables.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("The term log-linear derives from the fact that one can, through logarithmic transformations, restate the problem of analysing multi-way frequency tables in terms that are very similar to ANOVA."), tags$li("Specifically, one may think of the multi-way frequency table to reflect various main effects and interaction effects that add together in a linear fashion to bring about the observed table of frequencies."), tags$li("The Chi-squares of models that are hierarchically related to each other can be directly compared."), tags$li("Two models are hierarchically related to each other if one can be produced from the other by either adding terms (variables or interactions) or deleting terms (but not both at the same time). ")))  
              )),	
			  fluidRow(
			  box(
                title="Log-linear model tests", status="primary", solidHeader=TRUE, collapsible = TRUE
				,
                textOutput("textLoglin"),
 				verbatimTextOutput("loglinTest")
              ),
			  box(
                title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE
				,
				uiOutput('fv3a'), 
				selectInput('selectionLoglin', 'Select test for a log-linear model:', choices=c("Mutual independence"="1", "Partial independence"="2", "Conditional independence" = "3", "No three-way interaction" = "4")),
				actionButton("goButton2","Run the test!")
              )),
			  fluidRow(			  
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_loglin.md")
               )				  
			  ),				  
              textInput("text_infercat5", label="Interpretation", value="", placeholder="Enter text ...")
              ),
###########################
# Inference in proportion
###########################
			  tabPanel("Proportions", tags$div(tags$h2("Test of equal or given proportions"), tags$h4("Performs the test for testing the null hypothesis that the proportions (probabilities of success) in several groups are the same, or that they equal certain given values.") 
			   ),
			  fluidRow(
			  box(
                title="About the test of equal or given proportions", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
                tags$div(tags$ol(tags$li("Only groups with finite numbers of successes and failures are used."), tags$li("When entering data in the Input box counts of successes and failures must be non-negative and hence not greater than the corresponding numbers of trials which must be positive."), tags$li("All finite counts should be integers.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
              tags$div(tags$ol(tags$li("We may use the chi-squared test of independence to test for equality of proportions between populations."), tags$li("In case of small samples use the Yates' continuity correction.")))  
              )),
			  fluidRow(
			  box(
                title="Proportions tests", status="primary", solidHeader=TRUE, collapsible = TRUE
				,
                textOutput("textProp"),
 				verbatimTextOutput("propTest")
              ),
			  box(
                title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE,
				textInput("numSuccess", label="Number of successes:", value="35,41"), 
				textInput("numTotal", label="Total number of observations:", value="53,72"), 
				textInput("pNull", label="Proportion for null hypothesis:", value="0.5,0.5"), 
				radioButtons("pAlter", label="Alternative hypothesis:", choices=c("Two-sided" = "two.sided", "Less" = "less", "Greater" = "greater" ), selected="two.sided", inline=TRUE), 
				numericInput("pConf", label="Confidence level:", value=0.95, step=0.01, min=0.01, max=0.99),
				checkboxInput("pCorrect", label="Yates's continuity correction:", value=FALSE),
				actionButton("goButton","Run the test!")
              )), 
			   fluidRow(
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_prop.md")
               )				  
			  ),			  
              textInput("text_infercat6", label="Interpretation", value="", placeholder="Enter text ...")
              ),
##################################################
# Inference in proportion (binomial test)
##################################################
			  tabPanel("Binomial test", tags$div(tags$h2("Binomial test"), tags$h4("Performs an exact test of a simple null hypothesis about the probability of success in a Bernoulli experiment.") 
			  ),
			  fluidRow(
			  box(
                title="About a binomial test", status="success", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
                tags$div(tags$ol(tags$li("It is assumed that the variable of interest is considered to be dichotomous in nature where the two values are mutually exclusive and mutually exhaustive in all cases being considered."), tags$li("The sample size is much smaller than the population size."), tags$li("The sample is representative for the target population."), tags$li("Assumption of independent and identically distributed variables is met.")))
              ),			  
			  box(
                title="Things to think about", status="danger", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE,  
              tags$div(tags$ol(tags$li("This test can also be used to test hypotheses about the median of a population."), tags$li("It is a nonparametric analog of the one sample t-test and may come in handy when the population of interest is not normally distributed and the sample size is small (e.g., less than 30)")))  
              )),
			  fluidRow(
			  box(
                title="Binomial test for proportions", status="primary", solidHeader=TRUE, collapsible = TRUE
				,
                textOutput("textBinom"),
 				verbatimTextOutput("binomTest")
              ),
			  box(
                title="Inputs", status="warning", solidHeader=TRUE, collapsible = TRUE,
				numericInput("numSuccess1", label="Number of successes:", value=35, step=1, min=0), 
				numericInput("numTotal1", label="Total number of observations:", value=53, step=1, min=1), 
				numericInput("pNull1", label="Proportion for null hypothesis:", value=0.5, step=0.01, min=0.01, max=0.99), 
				radioButtons("pAlter1", label="Alternative hypothesis:", choices=c("Two-sided" = "two.sided", "Less" = "less", "Greater" = "greater" ), selected="two.sided", inline=TRUE), 
				numericInput("pConf1", label="Confidence level:", value=0.95, step=0.01, min=0.01, max=0.99),
				actionButton("goButton1","Run the test!")
              )),
			  fluidRow(
			   box(
                 title="R codes", status="info", solidHeader=TRUE, collapsible = TRUE, collapsed = TRUE, 
			     includeMarkdown("www/inc_binomial.md")
               )				  
			  ),
			  
              textInput("text_infercat7", label="Interpretation", value="", placeholder="Enter text ...")
            )	
    ))	# inference
  ) #tabItems
) #dashboardBody

# #######################################
#      U S E R   I N T E R F A C E
# #######################################
ui <- dashboardPage(
  dashboardHeader(title = "Categorical Data Analysis", titleWidth=300),
  
  dashboardSidebar(
    # 
    #
    # 
    sidebarMenu(id="tabs", textInput("name", label=h5("Enter your name"), value="", placeholder="Name"),
                menuItem("Introduction", tabName = "intro", icon = icon("info-circle")),
                radioButtons("data", "Data source:", c("None selected" = "", "Use example data" = "sample", "Upload your data" = "yourData")),
                
                conditionalPanel(
                  condition = "input.data == 'sample'",
                  selectInput(inputId = "dataInput", "Select the dataset:", 
                              choices = c("Titanic", "Hair and eye colour", "Exam scores", "Gym survey", "Chicken diet", "Driving offences", "Pine trees", "Marketing survey", "Countries"))
                ), 
				
                conditionalPanel(
                  condition = "input.data == 'yourData'",
                  fileInput(
                    inputId = "dataInput2",
                    label   = "Upload data file:",
                    accept  = c(".csv", ".tsv", ".xlsx", ".rds",
                                "text/csv", "text/tab-separated-values", "text/plain")
                  ),
                  checkboxInput('header', 'Header contains names of variables', TRUE),
                  radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ','),
                  radioButtons('quote', 'Quote', c(None='', 'Double Quote'='"', 'Single Quote'="'"), '"')
                ),
                
                conditionalPanel(
                   condition = "input.data == 'sample' || (input.data=='yourData' && output.fileUploaded)",
                   uiOutput('fv1'), uiOutput('fv2')),

					menuItemOutput("GraphsCat"),
					menuItemOutput("TablesCat"),
					menuItemOutput("InferenceCat"),

					#uiOutput('formatRep'),
					
					div(id = "div_dwnlRep", align = "center",
					    downloadButton(outputId = "dwnlRep", label = "Download report")
					)
					#uiOutput('formatBut')
     				  
   ) # sidebarMenu
  ), # dashboardSidebar
  body
)

# #######################################
#             S E R V E R
# #######################################
server <- function(input, output, session) {
# 
# Using sample data. Uploading catdata.RData using load() function.
####################################################################
  sampleData <- reactive({
    load("catdata.RData") 
    switch(input$dataInput,
	       "Titanic" = Titanic,
		     "Hair and eye colour" = HairEyeColor, 
         "Exam scores" = ExamScores, 
		     "Gym survey" = GymSurvey, 
		     "Chicken diet" = Chicken, 
		     "Driving offences" = Driving,
         "Pine trees" = Pines, 		   
		     "Marketing survey" = Market, 
		     "Countries" = Countries
    )
  })

  
  # Helper to read the uploaded file
  read_upload <- reactive({
    req(input$dataInput2)
    ext <- tolower(tools::file_ext(input$dataInput2$name))
    df <- switch(ext,
                 "csv"  = utils::read.csv(input$dataInput2$datapath, stringsAsFactors = FALSE),
                 "tsv"  = utils::read.delim(input$dataInput2$datapath, stringsAsFactors = FALSE),
                 "rds"  = readRDS(input$dataInput2$datapath),
                 "xlsx" = readxl::read_excel(input$dataInput2$datapath),
                 validate("Unsupported file type. Please upload csv/tsv/xlsx/rds.")
    )
    as.data.frame(df)
  })
  
  
  # Enforce limits (≤5000 rows & ≤10 columns)
  dataUploaded <- reactive({
    df <- read_upload()
    rows <- nrow(df); cols <- ncol(df)
    
    if (rows > 5000 || cols > 10) {
      showModal(modalDialog(
        title = "Dataset too large",
        paste0(
          "Your dataset has ", rows, " rows and ", cols, " columns.\n",
          "The limit is 5,000 rows and 10 columns. Please upload a smaller dataset."
        ),
        easyClose = TRUE, footer = modalButton("OK")
      ))
      validate(need(FALSE, ""))  # stop this render path cleanly
    }
    
    df
  })
  
############################
# Uploading your own data.
############################
  csvData <- reactive({
    csvdata <- input$dataInput2
    if(is.null(csvdata)){
      return(NULL)
    }else{
      data <- read.csv(csvdata$datapath, header=input$header, sep=input$sep, quote=input$quote)
      return(data)
    }
  })

   ##############################################################
   # datasetInput returns the active dataset (with hard size gate)
   ##############################################################
   datasetInput <- reactive({
     # Choose source consistent with your UI
     if (identical(input$data, "sample")) {
       df <- sampleData()         # you already define this above
     } else if (identical(input$data, "yourData")) {
       df <- csvData()            # your existing CSV reader (uses dataInput2/header/sep/quote)
     } else {
       return(NULL)               # "None selected" or initial state
     }
     
     req(!is.null(df))
     df <- as.data.frame(df)      # normalize: handles tables/arrays like Titanic, etc.
     
     # --- Option A: reject oversize datasets ---
     if (nrow(df) > 5000 || ncol(df) > 10) {
       showModal(modalDialog(
         title = "Dataset too large",
         paste0(
           "Your dataset has ", nrow(df), " rows and ", ncol(df), " columns.\n",
           "Limit is 5,000 rows and 10 columns. Please upload/select a smaller dataset."
         ),
         easyClose = TRUE, footer = modalButton("OK")
       ))
       validate(need(FALSE, ""))  # stop reactivity cleanly
     }
     
     df
   })
   
##########################################################################
# If the data source is not chosen, then in the main body
# the initial Intro page is displayed (e.g. 'Introduction to the topic'). 
##########################################################################
  observeEvent((input$data == ''), {
    updateTabItems(session, "tabs", "intro")})
#########################################
# Checking if the file has been uploaded.
#########################################
  output$fileUploaded <- reactive({
    return(!is.null(csvData()))
  })
  outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)
  ##################################################
  # Select columns with categorical variables only.
  ##################################################
  dataFac <- reactive({
    df <- datasetInput()                 # <- already size-checked upstream
    req(!is.null(df))
    
    df <- as.data.frame(df)              # normalize in case sample is table/array
    mask <- sapply(df, is.factor)
    out  <- df[, mask, drop = FALSE]     # explicit column subsetting
    
    # Optional: user-friendly note if no factor cols remain
    if (ncol(out) == 0L) {
      showNotification(
        "No categorical (factor) variables detected in the dataset.",
        type = "message", duration = 6
      )
      return(NULL)
    }
    out
  })
  
  dataForReport <- reactiveValues(data = NULL)
  
  observe({
    dataForReport$data <- dataFac()
  })
  
#############################################
# Select 1st categorical variable to display. 
#############################################
  output$fv1 <- renderUI({
  
  	  # if(length(datasetInput()) == 0 || is.null(datasetInput()) || is.null(input$factor) || is.null(dataFac()))
      # {
        # shiny:::flushReact()
        # return()
      # }   
    if(length(dataFac()) == 0 || is.null(dataFac())){
	#if(length(dataFac()) == 0 || ncol(dataFac()) == 0){
    out <- div(style="text-align:center", paste("No categorical variable in dataset"))
	}
    else{out <- selectInput('fv1', h5('Select 1st categorical variable'), choices = names(dataFac()))}
    return(out)
  })
###############################################
# Select 2nd categorical variable to display. 
###############################################
  output$fv2 <- renderUI({
   	 # if(length(datasetInput()) == 0 || is.null(datasetInput()) || is.null(input$factor) || is.null(dataFac()))
     # {
       # shiny:::flushReact()
       # return()
     # }   
    if(length(dataFac()) == 0 || is.null(dataFac())){
	out <- div(style="text-align:center", paste(" "))
    }else{
      if(ncol(dataFac()) == 1){
        out <- NULL
      }else{
        if(ncol(dataFac()) > 1){
          out <- selectInput('fv2', h5('Select 2nd categorical variable'), choices = names(dataFac()))
        }else{
          out <- NULL
        }
      }
    }
    return(out)
  })
###############################################################
# Select 3rd categorical variable to display (for Mantel test). 
###############################################################
  output$fv3 <- renderUI({
   	# if(length(datasetInput()) == 0 || is.null(datasetInput()) || is.null(input$factor) || is.null(dataFac()))
    # {
      # shiny:::flushReact()
      # return()
    # }   
    if(length(dataFac()) == 0 || is.null(dataFac())){
	out <- div(style="text-align:center", paste(" "))
    }else{
      if(ncol(dataFac()) == 1 || ncol(dataFac()) == 2){
        out <- NULL
      }else{
        if(ncol(dataFac()) > 2){
          out <- selectInput('fv3', h5('Select 3rd categorical variable (strata)'), choices = names(dataFac()))
        }else{
          out <- NULL
        }
      }
    }
    return(out)
  })
######################################################################
# Select 3rd categorical variable to display (for Log-Linear models). 
######################################################################
  output$fv3a <- renderUI({
    if(length(dataFac()) == 0 || is.null(dataFac())){
	out <- div(style="text-align:center", paste(" "))
    }else{
      if(ncol(dataFac()) == 1 || ncol(dataFac()) == 2){
        out <- NULL
      }else{
        if(ncol(dataFac()) > 2){
          out <- selectInput('fv3a', 'Select 3rd categorical variable', choices = names(dataFac()))
        }else{
          out <- NULL
        }
      }
    }
    return(out)
  })
#
##########################################
##  Display checkBox if you want sampling
##########################################
output$samplingBut <- renderUI({
out <- checkboxInput("sampling", "Take a simple random sample", value=FALSE)
})


########################################
# Display numericInput for sample size
########################################
output$sampleSize <- renderUI({
     if(length(datasetInput()) == 0 || is.null(input$sampling))
     {
       shiny:::flushReact()
       return()
     }
#if(is.null(input$sampling)) return()
else{
if(input$sampling == TRUE) {numericInput("ssize", "Sample size:", value=3, step=1, min=2, max=nrow(datasetInput()))
}
else{return()}
}
})
################################################################
# Display checkBox for type of sample (with/without replacement)
################################################################
output$replacement <- renderUI({
     if(length(datasetInput()) == 0 || is.null(input$sampling))
     {
       shiny:::flushReact()
       return()
     }
#if(is.null(input$sampling)) return()
else{
if(input$sampling == TRUE) {checkboxInput("replaceme", "Take a sample with replacement", FALSE)
}
else{return()}
}
})
################################
# Display numericInput for seed
################################
output$seed <- renderUI({
     if(length(datasetInput()) == 0 || is.null(input$sampling))
     {
       shiny:::flushReact()
       return()
     }
#if(is.null(input$sampling)) return()
else{ 
if(input$sampling == TRUE) {numericInput("sseed", "Seed for random number generator:", value=10, min=1, max=9999999, step=1)
}
else{return()}
}
})
#########################
# Action button for SRS
#########################
output$actionBut <- renderUI({
     if(length(datasetInput()) == 0 || is.null(input$sampling))
     {
       shiny:::flushReact()
       return()
     }
# if(is.null(input$sampling)) return()
else{
if(input$sampling == TRUE) {actionButton("go", "Press to generate a sample")
}
else{return()}
}
})
###################
# S A M P L I N G
###################
 sampleTaken <- reactive({
     if(length(datasetInput()) == 0 || is.null(input$sampling))
     {
       shiny:::flushReact()
       return()
     }

 else if((input$data == 'sample' || input$data == 'yourData') && input$sampling == FALSE) {dat <- datasetInput()}
 else if((input$data == 'sample' || input$data == 'yourData') && input$sampling == TRUE) {
 input$go
 isolate({
 set.seed(input$sseed)
 dat <- datasetInput()[sample(1:nrow(datasetInput()), size=input$ssize, replace=input$replaceme),]
 })
 }
return(dat)
})
#####################################
# Display download button for sample
#####################################
  output$downSampleBut <- renderUI({
     if(length(datasetInput()) == 0 || is.null(input$sampling))
     {
       shiny:::flushReact()
       return()
     }  
    if(input$sampling == TRUE){
      out <- downloadButton('downloadSample', 'Download sample')
    }else{
      out <- NULL
    }
    return(out)
  })
###########################
# Download sample dataset
###########################
   output$downloadSample <- downloadHandler(
    filename = function() {paste(input$dataInput, '_Sample.csv', sep='')},
    content = function(file) {write.csv(sampleTaken(), file)}
   )
################################################################################################
# Display radioButtons if there is more than 1 categorical variable (stacked/grouped bar chart).
################################################################################################
  output$selectBar <- renderUI({

  if(length(dataFac()) != 0 && ncol(dataFac())<=1){
	out <- NULL
      return(out)
    }else{
		if(ncol(dataFac())>1) {
      out <- radioButtons("typeBar", "Select bar type (for stacked and grouped bar charts group by the 2nd categorical variable):", c("Simple bar chart" = "plainBar", "Stacked bar chart" = "stackedBar", "Grouped bar chart" = "groupedBar"))
	  return(out)
	  }
	  }
  })
##################################################################### 
# Display radioButtons if you want % or sample size on the pie chart.
#####################################################################
  output$displayPie <- renderUI({
    if(length(dataFac()) != 0 && ncol(dataFac())<1){
	out <- NULL
      return(out)
    }else{
      out <- radioButtons("displayWithPie", "Select what to display for each slice:", c("Just a label" = "justLabel", "Label and number in the slice" = "sampleSizePie", "Label and percentage" = "percentPie"))
	  return(out)
	  }
  })
#########################################  
# Display checkBox if there are factors.
#########################################
  output$facCheckBox <- renderUI({
    if(length(dataFac()) != 0 && ncol(dataFac()) !=0){
      out <- checkboxInput("factor", "Group by the 1st categorical variable", FALSE)
    }else{
      out <- NULL
    }
    return(out)
  })
#
# ##############
#   N O T E S
# ##############
# 
# Print a note if there is no categorical variables in the selected dataset (bar chart).   
#########################################################################################
  output$textBar <- renderText({
    if(length(dataFac()) == 0 || is.null(dataFac())){
      out <- paste("NOTE: There are no categorical variables in the selected dataset.")
    }else{
      out <- paste("")}
    return(out)
  })
####################################################################################################
# Print a note if there are no at least two categorical variables in the selected dataset (mosaic).   
####################################################################################################
  output$textMosaic <- renderText({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=1){
      out <- paste("NOTE: At least two categorical variables are required for a mosaic plot.")
    }else{
      out <- paste("")}
    return(out)
  })
##################################################################################################
# Print a note if there are no at least two categorical variables in the selected dataset (assoc).   
##################################################################################################
  output$textAssoc <- renderText({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=1){
      out <- paste("NOTE: At least two categorical variables are required for an association plot.")
    }else{
      out <- paste("")}
    return(out)
  })
  ###################################################################################################
  # Print a note if there are no at least two categorical variables in the selected dataset (agree).
  ###################################################################################################
  output$textAgree <- renderText({
    df <- dataFac()
    if (is.null(df) || length(df) == 0 || ncol(df) <= 1 || is.null(input$fv1) || is.null(input$fv2)) {
      return("NOTE: At least two categorical variables are required for the agreement plot.")
    }
    # stop if requested columns are missing
    if (!all(c(input$fv1, input$fv2) %in% names(df))) return("")
    
    lv1 <- levels(as.factor(df[[input$fv1]]))
    lv2 <- levels(as.factor(df[[input$fv2]]))
    
    if (length(lv1) == 0L || length(lv2) == 0L) {
      return("NOTE: Selected variables must be categorical (with 2+ levels) for agreement metrics.")
    }
    
    # ✅ scalar boolean instead of vector comparison
    if (!identical(lv1, lv2)) {
      return(paste(
        "NOTE: For agreement measures, the two categorical variables must share the same",
        "set and order of categories (e.g., both raters use {Agree, Neutral, Disagree})."
      ))
    }
    
    ""  # no note
  })
  
  ################################################################################################
  # Print a note if there are no at least two categorical variables in the selected dataset (ca).
  ################################################################################################
  output$textCorrespond1 <- renderText({
    df <- dataFac()
    if (is.null(df) || length(df) == 0 || ncol(df) <= 1 || is.null(input$fv1) || is.null(input$fv2)) {
      return("NOTE: At least two categorical variables are required for correspondence analysis.")
    }
    if (!all(c(input$fv1, input$fv2) %in% names(df))) return("")
    
    lv1n <- nlevels(as.factor(df[[input$fv1]]))
    lv2n <- nlevels(as.factor(df[[input$fv2]]))
    
    # ✅ single boolean instead of c(a,b)<=2
    if (min(lv1n, lv2n) <= 2) {
      return("NOTE: For correspondence analysis, each categorical variable should have at least three categories.")
    }
    
    ""  # no note
  })
  
################################################################################################
# Print a note if there are no at least two categorical variables in the selected dataset (ca).   
################################################################################################
  output$textCorrespond2 <- renderText({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=1 || min(length(levels(dataFac()[,input$fv1])), length(levels(dataFac()[,input$fv2])))<=2) {
      out <- paste("NOTE: At least two categorical variables are required for a correspondence analysis. Also,  each of the categorical variable must have at least three categories. ")
    }else{
      out <- paste("")}
    return(out)
  })
################################################################################################
# Print a note if there are no at least two categorical variables in the selected dataset (vcd).   
################################################################################################
  output$textTblAssoc <- renderText({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=1) {
      out <- paste("NOTE: At least two categorical variables are required for an association statistic.")
    }else{
      out <- paste("")}
    return(out)
  })
# #############################################################################
#  Print a note if the contingency table is larger than 3x3 (Fisher exact test)
# ##############################################################################
  output$textFisher <- renderText({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=1) {
       out <- paste("NOTE: At least two categorical variables are required for the Fisher exact test.")
       }
	   else if(length(levels(dataFac()[,input$fv1]))+length(levels(dataFac()[,input$fv2]))>6) {out <- paste("NOTE: The sum of numbers of categories in both categorical variables can't exceed 6 for the Fisher exact test.")}
	   else{out <- paste("")}
          # return(out)	
  })
# #############################################################################
#  Print a note if there are no three categorical variables (Mantel test)
# ##############################################################################
  output$textMantel <- renderText({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=2) {
       out <- paste("NOTE: At least three categorical variables are required for the Mantel-Haenszel test.")
       }
	   else if(length(levels(dataFac()[,input$fv1]))<2 || length(levels(dataFac()[,input$fv2]))<2 || length(levels(dataFac()[,input$fv3]))<2) {out <- paste("NOTE: Each categorical variable must have at least 2 categories for the Mantel-Haenszel test.")}
	   else if(input$fv1 == input$fv2 || input$fv1 == input$fv3 || input$fv2 == input$fv3) {out <- paste("NOTE: All three selected categorical variables must be different.")}
	   else{out <- paste("")}
          # return(out)	
  })
# #############################################################################
#  Print a note if there are no three categorical variables (Log-linear models)
# ##############################################################################
  output$textLoglin <- renderText({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=2) {
       out <- paste("NOTE: At least three categorical variables are required for the log-linear model tests.")
       }
	   # else if(length(levels(dataFac()[,input$fv1]))<2 || length(levels(dataFac()[,input$fv2]))<2 || length(levels(dataFac()[,input$fv3]))<2) {out <- paste("NOTE: Each categorical variable must have at least 2 categories for the log-linear model tests.")}
	   # else if(input$fv1 == input$fv2 || input$fv1 == input$fv3 || input$fv2 == input$fv3) {out <- paste("NOTE: All three selected categorical variables must be different.")}
	   else{out <- paste("")}
          # return(out)	
  })
# ######################################
#  Print a note for testing proportions
# ######################################
output$textProp <- renderText({
 success <- as.numeric(unlist(strsplit(as.character(input$numSuccess), split=",")))
 total <- as.numeric(unlist(strsplit(as.character(input$numTotal), split=",")))
 pnull <- as.numeric(unlist(strsplit(as.character(input$pNull), split=",")))
if(any(success>total)){out <- paste("NOTE: All number of successes should be smaller than the respective total number of observations.")}
else if(length(success) != length(total) || length(success) != length(pnull) || length(total) != length(pnull)){out <- paste("NOTE: Equal number of entries is expected for all three inputs: number of successes, total number of observations, and proportions for null hypothesis.")}
else {out <- return()}
})
# ###############################################
#  Print a note for Chisq test (aggregated data)
# ###############################################
output$textChisqTest1 <- renderText({
 numFreq <- as.numeric(unlist(strsplit(as.character(input$numCounts), split=",")))
 numCells <- input$numRow*input$numColumn
if(any(numFreq<0)){out <- paste("NOTE: All frequencies should be greater than zero.")}
else if(length(numFreq) != numCells){out <- paste("NOTE: The number of frequencies should be equal to the product of the number of rows and columns.")}
else {out <- return()}
})
# #################################
#  Print a note for binomial test
# #################################
output$textBinom <- renderText({
if(input$numSuccess1>input$numTotal1){out <- paste("NOTE: The number of successes must be smaller than the total number of observations.")}
else {out <- return()}
})
# ##############
#  G R A P H S
# ##############
# 
  ####################
  # Bar chart (graph)
  ####################
  output$barGraph <- renderPlot({
    df <- dataFac()
    req(!is.null(df), length(df) > 0)
    req(!is.null(input$fv1), input$fv1 %in% names(df))
    
    # SIMPLE bar: either explicit selection or fallback
    if (is.null(input$typeBar) || input$typeBar %in% c("simpleBar", "single") || ncol(df) == 1L) {
      counts <- table(as.factor(df[[input$fv1]]))
      validate(need(length(counts) > 0, "Selected variable has no data."))
      barplot(counts,
              xlab = input$fv1, ylab = "Frequency",
              main = paste("Distribution by", input$fv1))
      return(invisible(NULL))
    }
    
    # GROUPED / STACKED bars need fv2
    req(!is.null(input$fv2), input$fv2 %in% names(df))
    counts <- table(as.factor(df[[input$fv1]]), as.factor(df[[input$fv2]]))
    validate(need(sum(counts) > 0, "No data for the selected variables."))
    
    if (input$typeBar == "groupedBar") {
      barplot(counts,
              beside = TRUE,                     # <-- grouped bars
              xlab = input$fv2, ylab = "Frequency",
              legend.text = TRUE,
              main = paste("Distribution by", input$fv1, "and", input$fv2))
    } else if (input$typeBar == "stackedBar") {
      barplot(counts,
              beside = FALSE,                    # <-- stacked bars (default)
              xlab = input$fv2, ylab = "Frequency",
              legend.text = TRUE,
              main = paste("Distribution by", input$fv1, "and", input$fv2))
    } else {
      # Fallback to simple if an unexpected option slips through
      counts1 <- table(as.factor(df[[input$fv1]]))
      barplot(counts1,
              xlab = input$fv1, ylab = "Frequency",
              main = paste("Distribution by", input$fv1))
    }
  })
  
##################
# Dotplot (graph)
##################
  output$dotPlot <- renderPlot({
    df <- dataFac()
    req(!is.null(df), length(df) > 0)
    
    if (ncol(df) == 1) {
      req(!is.null(input$fv1), input$fv1 %in% names(df))
      myTable <- table(as.factor(df[[input$fv1]]))
      validate(need(length(myTable) > 0, "Selected variable has no data."))
      dotplot(myTable, groups = FALSE, type = c("p","h"), xlab = "Frequency",
              prepanel = function (x, y) list(ylim = levels(reorder(y, x))),
              panel = function(x, y, ...) panel.dotplot(x, reorder(y, x), ...))
    } else {
      req(!is.null(input$fv1), !is.null(input$fv2))
      req(all(c(input$fv1, input$fv2) %in% names(df)))
      myTable <- table(as.factor(df[[input$fv1]]), as.factor(df[[input$fv2]]))
      validate(need(sum(myTable) > 0, "No data for the selected variables."))
      dotplot(myTable, groups = FALSE, layout = c(1, nlevels(as.factor(df[[input$fv2]]))),
              auto.key = list(lines = TRUE), type = c("p","h"), xlab = "Frequency",
              prepanel = function (x, y) list(ylim = levels(reorder(y, x))),
              panel = function(x, y, ...) panel.dotplot(x, reorder(y, x), ...))
    }
  })
  
####################
# Pie chart (graph)
####################
  output$pieChart <- renderPlot({
    df <- dataFac()
    req(!is.null(df), is.data.frame(df))
    req(!is.null(input$fv1), input$fv1 %in% names(df))
    
    x <- as.factor(df[[input$fv1]])
    tbl <- table(x, useNA = "no")
    
    validate(need(length(tbl) > 0, "Selected variable has no data."))
    
    # Default behavior exactly like the Rmd: if NULL → "justLabel"
    displayWithPie <- if (is.null(input$displayWithPie)) "justLabel" else input$displayWithPie
    
    # Colors like in the Rmd: rainbow by number of levels
    cols <- grDevices::rainbow(nlevels(x))
    
    if (identical(displayWithPie, "sampleSizePie")) {
      labs <- paste(names(tbl), "\n", as.vector(tbl), sep = "")
      pie(tbl, labels = labs, col = cols,
          main = paste("Pie chart of", input$fv1, "\n (with number in the slice)"))
      
    } else if (identical(displayWithPie, "percentPie")) {
      pct  <- round(100 * as.vector(tbl) / sum(tbl), 1)
      labs <- paste(names(tbl), "\n", pct, "%", sep = "")
      pie(tbl, labels = labs, col = cols,
          main = paste("Pie chart of", input$fv1, "\n (with percentage)"))
      
    } else { # "justLabel"
      labs <- names(tbl)
      pie(tbl, labels = labs, col = cols,
          main = paste("Pie chart of", input$fv1))
    }
  })
  
  
####################################
# Mosaic plot (vcd package) (graph)   
####################################
  # ---- Mosaic (match the Word report) ----
  output$mosaic <- renderPlot({
    df <- dataFac()
    req(!is.null(df), is.data.frame(df))
    req(!is.null(input$fv1), !is.null(input$fv2))
    req(all(c(input$fv1, input$fv2) %in% names(df)))
    
    x <- as.factor(df[[input$fv1]])  # rows
    y <- as.factor(df[[input$fv2]])  # columns
    
    validate(
      need(nlevels(x) >= 2 && nlevels(y) >= 2, "Both variables must have ≥ 2 levels."),
      need(sum(!is.na(x) & !is.na(y)) > 0, "No paired observations."),
      need(requireNamespace("vcd", quietly = TRUE),
           "Package 'vcd' is required. Install with install.packages('vcd').")
    )
    
    tab <- table(x, y, useNA = "no")
    validate(need(sum(tab) > 0, "No data for the selected variables."))
    
    # Match Rmd axis naming & orientation
    names(dimnames(tab)) <- c("x", "y")
    long.labels <- list(set_varnames = c(x = input$fv1, y = input$fv2))
    
    grid::grid.newpage()
    vcd::mosaic(
      tab,
      shade = TRUE,          # Pearson residual shading (adds color)
      legend = TRUE,         # residuals bar on the right
      labeling_args = long.labels
    )
  })
  
  
#######################################
# Associate plot (vcd package) (graph)  
#######################################
  output$assocPlot <- renderPlot({
    df <- dataFac()
    req(!is.null(df), is.data.frame(df))
    req(!is.null(input$fv1), !is.null(input$fv2))
    req(all(c(input$fv1, input$fv2) %in% names(df)))
    
    x <- as.factor(df[[input$fv1]])
    y <- as.factor(df[[input$fv2]])
    
    validate(
      need(nlevels(x) >= 2 && nlevels(y) >= 2,
           "At least two categorical variables (≥ 2 levels each) are required for an association plot."),
      need(sum(!is.na(x) & !is.na(y)) > 0, "No paired observations."),
      need(requireNamespace("vcd", quietly = TRUE),
           "Package 'vcd' is required. Install with install.packages('vcd').")
    )
    
    tab <- table(x, y, useNA = "no")
    validate(need(sum(tab) > 0, "No data for the selected variables."))
    
    # Friendly axis names (keys must match dimnames)
    names(dimnames(tab)) <- c("x", "y")
    long.labels <- list(set_varnames = c(x = input$fv1, y = input$fv2))
    
    grid::grid.newpage()
    vcd::assoc(
      tab,
      shade = TRUE,        # Pearson residual shading
      legend = TRUE,       # residuals scale on the right
      labeling_args = long.labels
    )
  })
  
########################################
# Agreement plot (vcd package) (graph)  
########################################
  # ---- Agreement plot (Shiny) ----
  output$agreePlot <- renderPlot({
    df <- dataFac()
    req(!is.null(df), is.data.frame(df), !is.null(input$fv1), !is.null(input$fv2))
    req(all(c(input$fv1, input$fv2) %in% names(df)))
    
    x <- as.factor(df[[input$fv1]])
    y <- as.factor(df[[input$fv2]])
    
    # Require identical level sets (and order)
    validate(need(identical(levels(x), levels(y)),
                  paste0("Agreement plot requires identical categories.\n",
                         input$fv1, ": {", paste(levels(x), collapse=", "), "}\n",
                         input$fv2, ": {", paste(levels(y), collapse=", "), "}")))
    
    tab <- table(x, y, useNA = "no")
    validate(need(sum(tab) > 0, "No paired observations."))
    
    validate(need(requireNamespace("vcd", quietly = TRUE),
                  "Package 'vcd' is required. Install with install.packages('vcd')."))
    
    grid::grid.newpage()
    vcd::agreementplot(tab, xlab = input$fv1, ylab = input$fv2)
  })
  
####################################################
# Correspondence analysis plot (ca package) (graph)  
####################################################
  output$correspond <- renderPlot({
    df <- dataFac()
    req(!is.null(df), is.data.frame(df))
    req(!is.null(input$fv1), !is.null(input$fv2))
    req(all(c(input$fv1, input$fv2) %in% names(df)))
    
    x <- as.factor(df[[input$fv1]])
    y <- as.factor(df[[input$fv2]])
    
    # Rmd requires ≥3 categories for EACH variable
    validate(
      need(nlevels(x) >= 3 && nlevels(y) >= 3,
           "At least two categorical variables are required and each must have ≥ 3 categories for correspondence analysis."),
      need(sum(!is.na(x) & !is.na(y)) > 0, "No paired observations."),
      need(requireNamespace("ca", quietly = TRUE),
           "Package 'ca' is required. Install with install.packages('ca').")
    )
    
    tab <- table(x, y, useNA = "no")
    validate(need(sum(tab) > 0, "No data for the selected variables."))
    
    # In the Rmd you had: ca(myTable, nd = ncol(myTable))
    # We'll choose a safe nd that never exceeds the rank:
    nd_safe <- max(1, min(nrow(tab), ncol(tab)) - 1)
    
    fit <- ca::ca(tab, nd = nd_safe)
    
    # ca::plot uses base graphics; add a clear title
    plot(fit, main = paste("Correspondence analysis of", input$fv1, "×", input$fv2))
  })
  
#
# ##############
#  T A B L E S
# ##############
#
# Print raw data  
##################
  output$view <- renderTable({
    if(!is.null(datasetInput())){
      out <- head(datasetInput(), n=input$obs)
    } else out <- NULL
    return(out)
  })
####################################################
# Display download button if example data was used.
####################################################
  output$downl <- renderUI({
    if(input$data == 'sample'){
      out <- downloadButton('downloadData', 'Download example dataset')
    }else{
      out <- NULL
    }
    return(out)
  })
###########################
# Download example dataset
###########################
   output$downloadData <- downloadHandler(
    filename = function() {paste(input$dataInput, '.csv', sep='')},
    content = function(file) {write.csv(sampleData(), file)}
   )
##########################################
# Print summary statistics (base) (table)   
##########################################
   output$summary <-renderPrint({
	  if(length(dataFac()) == 0 || is.null(dataFac()))
    {
      shiny:::flushReact()
      return()
    }   
     if(!is.null(dataFac())){
       dataset <- dataFac()
       out <- summary(dataset)
     } else out <- NULL
     return(out)
   })
#####################################################
# Print summary statistics by factor (psych) (table)
#####################################################
  output$summary1 <-renderPrint({
	  if(length(dataFac()) == 0 || is.null(dataFac()) || is.null(input$factor))
    {
      shiny:::flushReact()
      return()
    }   
    if(length(dataFac()) == 0 | is.null(dataFac())) {out <- paste("NOTE: There are no numeric variables in the selected dataset.")}
	else if(input$factor == FALSE){
      dataset <- dataFac()
      out <- describe(dataset, skew=FALSE, ranges=FALSE)
    } else {dataset <- dataFac()
      out <- describeBy(dataset, group=dataFac()[,input$fv1], skew=FALSE, ranges=FALSE)}

    return(out)
  })
###################################################################
# Generate and print 2-way frequency table (base package) (table)   
###################################################################
 output$twoWayTable <- renderTable(rownames = TRUE, {
   if(ncol(dataFac())>1){
     out <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
     
     out <- as.data.frame(out)
     out <- spread(out, Var2, Freq)
     rwn <- out$Var1
     out <- out[,-1]
     rownames(out) <- rwn
     
     return(out)
     
   } else {
     cTable <- as.data.frame(table(dataFac()[,input$fv1]))
     names(cTable)[1] = input$fv1
     out <- cTable
     
     return(out)
   }
  })  
###########################
# Cell percentages (table)
###########################
   output$twoWayTableCP <- renderTable(rownames = TRUE, {
     if(ncol(dataFac())>1){
       myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
       out <- prop.table(myTable)
       
       out <- as.data.frame(out)
       out <- spread(out, Var2, Freq)
       rwn <- out$Var1
       out <- out[,-1]
       rownames(out) <- rwn
       
       return(out)
       
     } else {
       myTable <- table(dataFac()[,input$fv1])
       cTable <- as.data.frame(prop.table(myTable))
       names(cTable)[1] = input$fv1
       out <- cTable
     }
  })
###############################
# Expected frequencies (table)
###############################
 output$twoWayTableExpect <- renderTable({
    if(ncol(dataFac())>1){
	  myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
	  out <- independence_table(myTable)
	  }
    else
	{
	myTable <- as.data.frame(table(dataFac()[,input$fv1]))
	names(myTable)[1] = input$fv1
	out <- independence_table(myTable)
	}
  })  
###########################################
# Expected frequencies (relative) (table)
###########################################
   output$twoWayTableExpectRel <- renderTable({
    if(ncol(dataFac())>1){
      myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
	  out <- independence_table(myTable, frequency = c("relative"))
	  }
    else
	{
	myTable <- table(dataFac()[,input$fv1])
	cTable <- as.data.frame(prop.table(myTable))
	names(cTable)[1] = input$fv1
	out <- independence_table(cTable, frequency = c("relative"))
	}
  })
#######################################
# Marginal freq (1st variable) (table)
#######################################
   output$twoWayTableMA <- renderTable({
    if(ncol(dataFac())>1){
      myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
	  cTable <- margin.table(myTable, 1)
	  dfTable <- as.data.frame(cTable)
	  names(dfTable)[1] = input$fv1
	  out <- dfTable}
    else
	{
	out <- NULL 
	}
  }) 
#######################################
# Marginal freq (2nd variable) (table)
#######################################
   output$twoWayTableMB <- renderTable({
    if(ncol(dataFac())>1){
      myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
	  cTable <- margin.table(myTable, 2)
	  dfTable <- as.data.frame(cTable)
	  names(dfTable)[1] = input$fv2
	  out <- dfTable}
    else
	{
    out <- NULL 
	}
  })
##############################################
# Marginal percentages (1st variable) (table)
##############################################
   output$twoWayTableMPA <- renderTable({
    if(ncol(dataFac())>1){
      myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
	  cTable <- margin.table(myTable, 1)
	  dfTable <- as.data.frame(prop.table(cTable))
	  names(dfTable)[1] = input$fv1
	  out <- dfTable}
    else
	{
	out <- NULL 
	}
  }) 
##############################################
# Marginal percentages (2nd variable) (table)
##############################################
   output$twoWayTableMPB <- renderTable({
    if(ncol(dataFac())>1){
      myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
	  cTable <- margin.table(myTable, 2)
	  dfTable <- as.data.frame(prop.table(cTable))
	  names(dfTable)[1] = input$fv2
	  out <- dfTable}
    else
	{
    out <- NULL 
	}
  })
##########################
# Row percentages (table)
##########################
   output$twoWayTablePR <- renderTable(rownames = TRUE, {
     if(ncol(dataFac())>1){
       myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
       out <- prop.table(myTable, 1)
       
       out <- as.data.frame(out)
       out <- spread(out, Var2, Freq)
       rwn <- out$Var1
       out <- out[,-1]
       rownames(out) <- rwn
       
       return(out)
       
     } else {
       out <- NULL 
     }
  })
#############################
# Column percentages (table)
#############################
   output$twoWayTablePC <- renderTable(rownames = TRUE, {
     if(ncol(dataFac())>1){
       myTable <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
       out <- prop.table(myTable, 2)
       
       out <- as.data.frame(out)
       out <- spread(out, Var2, Freq)
       rwn <- out$Var1
       out <- out[,-1]
       rownames(out) <- rwn
       
       return(out)
       
     } else {
       out <- NULL 
     }
  })   
#############################################################
# Print results of the correspondence analysis (ca package).   
#############################################################
   output$tblCorrespond <- renderPrint({
	  if(length(dataFac()) == 0 || is.null(input$fv1) || is.null(input$fv2) || is.null(dataFac()) && ncol(dataFac())<=2)
      #if(length(dataFac()) == 0 || is.null(input$fv1) || is.null(input$fv2))
    {
      shiny:::flushReact()
      return()
    }   
	else{
	if(length(levels(dataFac()[,input$fv1]))<=2 || length(levels(dataFac()[,input$fv1]))<=2) {out=NULL}
       else{
            xvector <- as.vector(dataFac()[,input$fv1])
		    yvector <- as.vector(dataFac()[,input$fv2])
			#long.labels <- list(set_varnames = c(xvector=input$fv1, yvector=input$fv2))
		    myTable <- table(xvector, yvector)
		    out <- print(ca(myTable, nd=ncol(myTable)))}}
			#length(dataFac()[,input$fv2]))
            return(out)		   
	   #}
  })
######################################################
# Print association statistics results (vcd package).   
######################################################
   output$tblAssoc <- renderPrint({
	  if(length(dataFac()) == 0 || is.null(dataFac()) && ncol(dataFac())<=1)
    {
      shiny:::flushReact()
      return()
    }   
       else{
            xvector <- as.vector(dataFac()[,input$fv1])
		    yvector <- as.vector(dataFac()[,input$fv2])
		    myTable <- table(xvector, yvector)
		    out <- summary(assocstats(myTable))
            return(out)		   
	   }
  })
#
# ###################
#  I N F E R E N C E
# ###################
#
# #############################
#  Chi-squared test (raw data)
# #############################
  output$chisqTest <- renderPrint({
    if(ncol(dataFac())<=1){out <- NULL
      }
    else
	{
	 conTbl <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
     test <- chisq.test(conTbl)
	 test$data.name <- paste(input$fv1, "and", input$fv2, "variables from", input$dataInput, "dataset")
	  out <- test
	return(out)}
  })
############################
# Two-way table aggregated
############################
aggTable <- reactive({
input$goaggButton
isolate({
    numFreq <- as.numeric(unlist(strsplit(as.character(input$numCounts), split=",")))
    aggTable <- matrix(numFreq, ncol=input$numColumn, nrow=input$numRow, byrow=TRUE)
	out <- as.table(aggTable)})
return(out)
})
# ###################################
#  Chi-squared test (aggregated data)
# ###################################
  output$chisqTest1 <- renderPrint({
	out <- summary(aggTable())
	return(out)
  })
###############################
# Expected frequencies (table)
###############################
 output$twoWayTableExpect1 <- renderTable({
	  out <- independence_table(aggTable())
	  return(out)
  })  
###########################################
# Expected frequencies (relative) (table)
###########################################
   output$twoWayTableExpectRel1 <- renderTable({
 	  out <- independence_table(aggTable(), frequency = c("relative"))
      return(out)
  })
######################
#  Fisher exact test
######################
  output$fisherTest <- renderPrint({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=1){out <- NULL
      }
	  else{if(length(levels(dataFac()[,input$fv1]))+length(levels(dataFac()[,input$fv2]))>6) {out <- NULL}
    else
	{
	 conTbl <- table(dataFac()[,input$fv1], dataFac()[,input$fv2])
     test <- fisher.test(conTbl, conf.int = TRUE, conf.level = 0.95, workspace=2e+6, hybrid=TRUE)
	 test$data.name <- paste(input$fv1, "and", input$fv2, "variables from", input$dataInput, "dataset")
	  out <- test}}
	return(out)
  })
# ###############################
#  Mantel-Haenszel test
# ###############################
  output$mantelTest <- renderPrint({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=2 || is.null(input$fv1)){out <- NULL
      }
	else{if(length(levels(dataFac()[,input$fv1]))<2 || length(levels(dataFac()[,input$fv2]))<2 || length(levels(dataFac()[,input$fv3]))<2 || input$fv1 == input$fv2 || input$fv1 == input$fv3 || input$fv2 == input$fv3) {out <- NULL}
    else
	{
	 conTbl <- table(dataFac()[,input$fv1], dataFac()[,input$fv2], dataFac()[,input$fv3])
     test <- mantelhaen.test(conTbl, conf.level = 0.95)
	 test$data.name <- paste(input$fv1, "and", input$fv2, "variables and strata", input$fv3, "from", input$dataInput, "dataset")
	  out <- test}}
	return(out)
  })
###################################
# Display list of Log-linear tests
###################################
  output$selectionLoglin <- renderUI({
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=2){out <- NULL
      }
    else  {out <- selectInput('selectLoglin', 'Select test for a log-linear model:', choices=c("Mutual independence"="1", "Partial-independence"="2", "Conditional independence" = "3", "No three-way interaction" = "4"))
    }
    return(out)
  })
# ###############################
#  Log-linear model tests
# ###############################
  loglinTestout <- eventReactive(input$goButton2,{
    if((length(dataFac()) == 0 || is.null(dataFac())) || ncol(dataFac())<=2){out <- NULL}
    else
	{
    isolate({
	  A <- dataFac()[,input$fv1]
	  B <- dataFac()[,input$fv2]
	  C <- dataFac()[,input$fv3a]
	  dat <- cbind(A,B,C)
	  s <- input$selectionLoglin
	  mytable <- xtabs(~A+B+C, data=dat)
     if(input$selectionLoglin == "1") {out <- loglm(~A+B+C, mytable)}
	 else if(input$selectionLoglin == "2") {out <- loglm(~A+B+C+B*C, mytable)}
	 else if(input$selectionLoglin == "3") {out <- loglm(~A+B+C+A*C+B*C, mytable)}
	 else if(input$selectionLoglin == "4") {out <- loglm(~A+B+C+A*B+A*C+B*C, mytable)}
	 })
	 }
	return(out)
  })
#
####################################
output$loglinTest <- renderPrint({
out <- loglinTestout()
if (is.null(out)){return(NULL)}
    out 
})

#################################
# Inference in proportion (test)
#################################
output$propTest <-renderPrint({
input$goButton
isolate({
 Success <- as.numeric(unlist(strsplit(as.character(input$numSuccess), split=",")))
 Total <- as.numeric(unlist(strsplit(as.character(input$numTotal), split=",")))
 Pnull <- as.numeric(unlist(strsplit(as.character(input$pNull), split=",")))
 if(all(Success<Total) && length(Success) == length(Total) && length(Success) == length(Pnull) && length(Total) == length(Pnull) && length(Success)!=2) 
{test <- prop.test(Success, Total, Pnull, alternative=input$pAlter, conf.level=input$pConf, correct=input$pCorrect)}
else if(length(Success)==2 && length(Total)==2) {test <- prop.test(Success, Total, alternative=input$pAlter, conf.level=input$pConf, correct=input$pCorrect)}
else {test <- NULL}})
return(test)
}) 
########################################
# Inference in proportion binomial test
########################################
output$binomTest <- renderPrint({
input$goButton1
isolate({
Success <- input$numSuccess1
Total <-  input$numTotal1
if(Success<Total) 
test <- binom.test(Success, Total, input$pNull1, alternative=input$pAlter1, conf.level=input$pConf1)
else {test <- NULL}})
return(test)
})
# ###############################################
#  G E N E R A T I N G  S I D E B A R  M E N U S
#    C A T E G O R I C A L  V A R I A B L E S
# ###############################################
# 
# If the data source has no categorical variable, then in the main body
# the initial Intro page is displayed (e.g. 'Introduction to the topic'). 
#
 # observeEvent((length(dataFac()) == 0 || is.null(dataFac())), {
 #   updateTabItems(session, "tabs", "intro")})
##########################################
# Creating the first menuItem dynamically.
##########################################
  output$GraphsCat <- renderMenu({ 
    if((input$data=='sample' || (input$data=='yourData' && !is.null(input$dataInput2))) && ncol(dataFac()) != 0){
      menuItem("Graphs", tabName = "graphsCat", icon = icon("bar-chart"))
    }else{
      menuItem(NULL)
    }
  })
###########################################
# Creating the second menuItem dynamically.
###########################################
  output$TablesCat <- renderMenu({
    if((input$data=='sample' || (input$data=='yourData' && !is.null(input$dataInput2))) && ncol(dataFac()) != 0){
       menuItem("Tables", tabName = "tablesCat", icon = icon("table"))
    }else{
       menuItem(NULL)
    }
  })
###########################################
# Creating the third menuItem dynamically.
###########################################
  output$InferenceCat <- renderMenu({
    if((input$data=='sample' || (input$data=='yourData' && !is.null(input$dataInput2))) && ncol(dataFac()) != 0){
      menuItem("Inference", tabName = "inferenceCat", icon = icon("calculator"))
    }else{
      menuItem(NULL)
    }
  })
#####################
# Download a report 
#####################
  
  repDataSetInput <- reactiveValues(data = NULL)
  observe({
    repDataSetInput$data <- datasetInput()  # latest full dataset
  })
  
  source(file = "report.R", local = TRUE)
  
}
shinyApp(ui, server)