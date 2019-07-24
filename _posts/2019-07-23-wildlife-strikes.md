---
layout: post
title: Viusalizations from the "FAA Wildlife Strikes Database"
categories: [tidytuesday, R]
---


[Source code](https://github.com/jmcastagnetto/tidytuesday-kludges/tree/master/2019-07-23_bird-impacts)

A small multiple of the yearly frequencies of strikes for the USA contiguous states,
showing that in recent years Texas and California are responsible for the majority
of this incidents

![Change in the frequencies of wildlife strikes in the contiguous states of USA](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-usamap.png) 

<!--more-->

Also, generated a [mp4 movie](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-usamap.mp4) of the graphic above, using [rayshader](https://www.rayshader.com/) for R.

![A movie of the plot above](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-usamap.gif)

A heatmap showing the distribution of wildlife strikes from 1990 until 2019 
by size of the animal, time of day, and type of organization to which the 
aircraft belonged (Government, Private, Military, Business, and 
Commercial airlines). 

![Distribution of wildlife strikes 1990-2019](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-heatmap.png) 

An movie in [mp4 format](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-heatmap.mp4) of the
heatmap, was also created, and converted to an animated gif (below).

![A movie of the heatmap above](/tidytuesday-kludges/assets/2019-07-23-wildlife-strikes-heatmap.gif)
