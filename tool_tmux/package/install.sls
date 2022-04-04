# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tmux with context %}

tmux is installed:
  pkg.installed:
    - name: {{ tmux.lookup.pkg.name }}
    - version: {{ tmux.get('version') or 'latest' }}
    {#- do not specify alternative return value to be able to unset default version #}

tmux setup is completed:
  test.nop:
    - name: Hooray, tmux setup has finished.
    - require:
      - pkg: {{ tmux.lookup.pkg.name }}
