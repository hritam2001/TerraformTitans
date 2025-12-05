#!/bin/bash
set -euxo pipefail

# Install Apache
yum -y update
yum -y install httpd
systemctl enable --now httpd

# Fetch instance details from IMDSv2
TOKEN="$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")"

IID="$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)"
AZ="$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)"
PRI_IP="$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)"
PUB_IP="$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 || true)"

# Render page
cat >/var/www/html/index.html <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>TerraformTItans — Instance Identity</title>
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
           margin: 2rem; background: #0f172a; color: #e2e8f0; }
    h1 { color: #38bdf8; }
    .grid { display:grid; grid-template-columns: 220px auto; gap:.5rem; }
    .key { color:#93c5fd; }
  </style>
</head>
<body>
  <h1>TerraformTItans</h1>
  <p>This EC2 instance serves its own identity and IPs:</p>
  <div class="grid">
    <div class="key">Instance ID</div><div>$IID</div>
    <div class="key">Availability Zone</div><div>$AZ</div>
    <div class="key">Private IP</div><div>$PRI_IP</div>
    <div class="key">Public IP</div><div>${PUB_IP:-"(none — behind ALB or no public IP)"}</div>
  </div>
  <hr style="margin:1.5rem 0;border-color:#334155">
  <p>Tip: If you hit this via the ALB, the client IP appears in the <code>X-Forwarded-For</code> header.</p>
</body>
</html>
EOF