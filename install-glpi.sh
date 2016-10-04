#!/bin/bash

# @Programa 
# 	@name: install-glpi.sh
#	
#	@versao: 0.4
#	Data 14 de Setembro de 2016
#	- Atualizado versão do GLPI para 0.90.5
#	- Adicionado diversos plugins do projeto
#	- Adicionado pacote php5-snmp
#	@versao: 0.3
#	Data 21 de Maio de 2016
#	- Atualizado versão do GLPI para 0.90.3
#	@versao: 0.2
#	Data 07 de Fevereiro de 2016
#	- Adicionado suporte a arquitetura ARM para uso em Cubietruck
#	@versao: 0.1
#	@Data 12 de Dezembro de 2015
# 	
# 	@Direitos 
# 		@autor: Halexsando de Freitas Sales
#		@e-mail: halexsandro@gmail.com
#	@Licenca: GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 <http://www.gnu.org/licenses/lgpl.txt>
#	
#	@Objetivo:
#		Este script tem como objetivo realizar a completa instalação do GLPI
#               para uso em estudos junto com o livro:
#               Central de Serviços com Software Livre: Estruturando uma Central de Serviços com o GLPI: 2ª Edição; 2015
#
# -------------------------------------------------------------------
# Saudação

clear

cd /tmp 

echo -e "
 #########################################################	
# Este script tem por objetivo realizar a instalação  do  #
# seguinte sistema de forma automatizada:                 #
# - GLPI 0.90.3 [http://glpi-project.com                  #
  -------------------------------------------------------
| install-glpi.sh | versão 0.4                            |
| Desenvolvido por: Halexsandro de Freitas Sales          |
| Contato: halexsandro@gmail.com                          |
| Central de Serviços com Software Livre: Estruturando uma|
|    Central de serviços com o GLPI: 2. Edição: 2015      |
|---------------------------------------------------------|
|                http://www.pillares.net                  |
 ---------------------------------------------------------
 - Tecle 'ENTER'
"

read -n1 opt

clear

# FIM ---------------------------------------------------------------

# -------------------------------------------------------------------
# Verificar se o usuário é o ROOT

if [ $UID -ne 0 ]
then
	clear
	echo -e "
 #########################################################	
# ERRO: Falta de acesso/privilégio                        #
# É necessário acesso de Administrador do Sistema         #
 ---------------------------------------------------------
#                                                         #
#            Encerrarei este processo agora!              #
#                                                         #
# Você precisa estar logado como root para executar este  #
# script.                                                 #
 ---------------------------------------------------------
|                http://www.pillares.net                  |
 ---------------------------------------------------------
"
	kill $$
fi
# FIM ---------------------------------------------------------------

# -------------------------------------------------------------------
# Detectar a versão do sistema operacional

debianVersion=$(cat /etc/debian_version | cut -d"." -f1 )

if [ $debianVersion -ne 8 ]
then
	clear 
	echo -e "
 #########################################################	
#        ERRO: Sistema Operacional não suportado          #
 ---------------------------------------------------------
#                                                         #
#            Encerrarei este processo agora!              #
#                                                         #
# Este script foi desenvolvido para o Debian 8.           #
#                                                         #
# Caso tenha alguma dúvida ou acredite que esta           #
# informação esteja errada, favor entrar em contato!      #
 ---------------------------------------------------------
|                http://www.pillares.net                  |
 ---------------------------------------------------------
"

	kill $$
fi

# FIM ---------------------------------------------------------------

# -------------------------------------------------------------------
# Detectando a arquitetura do Sistema

arch=$(uname -m)

case $arch in 

	i686)
		arch=i386
		;;
	i586)
		arch=i386
		;;
	i486)
		arch=i386
		;;
	i386)
		arch=i386
		;;

	x86_64)
		arch=amd64
		;;

	armv7l)
		arch=armv7l
		;;

	*)
		echo -e "

 ##########################################################
# ERRO: Arquitetura do Processador não suportada           #
 ----------------------------------------------------------
#                                                          #
#             Encerrarei este processo agora!              #
#                                                          #
# Este script foi desenvolvido para as seguintes           #
# arquiteturas:                                            #
# - i386, i486, i586, i686 [32 bits]                       #
# - x86_64 [64 bits]                                       #
# -  ARM [armv7l]                                          #
#                                                          #
# Caso tenha alguma dúvida ou acredite que esta informação #
# esteja errada, favor entrar em contato!                  #
 ---------------------------------------------------------
