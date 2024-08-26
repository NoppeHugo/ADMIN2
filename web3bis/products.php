<html>
<style>
    table,
    th,
    td {
        padding: 10px;
        border: 1px solid black;
        border-collapse: collapse;
    }
</style>

<head>
    <title>Catalogue WoodyToys</title>
</head>

<body>
    <h1>Catalogue WoodyToys</h1>

    <?php
    // Récupération des variables d'environnement
    $dbname = getenv('MARIADB_DATABASE');
    $dbuser = getenv('MARIADB_USER'); // Utilisez MARIADB_USER pour l'utilisateur
    $dbpass = getenv('MARIADB_PASSWORD'); // Utilisez MARIADB_PASSWORD pour l'utilisateur
    $dbhost = getenv('MARIADB_HOST');

    // Connexion à la base de données
    $connect = mysqli_connect($dbhost, $dbuser, $dbpass) or die("Unable to connect to '$dbhost'");
    mysqli_select_db($connect, $dbname) or die("Could not open the database '$dbname'");

    // Vérification de l'utilisateur connecté
    $result = mysqli_query($connect, "SELECT USER()");
    $row = mysqli_fetch_array($result);
    echo "<p>Utilisateur connecté : " . $row[0] . "</p>";

    // Affichage des privilèges de l'utilisateur connecté
    $result = mysqli_query($connect, "SHOW GRANTS FOR CURRENT_USER()");
    echo "<p>Privilèges de l'utilisateur connecté :</p><ul>";
    while ($row = mysqli_fetch_array($result)) {
        echo "<li>" . $row[0] . "</li>";
    }
    echo "</ul>";

    // Exécution de la requête SQL pour récupérer les produits
    $result = mysqli_query($connect, "SELECT id, product_name, product_price FROM products");
    ?>

    <table>
        <tr>
            <th>Numéro de produit</th>
            <th>Descriptif</th>
            <th>Prix</th>
        </tr>

        <?php
        // Affichage des résultats
        while ($row = mysqli_fetch_array($result)) {
            printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>", $row[0], $row[1], $row[2]);
        }
        ?>

    </table>
</body>

</html>

