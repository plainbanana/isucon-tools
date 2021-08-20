DEFAULT_USER:=ubuntu
MYSQL_ALLOW_IP:=%

install-essentials: ## install essentials
	sudo apt update
	sudo apt upgrade -y
	sudo apt install -y vim git-core htop dstat unzip graphviz jq silversearcher-ag iotop iftop sysstat
	# make zsh-init
	# make redis-init
	# make scripts-dl
	# make ssh_key_add
	# make alp-init
	make perconia-init
	make kataribe-init
	make slackcat-init
	make prepare-mysql-slowlog
	sudo tools/isulog install

ssh_key_add:
	sudo -u $(DEFAULT_USER) bash -c "curl https://github.com/Saggggo.keys >> ~/.ssh/authorized_keys"
	sudo -u $(DEFAULT_USER) bash -c "curl https://github.com/ryo628.keys  >> ~/.ssh/authorized_keys"
	sudo -u $(DEFAULT_USER) bash -c "curl https://github.com/plainbanana.keys  >> ~/.ssh/authorized_keys"

ssh_key_add_isucon:
	sudo -u isucon bash -c "curl https://github.com/Saggggo.keys >> ~/.ssh/authorized_keys"
	sudo -u isucon bash -c "curl https://github.com/ryo628.keys  >> ~/.ssh/authorized_keys"
	sudo -u isucon bash -c "curl https://github.com/plainbanana.keys  >> ~/.ssh/authorized_keys"

zsh-init: ## install zsh
	cd ~/ && sh -c "sudo apt update && sudo apt install -y zsh curl git-core" && rm -rf .oh-my-zsh && git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh  && sudo rm -f .zshrc && wget https://gist.github.com/plainbanana/5c6495c639674dd08c89bd2de3d881eb/raw/dfa7916f9f1b97cf358f13eaa2f316848d7883ed/.zshrc -P ~/ && if [ -e .bash_profile ]; then cat .bash_profile >> .zprofile; fi;

redis-init: ## install redis-server with systemd daemon
	sudo sh -c "apt install -y build-essential tcl wget && cd /usr/local/src && wget http://download.redis.io/redis-stable.tar.gz && tar xzvf redis-stable.tar.gz && cd redis-stable && make -o3 && make test && make install && sudo mkdir -p /etc/redis && cp redis.conf /etc/redis && wget https://gist.githubusercontent.com/plainbanana/0ec1a4589637c4c2961a834f7a1b7677/raw/95a54628ece623a89d7f8311fff61f83bbbcef2e/redis.service -P /etc/systemd/system/ && sudo adduser --system --group --no-create-home redis && sudo mkdir -p /var/lib/redis && sudo chown redis:redis /var/lib/redis && sudo chmod 770 /var/lib/redis && sudo systemctl enable redis && sudo systemctl start redis"

alp-init: ## install alp
	sudo sh -c "apt update && apt install -y unzip && cd /usr/local/src && wget https://github.com/tkuchiki/alp/releases/download/v0.0.4/alp_linux_amd64.zip && unzip alp_linux_amd64.zip && sudo mv alp_linux_amd64 /usr/local/bin/alp && sudo chown root:root /usr/local/bin/alp"

kataribe-init: ## install kararibe
	sudo sh -c "apt update && apt install -y unzip && cd /usr/local/src && wget  https://github.com/matsuu/kataribe/releases/download/v0.4.1/kataribe-v0.4.1_linux_amd64.zip && unzip kataribe-v0.4.1_linux_amd64.zip && sudo mv kataribe /usr/local/bin/kataribe && sudo chown root:root /usr/local/bin/kataribe"
	/usr/local/bin/kataribe -generate

# h2o-init: ## install H2O web server from source
#	sudo apt update && sudo apt install -y cmake openssl libssl-dev
#	sudo sh -c "cd /usr/local/src && rm -rf ./h20 && git clone https://github.com/h2o/h2o.git && cd h2o && git checkout 7677fce9e41668c6dc21928a19f7d977a186b4c4 && cmake -DWITH_BUNDLED_SSL=on . && make && make install && mkdir -p /etc/h2o && cp examples/h2o/* /etc/h2o && wget https://gist.github.com/plainbanana/5d0f8b22545b17ce5aabdf053050fa67/raw/c51cbe21b52dd8e3ae50ec4dec361dd129a0c3fd/h2o.service -P /etc/systemd/system/ && systemctl enable h2o && systemctl start h2o "

