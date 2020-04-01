#!/usr/bin/env bash

f_version="2.7.0"
f_authors="Marcos Freitas";

# colors
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

RED="\033[0;31m";
CYAN="\033[0;36m";
YELLOW="\033[1;33m";
LIGHT_GREEN="\033[1;32m";

# No Color
NC="\033[0m";

# script status
SCRIPT_STATUS=$?

# run this script as sudo
if [[ $EUID -ne "0" ]]; then
    sudo "${0}" "${@}";
fi

#
# Common functions used into configuration.sh files for All Images
#

# Receive a current count number on position $1;
# Receive a function name on position $2;
# not using but $0 is the name of the script itself;
function Count() {

    # check if position $1 exists
    if [ -z "$1" ]; then
        echo "Expected param 1";
        exit 0;
    fi

    if [ -z "$2" ]; then
        echo "Expected param 2";
        exit 0;
    fi

    if [ ${1} -ge 1 ]; then
        count=$1;
    fi

    if [ ${count} -le 3 ]; then
        echo -e ${RED};
        printf "\nUma saída inesperada ocorreu durante a última instrução, mas tudo pode estar bem.\nDeseja executar novamente o processo $2?\n"
        echo -e ${NC};
        read -n1 -r -p "Pressione S para continuar ou N para cancelar: " key

        # $key is empty when ENTER/SPACE is pressed
        if [ "$key" = 'S' -o "$key" = 's' ]; then
            echo -e ${CYAN};
            echo "Tentativa " ${count} " de 3...";
            echo -e ${NC};
            ${2} $((count += 1));
        else
            return 1;
        fi

    else
        echo "Não foi possível realizar a operação em $2, abortando o processo";
    fi
}

# receive the output string on position ${1} and a optional color on position ${2}
# version 1.1.0
function Separator() {
    echo '';
    echo '';

    # if ${2} is empty
    if [ -z "${2}" ]; then
        echo -e ${YELLOW};
    else
        echo -e ${2};
    fi

    echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::';
    echo ' ' ${1};
    echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::';
    echo -e ${NC};
    echo '';
    echo '';
}

# wait a key press to continue the process, by default the doesn't abort the script at all, only if passed the second argument as "abort"
# version 1.1.0 - Accepting arg 1 as message
# arg 2 as the expected_key_pressed for positive case
# arg 3 is the parameter to abort the entire script execution
# @info if global interactive_mode be false, input key won't be expected and always will continue, returning 1, be carefull with your outside logic when call this function.
function PressKeyToContinue() {

	if [ $interactive_mode == false ]; then
		Separator "::: pulando..." ${YELLOW};
		return 1;
	fi

    printf "\n";

    question="Pressione S para continuar ou qualquer outra tecla para pular essa parte execução do script";
	expected_key_pressed='s';
	abort_script=false;

	if [ ! -z "$1" ]; then
        question="${1}";
    fi

	if [ ! -z "$2" ]; then
        expected_key_pressed="${2}";
    fi

	if [[ ! -z "$3" && "${3,,}" == "abort" ]]; then
		# in case of a negative response, the script will abort the process
        abort_script=true;
    fi

    read -n1 -r -p "${question}: " key

	# "parameter expansion" transforming key to lowercase
    # @info $key is empty when ENTER/SPACE is pressed
    if [[ "${key,,}" == "${expected_key_pressed,,}" ]]; then
        echo 1;
    else
		if [ $abort_script == true ]; then
			exit 1;
		fi

		# by default continue to the next step
		echo 0;
    fi
}

# change values into configuration files. Receives $key $separator $value $file
# version 1.0.0
function ChangeValueConfig(){
    {
        Separator 'sed  -i "s|\('${1}' *'${2}'*\).*|\1'${3}'|" '${4}';';
        sed  -i "s|\('${1}' *'${2}'*\).*|\1'${3}'|" '${4}';
    } || {
        Count ${1} 'ChangeValueConfig';
    }
}

# @version 1.1.0 - Added arg 1 to receive "upgrade" command
function AptUpdate() {

    Separator "Buscando informações de atualização dos repositórios..." ${LIGHT_GREEN};

    apt-get -y update;

	if [[ ! -z "$1" && "${1,,}" == "upgrade" ]]; then
	   Separator "Instalando novas atualizações de pacotes disponíveis..." ${LIGHT_GREEN};
	   apt-get -y upgrade;
    fi

}

function AddExtraPackages() {
    {
        Separator "Preparando pré-requisitos";

        Separator "Instalando pacote de Idiomas Inglês:" ${LIGHT_GREEN};
        apt-get -y install language-pack-en;

		locale-gen "en_US.UTF-8" && localedef -v -c -i en_US -f UTF-8 en_US.UTF-8;
		export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && export LANGUAGE=en_US.UTF-8;

        printf '\n[ Status dos locales do sistema ]\n';
        locale;

        Separator "Instalando o pacote wget para capturar o conteúdo de uma URL, o editor nano e o pacote unzip para manipular arquivos .zip e outros pacotes auxiliares" ${LIGHT_GREEN};
        apt-get -y install wget nano unzip curl tree;

        Separator "Instalando pacotes adicionais para a configuração do NGINX e PHP" ${LIGHT_GREEN};
        apt-get -y install tar bzip2 gcc;

	    Separator "Instalando pacotes que auxiliam no gerenciamento e debug de conflitos de infraestrutura" ${LIGHT_GREEN};
	    apt-get install -y net-tools;


    } || {
        Count ${1} 'AddExtraPackages';
    }
}

function ProtectProjectDirectories() {
    {
        Separator "Protegendo os diretórios e arquivos do Projeto com as permissões CHMOD corretas";
        cd /var/www/;
        find html -type d -exec chmod -R 755 {} \; && \
        find html -type f -exec chmod -R 644 {} \;

    } || {
        Count ${1} 'ProtectProjectDirectories';
    }
}


Separator "Using functions.sh version $f_version | Authors: $f_authors" ${LIGHT_GREEN};