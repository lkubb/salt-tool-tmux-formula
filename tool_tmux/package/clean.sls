# vim: ft=sls

{#-
    Removes the tmux package.
    Has a dependency on `tool_tmux.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as tmux with context %}

include:
  - {{ sls_config_clean }}


tmux is removed:
  pkg.removed:
    - name: {{ tmux.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
