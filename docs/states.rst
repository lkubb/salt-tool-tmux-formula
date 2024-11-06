Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_tmux``
~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_tmux.package``
~~~~~~~~~~~~~~~~~~~~~
Installs the tmux package only.


``tool_tmux.xdg``
~~~~~~~~~~~~~~~~~
Ensures tmux adheres to the XDG spec
as best as possible for all managed users.
Has a dependency on `tool_tmux.package`_.


``tool_tmux.config``
~~~~~~~~~~~~~~~~~~~~
Manages the tmux package configuration by

* recursively syncing from a dotfiles repo

Has a dependency on `tool_tmux.package`_.


``tool_tmux.tpm``
~~~~~~~~~~~~~~~~~



``tool_tmux.clean``
~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_tmux`` meta-state
in reverse order.


``tool_tmux.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the tmux package.
Has a dependency on `tool_tmux.config.clean`_.


``tool_tmux.xdg.clean``
~~~~~~~~~~~~~~~~~~~~~~~
Removes tmux XDG compatibility crutches for all managed users.


``tool_tmux.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the tmux package.


``tool_tmux.tpm.clean``
~~~~~~~~~~~~~~~~~~~~~~~



