#!/usr/bin/bash
# 
# Installs terraform, go, az cli, dotnet for WSL environment

cd ~

sudo apt-get update -y
sudo apt-get install -y wget apt-transport-https software-properties-common

mkdir -p "$(pwd)/go/bin"
cat <<EOT > .ary-settings.sh
export GOBIN=$(pwd)/go/bin
EOT

if ! grep -q ".ary-settings.sh" .bashrc ; 
then 
  echo "add ary-settings to .bashrc"
  echo ". ~/.ary-settings.sh" >> .bashrc
fi

if ! command -v go ; 
then 
  echo "Installing GO"
  GO_VERSION="1.19.2"

  if ! test -f go$GO_VERSION.tar.gz ; then
    wget  -r --tries=10 https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz -O go$GO_VERSION.tar.gz
  else
    echo "Go distr downloaded..."
  fi
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go$GO_VERSION.tar.gz
else
  echo "Go already installed" 
fi
echo "export GOROOT=/usr/local/go"          >> ".ary-settings.sh" 
echo "export PATH=\$PATH:/usr/local/go/bin" >> ".ary-settings.sh" 


if ! command -v terraform ; 
then 
    echo "Install Terraform"
    sudo apt-get install -y gnupg software-properties-common

    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

    gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update
    sudo apt-get install terraform -y
else
    echo "Terraform already installed"
fi

if ! (command -v az | grep '/usr/bin/az') ; 
then 
    echo "Install AZ CLI"
    sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

    sudo apt-get update
    sudo apt-get install azure-cli -y
else
    echo "AZ already installed"
fi

if ! (command -v kubectl) ; 
then 
    echo "Install kubectl"
    sudo apt-get install -y ca-certificates curl apt-transport-https
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
else
    echo "kubectl already installed"
fi


if ! (command -v dotnet) ; 
then 
    echo "Install Dotnet SDK"
    wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-6.0 dotnet-sdk-7.0
else
    echo "Dotnet already installed"
fi



sudo apt-get update

sudo apt-get install -y mc
sudo apt-get install -y powershell

#configure git
git config --global credential.helper store




