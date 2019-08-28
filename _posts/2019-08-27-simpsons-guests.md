---
layout: post
title: The Simpons 7 degrees of separation
categories: [tidytuesday, R]
---

[Source code](https://github.com/jmcastagnetto/tidytuesday-kludges/tree/master/2019-08-27_simpsons-guests)

Used the [Simpons guest dataset](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-08-27) from the [TidyTuesday](https://github.com/rfordatascience/tidytuesday/) project.

First, I looked at the distribution of the number of unique guests per season, and overall

![Overall guests distribution](/tidytuesday-kludges/assets/2019-08-27-simpsons-guests/guests-in-groups.png)

![Distribution of the number of guests over the seasons](/tidytuesday-kludges/assets/2019-08-27_simpsons-guests/tufte-boxplot.png)

## A newtwork of guests

Then, I grouped the guests by when they appear concurrently in an episode, and used `igraph` to try and cluster them in "communities"

![Network of guests showing clusters](/tidytuesday-kludges/assets/2019-08-27-simpsons-guests/guests-network.png)

Using the network, found that the longest distance between two guests is 7, so is "The Simpsons 7 degrees of separation".

Made the network into an interactive graph using [visNetwork](https://datastorm-open.github.io/visNetwork/). You can use the dropdown to pick a guest, "Marcia Wallace" is important in this network, because she has a lot of connections to other guests.

[An interactive visNetwork graph](/tidytuesday-kludges/assets/2019-08-27-simpsons-guests/visnetwork-interactive.html)

<iframe src="/tidytuesday-kludges/assets/2019-08-27-simpsons-guests/visnetwork-interactive.html" frameborder="0" width="900" height="700" allowfullscreen="allowfullscreen">A network of guests from "The Simpsons"</iframe>


Just for kicks, made another interactive graph using `networkD3`:

[An interactive networkD3 graph](/tidytuesday-kludges/assets/2019-08-27-simpsons-guests/networkd3-viz.html)

<iframe src="/tidytuesday-kludges/assets/2019-08-27-simpsons-guests/networkd3-viz.html" frameborder="0" width="900" height="700" allowfullscreen="allowfullscreen">A network of guests from "The Simpsons"</iframe>




