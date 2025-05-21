FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build || npm run prod || true

FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip git unzip curl libonig-dev \
    && docker-php-ext-install pdo pdo_mysql gd

COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

COPY --from=build /app/public /app/public

RUN composer install --no-interaction --prefer-dist --optimize-autoloader
RUN php artisan storage:link || true

ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_KEY=base64:GENERATE_YOUR_KEY

EXPOSE 3131

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=3131
