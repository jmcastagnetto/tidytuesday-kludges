---
layout: default
title: My `#TidyTuesday` visualization kludges
---

Main repo: [https://github.com/jmcastagnetto/tidytuesday-kludges/](https://github.com/jmcastagnetto/tidytuesday-kludges/)

<div class="posts">
  {% for post in site.posts %}
    <article class="post">
      <h2><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></h1>
      <div class="entry">
        {{ post.excerpt }}
      </div>
      <a href="{{ site.baseurl }}{{ post.url }}" class="read-more">Read More</a>
    </article>
  {% endfor %}
</div>
