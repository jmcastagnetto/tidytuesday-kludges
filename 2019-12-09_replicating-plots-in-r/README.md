## Reproducing the plot of divorce rate and margarina consumption in Maine from [Spurious Correlations]()

There are at least three different versions of this plot:

1. The one from the original version of the site: http://tylervigen.com/view_correlation?id=1703
2. A more sleek/modern version on the current (as of 2019-12-09) site: http://tylervigen.com/spurious-correlations
3. A plot that appeared in the 2014-05-26 article "[Spurious correlations: Margarine linked to divorce?](https://www.bbc.com/news/magazine-27537142)"

I will try to attempt reproducing all three (mis-)using [ggplot2](https://github.com/rafalab/dslabs/), and the dataset from the [dslabs](https://github.com/rafalab/dslabs/) package.

### Old version of the plot

The original version looks like this:

![Orignal (old) version of the plot](https://github.com/jmcastagnetto/tidytuesday-kludges/blob/master/2019-12-09_replicating-plots-in-r/divorce-margarine-old-version.png)

And the repliacted version is:

![Replicated plot of the old version](https://github.com/jmcastagnetto/tidytuesday-kludges/blob/master/2019-12-09_replicating-plots-in-r/sc-oldplot-divorce-margarine.png)


### BBC's version of the plot

For this plot I had to get the background image, and [tineye](https://tineye.com/) helped me find a copy of it at BBC's site (https://ichef-1.bbci.co.uk/news/1024/cpsprodpb/18663/production/_95493999_p04z8ltw.jpg)

So here is the original plot (from BBC)

![BBC version of the plot](https://ichef.bbci.co.uk/news/320/media/images/75069000/jpg/_75069991_newcorrelation_graph02b_624gr.jpg)

And here is my attempt at replicating it (couldn't get the axis title alignment quite the same):

![My replication of the BBC plot](https://github.com/jmcastagnetto/tidytuesday-kludges/blob/master/2019-12-09_replicating-plots-in-r/sc-bbcplot-divorce-margarine.png)