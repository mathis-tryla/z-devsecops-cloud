FROM node:lts-alpine

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
RUN npm run build


FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

# remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# copy from the stage 1
COPY --from=0 /app/dist /usr/share/nginx/html

EXPOSE 3000

# start the nginx web server and runs it in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]