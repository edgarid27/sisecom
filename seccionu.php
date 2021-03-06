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
    <script src="js/seccion.js"></script>
    
    <script type="text/javascript">
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

	<title>Panel principal de administración de almacen.</title>
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
     <div class="table-responsive">
      <table id="seccion" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="id">ID</th>
                    <th data-column-id="seccion">Seccion</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Modificar y eliminar.</th>
                </tr>
            </thead>
       </table>
       </div> 
        <br />
        <span id="resdlt"></span><br />
        <br />
        <br />
    
    <fieldset>
        <legend>Modificar</legend>
    </fieldset>
    <form id="formal" method="POST">
        
        <div class="form-group">
            <label for="id">ID:</label><br />
            <input type="text" maxlength="50" class="form-control" id="xid" name="xid" placeholder="ID" readonly="readonly" />
        </div>

        <div class="form-group">
            <label for="seccion">Seccion:</label><br />
			<input type="text" maxlength="50" onkeypress="return soloLetras(event)" class="form-control" id="xseccion" name="xseccion" placeholder="Seccion" />
		</div>
        
        <div class="from-group">
        <span id="res"></span><br />
		<input type="button" id="botonc" value="Modificar" class="form-control btn-success"/>
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