tmux is installed:
  pkg.installed:
    - name: tmux

tmux setup is completed:
  test.nop:
    - name: tmux setup has finished, this state exists for technical reasons.
    - require:
      - pkg: tmux
