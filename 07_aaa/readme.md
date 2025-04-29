# 07_aaa

## Deployment

The AAA server was deployed using the official `freeradius/freeradius-server:latest` image.

FreeRADIUS is running in **full debug mode** (`-X` parameter) inside the container, which allows easy real-time monitoring and troubleshooting during development.

The server listens on:

- **Authentication port:** `1812/udp`
- **Accounting port:** `1813/udp`

Configuration files are structured as:


- `/etc/raddb/mods-config/files/authorize` — list of authorized users.
- `/etc/raddb/clients.conf` — list of trusted RADIUS clients (NAS devices).

### Important configuration notes:

- **Clients are configured** with shared secret keys to securely communicate with the RADIUS server.
- **Users are configured** with usernames and passwords (Cleartext-Password attribute).
- **Default testing credentials**:  
  Example user entry inside `authorize` file:
  test Cleartext-Password := "test25"
## Required steps before use

- Ensure ports `1812/udp` and `1813/udp` are reachable from router and other clients.
- Make sure all RADIUS clients (router, etc.) are properly listed in `clients.conf` with matching shared secrets.

---

## Testing

### 1. Direct RADIUS Test

Before integrating AAA into SSH, the RADIUS server can be tested using `radtest` utility from inside the network:

```bash
radtest test test25 127.0.0.1 0 testing123
```
Where
- test = username
- test25 = password
- 127.0.0.1 = FreeRADIUS IP (localhost inside container)
- 0 = NAS-Port-Id (default)
- testing123 = shared secret from clients.conf

Output should look like this:
```
Sent Access-Request Id 0 from 0.0.0.0:47874 to 127.0.0.1:1812 length 75
Received Access-Accept Id 0 from 127.0.0.1:1812 to 127.0.0.1:47874 length 38
```
### 2. SSH Authetication Test
Once RADIUS server responds correctly to radtest, the SSH server on the router container is configured to use PAM with pam_radius_auth.so module.
**1. Login via SSH**
- ssh test@localhost
**2. Check logs**
- FreeRADIUS logs `docker logs aaa -f` should show incoming Access-Request from the router IP.