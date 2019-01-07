<?php
session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
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
    <link rel="stylesheet" type="text/css" href="css/css/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="css/nav.css" />
    
    <script src="js/jquery.min.js"></script> 
    <script src="js/bootstrap.min.js"></script>
    
    <script src="js/jquery-3.2.1.js"></script>
    <script src="js/jquery.bootgrid.min.js"></script>
    <script src="js/ciudad.js"></script>

    <script type="text/javascript">
        function soloLetras(e){
           key = e.keyCode || e.which;
           tecla = String.fromCharCode(key).toLowerCase();
           letras = ' qwertyuiopñlkjhgfdsazxcvbnm().,';
           especiales = "08-09-37-39-46";

           tecla_especial = false
           for(var i in especiales){
                if(key == especiales[i]){
                    tecla_especial = true;
                    break;
                }
            }

            if(letras.indexOf(tecla)==-1 && !tecla_especial){
                return false;
            }
        }
    </script>
    

	<title>Panel principal de administración de proveedor.</title>
</head>

<body>
    <div class="container">
    <header class="page-header dropdown-header modal-header" >
        <img src="img/logo-circle.png"  height="40%" class="img-circle img-responsive" />
        <h2>Panel de administracion de almacen</h2>
    </header>
    
     <?php
      include_once('nav.php');
      echo $nav; 
     ?>
        
        <br />
        <br />
        <br />
        <br />
        <br />
        
    </div>
    
    <div class="container">

    <fieldset>
        <legend>Agregar</legend>
    </fieldset>
    <form id="formal" method="POST">
        
        <div class="form-group">
            <label for="ciudad">Ciudad, estado:</label><br />
			<input type="text" maxlength="50" onkeypress="return soloLetras(event)" class="form-control" id="xce" name="xce" placeholder="Ciudad, estado" />
		</div>
        
        <div class="from-group">
        <span id="res"></span><br />
		<input type="button" id="botona" value="Agregar" class="form-control btn-primary"/>
        </div>
        
        <div class="from-group">
        <br />
		<input type="reset" id="botonc" value="Eliminar datos de formulario" class="btn btn-danger pull-right"/>
        </div>
        
    </form>
    
    <br />
    <br />
    <br />
    
    </div>

    <div class="container">
        <footer class="panel-footer modal-footer">
            <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
        </footer>
    </div>
</body>
</html>