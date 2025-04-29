# IBS Project – Secure SOHO Network Deployment

- Author: Richard Húska
This project is part of the *Information and Network Security* course and represents a secure SOHO (Small Office/Home Office) network setup using containerized services. The infrastructure is built with **Docker Compose**, using real-world services and practices in terms of **authentication, access control, monitoring, and routing**.

## Requirements
To successfully run and test the project, you need the following environment:
- Operating system: **Linux**
- Installed: `docker`, `docker-compose`
- User permissions: root/sudo access for Docker networking

## How to Run
1. Clone or download this repository.
2. Open a terminal in the project root directory.
3. Run the following command to start all services:

```bash
sudo docker-compose up -d
```

## Project
In this network there are these services available at corresponding ports. For all external communication is responsible router, which routes packets from host to this services.

| Service            | Protocol | Port  |
|--------------------|----------|-------|
| HTTP               | TCP      | 80    |
| HTTPS              | TCP      | 443   |
| DNS                | UDP/TCP  | 1053  |
| Mail - SMTP        | TCP      | 25    |
| Mail - Submission  | TCP      | 587   |
| Mail - IMAP        | TCP      | 143   |
| VPN (WireGuard)    | UDP      | 666   |
| RADIUS Auth        | UDP      | 1812  |
| RADIUS Accounting  | UDP      | 1813  |
| SSH (Router Access)| TCP      | 22    |

Every service has its own documentation in appropriate folder (`01_router/readme.md, ..`), where is detailed description of deployment proccess and testing.

## Bibliography
Used sources:
- **Debian Base Image (Router)**  
  https://hub.docker.com/_/debian

- **NGINX (Reverse Proxy)**  
  https://nginx.org/

- **ISC BIND (DNS Server)**  
  https://www.isc.org/bind/

- **Docker Mailserver (Mail Server)**  
  https://docker-mailserver.github.io/docker-mailserver/

- **OpenSSH (SSH Server)**  
  https://www.openssh.com/

- **WireGuard (VPN Server)**  
  https://www.wireguard.com/

- **FreeRADIUS (AAA Server)**  
  https://freeradius.org/

- **Fail2ban (Brute-force Protection)**  
  https://www.fail2ban.org/

- **ChatGPT (Debugging Assistant)**  
  https://chat.openai.com/

