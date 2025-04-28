FROM debian:bullseye-slim

# install packages
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      iptables \
      openssh-server \
      libpam-radius-auth \
      fail2ban \
      rsyslog \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash test \
&& echo 'test:test' | chpasswd
# prep dirs
RUN mkdir -p /etc/router /var/run/sshd




# copy your NAT and RADIUS‐shared‐secret files
COPY nat.conf             /etc/router/nat.conf
COPY pam_radius_auth.conf /etc/pam_radius_auth.conf

# write a *clean* PAM stack for sshd:
RUN printf '%s\n' \
    'auth    sufficient    pam_radius_auth.so' \
    'auth    required      pam_deny.so'        \
    'account sufficient    pam_radius_auth.so' \
    'account required      pam_permit.so'      \
    'session required      pam_permit.so'      \
  > /etc/pam.d/sshd

# sshd config tweaks
RUN sed -i \
      -e 's/^#PermitRootLogin.*/PermitRootLogin yes/' \
      -e 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' \
      -e 's/^#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' \
      -e 's/^#UsePAM.*/UsePAM yes/' \
      -e 's/^#LogLevel.*/LogLevel DEBUG3/' \
    /etc/ssh/sshd_config

# generate host keys
RUN ssh-keygen -A

# 4) nakonfigurovat rsyslog, aby logoval do /var/log/auth.log
RUN sed -i 's/#auth,authpriv.*\/var\/log\/auth.log/auth,authpriv.*\/var\/log\/auth.log/' /etc/rsyslog.conf

# setup fail2ban
COPY fail2ban/jail.local /etc/fail2ban/jail.local

# start NAT + sshd
CMD sh -c "\
        sh /etc/router/nat.conf & \
        rsyslogd -n & \
        fail2ban-server -xf & \
        exec /usr/sbin/sshd -D \
    "
