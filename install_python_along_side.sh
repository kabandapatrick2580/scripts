#!/usr/bin/env bash

set -e

echo "=========================================="
echo " Python Source Installer"
echo "=========================================="

read -p "Enter the Python version you want to install (example: 3.11.2): " PYTHON_VERSION

PYTHON_TAR="Python-$PYTHON_VERSION.tgz"
PYTHON_DIR="Python-$PYTHON_VERSION"
DOWNLOAD_URL="https://www.python.org/ftp/python/$PYTHON_VERSION/$PYTHON_TAR"

echo ""
echo "Preparing to install Python $PYTHON_VERSION"
echo ""

echo "Updating package list..."
sudo apt update

echo "Installing required dependencies..."
sudo apt install -y \
build-essential \
zlib1g-dev \
libncurses5-dev \
libgdbm-dev \
libnss3-dev \
libssl-dev \
libreadline-dev \
libffi-dev \
libsqlite3-dev \
libbz2-dev \
wget

echo ""
echo "Downloading Python $PYTHON_VERSION..."
cd /tmp
wget $DOWNLOAD_URL

echo ""
echo "Extracting source files..."
tar -xvf $PYTHON_TAR

cd $PYTHON_DIR

echo ""
echo "Configuring build..."
./configure --enable-optimizations

echo ""
echo "Compiling Python (this may take several minutes)..."
make -j$(nproc)

echo ""
echo "Installing Python using altinstall..."
sudo make altinstall

echo ""
echo "=========================================="
echo "Installation completed"
echo "=========================================="

MAJOR_MINOR=$(echo $PYTHON_VERSION | cut -d '.' -f1,2)

echo ""
echo "Installed Python version:"
python$MAJOR_MINOR --version

echo ""
echo "Binary location:"
which python$MAJOR_MINOR

echo ""
echo "Done."