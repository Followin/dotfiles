if status is-interactive
    # Commands to run in interactive sessions can go here
end

for f in $HOME/.config/fish/user/**/*.fish
  source $f
end
