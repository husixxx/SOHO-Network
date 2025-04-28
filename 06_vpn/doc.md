**SETUP**
- 1. step after creating tunnel: `sudo ip addr add 10.200.200.2/32 dev peer1`
- 2. step: `sudo ip route add 10.200.200.1/32 dev peer1 src 10.200.200.2`
- 3. step: `sudo wg show peer1 latest-handshakes` -> Should be non null
- 4. step: `AllowedIPs` in `peer1.conf` must be set to all of these: `10.10.10.0/24, 10.200.200.1/32, 10.200.200.2/32`
- 5. step: Dont forget to change port in compose..

In case of coliding with old connections use:
`sudo wg-quick down peer1 2>/dev/null || true`
`sudo ip link delete peer1     2>/dev/null || true`
`sudo ip route del 10.200.200.0/24 2>/dev/null || true`

**Testing** 
`ping -c2 10.10.10.5` dns ping should response