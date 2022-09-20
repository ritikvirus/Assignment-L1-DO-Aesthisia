# Task
Use source code from 'aesthisia-demo/' directory & use the src to build docker image for the same. 
To run the app, use command: 'npm start'
Run the docker image on port 3000 & check the output on 'http://localhost:3000'  

# Let's Start
### I'm using AWS Instance ubuntu 22.04
## Follow These steps
Make sure In Your Instance In pc port 3000 opened
```bash
sudo apt update -y && sudo apt upgrade -y
```
![update & upgrade ](https://github.com/ritikvirus/Assignment-L1-DO-Aesthisia/blob/master/images/first%20update.PNG)  

### Install Docker
```bash
sudo -i
```
```bash
apt install docker.io -y
```
![dockerinstall](https://github.com/ritikvirus/Assignment-L1-DO-Aesthisia/blob/master/images/second%20step%20install%20docker.PNG)  
### Clone React App Source Code
follow this link for react app ** [Source Code](https://github.com/ritikvirus/Assignment-L1-DO-Aesthisia/tree/master/aesthisia-demo)  
```bash
git clone https://github.com/ritikvirus/Assignment-L1-DO-Aesthisia.git
```  
![gitcloneimg](https://github.com/ritikvirus/Assignment-L1-DO-Aesthisia/blob/master/images/thrid%20Git%20clone.PNG)  

```bash
ls
```
```bash
cd Assignment-L1-DO-Aesthisia
```
### its Optional (aesthisia-demo directory move previous in directory  )
```bash
mv aesthisia-demo ../
```
```bash
cd ..
```
### Go to inside aesthisia-demo directory

```bash
cd aesthisia-demo
```
### make Docker file inside 
```bash
vim Dockerfile
```
Write Docker File & You Can also paste these code  

```bash
FROM node:16
WORKDIR /aesthisia-demo
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm","start"]

```  
![dockerfile](https://github.com/ritikvirus/Assignment-L1-DO-Aesthisia/blob/master/images/Dockerfile.PNG)  

### build Docker File 
```bash
docker build -t react-img .
```  
![dockerbuild](https://github.com/ritikvirus/Assignment-L1-DO-Aesthisia/blob/master/images/buildimg.PNG)  

```bash
docker run -d -p 3000:3000 --name reactapp react-img
```
### enjoy 
yourIP:3000