|                http://www.pillares.net                  |
 ---------------------------------------------------------

"
		kill $$
;;

esac
# FIM ---------------------------------------------------------------

echo -e "
Estou agora adicionando os repositórios do Debian...
"
sleep 3

clear

echo "deb http://ftp.br.debian.org/debian/ jessie main" > /etc/apt/sources.list
echo "deb-src http://ftp.br.debian.org/debian/ jessie main" >> /etc/apt/sources.list

echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list

echo "deb http://ftp.br.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list
echo "deb-src http://ftp.br.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list

echo "deb http://ftp.de.debian.org/debian/ jessie main non-free" >> /etc/apt/sources.list

clear 

echo -e "
 #########################################################	
#              Instalação de Pacotes                      #
 ---------------------------------------------------------
#                                                         #
# Realizaremos agora a instalação de softwares que são    #
# necessários para o correto funcionamento do sistema     #
# GLPI. Dentre estes estão:                               #
#  - Banco de Dados MariaDB                               #
#  - Servidor HTTP Apache                                 #
#  - Suporte a linguagem PHP                              #
 ---------------------------------------------------------
|                http://www.pillares.net                  |
 ---------------------------------------------------------

- Para continuar, pressione qualquer outra tecla!
"

read -n1 opt

apt-get update

apt-get upgrade -y

apt-get install ca-certificates apache2 libapache2-mod-php5 php5-cli php5 php5-gd php5-imap php5-ldap php5-mysql php-soap php5-xmlrpc mariadb-server zip unzip bzip2 unrar-free php5-snmp -y

# -------------------------------------------------------------------
# Instalação do GLPI

clear

# Baixando o GLPI

