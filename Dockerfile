FROM node:23.5.0-alpine3.21 AS build-stage

WORKDIR /app
COPY package*.json ./

RUN npm i

COPY . .

RUN npm run build

FROM nginx:1.27.3-alpine3.20-slim AS production-stage


RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d/
COPY --from=build-stage /app/dist /usr/share/nginx/html
# Copy css folder
COPY --from=build-stage /app/css /usr/share/nginx/html/css

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
