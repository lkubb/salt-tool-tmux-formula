# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tmux with context %}


{%- for user in tmux.users %}

tmux config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_tmux'].conffile }}

{%-   if user.xdg %}

tmux config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_tmux'].confdir }}
{%-   endif %}
{%- endfor %}
