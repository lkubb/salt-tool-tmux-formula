{%- for user in salt['pillar.get']('tool:tmux', salt['pillar.get']('tool:users', [])) %}
  {%- from 'tool/tmux/map.jinja' import user, xdg with context %}
tmux configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ xdg.config }}/tmux
    - source:
      - salt://user/{{ user.name }}/dotfiles/tmux
      - salt://user/dotfiles/tmux
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
