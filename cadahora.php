
<html>
<head>
	<link rel="icon" href="img/icosecom.ico"/>
    <meta name="author" content="Edgar Felipe Hernandez Garcia - TeamScrlet"/>
    <meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="css/jquery.bootgrid.css" />
    <link rel="stylesheet" type="text/css" href="css/font-awesome-4.7.0/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="css/font-awesome-4.7.0/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="css/css/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="css/nav.css" />

    <script src="js/jquery.min.js"></script> 
    <script src="js/bootstrap.min.js"></script>
    
    <script src="js/jquery-3.2.1.js"></script>
    <script src="js/jquery.bootgrid.min.js"></script>
    <script src="js/rmab.js"></script>
<script>
function comprobar()
{
	hoy=new Date();
	hora=hoy.getHours();
	minutos=hoy.getMinutes();
	segundos=hoy.getSeconds();
	if(hora == 9 || hora == 10 || hora == 17 || hora == 18){
		$.ajax
		({
		type: "POST",
		url: "date.php",
		data: {  }
		}).done(function( msg ) {
		});
			}
	setTimeout("comprobar()",60000);
}
</script>
</head>


<body id="cuerpo" onload="comprobar()">
<span id="showtimeh"></span>
</body>
</html>