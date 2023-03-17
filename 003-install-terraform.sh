
# install tflint
TFLINT_VERSION=$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep tag_name | cut -d '"' -f 4)
wget "https://github.com/terraform-linters/tflint/releases/download/$TFLINT_VERSION/tflint_linux_amd64.zip" -O tflint.zip
unzip tflint.zip
chmod +x tflint
sudo mv tflint /usr/local/bin
