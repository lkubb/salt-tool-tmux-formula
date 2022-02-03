{%- from 'tool-tmux/map.jinja' import tmux %}

include:
  - .package
{%- if tmux.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
{%- if tmux.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  - .configsync
{%- endif %}
{%- if tmux.users | selectattr('tmux.tpm', 'defined') | selectattr('tmux.tpm') %}
  - .tpm
{%- endif %}
