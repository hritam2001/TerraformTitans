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
  <title>TerraformTitans — Instance Identity</title>
  <style>
    body {
      font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
      margin: 0;
      background: linear-gradient(135deg, #0f172a, #1e293b);
      color: #e2e8f0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      text-align: center;
    }
    .container {
      background: #1e293b;
      padding: 2rem 3rem;
      border-radius: 12px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.5);
      max-width: 600px;
      width: 100%;
    }
    h1 {
      color: #38bdf8;
      margin-bottom: 1rem;
      font-size: 2rem;
      letter-spacing: 1px;
    }
    p {
      margin-bottom: 1.5rem;
      font-size: 1.1rem;
      color: #cbd5e1;
    }
    .grid {
      display: grid;
      grid-template-columns: 180px auto;
      gap: 0.75rem;
      text-align: left;
    }
    .key {
      color: #93c5fd;
      font-weight: 600;
    }
    .value {
      color: #f1f5f9;
    }
    hr {
      margin: 2rem 0;
      border: none;
      border-top: 1px solid #334155;
    }
    footer {
      font-size: 0.95rem;
      color: #94a3b8;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>TerraformTitans</h1>
    <p>This EC2 instance serves its own identity and IPs:</p>
    <div class="grid">
      <div class="key">Instance ID</div><div class="value">$IID</div>
      <div class="key">Availability Zone</div><div class="value">$AZ</div>
      <div class="key">Private IP</div><div class="value">$PRI_IP</div>
      <div class="key">Public IP</div><div class="value">${PUB_IP:-"(none — behind ALB or no public IP)"}</div>
    </div>
    <hr>
    <footer>We are Team TerraTitans and this is our Capstone Project [Team-4]</footer>
  </div>
</body>
</html>
EOF