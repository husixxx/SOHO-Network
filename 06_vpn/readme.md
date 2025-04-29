# 06_vpn

## Deployment

For VPN connectivity, a containerized **WireGuard** server was deployed using the image `linuxserver/wireguard`.  
This server provides secure remote access into the internal Docker network.

The VPN uses:

- **Internal subnet:** `10.200.200.0/24`
- **WireGuard Server IP:** `10.200.200.1`
- **First peer/client IP:** `10.200.200.2`
- **Tunnel interface:** `peer1`

After launching the container (`docker compose up -d`), several **manual steps** must be done to fully activate the VPN connection:

### Required Steps after Docker startup

1. **Add IP address for VPN peer:**
```bash
  sudo ip addr add 10.200.200.2/32 dev peer1
```
2. **Add route for server communication:**
```bash
sudo ip route add 10.200.200.1/32 dev peer1 src 10.200.200.2
```

### Cleanup
```bash
sudo wg-quick down peer1 2>/dev/null || true
sudo ip link delete peer1 2>/dev/null || true
sudo ip route del 10.200.200.0/24 2>/dev/null || true
```

## Testing

**1.Check handshake between client and server**
```bash
sudo wg show peer1 latest-handshakes
```
- Expected Result: A non-null value confirming active handshake.

**2.Ping an internal DNS server**
```bash
ping -c2 10.10.10.5
```
- Expected result: ICMP echo replies should be received from 10.10.10.5.
- Every other services can be pinged and replies should be received.ss