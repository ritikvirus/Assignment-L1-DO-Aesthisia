FROM node:16
WORKDIR /aesthisia-demo
COPY aesthisia-demo/package.json .
RUN npm install
COPY aesthisia-demo/. .
EXPOSE 3000
CMD ["npm","start"]
