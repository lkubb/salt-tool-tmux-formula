{%- from 'tool-tmux/map.jinja' import tmux %}

include:
  - .package
{%- if tmux.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
