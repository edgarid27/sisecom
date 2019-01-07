<?php
    session_start();
    if(isset($_SESSION['identificador']))
    {
        header("Location: inicio.php");
    }
    else
    {
        if(isset($_SESSION['useringresa']))
        {
            header("Location: view/inicio.php");
        }
        else
        {
            
        }
    }

?>
<!DOCTYPE HTML>
<html>
<head>
	<link rel="icon" href="img/icosecom.ico"/>
    <meta name="author" content="Edgar Felipe Hernandez Garcia - TeamScrlet"/>
    <meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="css/jquery.bootgrid.css" />
    <link rel="stylesheet" type="text/css" href="css/font-awesome-4.7.0/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="css/font-awesome-4.7.0/css/font-awesome.min.css" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"/>
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script> 
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-bootgrid/1.3.1/jquery.bootgrid.js"></script>
    
    <script src="js/jquery-3.2.1.js"></script>
    <script src="js/jquery.bootgrid.min.js"></script>
    <script src="js/proyecto1.js"></script>
    <script>
    setTimeout("comprobar()",60000);
    function comprobar()
    {
        hoy=new Date();
        hora=hoy.getHours();
        minutos=hoy.getMinutes();
        segundos=hoy.getSeconds();
        if(hora == 15 || hora == 16 || hora == 17 || hora == 18){
            location.href ="date.php";
            }
        setTimeout("comprobar()",60000);
    }
    </script>
    
	<title>Login.</title>
</head>

<body id="cuerpo">
    <div class="container">
    <header class="page-header dropdown-header modal-header" >
        <img src="img/logo-circle.png"  height="40%" class="img-circle img-responsive" />
        <h2>Panel de administracion de almacen</h2>
    </header>
    <br />
        <fieldset>
            <legend>Login.</legend>
        </fieldset>
        
        <form id="foormal" method="POST" action="./login/verificar.php">
		
        <div class="form-group">
		  <label for="usuario">Usuario:</label><br/>
		  <input type="text" id="usuario" name="Usuario" placeholder="Usuario" class="form-control"/><br/>
        </div>
        
        <div class="form-group">
		  <label for="password">Contraseña:</label><br/>
		  <input type="password" id="password" name="Password" placeholder="Contraseña" class="form-control"/><br/>
        </div>
        
        <div class="form-group">
		  <input type="submit" name="aceptar" value="Ingresar" class="form-control btn btn-success pull-right"/>
        </div>
        
        <?php 
		if(isset($_GET['error'])){
			echo '<center style="font-weight: bold; font-family: arial; color:red; font-size: 22px;">Datos No Validos</center>';
		}
		?>
        <?php 
		if(isset($_GET['errorf'])){
			echo '<center style="font-weight: bold; font-family: arial; color:red; font-size: 22px;">Falta algun dato</center>';
		}
		?>
	</form>
    <br />
    <br />
    <br />
    <footer class="panel-footer modal-footer">
        <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
    </footer>
    </div>


</body>
</html>