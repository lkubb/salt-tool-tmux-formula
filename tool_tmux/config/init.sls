# vim: ft=sls

{#-
    Manages the tmux package configuration by

    * recursively syncing from a dotfiles repo

    Has a dependency on `tool_tmux.package`_.
#}

include:
  - .sync
