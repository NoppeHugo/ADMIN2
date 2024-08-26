# Utilisez l'image officielle Nginx
FROM nginx:latest

# Copiez votre fichier de configuration nginx personnalisé dans le conteneur
COPY nginx.conf /etc/nginx/nginx.conf

# Créez le répertoire pour le site web et définissez-le comme répertoire de travail
WORKDIR /var/www/html/www

# Copiez votre page d'accueil personnalisée dans le répertoire du site web
COPY index.html /var/www/html/www/
COPY index2.html /var/www/html/blog/

# Exposez le port 80 pour le trafic HTTP
EXPOSE 80

# Démarrez Nginx en mode premier plan
CMD ["nginx", "-g", "daemon off;"]
