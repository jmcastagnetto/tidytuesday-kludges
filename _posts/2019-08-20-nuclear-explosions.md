---
layout: post
title: Chart, maps and globe showing nuclear explosions (1945-1998)
categories: [tidytuesday, R]
---

[Source code](https://github.com/jmcastagnetto/tidytuesday-kludges/tree/master/2019-08-20_nuclear-explosions)

The visualizations here were made using the `#TidyTuesday` dataset of [nuclear explosions](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-08-20) which where published by [`data is plural`](https://github.com/data-is-plural/nuclear-explosions). Originally the information came from a [report by the Stockholm International Peace Research Institute (SIPRI](https://github.com/data-is-plural/nuclear-explosions/blob/master/documents/sipri-report-original.pdf).

## Chart of the cummulative yield by country

The following chart compares the cummulative yield (the sum, in Megatons, of all nuclear devices detonated) for each country from the 1940s to the 1990s.

![Cummulative yield of nuclear explosions by country](/tidytuesday-kludges/assets/2019-08-20-nuclear-explosions/yield-by-country.png))

<!--more-->

## A timeline of the nuclear explosions from 1945 to 1998

This [timeline of nuclear explosions (1945-1998)](/tidytuesday-kludges/assets/2019-08-20-nuclear-explosions/nuclear-explosions-map-blast-range.html) was produced using [echarts4r](https://github.com/JohnCoene/echarts4r), and shows the location of the nuclear explosions, using the range (radius) of the blast as the 

<iframe src="/tidytuesday-kludges/assets/2019-08-20-nuclear-explosions/nuclear-explosions-map-blast-range.html" frameborder="0" width="900" height="700" allowfullscreen="allowfullscreen">Timeline of nuclear explosions (195-1998)</iframe>


## A globe showing all nuclear explosion locations (1945-1998)

[Globe showing locations of nuclear explosions (1945-1998)](/tidytuesday-kludges/assets/2019-08-20-nuclear-explosions/nuclear-explosions-globe-thermal-range.html), made using [echarts4r](https://github.com/JohnCoene/echarts4r).

<iframe src="/tidytuesday-kludges/assets/2019-08-20-nuclear-explosions/nuclear-explosions-globe-thermal-range.html" frameborder="0" width="900" height="700" allowfullscreen="allowfullscreen">Globe mapping the locations of nuclear explosions (1945-1998)</iframe>

