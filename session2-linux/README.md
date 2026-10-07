# Session 2: Linux Homework

## Task 1: Soft Link vs Hard Link

| | Soft Link (symbolic link) | Hard Link |
| :--- | :--- | :--- |
| What it is | A shortcut/pointer to a file **path** | Another **name** for the same inode (same data) |
| Inode | Different inode from the target | Shares the same inode as the target |
| Works if target is deleted? | No — becomes a broken/dangling link | Yes — data survives until the last hard link is removed |
| Can link a directory? | Yes | No (normal users cannot hard-link directories) |
| Can cross filesystems? | Yes | No — must be on the same filesystem |

Commands:

```bash
# Soft link
ln -s /path/to/original.txt softlink.txt

# Hard link
ln /path/to/original.txt hardlink.txt

# See inode numbers (hard links share one inode)
ls -li original.txt hardlink.txt softlink.txt

# Practice: create and delete
echo "hello" > original.txt
ln original.txt hardlink.txt
ln -s original.txt softlink.txt
rm original.txt        # softlink.txt is now broken, hardlink.txt still works
```

**Interview answer:** A hard link is an extra directory entry pointing to the same inode, so the data lives as long as any link exists; it cannot span filesystems or point to directories. A soft link is a small file that stores a path, so it can point anywhere (including directories and other filesystems) but breaks when the target is removed.

## Task 2: adduser vs useradd

| | `adduser` | `useradd` |
| :--- | :--- | :--- |
| Type | Friendly Perl wrapper script (Debian/Ubuntu) | Low-level system binary (all distros) |
| Interaction | Interactive — prompts for password, full name, etc. | Non-interactive — everything via flags |
| Home directory | Created automatically | Only created if you pass `-m` |
| Default shell | Sets `/bin/bash` automatically | Defaults to `/bin/sh` unless `-s` is given |

**On Ubuntu, `adduser` is preferred** for interactive use because it creates the home directory, sets a sane shell, and prompts for the password. `useradd` is preferred in scripts/automation because it is non-interactive and available everywhere.

> ⚠️ Creating a user requires root privileges on a local machine (`sudo`). Run this on your own Linux machine/VM — it is documented here, not executed in this repo.

```bash
# Recommended on Ubuntu (run locally with sudo)
sudo adduser testuser

# Equivalent with useradd
sudo useradd -m -s /bin/bash testuser
sudo passwd testuser

# Verify
id testuser
getent passwd testuser
```

## Task 3: journalctl

`journalctl` reads the logs collected by **systemd-journald** — the central logging service on systemd-based Linux distributions. It captures kernel messages, service stdout/stderr, and boot logs in one indexed binary journal.

```bash
# All logs (newest last), page through with less
journalctl

# Live "tail -f" of the system journal
journalctl -f

# Logs since a time
journalctl --since "1 hour ago"
journalctl --since today

# Logs for one boot
journalctl -b        # current boot
journalctl -b -1     # previous boot

# Kernel messages only (like dmesg)
journalctl -k
```

Service-specific examples:

```bash
# All logs for a service
journalctl -u ssh.service

# Service logs since boot, follow live
journalctl -u nginx.service -b -f

# Only errors (priority 3) for a service
journalctl -u docker.service -p err

# System-level example: last 50 lines, no pager
journalctl -n 50 --no-pager
```

## Task 4: Linux Command Cheat Sheet

| Command | Purpose | Example |
| :--- | :--- | :--- |
| `ls` | List directory contents | `ls -lah` |
| `cd` | Change directory | `cd /var/log` |
| `pwd` | Print working directory | `pwd` |
| `cp` | Copy files/dirs | `cp -r src/ dst/` |
| `mv` | Move/rename | `mv old.txt new.txt` |
| `rm` | Remove files | `rm -rf dir/` (careful!) |
| `mkdir` / `touch` | Create dir / empty file | `mkdir -p a/b`, `touch f.txt` |
| `cat` / `less` | View file contents | `cat app.log` |
| `head` / `tail` | First/last lines | `tail -f app.log` |
| `grep` | Search text | `grep -r "error" /var/log` |
| `find` | Find files | `find / -name "*.log"` |
| `chmod` / `chown` | Permissions / ownership | `chmod 755 s.sh`, `chown u:g f` |
| `ps` / `top` | Processes | `ps aux`, `top` |
| `df` / `du` | Disk usage | `df -h`, `du -sh *` |
| `free` | Memory usage | `free -h` |
| `systemctl` | Manage services | `systemctl status nginx` |
| `journalctl` | View logs | `journalctl -u nginx` |
| `ssh` | Remote login | `ssh user@host` |
| `scp` / `rsync` | Copy over SSH | `scp f.txt user@host:/tmp` |
| `curl` / `wget` | HTTP requests / download | `curl -I https://example.com` |
| `tar` / `zip` | Archives | `tar -czvf a.tgz dir/` |
| `ln` | Links | `ln -s target link` |
| `sudo` | Run as root | `sudo systemctl restart ssh` |
| `man` / `--help` | Documentation | `man journalctl` |
