{%- from 'tool-tmux/map.jinja' import tmux %}

{%- for user in tmux.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
tmux configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user.xdg.config }}/tmux
    - source:
      - salt://dotconfig/{{ user.name }}/tmux
      - salt://dotconfig/tmux
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
{%- endfor %}
