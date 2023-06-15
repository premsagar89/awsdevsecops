FROM public.ecr.aws/nginx/nginx:1.24-alpine-slim
COPY . /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80