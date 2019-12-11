# installing dependencies
echo "Installing required packages..."
apt-get install -y \
  docker \
  docker-compose \
  mysql-client \
  git \
  zsh \
  &> /dev/null
echo "Done"
echo ""



# check if deckle user already exists
if getent passwd "deckle" >/dev/null; then
    echo "User deckle already exists"
else
    echo "Creating the deckle user"
    sudo useradd -m -U -G docker,sudo -p $(openssl passwd -1 deckle) -s /bin/zsh deckle
    echo "Done"

fi
echo ""

# moving apps to deckle home
echo "Installing local apps in deckle home directory..."
if [ -d "/home/deckle/apps" ]; then
  echo "Removing previously installed apps"
  rm -rf /home/deckle/apps
fi
echo "Copying new apps..."
mv /tmp/apps /home/deckle
echo "Done"
echo ""

# prepare projects directory
if [ ! -d "/home/deckle/projects" ]; then
  echo "Creating projects target directory"
  mkdir /home/deckle/projects
  echo ""
fi


# Configuring Docker
if [ -d "/tmp/docker.service.d" ]; then
  if [ -d "/etc/systemd/system/docker.service.d" ]; then
    rm -rf "/etc/systemd/system/docker.service.d";
  fi
mv /tmp/docker.service.d /etc/systemd/system/
fi

if ! docker network ls | grep -q deckle; then
  echo "Creating the deckle docker network"
  docker network create deckle
else
  echo "Docker network deckle already exists"
fi
echo ""

# adding docker group to vagrant user
usermod -G docker vagrant

# starting docker apps
echo "Starting deckle apps..."
if [ -d "/home/deckle/apps" ]; then
  cd /home/deckle/apps || exit;
  while IFS= read -d $'\0' -r dir ; do
    (
      cd "$dir" || exit
      if [ -f docker-compose.yml ]; then
        docker-compose up -d
      fi
    )
  done < <(find . -mindepth 1 -maxdepth 1 -type d -print0)
else
  echo "Unable to access the apps directory (/home/deckle/apps)"
fi

# install oh my zsh
if [ ! -d /home/deckle/.oh-my-zsh ]; then
  echo "Installing Oh My Zsh..."
  runuser -l deckle -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
fi

echo "Enforcing files ownership to deckle user..."
sudo chown -R deckle "/home/deckle"
echo "Done"
echo ""
