---
layout: post
title: Exploring the Video games dataset
categories: [tidytuesday, R]
---

[Source code](https://github.com/jmcastagnetto/tidytuesday-kludges/tree/master/2019-07-30_video_games)

The data comes from [#TidyTuesday Video games dataset](https://github.com/rfordatascience/tidytuesday/blob/master/data/2019/2019-07-30), and I decided to go "old style" and used the [txtplot](https://cran.r-project.org/web/packages/txtplot/index.html) R package.

First, let's graph the number of games released per year

![Number of games per year](/tidytuesday-kludges/assets/2019-07-30-video-games/txtplot-games-per-year.png) 
<!--more-->

Next, we can plot their Metascore distribution by price range:

![Metascore by price range](/tidytuesday-kludges/assets/2019-07-30-video-games/txtplot-metascore-by-price-range.png) 

Finally, we will plot the price distribution, to find the pricing "sweet spots":

![Pricing sweet spots](/tidytuesday-kludges/assets/2019-07-30-video-games/txtplot-price-distribution.png) 

As an added bonus, here is an animation of how game ownership has changed over the years, classified by price range:

![Change in game ownership over the years](/tidytuesday-kludges/assets/2019-07-30-video-games/animaotion-points.gif)
