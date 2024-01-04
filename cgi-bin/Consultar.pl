#!C:\xampp\perl\bin\perl5.32.1.exe
#!/usr/bin/perl

use warnings;
use CGI;

my $cgi = CGI -> new;

## Capturamos los parametros enviados desde los formularios
my $nombre_universidad = $cgi -> param('Nombre');
my $periodo_licenciamiento = $cgi -> param('Periodo');
my $departamento_local = $cgi -> param('Departamento');
my $denominacion_programa = $cgi -> param('Denominacion');

## Abro el archivo en modo de lectura para la busqueda
open (my $archivo, "Programas de Universidades.csv") or die "No se pudo abrir el archivo";

my $busqueda;
my @universidad; 
## Bucle para recorrer linea por linea el archivo .csv
while (<$archivo>){
    chomp;
    $_ =~ s/�/*/g;
    $_ =~ s/\|/&/g;

    $busqueda = ($_ =~ /&$nombre_universidad&/ig && $_ =~ /&$periodo_licenciamiento&/ig && $_ =~ /&$departamento_local&/ig && $_ =~ /&$denominacion_programa&/ig) ? 1 : 0;
    $_ =~ s/_/ /g;

    if ($busqueda) {
        @universidad = split("&", $_);
    }
    last if $busqueda;
}

## Se escribe el documento html
print $cgi -> header('text/html');
print <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="autor" content="Yourdyy Yossimar Huayhua Hillpa">
    <meta name="Descripcion" content="Pagina web para hacer consulta sobre Universidades">
    <link rel="shortcut icon" href="../src/icono_libro.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../disenio.css" />
    <title>Consulta Bibliografica</title>
</head>
<body>
    <header>
        <h2>Consulta bibliografica sobre universidades</h2>
    </header>
    <main>
HTML
my $tabulacion = "         ";
if ($busqueda == 0){
    print $tabulacion . "<h4>No se encontro la Universidad.</h4>\n"; 
} else {
    print $tabulacion . "<h3>La universidad fue encontrada. La informacion completa a continuacion:</h3>\n";
    foreach my $dato (@universidad){
        print $tabulacion . "<p>$dato</p>\n";
    }
}
print <<HTML;
    </main>
    <footer>
        &copy;2023 <b>Yourdyy</b>
    </footer>
</body>
</html>
HTML


