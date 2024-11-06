# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_tmux`` meta-state
    in reverse order.
#}

include:
  - .tpm.clean
  - .config.clean
  - .package.clean
