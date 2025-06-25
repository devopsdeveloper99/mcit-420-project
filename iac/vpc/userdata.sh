#!/bin/bash -ex

sudo yum update -y

Sudo yum install -y python3 git wget tar gcc zlib-devel

sudo yum groupinstall -y "Development Tools"

cd /usr/local/src

sudo wget https://www.sqlite.org/2024/sqlite-autoconf-3450000.tar.gz

sudo tar -xzf sqlite-autoconf-3450000.tar.gz

cd sqlite-autoconf-3450000
sudo ./configure --prefix=/usr/local
sudo make
sudo make install

# Export updated paths for runtime
export LD_LIBRARY_PATH=/usr/local/lib
export PATH=/usr/local/bin:$PATH

# Clone Django project
cd /home/ec2-user
git clone https://github.com/devopsdeveloper99/newssearch.git
cd newssearch

# Ensure ownership
chown -R ec2-user:ec2-user /home/ec2-user/newssearch

# Create and activate Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Upgrade pip and install Python dependencies
pip install --upgrade pip setuptools virtualenv
pip install -r requirements.txt || true
pip install django requests 'urllib3<2.0' --force-reinstall

# OPTIONAL: Apply DB migrations if needed
# python3 manage.py migrate

# Run Django server in background and log output
nohup python3 manage.py runserver 0.0.0.0:8000 > /home/ec2-user/newssearch/server.log 2>&1 &