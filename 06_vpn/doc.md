**1.** step after creating tunnel
`sudo ip addr add 10.200.200.2/32 dev peer1`
**2.**
`sudo ip route add 10.200.200.1/32 dev peer1 src 10.200.200.2`
**3.**
`sudo wg show peer1 latest-handshakes` -> Should be non null
**4.**
`ping -c2 10.10.10.5` dns ping should response

- `AllowedIPs` must be set to all of these: `10.10.10.0/24, 10.200.200.1/32, 10.200.200.2/32`
- Dont forget to change port in compose..