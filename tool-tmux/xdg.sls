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
    - require_in:
      - tmux setup is completed

tmux has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config }}/tmux/tmux.conf
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: False
    - makedirs: True
    - mode: '0600'
    - dir_mode: '0700'
    - require_in:
      - tmux setup is completed

  {%- if user.xdg.config != user.home ~ '/.config' and user.get('persistenv') %}

persistenv file for tmux for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home }}/{{ user.persistenv }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

# if XDG_CONFIG_HOME is not ~/.config , you need to alias tmux='tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf' because it is hardcoded
tmux uses config file in custom XDG_CONFIG_HOME for user {{ user.name }}:
  file.append:
    - name: {{ user.persistenv }}
    - text: alias tmux='tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf'
    - require:
      - persistenv file for tmux for user '{{ user.name }}' exists
  {%- endif %}
{%- endfor %}
