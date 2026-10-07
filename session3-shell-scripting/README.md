# Session 3: Shell Scripting Homework — System Information Script

`system_info.sh` prints the date, hostname, username, disk usage and running
processes, uses variables and `read -p`, creates a directory with `mkdir`, a
file with `touch`, and stores the process list in it using `>` redirection.

## Commands used in the script

| Command | Used for |
| :--- | :--- |
| `date` | Print the current date/time |
| `hostname` | Print the machine hostname |
| `whoami` | Print the current username |
| `df -h` | Print disk usage in human-readable form |
| `ps` | List running processes |
| `read -p` | Take user input (name, roll number, comment) |
| `mkdir -p` | Create the output directory |
| `touch` | Create the empty output file |
| `echo` | Print output |
| `>` | Redirect `ps` output into `process.log` |
| `$(...)` | Store command output in variables |

## How to run

```bash
chmod +x system_info.sh
./system_info.sh                 # writes to ./system-info-output/process.log
./system_info.sh /tmp/my-output  # or pass your own output directory
```

## Example output structure

The script produces output in this shape — run it yourself and paste your own
output as evidence (do not copy this template):

```text
========== System Information ==========
Date      : <date output>
Hostname  : <your-hostname>
Username  : <your-username>

========== Disk Usage ==========
<df -h output: filesystem rows with size/used/avail/mount>

========== Running Processes ==========
<ps output: PID TTY TIME CMD rows>

========== Your Details ==========
Name       : <your name>
Roll No    : <your roll number>
Comment    : <your comment>

Process information saved to: <output_dir>/process.log
```

`process.log` then contains the same `ps` output captured via `>` redirection.
