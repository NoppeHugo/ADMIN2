hierarchie des répertoires : 

un dossier srv :
    un dossier dns :
        fichier zones  
        fichier config
        fichier scripts 
        fichier logs 
        fichier backup 


named.conf

options {
  directory "/var/cache/bind";
  // version statement for security to avoid hacking known weaknesses
  // if the real version number is revealed
  version "not currently available";
  allow-query { any; };
  allow-query-cache { none; };
  recursion no;
};

zone "l2-3.ephec-ti.be." {
  type master;
  file "/etc/bind/l2-3.zone";
  allow-transfer {
    none;
  };
};

l2-3.zone

$TTL 3600
$ORIGIN l2-3.ephec-ti.be.

@       IN      SOA     ns1.l2-3.ephec-ti.be. admin.l2-3.ephec-ti.be. (
                            2023040901 ; Serial
                            7200       ; Refresh
                            1200       ; Retry
                            2419200    ; Expire
                            3600 )     ; Negative Cache TTL

; Définition des serveurs de noms
@       IN      NS      ns1.l2-3.ephec-ti.be.

; Enregistrements A pour les serveurs de noms
ns1     IN      A       54.37.15.123

; Enregistrements A supplémentaires
www     IN      A       54.37.15.123
mail    IN      A       54.37.15.123


docker run -d --name=dns -p 53:53/udp -p 53:53/tcp --mount type=bind,source=/home/hugo/tp4/named.conf,target=/etc/bind/named.conf --mount type=bind,source=/home/hugo/tp4/l2-3.zone,target=/etc/bind/l2-3.zone internetsystemsconsortium/bind9:9.18

docker run -d --name=dns -p 53:53/udp -p 53:53/tcp --mount type=bind,source=/home/hugo/tp4/named.conf,target=/etc/bind/named.conf --mount type=bind,source=/home/hugo/tp4/l2-3.zone,target=/etc/bind/l2-3.zone internetsystemsconsortium/bind9:9.18 named -g -u bind

Ajouter à la zone 

l2-3    IN    NS    ns.l2-3.ephec-ti.be. 
ns.l2-3 IN    A     54.37.15.123

l2-3.ephec-ti.be. IN DS 17284 13 2 2DD0F4FA4E1B895A32E9893B43C795B1621087B8FCB4658331BE551D72935165

hugo: dnssec-dsfromkey -2 Kl2-3.ephec-ti.be.+013+17284.key

WEB

1.3 logs

log_format log_per_virtualhost '[$host] $remote_addr [$time_local] $status '
                               '"$request" $body_bytes_sent';

access_log /dev/stdout log_per_virtualhost;


pour la db

mysql -h 172.17.0.4 -u root -p

mysql -h 172.17.0.4 -u root -pmypass < woodytoys.sql

au point 5 lancer php sur chatgpt
ici je suis pas sur 
docker run --name php --rm -d --mount type=bind,source=[votre répertoire de travail]/html,www,target=/var/www/html/www php-container


 docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' php
172.17.0.5

events {
}
http {
    log_format log_per_virtualhost '[$host] $remote_addr [$time_local]  $status "$request" $body_bytes_sent';
    access_log /dev/stdout log_per_virtualhost;

    server {
        listen       80;
        server_name  www.l2-3.ephec-ti.be;
        index        index.html;
        root         /var/www/html/www/;
        location ~* \.php$ {
            fastcgi_pass 172.17.0.5:9000;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	    }
    }


    server {
        listen       80;
        server_name  blog.l2-3.ephec-ti.be;
        index        blogindex.html;
        root         /var/www/html/blog/;
    }
}

IP PHP 172.17.0.3