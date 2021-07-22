clear
apk update; apk add gnupg -yq --silent
apk add wget git -y
clear
addrepo(){
	
	mkdir -p /etc/apk/sources.list.d && printf "deb https://hax4us.github.io/TermuxBlack/ termuxblack main" > /etc/apk/sources.list.d/termuxblack.list

	wget -q https://hax4us.github.io/TermuxBlack/termuxblack.key -O termuxblack.key && apk-key add termuxblack.key

	apk-get update -yq --silent
	}

addrepo


clear

apk upgrade -y -o Dpkg::Options::="--force-confnew"
apk install -y autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ruby2 ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git -o Dpkg::Options::="--force-confnew"

source <(curl -sL https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)
rm -rf $HOME/metasploit-framework
echo
cd $HOME
git clone --depth 1 https://github.com/rapid7/metasploit-framework.git

cd $HOME/metasploit-framework
sed '/rbnacl/d' -i Gemfile.lock
sed '/rbnacl/d' -i metasploit-framework.gemspec
gem install bundler
sed 's|nokogiri (1.*)|nokogiri (1.8.0)|g' -i Gemfile.lock

gem install nokogiri -v 1.8.0 -- --use-system-libraries

gem install actionpack
bundle update activesupport
bundle update --bundler
bundle install -j5
/bin/find -type f -executable -exec termux-fix-shebang \{\} \;
rm ./modules/auxiliary/gather/http_pdf_authors.rb
if [ -e /bin/msfconsole ];then
	rm /bin/msfconsole
fi
if [ -e /bin/msfvenom ];then
	rm /bin/msfvenom
fi
ln -s $HOME/metasploit-framework/msfconsole /usr/bin/
ln -s $HOME/metasploit-framework/msfvenom /usr/bin/
termux-elf-cleaner /usr/lib/ruby/gems/2.4.0/gems/pg-0.20.0/lib/pg_ext.so

cd $HOME/metasploit-framework/config
curl -sLO https://raw.githubusercontent.com/limitedeternity/metasploit_in_termux/master/database.yml

mkdir -p /var/lib/postgresql
initdb /var/lib/postgresql

pg_ctl -D /var/lib/postgresql start
createuser msf
createdb msf_database
pg_ctl -D /var/lib/postgresql stop

cd $HOME
