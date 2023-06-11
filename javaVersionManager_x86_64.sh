#!/bin/bash

jdk1_8_0_151_url='https://repo.huaweicloud.com/java/jdk/8u151-b12/jdk-8u151-linux-x64.tar.gz'
jdk1_8_0_202_url='https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz'
jdk11_url='https://d6.injdk.cn/openjdk/openjdk/11/openjdk-11+28_linux-x64_bin.tar.gz'
jdk17_url='https://d6.injdk.cn/openjdk/openjdk/17/openjdk-17.0.1_linux-x64_bin.tar.gz'

java_dir='/usr/lib/jvm/'

jdk1_8_0_151_home=$java_dir'jdk1.8.0_151'
jdk1_8_0_202_home=$java_dir'jdk1.8.0_202'
jdk11_home=$java_dir'jdk-11'
jdk17_home=$java_dir'jdk-17.0.1'

echo '[*] Checking if JDKs already downloaded...'
if [ -d "$jdk1_8_0_151_home" ] && [ -d "$jdk1_8_0_202_home" ] && [ -d "$jdk11_home" ] && [ -d "$jdk17_home" ]; then
    echo '[*] JDKs already downloaded, skipping download...'
else
    echo '[*] Downloading and extracting JDKs...'
    if [ -d "$java_dir" ]; then
        echo "[*] Directory $java_dir already exists. Skipping creation..."
    else
        sudo mkdir -p $java_dir
    fi

    if [ ! -d "$jdk1_8_0_151_home" ]; then
        echo "[*] Start Downloading $jdk1_8_0_151_home..."
        wget -qO- $jdk1_8_0_151_url | sudo tar xz -C $java_dir && echo "[+] $jdk1_8_0_151_home downloaded and extracted successfully!" || { echo "[-] Error: Failed to download or extract JDK 1.8.0_151"; exit 1; }
    fi
    if [ ! -d "$jdk1_8_0_202_home" ]; then
        echo "[*] Start Downloading $jdk1_8_0_202_home..."
        wget -qO- $jdk1_8_0_202_url | sudo tar xz -C $java_dir && echo "[+] $jdk1_8_0_202_home downloaded and extracted successfully!" || { echo "[-] Error: Failed to download or extract JDK 1.8.0_202"; exit 1; }
    fi
    if [ ! -d "$jdk11_home" ]; then
        echo "[*] Start Downloading $jdk11_home..."
        wget -qO- $jdk11_url | sudo tar xz -C $java_dir && echo "[+] $jdk11_home downloaded and extracted successfully!" || { echo "[-] Error: Failed to download or extract JDK 11"; exit 1; }
    fi
    if [ ! -d "$jdk17_home" ]; then
        echo "[*] Start Downloading $jdk17_home..."
        wget -qO- $jdk17_url | sudo tar xz -C $java_dir && echo "[+] $jdk17_home downloaded and extracted successfully!" || { echo "[-] Error: Failed to download or extract JDK 17"; exit 1; }
    fi
fi

echo '[*] Configuring environment variables...'

echo "export JAVA_HOME=$jdk1_8_0_151_home" | sudo tee -a /etc/environment
echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/environment

echo "export JDK_1_8_0_202=$jdk1_8_0_202_home" | sudo tee -a /etc/environment
echo "export PATH=\$PATH:\$JDK_1_8_0_202/bin" | sudo tee -a /etc/environment

echo "export JDK_11=$jdk11_home" | sudo tee -a /etc/environment
echo "export PATH=\$PATH:\$JDK_11/bin" | sudo tee -a /etc/environment

echo "export JDK_17=$jdk17_home" | sudo tee -a /etc/environment
echo "export PATH=\$PATH:\$JDK_17/bin" | sudo tee -a /etc/environment

source /etc/environment

echo '[*] Setting up update-alternatives...'
sudo update-alternatives --install /usr/bin/java java $jdk1_8_0_151_home/bin/java 1
sudo update-alternatives --install /usr/bin/java java $jdk1_8_0_202_home/bin/java 2
sudo update-alternatives --install /usr/bin/java java $jdk11_home/bin/java 3
sudo update-alternatives --install /usr/bin/java java $jdk17_home/bin/java 4

echo '1) JDK 1.8.0_151'
echo '2) JDK 1.8.0_202'
echo '3) JDK 11'
echo '4) JDK 17'
read choice

case $choice in
    1)
        sudo update-alternatives --set java $jdk1_8_0_151_home/bin/java
        ;;
    2)
        sudo update-alternatives --set java $jdk1_8_0_202_home/bin/java
        ;;
    3)
        sudo update-alternatives --set java $jdk11_home/bin/java
        ;;
    4)
        sudo update-alternatives --set java $jdk17_home/bin/java
        ;;
    *)
        echo '[-] Invalid choice.'
        ;;
esac