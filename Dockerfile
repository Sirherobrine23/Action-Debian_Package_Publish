# Imagem de contêiner que executa seu código
FROM ubuntu:latest
USER root
RUN apt update 
RUN apt install git -y

# Copia o arquivo de código do repositório de ação para o caminho do sistema de arquivos `/` do contêiner
COPY repo.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Arquivo de código a ser executado quando o contêiner do docker é iniciado (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]