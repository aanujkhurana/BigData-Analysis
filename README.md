# Big Data Analysis Project;
This repository contains the code and data for a comprehensive big data analysis project focused on Eminem. The project leverages various data sources, including Twitter, Spotify, and YouTube, to analyze Eminem's presence on social media, his music catalog, and audience engagement.

- [Eminem - Wikipedia](https://en.wikipedia.org/wiki/Eminem): Visit Eminem's Wikipedia page for more information about his life and career.


## Table of Contents

- [Overview](#overview)
- [Data Sources](#data-sources)
- [Tools and Technologies](#tools-and-technologies)
- [Setup](#setup)
- [Directory Structure](#directory-structure)
- [Key Findings](#Key-Findings)
- [Graph Images](#Graph-Images)
- [Contributing](#contributing)

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

## Key Findings

1. **Eminem's Music Career:**
   - Active for 24 years.
   - Released 4 albums and numerous songs.
   - Collaborated with artists like Rihanna, Snoop Dogg, and Juice WRLD.

2. **YouTube Engagement:**
   - Identified top-viewed and top-liked videos, including "Love The Way You Lie" ft. Rihanna and "Rap God."
   - Observed a correlation between views and likes, indicating higher engagement for popular videos.

3. **Twitter Sentiment Analysis:**
   - Analyzed public sentiments towards Eminem, revealing a mix of positive and negative emotions.
   - Identified key terms frequently associated with Eminem, including "Slim Shady," "rap," and "music."

4. **Decision Tree Modeling:**
   - Built a decision tree model to predict whether a song is by Eminem, achieving accurate predictions.

5. **LDA Topic Modeling:**
   - Identified significant groups of words related to Eminem, such as "Slim Shady," "rap," and "music heart."

## Refinement of Social Media Analytics

- Explore additional data sources beyond Spotify, YouTube, and Twitter to gather more comprehensive insights.
- Experiment with different parameters and algorithms to improve the accuracy and relevance of the analysis results.
- Incorporate user feedback and domain expertise to refine the analytical approach and interpretation of findings.

## Future Directions

- Extend the analysis to include other social media platforms, such as Instagram and Facebook, to capture a broader spectrum of audience interactions.
- Explore advanced machine learning models and natural language processing techniques to extract deeper insights from social media conversations.
- Collaborate with domain experts and stakeholders to further refine the analysis methodology and address specific research questions.

## Conclusion

The social media analytics conducted for Eminem provide valuable insights into his music career, public reception, and online engagement. By leveraging diverse data sources and analytical techniques, we gain a comprehensive understanding of Eminem's influence and impact in the music industry. This project serves as a foundation for future research and exploration in the field of social media analytics.

## Graph Images
<div align="Left">
    <img src="/GraphImages/img3.png" width="400px"</img>
    <img src="/GraphImages/img14.png" width="400px"</img>
    <img src="/GraphImages/img1.png" width="400px"</img>
    <img src="/GraphImages/img4.png" width="400px"</img>
    <img src="/GraphImages/img6.png" width="400px"</img>
    <img src="/GraphImages/img8.png" width="400px"</img>
    <img src="/GraphImages/img5.png" width="400px"</img>
    <img src="/GraphImages/img7.png" width="400px"</img>
    <img src="/GraphImages/img15.png" width="400px"</img>
    <img src="/GraphImages/img16.png" width="400px"</img>
    <img src="/GraphImages/img12.png" width="400px"</img>
    <img src="/GraphImages/img11.png" width="400px"</img>
    <img src="/GraphImages/img13.png" width="400px"</img>
    <img src="/GraphImages/img9.png" width="400px"</img>
    <img src="/GraphImages/img10.png" width="400px"</img>
    <img src="/GraphImages/img2.png" width="400px"</img>
</div>


-----------------------------------------------------------------------------------------------

## Contributing

Contributions to this project are welcome! If you have any ideas, suggestions, or improvements, feel free to open an issue or submit a pull request.


-----------------------------------------------------------------------------------------------
