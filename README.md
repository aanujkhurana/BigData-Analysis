# Big Data Analysis Project: Eminem

![Eminem](https://i.imgur.com/EXAMPLE.jpg)

This repository contains the code and data for a comprehensive big data analysis project focused on Eminem. The project leverages various data sources, including Twitter, Spotify, and YouTube, to analyze Eminem's presence on social media, his music catalog, and audience engagement.

## Table of Contents

- [Overview](#overview)
- [Data Sources](#data-sources)
- [Tools and Technologies](#tools-and-technologies)
- [Setup](#setup)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)
- [License](#license)

## Overview

Eminem, also known as Marshall Mathers, is one of the most influential and successful artists in the history of hip-hop. This project aims to analyze various aspects of Eminem's career and music using big data techniques. The analysis includes sentiment analysis of social media conversations, exploration of his discography on Spotify, and audience engagement on YouTube.

## Data Sources

The project utilizes data from the following sources:

- **Twitter API**: Collects tweets related to Eminem for sentiment analysis and network analysis.
- **Spotify API**: Retrieves information about Eminem's albums, tracks, and audio features for analysis.
- **YouTube API**: Gathers data on Eminem's videos, comments, and audience engagement for further analysis.

## Tools and Technologies

The analysis is performed using the following tools and technologies:

- **R Programming Language**: Used for data collection, preprocessing, analysis, and visualization.
- **vosonSML**: A package for social media and web data collection and analysis.
- **Rspotify**: An R wrapper for the Spotify Web API, used for retrieving Eminem's music data.
- **tuber**: An R package for interacting with the YouTube Data API to collect video and comment data.
- **igraph**: A package for network analysis and visualization.
- **tidytext**: A package for text mining and sentiment analysis.

## Setup

To replicate the analysis, follow these steps:

1. Clone this repository to your local machine.
2. Install the required R packages listed in the `install_packages.R` file.
3. Obtain API keys for Twitter, Spotify, and YouTube.
4. Update the authentication variables in the R scripts with your API keys.
5. Run the main analysis script (`main.R`) to perform data collection, preprocessing, analysis, and visualization.

## Directory Structure

The repository is organized as follows:

- **main.R/**: Contains R scripts for data collection, preprocessing, analysis, and visualization.
- **Data/**: Contains the collected data files.
- **Gephi/**: Contains the collected Graph files.
- **RStudio/**: Contains R Markdown notebooks documenting the analysis process.
- **GraphImages/**: Contains the Graph PNG Images.

## Contributing

Contributions to this project are welcome! If you have any ideas, suggestions, or improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
