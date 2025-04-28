# Router
## Deployment
For the router I chose the `debian:bullseye-slim` image because it provides the necessary network stack for managing NAT rules, SSH access, PAM modules, and system logging.
The router is responsible for all external communication. It handles DNAT rules and redirects external traffic arriving on standard service ports (DNS, HTTP,...) to the correct internal service container based on static mappings defined in `./nat.conf`

Additionally, the router runs an ssh server **SSHD**, which allows ssh remote access. The SSH server is integrated with a **FreeRADIUS** authentication backend using PAM, meaning that SSH login attempts are authenticated against the centralized AAA server, running in `07_aaa`.
The RADIUS authentication is configured in `./pam_radius_auth.conf`, where the AAA server IP and shared secret are defined.

For brute-force protection, the router also runs **Fail2ban**, monitoring `/var/log/auth.log` for failed SSH login attempts. The jail configuration is located at:
`./fail2ban/jail.local` and will ban IPs automatically after 3 failed login attempts for 1 hour.

**Requirements**
- In order for SSH login via RADIUS to work, an user must exist on the destination machine. (test:test)
1. In the need of working ssh through freeRadius authentication, there must exist user in destination machine.

## Testing

### 1. NAT / Port forwarding
```bash
# Test HTTP port forwarding to reverse proxy
curl -I http://localhost/

# Test HTTPS port forwarding to reverse proxy
curl -kI https://localhost/

# Test DNS forwarding to bind9
dig @localhost -p 1053 example.com +short

# Test SMTP port forwarding to mail server
echo "test mail" | nc localhost 25

# Test IMAP port forwarding to mail server
(echo "A1 LOGIN test test"; echo "A1 LOGOUT") | nc localhost 143
```
### 2. SSH + FAIL2BAN
```bash
ssh test@localhost
```
Current password is `test25`, after its insertion you should be authorized and connected, in the `aaa` container should be logs about proccessing authorization request.

After inserting wrong password for `3` times, source IP is banned.
To see logs about banned IP`s run:
```bash
docker exec router fail2ban-client status sshd
```
