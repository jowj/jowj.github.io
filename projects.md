---
permalink: /projects/
title: Projects
---
<p>Posts in category "projects" are:</p>

<ul>
  {% for post in site.categories.projects %}
    {% if post.url %}
        <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endif %}
  {% endfor %}
</ul>
