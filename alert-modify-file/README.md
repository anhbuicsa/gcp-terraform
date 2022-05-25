# Audit and notify when an user modify the important files
Tracking File Server configuration changes is important as these changes can lead to critical services outage

![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/alert-modify-file/hacker.png?raw=true "Title")
apt-get install auditd
service auditd restart

systemctl is-enabled auditd
ausearch -f  /opt/restartos.sh

sudo apt-cache madison google-cloud-ops-agent
apt install google-cloud-ops-agent




/etc/audit/auditd.conf
log_file = /var/log/auditd.log


service auditd restart


apt install google-cloud-ops-agent

