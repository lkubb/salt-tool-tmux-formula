# `tmux` Formula
Sets up, configures and updates `tmux` terminal multiplexer.

## Usage
Applying `tool-tmux` will make sure `tmux` is configured as specified.

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

#### User-specific
The following shows an example of `tool-tmux` pillar configuration. Namespace it to `tool:users` and/or `tool:tmux:users`.
```yaml
user:
  xdg: true      # force xdg dirs
  # sync this user's config from a dotfiles repo available as
  # salt://dotconfig/<user>/tmux or salt://dotconfig/tmux
  dotconfig: true
  # persist tmux env vars to use xdg dirs permanently
  # (will be appended to file relative to $HOME)
  persistenv: '.config/zsh/zshenv'
  tmux:
    tpm: false  # installs Tmux Plugin Manager
```

#### Formula-specific
```yaml
tool:
  tmux:
    defaults:
      tpm: false # installs Tmux Plugin Manager
```

### Dotfiles
`tool-tmux.configsync` will recursively apply templates from 

- `salt://dotconfig/<user>/tmux` or
- `salt://dotconfig/tmux`

to the user's config dir for every user that has it enabled (see `user.dotconfig`). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).