h2o-init: ## install H2O web server from source
	sudo apt update && sudo apt install -y cmake openssl libssl-dev
	sudo sh -c "cd /usr/local/src && rm -rf ./h20 && git clone https://github.com/h2o/h2o.git && cd h2o && git checkout 7359e98d78d018a35f5da7523feac69f64eddb4b && cmake -DWITH_BUNDLED_SSL=on . && make && make install && mkdir -p /etc/h2o && cp examples/h2o/* /etc/h2o && wget https://gist.github.com/plainbanana/5d0f8b22545b17ce5aabdf053050fa67/raw/c51cbe21b52dd8e3ae50ec4dec361dd129a0c3fd/h2o.service -P /etc/systemd/system/ && systemctl status h2o"

perconia-init: ## install perconia-toolkit for SQL slowlog
	sudo sh -c "cd /usr/local/src && wget https://www.percona.com/downloads/percona-toolkit/3.2.0/binary/debian/bionic/x86_64/percona-toolkit_3.2.0-1.bionic_amd64.deb && sudo apt update && sudo apt install -y gdebi && yes | sudo gdebi percona-toolkit_3.2.0-1.bionic_amd64.deb"
	sudo sh -c "mkdir -p /var/log/mysql && chown mysql:mysql /var/log/mysql && sudo chmod 700 /var/log/mysql"

## scripts-dl: ## download useful scripts
## 	bash -c "cd ~/ && mkdir -p scripts && cd scripts && wget https://gist.github.com/plainbanana/d1a11ec4cdb64bdc21736e3732dc30d9/raw/cb072f30cfeae71e2bb64ca4f474e225d7c57f37/start-daemon.sh && chmod +x start-daemon.sh"
## 	bash -c "cd ~/ && cd scripts && wget https://gist.github.com/plainbanana/5947ef8da734bc1302a0820fb97e0396/raw/2fa0d3bd8b8a5dfbdbe3445b6848799f3e77c83b/refresh.sh && chmod +x refresh.sh"

node-init:
	sudo apt-get install -y nodejs npm
	sudo npm cache clean
	sudo npm install n -g
	sudo n stable
	sudo ln -sf /usr/local/bin/node /usr/bin/node
	sudo apt-get purge -y nodejs npm
	echo "systemdの設定ファイルからnodeパスを書き換え"

# golang-1.9: ## install gokang-1.9
# 	sudo apt update && sudo apt install -y software-properties-common
# 	echo "export GOPATH=$HOME/.go" >> .bashrc
# 	echo "export GOPATH=$HOME/.go" >> .zshrc
# 	echo "export GOBIN=$GOPATH/bin" >> .bashrc
# 	echo "export GOBIN=$GOPATH/bin" >> .zshrc
# 	export GOPATH=$HOME/.go
# 	export GOBIN=$GOPATH/bin
# 	sudo add-apt-repository ppa:hnakamur/golang-1.9
# 	sudo apt update
# 	sudo apt install -y golang-go

slackcat-init:
	wget https://github.com/bcicen/slackcat/releases/download/1.7.3/slackcat-1.7.3-linux-amd64 -O slackcat
	sudo mv slackcat /usr/local/bin/
	sudo chmod +x /usr/local/bin/slackcat
	slackcat --configure

prepare-mysql-multi:
	sudo mysql -e "rename user isucon@'*' to isucon@'$(MYSQL_ALLOW_IP)'"

prepare-mysql-slowlog:
	sudo ./tools/prepare_slow

prepare-nginx-kataribe:
	sudo ./tools/prepare_kataribe

before:
	isulog lotate

pprof:
	isulog profile -t pprof

kataribe:
	isulog profile -t kataribe

pt-query-digest:
	isulog profile -t slow
