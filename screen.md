|Command             | Description
|--------------------|--------------------------------------------------------
|screen              | start screen
|screen -S \<name>   | start screen with with session \<name>
|screen -r \<name>   | attach screen session with name \<name>
|screen -r PID       | attach detached screen session
|screen -DR          | list of detached screen
|ctrl-a a            | send ctrl-a to current program
|ctrl-a c            | create a new window
|ctrl-a SPACE        | next window (also ctrl-a n)
|ctrl-a BACKSPACE    | previous window (also ctrl-a p)
|ctrl-a 1|2|3|n      | switch to window n
|ctrl-a "            | choose window
|ctrl-a ctrl a       | switch between windows
|ctrl-a w            | show all window
|ctrl-a A            | set window name
|ctrl-a x            | lock your screen session
|ctrl-a d            | detach window
|ctrl-a D D          | detach window and logout (quick exit)
|ctrl-a ?            | help
|ctrl-a \[           | start copy to the buffer
|ctrl-a ]            | paste from the buffer
|ctrl-a H            | creates a running log of the session
|ctrl-a S            | create split screen
|ctrl-a TAB          | switch between split screens
|ctrl-a X            | remove active window from split screen
|ctrl-a Q            | remove all windows from split screen except current one
|ctrl-a O            | logout active window (disable output)
|ctrl-a I            | login active window (enable output)
