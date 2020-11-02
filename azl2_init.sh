
#!/bin/bash

yum upgrade -y && yum update -y
amazon-linux-extras install -y kernel-ng
PKG_INSTALL='sudo git awscli zsh util-linux-user openssh passwd'
read -p "Enter USERNAME to add: " USERNAME

echo "Installing packages: ${PKG_INSTALL}"
yum install -y ${PKG_INSTALL} >> /dev/null

echo "Adding and configuring user: ${USERNAME}"
useradd -m ${USERNAME} >> /dev/null
echo "${USERNAME}    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

echo "Installing "Oh my zsh" for ${USERNAME}"
runuser -l ${USERNAME} -c "curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh"
sudo chsh ${USERNAME} -s /bin/zsh
runuser -l ${USERNAME} -c "sed -i 's/ZSH_THEME=.*/ZSH_THEME=\"tonotdo\"/' ~/.zshrc"

echo "Creating SSH keys for user ${USERNAME}"
runuser -l ${USERNAME} -c "ssh-keygen -t rsa -b 4096 -f /home/${USERNAME}/.ssh/id_rsa -q -N \"\"" >> /dev/null
echo "Public key for user ${USERNAME}:"
runuser -l ${USERNAME} -c "cat /home/${USERNAME}/.ssh/id_rsa.pub"
