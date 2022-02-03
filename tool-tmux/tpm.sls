{%- from 'tool-tmux/map.jinja' import tmux %}

include:
  - .package

{%- for user in tmux.users | selectattr('tmux.tpm', 'defined') | selectattr('tmux.tpm') %}

# git.cloned behaves as makedirs: true
Tmux Plugin Manager is installed for user '{{ user.name }}':
  git.cloned:
    - name: https://github.com/tmux-plugins/tpm
    - target: {{ user._tmux.datadir }}/plugins/tpm
    - user: {{ user.name }}
    - require:
        - tmux setup is completed
{%- endfor %}
