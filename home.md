---
title:       "Lexgera"
h1:          "Lexgera"
lang:        "it"
slug:        "home"
layout:      "pagina"
permalink:   "/lexgera.html"
og_image:    "/assets/img/og-image.png"
og_thumb:    "/assets/img/og-thumb.png"
keyword:     "legge, avvocati"
excerpt:     "Descrizione breve della pagina"
---
{% assign t = site.data.testi[page.lang] %}
{%- include sezione-1.html t=t -%}
{%- include sezione-2.html t=t -%}
{%- include sezione-3.html t=t -%}
{%- include sezione-4.html t=t -%}
