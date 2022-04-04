# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as tmux with context %}


{%- for user in tmux.users | selectattr('tmux.tpm', 'defined') | selectattr('tmux.tpm') %}

Tmux Plugin Manager is removed for user '{{ user.name }}':
  file.absent:
    - name: {{ user._tmux.datadir | path_join('plugins', 'tpm') }}
{%- endfor %}
