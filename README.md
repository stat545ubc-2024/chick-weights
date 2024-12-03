[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/_WsouPuM)

# Shiny App that visualizes chick weights by diet
## Emily Zhang
### STAT545B, 2024 WT1

This app allows you to view the ChickWeight dataset that is built into R and visualize the data as a histogram. The data comes from an experiment on the effect of diet on early growth of chicks. 

Users can see a scrollable, sortable table showing the dataset. A histogram is generated based on the filtered dataset. Moreover, simple summary statistics are automatically calculated with the dataset - the mean, median, and standard deviation of the data is found.

Users can also optionally download the filtered data as a CSV file. 



Five features are built into the shiny app that improves its functionality:
- Feature 1: Filter dataset based on diet; allows users to select what data they wish to view based on their research goals
- Feature 2: Display number of results after filtering; the user can see how many chicks are in each diet group
- Feature 3: A histogram of chick weight based on the filtered dataset is automatically to better visualize the distribution of the data
- Feature 4: The user can download the filtered data as a CSV file by clicking a button on the side panel
- Feature 5: The mean, median, and standard deviation of the filtered data are automatically reported at the bottom of the page.

It can be found online at the following link: https://ezhangg.shinyapps.io/chick-weights/