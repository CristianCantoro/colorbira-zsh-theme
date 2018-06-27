colorbira-zsh-theme
-------------------

A theme for oh-my-zsh, extends the bira theme (part of the default themes) with the following features:
* define the prompt colors for root and non-root user (username, @ symbol and host color), for use across several machines;
* visualize the ruby version in use with [rvm](https://rvm.io/) or [rbenv](https://github.com/rbenv/rbenv), the theme provides 3 helper functions `rvm_prompt_active`. `rvm_activate_prompt` and `rvm_deactivate_prompt` to control the visualization of the ruby info;
* support for Python [virtualenvs](https://virtualenv.pypa.io/en/stable/)
* support for git (branch name and clean/dirty repo)

## Screenshot

![Screenshot of the colorbira theme](https://i.imgur.com/EHMeJI4.png)

## Per-host prompt color definitions

Create a fine named `hosts.themes` with your per-host prompt color definitions.

You can define a color for the following 3 parts of the prompt:
  - the `<user>` name
  - the `<at>` symbol (@)
  - the `<host>` name
for a non-root user and for root

So the following variables can be defined:
  - `user_color_user`
  - `at_color_user`
  - `host_color_user`

  - `user_color_root`
  - `at_color_root`
  - `host_color_root`

The colors are defined in this order `<user>`, `<at>`, `<host>` so if a color is not defined the precedent is used.
No color equals to white.
