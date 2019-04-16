---
permalink: /personal/
title: Categories
---
<p>Posts in category "personal" are:</p>

<ul>
  {% for post in site.categories.personal %}
    {% if post.url %}
        <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endif %}
  {% endfor %}
</ul>
