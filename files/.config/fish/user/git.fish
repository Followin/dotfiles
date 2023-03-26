function git_current_branch
  git rev-parse --abbrev-ref HEAD
end

function git_main_branch
  git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
end

abbr g git
abbr gst "git status"
abbr gsts "git status -s"

abbr gcmsg "git commit -m"
abbr gcam "git commit -am"
abbr gcn! "git commit -v --amend --no-edit"
abbr gcan! "git commit -v -a --amend --no-edit"
abbr gc! "git commit -v --amend"
abbr gc "git commit -v"

abbr gupam "git fetch && git pull --rebase --autostash origin master"
abbr gf "git fetch"
abbr gl "git pull"

abbr grhh "git reset --hard"
abbr grh "git reset"

abbr gclean "git clean -id"

abbr grt "cd (git rev-parse --show-toplevel || echo .)"

abbr gco "git checkout"
abbr gcm "git checkout (git_main_branch)"
abbr gcb "git checkout -b"
abbr gbD "git branch -D"

abbr gp "git push"
abbr gpf "git push --force-with-lease"
abbr gpsup "git push --set-upstream origin (git_current_branch)"

abbr ga "git add"
abbr gan "git add -N ."
abbr gapa "git add --patch"

abbr gd "git diff"
abbr gdca "git diff --cached"

abbr glo "git log --oneline --decorate"
abbr glols "git log --graph --pretty=\"\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'\" --stat"

abbr grs "git restore"

abbr gsta "git stash"
abbr gstaa "git stash apply"
