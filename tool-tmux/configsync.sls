{%- from 'tool-tmux/map.jinja' import tmux %}

{%- for user in tmux.users %}
tmux configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user.xdg.config }}/tmux
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
