---
layout: post
title: Interactive graph of roman emperors
categories: [tidytuesday, R]
---

[Source code](https://github.com/jmcastagnetto/tidytuesday-kludges/tree/master/2019-08-13_roman-emperors)

## Using visNetwork

Emperors from the **Principate** era marked as squares, and from the **Dominate** era as triangles.

[An interactive graph](/tidytuesday-kludges/assets/2019-08-13-roman-emperors/visnetwork-interactive.html) using [visNetwork](https://datastorm-open.github.io/visNetwork/).

<iframe src="/tidytuesday-kludges/assets/2019-08-13-roman-emperors/visnetwork-interactive.html" frameborder="0" width="900" height="700" allowfullscreen="allowfullscreen">A network of roman emperors</iframe>

<!--more-->

## Using igraph

Regular network

![Regular network](/tidytuesday-kludges/assets/2019-08-13-igraph-plot.png)

And with (artificial) clusters

![Network with clusters](/tidytuesday-kludges/assets/2019-08-13-igraph-cluster-plot.png)

## Using ggraph

![Regular network](/tidytuesday-kludges/assets/2019-08-13-ggraph-plot.png)
