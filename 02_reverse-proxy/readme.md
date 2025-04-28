# 02_reverse-proxy

## Deployment

For the reverse proxy, I chose the `nginx:stable-alpine` image because it is lightweight, reliable, and well-suited for forwarding internal services to the outside world.

The main Nginx configuration is stored in `./nginx.conf` and mounted inside the container.  
All SSL/TLS certificates exists inside `./certs/`.

The reverse proxy listens on:
- **Port 80** (HTTP) - redirects traffic to HTTPS
- **Port 443** (HTTPS) - serves encrypted traffic

The proxy forwards requests coming to `app.mydomain.local` to the internal backend service at `http://10.10.10.10`, to force HTTPS connection. This proxy server then has thes supports only for secure protocols TLSv1.2 and TLSv1.3, secures SSL cipher suites.
Proxy headers are correctly set (`Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`)


---

## Requirements

1. SSL/TLS certificates must be present:
   - `fullchain.pem` (certificate chain)
   - `privkey.pem` (private key)

These files are placed in the directory `./certs/`.

2. The backend application must be reachable at IP address `10.10.10.10` inside the Docker network.

3. The domain `app.mydomain.local` must resolve correctly:
   - Example for local testing, in `/etc/hosts` add:
     ```
     127.0.0.1 app.mydomain.local
     ```

---

## Testing

### 1. HTTP redirection test

```bash
curl -I http://app.mydomain.local
curl -vk https://app.mydomain.local
```
1. Should be response 301 Moved Permanently to `https://app.mydomain.local/`
2. Should load tls connection correctly.