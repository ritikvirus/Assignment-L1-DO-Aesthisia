FROM node:16
WORKDIR /aesthisia-demo
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm","start"]
