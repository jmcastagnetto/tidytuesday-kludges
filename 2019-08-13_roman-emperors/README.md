For this dataset, I wanted to explore creating a graph that
show the predecessor for each emperor. 

Comparing the end and start dates, quickly noticed some cases in
which succesive entries did not correspond to a continuous
sucession. In fact, apparently there were times when multiple 
emperors were in power.

To get the predecessor for each emperor, I used a [naive 
comparison of the ending and start date for each reign, 
allowing for a 1 day overlap at most](https://github.com/jmcastagnetto/tidytuesday-kludges/blob/1455a8fef0ef9989da8c96480447d6a5eee01ca2/2019-08-13_roman-emperors/01-get-data.R#L6).

Made a couple of graphs using [igraph](https://igraph.org/r/), another one using [ggraph](https://github.com/thomasp85/ggraph), and an [interactive](https://jmcastagnetto.github.io/tidytuesday-kludges/tidytuesday/r/2019/08/13/roman-emperors.html) one using [visNetwork](https://datastorm-open.github.io/visNetwork/).

Special thanks to Katya Ognyanova for her [excellent network viz tutorial](https://kateto.net/network-visualization) tutorial.
