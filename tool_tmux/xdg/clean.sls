# vim: ft=sls

{#-
    Removes tmux XDG compatibility crutches for all managed users.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tmux with context %}


{%- for user in tmux.users | rejectattr("xdg", "sameas", false) %}

{%-   set user_default_conf = user.home | path_join(tmux.lookup.paths.confdir, tmux.lookup.paths.conffile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(tmux.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(tmux.lookup.paths.xdg_conffile) %}

tmux configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_conf }}
    - source: {{ user_xdg_conffile }}

tmux does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_confdir }}
    - require:
      - tmux configuration is cluttering $HOME for user '{{ user.name }}'

{%-   if user.xdg.config != user.home ~ "/.config" and user.get("persistenv") %}

tmux is ignorant about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: ^{{ "alias tmux='tmux -f ${XDG_CONFIG_HOME}/" ~ tmux.lookup.paths.xdg_dirname |
                path_join(tmux.lookup.paths.xdg_conffile) ~ "'" | regex_escape }}$
    - repl: ''
    - ignore_if_missing: true
{%-   endif %}
{%- endfor %}
