FROM nginx:1.17.9

WORKDIR /statics

COPY . lab
COPY nginx/conf.d /etc/nginx/conf.d
COPY nginx/ssl /etc/nginx/ssl

CMD sleep 2 && nginx -g 'daemon off;'
