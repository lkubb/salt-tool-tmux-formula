# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as tmux with context %}

include:
  - {{ tplroot }}.package.install


{%- for user in tmux.users | selectattr("tmux.tpm", "defined") | selectattr("tmux.tpm") %}

# git.cloned behaves as makedirs: true
Tmux Plugin Manager is installed for user '{{ user.name }}':
  git.cloned:
    - name: https://github.com/tmux-plugins/tpm
    - target: {{ user._tmux.datadir | path_join("plugins", "tpm") }}
    - user: {{ user.name }}
    - require:
        - tmux setup is completed
{%- endfor %}
