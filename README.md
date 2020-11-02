# Imagens Alpine com NGINX, PHP-FPM e MySQL para hospedagem Laravel em Docker (Em desenvolvimento)

**Os arquivos Laravel devem ser instalados previamente na pasta www.**

Este projeto está equipado com docker-compose, ao clonar você pode executar desta forma:

`docker-compose up -d`

# Detalhes dos Containeres

### NGINX
O serviço de NGINX possui configurações customizadas a partir dos templates em **.docker/nginx**.
Ele depende do serviço de php e se comunica pelo host e porta passados nas variáveis de ambiente.

### PHP-FPM
O serviço de PHP-FPM não possui configurações customizadas, mas a construção do container prepara as permissões corretas de arquivos e a instalação do Laravel de acordo com os scripts Bash nas pasta **.docker/src/scripts**.

### MySQL
O MySQL possui a versão 8+ com implementação de fallback de autenticação para versão 5.7.


## Detalhes

Na raiz do repositório há o arquivo .env que define o nome do projeto que reflete nas configurações do Laravel, prefixo de containeres e nome de Banco de dados, além do ambiente (development ou production) para o php-fpm.

O arquivo docker-compose.yml implementa outras variáveis de ambiente utilizadas pelo dockerize.
