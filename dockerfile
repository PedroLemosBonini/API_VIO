# esse arquivo é a imagem

# Baixa e executa a imagem do node na versão Alpine (versão simplificada) 
FROM node:alpine 

# Define o local onde o app irá ficar no disco do container
# O caminho o Dev quem escolhe
WORKDIR /usr/app 

# Copia tudo que começa com package termina com .json para dentro de /usr/app
COPY package*.json ./

# Executa o npm install para adicionar todas as dependências e criar a pasta node_modules
RUN npm install

# Copia tudo que esta no diretório onde o arquivo Dockerfile está 
# Sera copiado dentro da pasta /usr/app do container
# Vamos ignorar a node_modules (.dockerignore)
COPY . .

# ele fica escutando a porta 5000 da minha maquina 
# Container ficara ouvindo os acessos na porta 5000
EXPOSE 5000

# Executa o comando para iniciar o script que está no package.json
CMD npm start