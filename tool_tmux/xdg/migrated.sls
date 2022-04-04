# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tmux with context %}

include:
  - {{ tplroot }}.package


{%- for user in tmux.users | rejectattr('xdg', 'sameas', False) %}

{%-   set user_default_conf = user.home | path_join(tmux.lookup.paths.confdir, tmux.lookup.paths.conffile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(tmux.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(tmux.lookup.paths.xdg_conffile) %}

# workaround for file.rename not supporting user/group/mode for makedirs
tmux has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user_xdg_confdir }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true
    - onlyif:
      - test -e '{{ user_default_conf }}'

Existing tmux configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user_xdg_conffile }}
    - source: {{ user_default_conf }}
    - require:
      - tmux has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - tmux setup is completed

tmux has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user_xdg_conffile }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - makedirs: true
    - mode: '0600'
    - dir_mode: '0700'
    - require:
      - Existing tmux configuration is migrated for user '{{ user.name }}'
    - require_in:
      - tmux setup is completed

{%-   if user.xdg.config != user.home ~ '/.config' and user.get('persistenv') %}

persistenv file for tmux exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

# if XDG_CONFIG_HOME is not ~/.config , you need to
# alias tmux='tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf' because it is hardcoded
# not sure how to force custom XDG_DATA_HOME
tmux knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.persistenv }}
    - text: alias tmux='tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf'
    - require:
      - persistenv file for tmux exists for user '{{ user.name }}'
    - require_in:
      - tmux setup is completed
{%-   endif %}
{%- endfor %}
