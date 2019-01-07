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
				<script>
					function comprobar()
					{
						$.ajax
						({
						type: "POST",
						url: "mailrma.php",
						data: { norden: "El numero de orden: 380", cliente: "Del cliente: ADINSA", direccion: "De la direccion: Av. Degollado 231 Col. Centro", contcliente: "Contacto del cliente: Juanis", telefono: "Numero de telefono(s): 7114245 - 8711374436", producto: "El producto enviado a RMA es el: Switch", modelo: "Modelo: FGSW-1816HPS", serie: "Serie: AK80087200093", repfalla: "Con la falla reportada de: no responde", recibido: "Recibido el : Dia Jueves 30 de Agosto del 2018", enviado: "Enviado para su reparacion el: Dia Sábado 1 de Septiembre del 2018", proveedor: "Enviado al proveedor: Syscom", rmap: "RMA de proveedor: 1090274", md: "Mas detalles en 192.168.1.250:8080/almacen/rmabcv.php (sin comillas), buscar el RMA con el ID: 18"}
						}).done(function( msg ) {
						});
					}		
				</script>
				</head>


				<body onload="comprobar()">
				<span></span>
				</body>
				</html>