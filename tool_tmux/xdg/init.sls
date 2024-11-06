# vim: ft=sls

{#-
    Ensures tmux adheres to the XDG spec
    as best as possible for all managed users.
    Has a dependency on `tool_tmux.package`_.
#}

include:
  - .migrated
