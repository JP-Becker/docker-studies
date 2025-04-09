ARG NODE_VERSION=18.19.1
FROM node:${NODE_VERSION}

# Imagens com tamanhos bem menores para ocupar menos espaço
# FROM node:${NODE_VERSION}--alpine
# FROM node:${NODE_VERSION}--slim  
LABEL maintainer="Joao"
LABEL env="production"

# Setando as variaveis de ambiente
ENV PORT=3001 
ENV MESSAGE="Hello from Dockerfile"

WORKDIR /app

# Copiando o package.json para ficar no cache e só rodar o npm install quando houver mudança
# Isso melhora o tempo de build, pois não precisa baixar as dependências toda vez
COPY package*.json ./

# Instalando as dependências
RUN npm install

# Copiando todos os arquivos para a imagem
# Não é necessário copiar o node_modules, pois ele já foi instalado na imagem, no docker ignore já está sendo ignorado
COPY . .

# Executando comando durante a construção da imagem, o primeiro atualiza a lista de pacotes disponiveis
# Rodando antes de trocar o usuário para não dar erro de permissão
RUN apt-get update \
&& apt-get install -y vim \
&& rm -rf /var/lib/apt/lists/*

# Criando um usuário com o run e setando ele como padrão, para nao cair como usuário root
RUN useradd -m mynode
USER mynode


# essa parada aqui vai falar se a aplicação está rodando corretamente ou não. aparece no status do docker ps
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \

  # Entrypoint é fixo, e caso bote outros comandos na sequencia ele irá concatenar com esses 
  # ENTRYPOINT ["curl", "-f", "http://localhost:3002"]
  CMD ["curl", "-f", "http://localhost:3001"] || exit 1

  
VOLUME [ "/data"]
EXPOSE ${PORT}

# Executa um comando dentro do container 
CMD ["node", "index.js"]