# 03_dns

## Deployment

For the DNS server, I chose the **BIND9** implementation inside a lightweight container based on the Debian image.  
The server is configured to respond only to internal LAN queries and resolves a custom domain used across the project:  
**`mydomain.local`**.

The configuration is split into two key files:

- `bind/named.conf.options` – global server options (e.g., recursion, listen addresses)
- `bind/named.conf.local` – zone configuration, linking zones to zone files

All specific domain records are stored under `bind/zones/`.

The server listens on UDP port 1053, which is properly **NAT**ted and **forwarded** through the router container.  
Thus, from the host's perspective, DNS queries are sent to `localhost:1053` or `dns.mydomain.local`.

### Requirements

- A NAT rule on the router to forward UDP/1053 traffic to the DNS container (10.10.10.5:53).
- `mydomain.local` zone must correctly point important services
- Bind9 configuration must match directory structure as expected:
  - `/etc/bind/named.conf.options`
  - `/etc/bind/named.conf.local`
  - `/etc/bind/zones/*`

## Testing

After deploying the DNS service and ensuring NAT and forwarding rules are applied, the DNS functionality is verified as follows:

### DNS Query test for A record

```bash
dig @localhost -p 1053 app.mydomain.local
dig dns.mydomain.local -p 1053 app.mydomain.local
```
### Testing from VPN tunel
```bash
dig @10.10.10.5 app.mydomain.local
```