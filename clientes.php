<?php
session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }
    
    require_once('php/conexion.php');
    $shsql ="SELECT id, ciudad FROM `ciudad` where estatus = 1 order by ciudad";
    $rec1= mysqli_query($con,$shsql);
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
    <script src="js/clientes.js"></script>
    
    <script>
        function soloNumeros(e){
           key = e.keyCode || e.which;
           tecla = String.fromCharCode(key).toLowerCase();
           letras = " 0123456789-";
           especiales = "8-37-39-46";

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

        function soloNumerospat(e){
           key = e.keyCode || e.which;
           tecla = String.fromCharCode(key).toLowerCase();
           letras = " 0123456789()-";
           especiales = "8-37-39-46";

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

        function mayus(e) {
            e.value = e.value.toUpperCase();;

        }

        function soloLetras(e){
           key = e.keyCode || e.which;
           tecla = String.fromCharCode(key).toLowerCase();
           letras = ' qwertyuiopñlkjhgfdsazxcvbnm0123456789-/*+½¼¾¶()=.,*$#_:"?¿!¡%@';
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

	<title>Panel principal de administración de clientes.</title>
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
        </div>
        
        <div class="container">
        <br />
        <br /><br />
    
    <fieldset>
        <legend>Agregar</legend>
    </fieldset>
    <form id="formal" method="POST">
        
        <div class="form-group">
            <label for="cliente">Cliente:</label><br />
			<input type="text" maxlength="50" class="form-control" onkeypress="return soloLetras(event)" id="xcliente" name="xcliente" placeholder="Cliente" />
		</div>
        
        <div class="form-group">
            <label for="direccion">Direccion:</label><br />
			<input type="text" maxlength="75" class="form-control" onkeypress="return soloLetras(event)" id="xdireccion" name="xdireccion" placeholder="Dirección" />
		</div>
        
        <div class="form-group">
        <label for="CiudadEstado">Ciudad/estado:</label>
        <select id="xce" name="xce" class="form-control">
            <option value="0">SELECCIONE</option>
            <?php
                while($row = mysqli_fetch_array($rec1))
                {
                    echo "<option value='".$row['0']."'>";
                    echo $row['1'];
                    echo "</option> 
            ";
                }
            ?>
        </select>
        </div>

        <div class="form-group">
            <label for="contacto">Contacto:</label><br />
            <input type="text" maxlength="50" class="form-control" onkeypress="return soloLetras(event)" id="xcontacto" name="xcontacto" placeholder="Contacto" />
        </div>

        <div class="form-group">
            <label for="telefono">Telefono:</label><br />
            <input type="text" maxlength="15" onkeypress="return soloNumerospat(event)" class="form-control" id="xtelefono" name="xtelefono" placeholder="Telefono" />
        </div>

        <div class="form-group">
            <label for="telefonoalt">Telefono alternativo (no obligatorio):</label><br />
            <input type="text" maxlength="15" onkeypress="return soloNumerospat(event)" class="form-control" id="xtelefonoalt" name="xtelefonoalt" placeholder="Telefono alternativo" />
        </div>
        
        <div class="from-group">
        <span id="res"></span><br />
		<input type="button" id="botona" value="Agregar" class="form-control btn-primary"/>
        </div>
        
        <div class="from-group">
        <br />
		<input type="reset" id="botonc" value="Eliminar datos de formulario" class="btn btn-danger pull-right"/>
        <br />
        </div>
        
    </form>
    
    </div>
    <br />
    <div class="container">
        <footer class="panel-footer modal-footer">
            <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
        </footer>
    </div>
    
</body>
</html>