include:
  - .package
{%- if salt['pillar.get']('tool:tmux', salt['pillar.get']('tool:users', [])) | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
