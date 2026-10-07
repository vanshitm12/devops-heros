# Session 4: Networking Commands

Run each command on your own machine, paste your **own** output or screenshot in
the evidence block under it, and keep the short explanation.

## 1. `ifconfig` / `ip addr`

```bash
ifconfig          # macOS/Linux (may need: sudo ifconfig)
ip addr           # Linux
```

**What it shows:** every network interface and its IP address, netmask and MAC
address — your machine's identity on each network.

**My output:**

```text
<paste output or add screenshot here>
```

## 2. `ping`

```bash
ping -c 4 8.8.8.8
ping -c 4 google.com
```

**What it shows:** whether a host is reachable and the round-trip time; also
proves DNS works when pinging a hostname.

**My output:**

```text
<paste output or add screenshot here>
```

## 3. `nslookup` / `dig`

```bash
nslookup google.com
dig google.com
```

**What it shows:** which IP addresses a domain name resolves to — the DNS
translation step before any connection.

**My output:**

```text
<paste output or add screenshot here>
```

## 4. `traceroute` / `tracert`

```bash
traceroute google.com     # macOS/Linux
tracert google.com        # Windows
```

**What it shows:** every router hop between you and the destination and the
latency of each hop.

**My output:**

```text
<paste output or add screenshot here>
```

## 5. `netstat` / `ss`

```bash
netstat -an | head        # macOS
ss -tuln                  # Linux: listening TCP/UDP ports
```

**What it shows:** open connections and which ports are listening — useful to
see which services a machine exposes.

**My output:**

```text
<paste output or add screenshot here>
```

## 6. `curl`

```bash
curl -I https://example.com
```

**What it shows:** the HTTP response headers — confirms a web server is
reachable and responding on port 80/443.

**My output:**

```text
<paste output or add screenshot here>
```

## 7. `arp -a`

```bash
arp -a
```

**What it shows:** the local IP-to-MAC address table — who your machine has
recently talked to on the local network.

**My output:**

```text
<paste output or add screenshot here>
```

## 8. `route` / `netstat -r`

```bash
netstat -rn               # routing table (macOS/Linux)
ip route                  # Linux
```

**What it shows:** the routing table — which gateway your traffic takes to
leave the local network.

**My output:**

```text
<paste output or add screenshot here>
```
