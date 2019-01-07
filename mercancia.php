<?php
    session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }
    require_once('php/conexion.php');
    $shsql ="SELECT id, marca FROM `marcas` where estatus = 1 and categoria = 1 order by marca";
    $rec1= mysqli_query($con,$shsql);
    
    $shsq3 ="SELECT id, seccion FROM `seccion` where estatus = 1 order by seccion";
    $rec3  = mysqli_query($con,$shsq3);
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
    <script src="js/combos.js"></script>
    <script src="js/mercancia.js"></script>
    
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

        function soloLetas(e){
           key = e.keyCode || e.which;
           tecla = String.fromCharCode(key).toLowerCase();
           letras = " qwertyuiopñlkjhgfdsazxcvbnm-";
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

        function soloLetras(e)
        {
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

	<title>Panel principal de administración de mercancia.</title>
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
        
        
        </div>
        
        <div class="container">
       
        
        <br />
        <br /><br />
    
    <fieldset>
        <legend>Agregar</legend>
    </fieldset>
    <form id="formal" method="POST">
        
        <div class="form-group">
        <label for="Mercancia">Mercanacia:</label>
        <select name="xmercancia" id="xmercancia" class="form-control">
          <option value="0">SELECCIONE</option>
        </select>
        </div>
        
        <div class="form-group">
        <label for="Marca">Marca:</label>
        <select id="xmarca" name="xmarca" class="form-control">
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
            <label for="modelo">Modelo:</label><br />
			<input type="text" maxlength="50"  onkeyup="mayus(this)" onkeypress="return soloLetras(event)"  class="form-control" id="xmodelo" name="xmodelo" placeholder="Modelo" />
		</div>
        
        <?php
        $shsq4 ="SELECT * FROM descripcion WHERE estatus = 1 order by descripcion";
        $rec4= mysqli_query($con,$shsq4);
        ?>
        
        <div class="form-group">
        <label for="Categoria">Categoria:</label>
        <select name="xdescripcion" id="xdescripcion" class="form-control">
          <option value="0">SELECCIONE</option>
          <?php
                while($row3 = mysqli_fetch_array($rec4))
                {
                    echo "<option value='".$row3['0']."'>";
                    echo $row3['1'];
                    echo "</option> 
            ";
                }
            ?>
        </select>
        </div>
        
        <div class="form-group">
			<label for="name">Descripción:</label>
            <textarea class="form-control" maxlength="300" onkeypress="return soloLetras(event)" name="coment" id="coment"  placeholder="Nota"></textarea>
		</div>

        <div class="form-group">
        <label for="seccion">Seccion o referencia de ubicación de la mercancia:</label>
        <select id="xseccion" name="xseccion" class="form-control">
        <option value="0">SELECCIONE</option>
        <?php
            while($rowb = mysqli_fetch_array($rec3))
            {
                echo "<option value='".$rowb['0']."'>";
                echo $rowb['1'];
                echo "</option> 
        ";
            }
        ?>
        </select>
        </div>
  
        <div class="form-group">
            <label for="imagen">Imagen:</label><br />
			<input type="file" class="form-control" id="ximagen" name="ximagen" placeholder="Imagen de la mercancia"/>
		</div>
        
        <div class="from-group">
        <span id="res"></span><br />
		<input type="button" id="botona" value="Agregar" class="form-control btn-primary"/>
        </div>

        <div class="from-group">
        <br />
		<input type="reset" id="botond" value="Eliminar datos de formulario" class="btn btn-danger pull-right"/>
        </div>
        
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