# 04_mailserver

## Deployment

For the mailserver, the official image **`mailserver/docker-mailserver:latest`** was selected,  
providing a full-featured and production-ready email stack inside a single container.

The deployment uses the following structure:

- `config/` – configuration overrides and server settings.
- `maildata/` – persistent mail storage for user inboxes.
- `state/` – internal server state (e.g., Dovecot, Postfix states).
- `.env` – environment variables for easy configuration of the container.

Environment file `.env` contains critical settings like the mail domain, SSL usage, and user accounts.

The mailserver is responsible for:

- Handling SMTP (`port 25` for MTA relay and receiving)
- Secure SMTP Submission (`port 587`)
- IMAP access (`port 143`) for client email retrieval
- Local delivery and spam checking, but i am not sure if it works properly in my solution.

These ports are properly forwarded by the router container (NAT), making mail services reachable via **localhost** externally.

All emails are stored persistently inside the `maildata/` volume, even if the container is restarted or rebuilt.

### Requirements

- Ports 25, 587, 143 must be forwarded from the router to the mailserver (internal IP `10.10.10.15`).
- Proper configuration of DNS MX records if real domain was used (in this case internal DNS).
- SSL certificates can be optionally generated for encrypted submission and IMAP.

### Important configs

- `config/` contains override files for fine-tuning Postfix, Dovecot, and other services. Also in `/postfix-accounts.cf` there defined authorized users in this server.
- `.env` contains user account setup, mail domain, SSL settings, and restrictions.

## Testing

### Basic connectivity tests

To check if the mailserver is correctly reachable through NAT and responds to SMTP:

```bash
telnet localhost 25
telnet localhost 587
telnet localhost 143
```
First two commands should return `220` SMTP greetings for `STARTTLS`

To try sending secured email 
```bash
swaks --to husic@mydomain.local --from anotheruser@mydomain.local --server localhost --port 587 --auth LOGIN --auth
-user husic@mydomain.local --auth-password Heslo123 --tls
``` Output after establishing connection should be something like:  ....~> This is a test mailing....