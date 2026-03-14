---
title:       "Lexgera"
h1:          "Titolo 1"
lang:        "it"
slug:        "index"
layout:      "pagina"
permalink:   "/"
og_image:    "/assets/img/og-image.png"
og_thumb:    "/assets/img/og-thumb.png"
keyword:     "legge, avvocati"
excerpt:     "Descrizione breve della pagina"
---
{% assign t = site.data.testi[page.lang] %}

{%- include azienda.html t=t -%}

<!--
{%- include servizi.html t=t -%}
{%- include contatti.html t=t -%}
-->
