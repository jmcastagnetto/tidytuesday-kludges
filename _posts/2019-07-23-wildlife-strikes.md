---
layout: post
title: Visualizations from the "FAA Wildlife Strikes Database"
categories: [tidytuesday, R]
---

[Source code](https://github.com/jmcastagnetto/tidytuesday-kludges/tree/master/2019-07-23_bird-impacts)

First, a heatmap showing the distribution of wildlife strikes from 1990 until 2019 
by size of the animal, time of day, and type of organization to which the 
aircraft belonged (Government, Private, Military, Business, and 
Commercial airlines). 

![Distribution of wildlife strikes 1990-2019](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-heatmap.png) 
<!--more-->

An movie in [mp4 format](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-heatmap.mp4) of the
heatmap using [rayshader](https://www.rayshader.com/) for R. Below is an animation of the mp4 as a gif file

![A movie of the heatmap above](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-heatmap.gif)

The second visualization shows a small multiple of the yearly frequencies of
strikes for the USA contiguous states, showing that in recent years Texas and
California are responsible for the majority of this incidents

![Change in the frequencies of wildlife strikes in the contiguous states of USA](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-usamap.png) 

Also, generated a [mp4 movie](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-usamap.mp4) of
the graphic above, and below the converted gif animation:

![A movie of the plot above](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-usamap.gif)


