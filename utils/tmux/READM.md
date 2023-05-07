# Installation
```
sudo apt-get install tmux
mkdir ~/tmux
git clone https://github.com/tmux-plugins/tmux-resurrect ~/tmux

echo "unbind-key C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# last windows
unbind l
bind-key \` last-window

#resurrect restore window
run-shell ~/tmux/resurrect.tmux" | tee ~/.tmux.conf

tmux source-file ~/.tmux.conf![image](https://user-images.githubusercontent.com/101592073/236673065-e04f9cef-a34b-43c9-bee8-43b529ff35bf.png)
```


# Keys & Shorcuts 

Scrol up and down

`C-a [ (q to cancel)`

Misc
```
C-a s (all windows across all sessions)
C-a ( or ) (move across sessions)
C-a , (name the window)
```



Save & restore sessions

```
C-a C-s (save sessions)
C-a C-r (restore sessions)
```
