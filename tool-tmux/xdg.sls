{%- from 'tool-tmux/map.jinja' import tmux %}

include:
  - .package

{%- for user in tmux.users | rejectattr('xdg', 'sameas', False) %}
Existing tmux configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/tmux/tmux.conf
    - source: {{ user.home }}/.tmux.conf
    - onlyif:
      - test -e {{ user.home }}/.tmux.conf
    - makedirs: true
    - prereq_in:
      - tmux setup is completed

tmux has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config }}/tmux/tmux.conf
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: True
    - mode: '0600'
    - dir_mode: '0700'
    - prereq_in:
      - tmux setup is completed

  {%- if user.xdg.config != user.home ~ '/.config' and user.get('persistenv') %}
# if XDG_CONFIG_HOME is not ~/.config , you need to alias tmux='tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf' because it is hardcoded
tmux uses config file in custom XDG_CONFIG_HOME for user {{ user.name }}:
  file.append:
    - name: {{ user.persistenv }}
    - text: alias tmux='tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf'
  {%- endif %}
{%- endfor %}