cd /tmp

	## Processo de instalação do GLPI
	# Baixando o GLPI
	wget https://github.com/glpi-project/glpi/releases/download/0.90.5/glpi-0.90.5.tar.gz
	tar -zxvf glpi-0.90.5.tar.gz
	mv glpi /var/www/html/

	# Baixando o Webservice
	wget https://forge.glpi-project.org/attachments/download/2099/glpi-webservices-1.6.0.tar.gz
	tar -zxvf glpi-webservices-1.6.0.tar.gz
	mv webservices /var/www/html/glpi/plugins/

	# Baixando o Racks
	wget https://github.com/InfotelGLPI/racks/releases/download/1.6.2/glpi-racks-1.6.2.tar.gz
	tar -zxvf glpi-racks-1.6.2.tar.gz
	mv racks /var/www/html/glpi/plugins/

	# Baixando o DashBoard
	wget https://forge.glpi-project.org/attachments/download/2154/GLPI-dashboard_plugin-0.7.6.tar.gz
	tar -zxvf GLPI-dashboard_plugin-0.7.6.tar.gz
	mv dashboard /var/www/html/glpi/plugins/
	
	# Baixando o MyDashboard
	wget https://github.com/InfotelGLPI/mydashboard/releases/download/1.2.1/glpi-mydashboard-1.2.1.tar.gz
	tar -zxvf glpi-mydashboard-1.2.1.tar.gz
	mv mydashboard /var/www/html/glpi/plugins/mydashboard

	# Baixando Seasonality
	wget https://github.com/InfotelGLPI/seasonality/releases/download/1.1.0/glpi-seasonality-1.1.0.tar.gz
	tar glpi-seasonality-1.1.0.tar.gz
	mv seasonality /var/www/html/glpi/plugins/seasonality

	# Baixando More LDAP
	wget https://github.com/pluginsGLPI/moreldap/releases/download/0.90-0.2.2/glpi-moreldap-0.90-0.2.2.tar.gz
	tar -zxvf glpi-moreldap-0.90-0.2.2.tar.gz
	mv glpi /var/www/html/glpi/plugins/moreldap

	# Baixando SimCard Beta
	wget https://github.com/pluginsGLPI/simcard/archive/1.4.1.tar.gz
	tar -zxvf 1.4.1.tar.gz
	mv simcard-1.4.1 /var/www/html/glpi/plugins/simcard

	# Baixando Hidefields
	wget https://github.com/tomolimo/hidefields/archive/1.0.0.tar.gz
	tar -zxvf 1.0.0.tar.gz
	mv hidefields-1.0.0 /var/www/html/glpi/plugins/hidefields

	# Baixando Form Validation
	wget https://github.com/tomolimo/formvalidation/archive/0.1.2.tar.gz
	tar -zxvf 0.1.2.tar.gz
	mv formvalidation-0.1.2 /var/www/html/glpi/plugins/formvalidation

	# Baixando PDF
	wget https://forge.glpi-project.org/attachments/download/2139/glpi-pdf-1.0.2.tar.gz
	tar -zxvf glpi-pdf-1.0.2.tar.gz
	mv pdf /var/www/html/glpi/plugins/pdf

	# Baixando Data Injection
	wget https://github.com/pluginsGLPI/datainjection/releases/download/2.4.1/glpi-datainjection-2.4.1.tar.gz
	tar -zxvf glpi-datainjection-2.4.1.tar.gz
	mv datainjection /var/www/html/glpi/plugins/datainjection

	# Baixando IP Reports
	wget https://forge.glpi-project.org/attachments/download/2128/glpi-addressing-2.3.0.tar.gz
	tar -zxvf glpi-addressing-2.3.0.tar.gz
	mv addressing /var/www/html/glpi/plugins/addressing

	# Baixando Generic Objects Management
	wget https://github.com/pluginsGLPI/genericobject/archive/0.85-1.0.tar.gz
	tar -zxvf 0.85-1.0.tar.gz
	mv genericobject-0.85-1.0 /var/www/html/glpi/plugins/genericobject

	# Baixando Barscode
	wget https://forge.glpi-project.org/attachments/download/2153/glpi-barcode-0.90+1.0.tar.gz
	tar -zxvf glpi-barcode-0.90+1.0.tar.gz
	mv barcode /var/www/html/glpi/plugins/barcode

	# Baixando Timezones
	#wget https://github.com/tomolimo/timezones/archive/2.0.0.tar.gz
	#tar -zxvf 2.0.0.tar.gz
	#mv timezones-2.0.0 /var/www/html/glpi/plugins/timezones

	# Baixando Monitoring
	wget https://github.com/ddurieux/glpi_monitoring/releases/download/0.90%2B1.1/glpi_monitoring_0.90.1.1.tar.gz
	tar glpi_monitoring_0.90.1.1.tar.gz
	mv monitoring /var/www/html/glpi/plugins/monitoring

	# Baixando Applince
	wget https://forge.glpi-project.org/attachments/download/2147/glpi-appliances-2.1.tar.gz
	tar -zxvf glpi-appliances-2.1.tar.gz
	mv appliances /var/www/html/glpi/plugins/appliances

	# Baixando Certificates Inventory
 	wget https://github.com/InfotelGLPI/certificates/releases/download/2.1.1/glpi-certificates-2.1.1.tar.gz
	tar -zxvf glpi-certificates-2.1.1.tar.gz
	mv certificates /var/www/html/glpi/plugins/certificates

	# Baixando Databases Inventory
	wget https://github.com/InfotelGLPI/databases/releases/download/1.8.1/glpi-databases-1.8.1.tar.gz
	tar -zxvf glpi-databases-1.8.1.tar.gz
	mv databases /var/www/html/glpi/plugins/databases

	# Baixando Domains
	wget https://github.com/InfotelGLPI/domains/releases/download/1.7.0/glpi-domains-1.7.0.tar.gz
	tar -zxvf glpi-domains-1.7.0.tar.gz
	mv domains /var/www/html/glpi/plugins/domains

	# Baixando Human Resources Management
	wget https://github.com/InfotelGLPI/resources/releases/download/2.2.1/glpi-resources-2.2.1.tar.gz
	tar -zxvf glpi-resources-2.2.1.tar.gz
	mv resources /var/www/html/glpi/plugins/resources

	# Baixando Web Applications Inventory
 	wget https://github.com/InfotelGLPI/webapplications/releases/download/2.1.1/glpi-webapplications-2.1.1.tar.gz
	tar -zxvf glpi-webapplications-2.1.1.tar.gz
	mv webapplications /var/www/html/glpi/plugins/webapplications

	# Baixando Order Management
	wget https://github.com/pluginsGLPI/order/archive/0.85+1.1.tar.gz
	tar -zxvf 0.85+1.1.tar.gz
	mv order-0.85-1.1 /var/www/html/glpi/plugins/order

	# Baixando Inventory Number Generation
 	wget https://github.com/pluginsGLPI/geninventorynumber/releases/download/0.85%2B1.0/glpi-geninventorynumber-0.85.1.0.tar.gz
	tar -zxvf glpi-geninventorynumber-0.85.1.0.tar.gz
	mv geninventorynumber /var/www/html/glpi/plugins/geninventorynumber

	# Baixando GLPI Connections BETA4 0.90-1.7.3
 	wget https://github.com/pluginsGLPI/connections/releases/download/0.90-1.7.3/glpi-connections-0.90-1.7.3.tar.gz
	tar -zxvf glpi-connections-0.90-1.7.3.tar.gz
	mv connections /var/www/html/glpi/plugins/connections

	# Baixando GLPI Renamer 0.90-1.0
	wget https://github.com/pluginsGLPI/renamer/releases/download/0.90-1.0/glpi-renamer-0.90-1.0.tar.gz
	tar -zxvf glpi-renamer-0.90-1.0.tar.gz
	mv renamer /var/www/html/glpi/plugins/renamer

	# Baixando Behaviors
	wget https://forge.glpi-project.org/attachments/download/2124/glpi-behaviors-1.0.tar.gz
	tar -zxvf glpi-behaviors-1.0.tar.gz
	mv behaviors /var/www/html/glpi/plugins/behaviors

	# Baixando Ticket Cleaner
	wget https://github.com/tomolimo/ticketcleaner/archive/2.0.4.tar.gz
	tar -zxvf 2.0.4.tar.gz
	mv ticketcleaner-2.0.4 /var/www/html/glpi/plugins/ticketcleaner

	# Baixando Escalation
	wget https://forge.glpi-project.org/attachments/download/2150/glpi-escalation-0.90+1.0.tar.gz
	tar -zxvf glpi-escalation-0.90+1.0.tar.gz
	mv escalation /var/www/html/glpi/plugins/escalation

	# Baixando News
	wget https://github.com/pluginsGLPI/news/releases/download/0.90-1.3/glpi-news-0.90-1.3.tar.gz
	tar -zxvf glpi-news-0.90-1.3.tar.gz
	mv news /var/www/html/glpi/plugins/news

	# Baixando Historical purge
	wget https://github.com/pluginsGLPI/purgelogs/releases/download/0.85%2B1.1/glpi-purgelogs-0.85-1.1.tar.gz
	tar -zxvf glpi-purgelogs-0.85-1.1.tar.gz
	mv purgelogs-0.85-1.1 /var/www/html/glpi/plugins/purgelogs

	# Baixando Escalade 
	wget https://github.com/pluginsGLPI/escalade/releases/download/0.90-1.2/glpi-escalade-0.90-1.2.tar.gz
	tar -zxvf glpi-escalade-0.90-1.2.tar.gz
	mv escalade /var/www/html/glpi/plugins/escalade

	# Baixando ITIL Category Groups
	wget https://github.com/pluginsGLPI/itilcategorygroups/releases/download/0.90%2B1.0.3/glpi-itilcategorygroups-0.90-1.0.3.tar.gz
	tar -zxvf glpi-itilcategorygroups-0.90-1.0.3.tar.gz
	mv itilcategorygroups /var/www/html/glpi/plugins/itilcategorygroups

	# Baixando Consumables
	wget https://github.com/InfotelGLPI/consumables/releases/download/1.1.0/glpi-consumables-1.1.0.tar.gz
	tar -zxvf glpi-consumables-1.1.0.tar.gz
	mv consumables /var/www/html/glpi/plugins/consumables

	# Baixando PrinterCounters
	wget https://github.com/InfotelGLPI/printercounters/releases/download/1.2.1/glpi-printercounters-1.2.1.tar.gz
	tar -zxvf glpi-printercounters-1.2.1.tar.gz
	mv printercounters /var/www/html/glpi/plugins/printercounters

	# Baixando Financial Reports
	wget https://github.com/InfotelGLPI/financialreports/releases/download/2.2.1/glpi-financialreports-2.2.1.tar.gz
	tar -zxvf glpi-financialreports-2.2.1.tar.gz
	mv financialreports /var/www/html/glpi/plugins/financialreports

	# Baixando Timelineticket
	wget https://github.com/pluginsGLPI/timelineticket/releases/download/0.90%2B1.0/glpi-timelineticket-0.90.1.0.tar.gz
	tar -zxvf glpi-timelineticket-0.90.1.0.tar.gz
	mv timelineticket /var/www/html/glpi/plugins/timelineticket

	# Baixando Accounts Inventory
	wget https://github.com/InfotelGLPI/accounts/releases/download/2.1.1/glpi-accounts-2.1.1.tar.gz
	tar -zxvf glpi-accounts-2.1.1.tar.gz
	mv  accounts /var/www/html/glpi/plugins/accounts

	# Baixando FusionInventory
	wget "https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi090%2B1.4/fusioninventory-for-glpi_0.90.1.4.tar.gz"
	tar -zxvf "fusioninventory-for-glpi_0.90.1.4.tar.gz"
	mv fusioninventory /var/www/html/glpi/plugins/fusioninventory

	
