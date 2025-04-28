#!/usr/bin/env expect

# Parametry
set timeout 5
set host "localhost"
set user "alice"
set wrong_pass "WrongPass"
set attempts 3

for {set i 1} {$i <= $attempts} {incr i} {
    spawn ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $user@$host
    expect {
        "assword:" {
            send "$wrong_pass\r"
            exp_continue
        }
        "Permission denied" {
            puts "Attempt $i: denied"
        }
        timeout {
            puts "Attempt $i: timeout"
        }
    }
    catch { close }
    sleep 1
}

exit 0
