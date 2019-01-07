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
    <div class="table-responsive">
      <table id="ciudad" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="id" data-type="numeric">ID</th>
                    <th data-column-id="ciudad">Ciudad</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Modificar y eliminar.</th>
                </tr>
            </thead>
       </table>
       
       <span id="resdlt"></span>
       </div>
       <br />
             
       <div class="col-md-12">
              	<form action="GenPDF.php" method="post">
                	<input type="hidden" name="reporte_name"/>
                	<input type="submit" name="create_pdf" class="btn btn-danger pull-right" value="Generar PDF" style="margin-left: 10px;"/>
                </form>

              	<form action="GenExcel.php" method="post">
                	<input type="submit" name="create_Excel" class="btn btn-success pull-right" value="Generar Excel" style="margin-left: 10px;"/>
                </form>
        </div>
        
        <br />
        <br /><br />
    
    <fieldset>
        <legend>Modificar</legend>
    </fieldset>
    <form id="formal" method="POST">
        <div class="form-group">
            <label for="id">ID del ciudad:</label><br />
			<input type="text" class="form-control" id="xid" name="xid" placeholder="ID del ciudad" readonly="readonly" />
		</div>
        
        <div class="form-group">
            <label for="ciudad">Ciudad, estado:</label><br />
			<input type="text" maxlength="50" onkeypress="return soloLetras(event)" class="form-control" id="xce" name="xce" placeholder="Ciudad, estado" />
		</div>
        
        <div class="from-group">
        <span id="resu"></span><br />
		<input type="button" id="botonc" value="Modificar" class="form-control btn-success"/>
        </div>
        
        <div class="from-group">
        <br />
		<input type="reset" id="botonc" value="Eliminar datos de formulario" class="btn btn-danger pull-right"/>
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