# Adequando Apache

echo -e "<Directory \"/var/www/html/glpi\">
    AllowOverride All
</Directory>

" > /etc/apache2/conf-available/glpi.conf

a2enconf glpi.conf
service apache2 restart

# Adequando permissões nos arquivos
chmod 775 /var/www/html -Rf
chown www-data:www-data /var/www/html -Rf

# FIM ---------------------------------------------------------------

# -------------------------------------------------------------------
# Configurando Banco de dados para o GLPI

clear

echo -e "
 #########################################################	
#         Configuração do Banco de Dados do GLPI          #
 ---------------------------------------------------------
#                                                         #
# Procederemos agora com a criação de uma conta para      #
# gerenciamento do banco de dados do sistema GLPI.        #
# Por praticidade, criaremos:                             #
 ---------------------------------------------------------     
# - Uma base de dados de nome GLPI e,                     #
# - Uma conta de administração da Base de dados de        #
# nome 'glpi'.                                            #
 ---------------------------------------------------------
|                http://www.pillares.net                  |
 ---------------------------------------------------------

 - Informe a senha do usuário root do MariaDB criada durante esta
   instalação e pressione <ENTER> [a senha não será impressa na tela]:
"
read -s rootMariaPWD

clear

echo -e "
---
 - Informe agora uma senha para o usuário GLPI usado pelo sistema e 
 pressione <ENTER> [a senha não será impressa na tela]:

