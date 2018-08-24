TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='cubis.conf'
CONFIGFOLDER='/root/.cubis'
COIN_DAEMON='cubisd'
COIN_CLI='cubis-cli'
COIN_PATH='/usr/local/bin/'
COIN_TGZ='https://github.com/altcuim/Cubiscoin/releases/download/v1.0.1/Cubiscoin-cli.tar.gz'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')

COIN_NAME='Cubis'
COIN_PORT=25333
RPC_PORT=26333

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function stop_priv_node(){
  echo -e "Stop $COIN_NAME deamon"
  systemctl stop $COIN_NAME.service
  sleep 3
}

function restart_node(){
  systemctl start $COIN_NAME.service
  echo -e "restart $COIN_NAME completed"
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
  cd $TMP_FOLDER
  wget -q $COIN_TGZ
  echo -e "Download $COIN_NAME binaries completed"
  tar xvzf $COIN_ZIP -C /usr/local/bin/
  compile_error
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
  cd - >/dev/null 2>&1
  rm -r $TMP_FOLDER >/dev/null 2>&1
  clear
}
prepare_system(){
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install libzmq5 >/dev/null 2>&1
}

prepare_system
stop_priv_node
download_node
restart_node
