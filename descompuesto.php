<?php
    session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }

    require_once('php/conexion.php');
    $shsql ="SELECT id, marca FROM `marcas` where estatus = 1 and categoria = 2 order by marca";
    $rec1  = mysqli_query($con,$shsql);
    
    $shsq2 ="SELECT id, estado FROM `estado` where estatus = 1 order by estado";
    $rec2  = mysqli_query($con,$shsq2);

    $shsq3 ="SELECT id, seccion FROM `seccion` where estatus = 1 order by seccion";
    $rec3  = mysqli_query($con,$shsq3);

    $shsq4 ="SELECT id, almacen FROM `almacen` where estatus = 1 order by almacen";
    $rec4  = mysqli_query($con,$shsq4);
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
    <script src="js/descompuesto.js"></script>
    
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
            e.value = e.value.toUpperCase();
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

    <title>Panel principal de administración de herramientas (descompuesta)</title>
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
    
      <table id="herramienta" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="id" data-type="numeric">ID</th>
                    <th data-column-id="herramienta">Herramienta</th>
                    <th data-column-id="descripcion">Descripcion</th>
                    <th data-column-id="marcas">Marca</th>
                    <th data-column-id="modelo">Modelo</th>
                    <th data-column-id="estad">Estado</th>
                    <th data-column-id="existencia">Existencia</th>
                    <th data-column-id="seccionb">Seccion</th>
                    <th data-column-id="almacen">Almacen</th>
                    <th data-column-id="imagen" data-formatter="pix">Imagen<th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Agregar.</th>
                </tr>
            </thead>
        </table>
       
        <span id="resdlt"></span>
        </div>
        <br />
        <br /><br />
    
    <fieldset>
        <legend>Agregar</legend>
    </fieldset>
    
    <form id="formal" method="POST">
        
        <div class="form-group">
            <input type="hidden" maxlength="50" class="form-control" id="xid" name="xid"/>
        </div>

        <div class="form-group">
            <label for="herramienta">Herramienta:</label><br />
            <input type="text" maxlength="50" class="form-control" id="xherramienta" name="xherramienta"  placeholder="Herramienta" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label for="descripcion">Descripción de la herramienta:</label><br />
            <textarea type="text" maxlength="250" class="form-control" id="xdescripcion" name="xdescripcion" placeholder="Descripción de la herramienta" readonly="readonly"></textarea>
        </div>
        
        <div class="form-group">
        <label for="Marca">Marca:</label>
        <select id="xmarca" name="xmarca" disabled="disabled" class="form-control">
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
            <label for="modelo">Modelo de la herramienta:</label><br />
            <input type="text" maxlength="50" class="form-control" onkeyup="mayus(this)" id="xmodelo" name="xmodelo" placeholder="Modelo de la herramienta" readonly="readonly" />
        </div>
        
        <div class="form-group">
        <label for="estado">Estado de la herramienta:</label>
        <select id="xestado" name="xestado" disabled="" class="form-control">
        <option value="3">Descompuesto</option>
        </select>
        </div>
        
        <div class="form-group">
            <label for="modelo">Cantidad existente de la herramienta:</label><br />
            <input type="text" maxlength="50" class="form-control" onkeypress="return soloNumeros(event)" id="xcant" name="xcant" placeholder="Modelo de la herramienta" readonly="readonly" />
        </div>

        <div class="form-group">
            <label for="modelo">Cantidad en perdida de la nueva herramienta:</label><br />
            <input type="text" maxlength="50" class="form-control" onkeypress="return soloNumeros(event)" id="xcantn" name="xcantn" placeholder="Cantidad en perdida de la nueva herramienta"/>
        </div>

        <div class="form-group">
        <label for="seccion">Seccion o referencia de ubicación de la herramienta:</label>
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
        <label for="almacen">Almacen:</label>
        <select id="xalmacen" name="xalmacen" class="form-control">
        <option value="0">SELECCIONE</option>
        <?php
            while($rowc = mysqli_fetch_array($rec4))
            {
                echo "<option value='".$rowc['0']."'>";
                echo $rowc['1'];
                echo "</option> 
        ";
            }
        ?>
        </select>
        </div>

        <div class="form-group">
            <label for="descripcion">Razón de falla:</label><br />
            <textarea type="text" maxlength="115" onkeypress="return soloLetras(event)" class="form-control" id="xrdf" name="xrdf" placeholder="Razón de falla"></textarea>
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