"

read -s pwdGLPIBD

mysql -u root -p$rootMariaPWD -e "create database glpi";
mysql -u root -p$rootMariaPWD -e "create user 'glpi'@'localhost' identified by '$pwdGLPIBD'";
mysql -u root -p$rootMariaPWD -e "grant all on glpi.* to glpi with grant option";

clear

echo -e "
 #########################################################	
#         Configuração do Banco de Dados do GLPI          #
 ---------------------------------------------------------
#                                                         #
# Ok! Criamos então:                                      #
#                                                         #
# - Uma base de dados de nome GLPI e,                     #
# - Uma conta de administração da Base de dados de nome   #
# 'glpi'.                                                 #
 ---------------------------------------------------------
# Tome nota dos dados pois serão necessários para         #
# finalizar as configurações dos sistemas via WEB         #
 ---------------------------------------------------------
|                http://www.pillares.net                  |
 ---------------------------------------------------------

 - Precione qualquer tecla para continuar...
"
read -n1 opt

clear


service cron restart


echo -e "
 #########################################################	
#                  PROCESSO FINALIZADO                    #
 ---------------------------------------------------------
#                                                         #
# Aparentemente terminamos o processo de instalação!      #
# Agora, acesse o seu servidor externamente a partir      #
# de um web browser:                                      #
#                                                         #
# HTTP://IP_SERVIDOR/glpi                                 #
#                                                         #
# Abaixo serão exibidos os possíveis endereços deste      #
# servidor:                                               #
 ---------------------------------------------------------
|                http://www.pillares.net                  |
 ---------------------------------------------------------
 IPs deste Servidor:
"
hostname -I | tr ' ' '\n'
