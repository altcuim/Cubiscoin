COIN_DAEMON='cubisd'
COIN_CLI='cubis-cli'
COIN_PATH='/root/cubis/'
COIN_TGZ='https://github.com/altcuim/Cubiscoin/releases/download/v1.0.1/Cubiscoin-cli.tar.gz'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_NAME='Cubis'
COIN_PORT=25333

function stop_priv_node(){
  echo -e "Stop $COIN_NAME deamon"
  systemctl stop $COIN_NAME.service
  sleep 5
  rm /usr/local/bin/$COIN_DAEMON
  rm /usr/local/bin/$COIN_CLI
  mkdir $COIN_PATH
  cd $COIN_PATH
  ./cubis-cli stop
  sleep 5
}

function restart_node(){
  echo -e "Start $COIN_NAME deamon"
  cd $COIN_PATH
  ./cubisd -daemon
  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    exit 1
  fi
  sleep 10
  ./cubis-cli getinfo
  echo -e "MN upgrade completed"
}

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function download_node() {
  echo -e "Prepare to download $COIN_NAME binaries"
  cd $COIN_PATH
  wget -q $COIN_TGZ
  echo -e "Download $COIN_NAME binaries completed"
  tar xvzf $COIN_ZIP -C $COIN_PATH
  compile_error
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
  rm $COIN_ZIP
}
function prepare_system(){
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install libzmq5 >/dev/null 2>&1
}

function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port $COIN_PORT"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}
prepare_system
stop_priv_node
download_node
enable_firewall
restart_node
