<?php
    session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }

    require_once('php/conexion.php');
    $shsql ="SELECT id, marca FROM `marcas` where estatus = 1 and categoria = 2 order by marca";
    $rec1= mysqli_query($con,$shsql);
    
    $shsq2 ="SELECT id, estado FROM `estado` where estatus = 1 and id = 4 order by estado";
    $rec2= mysqli_query($con,$shsq2);

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
    
    <script type="text/javascript">
      "use strict";jQuery.base64=(function($){var _PADCHAR="=",_ALPHA="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",_VERSION="1.0";function _getbyte64(s,i){var idx=_ALPHA.indexOf(s.charAt(i));if(idx===-1){throw"Cannot decode base64"}return idx}function _decode(s){var pads=0,i,b10,imax=s.length,x=[];s=String(s);if(imax===0){return s}if(imax%4!==0){throw"Cannot decode base64"}if(s.charAt(imax-1)===_PADCHAR){pads=1;if(s.charAt(imax-2)===_PADCHAR){pads=2}imax-=4}for(i=0;i<imax;i+=4){b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6)|_getbyte64(s,i+3);x.push(String.fromCharCode(b10>>16,(b10>>8)&255,b10&255))}switch(pads){case 1:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6);x.push(String.fromCharCode(b10>>16,(b10>>8)&255));break;case 2:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12);x.push(String.fromCharCode(b10>>16));break}return x.join("")}function _getbyte(s,i){var x=s.charCodeAt(i);if(x>255){throw"INVALID_CHARACTER_ERR: DOM Exception 5"}return x}function _encode(s){if(arguments.length!==1){throw"SyntaxError: exactly one argument required"}s=String(s);var i,b10,x=[],imax=s.length-s.length%3;if(s.length===0){return s}for(i=0;i<imax;i+=3){b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8)|_getbyte(s,i+2);x.push(_ALPHA.charAt(b10>>18));x.push(_ALPHA.charAt((b10>>12)&63));x.push(_ALPHA.charAt((b10>>6)&63));x.push(_ALPHA.charAt(b10&63))}switch(s.length-imax){case 1:b10=_getbyte(s,i)<<16;x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_PADCHAR+_PADCHAR);break;case 2:b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8);x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_ALPHA.charAt((b10>>6)&63)+_PADCHAR);break}return x.join("")}return{decode:_decode,encode:_encode,VERSION:_VERSION}}(jQuery));
    function ExportToExcel(herramienta){
           var htmltable= document.getElementById('herramienta');
           var html = htmltable.outerHTML;
           window.open('data:application/vnd.ms-excel;base64,' +  $.base64.encode(html));
        }
    </script>
    
    <script type="text/javascript">
        function Redireccionar(){ 
            location.href ="php/pdf/genPDFTool.php";
        };
    </script>
    
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

	<title>Panel principal de administración de herramientas (update...)</title>
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
    
      <table id="descompuesto" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="id" data-type="numeric">ID</th>
                    <th data-column-id="herramienta">Herramienta</th>
                    <th data-column-id="descripcion">Descripcion</th>
                    <th data-column-id="marca">Marca</th>
                    <th data-column-id="modelo">Modelo</th>
                    <th data-column-id="estado">Estado</th>
                    <th data-column-id="cantidad">Unid. descompuestas</th>
                    <th data-column-id="seccion">Seccion</th>
                    <th data-column-id="almacen">Almacen</th>
                    <th data-column-id="razon">Razon</th>
                    <th data-column-id="imagen" data-formatter="pix">Imagen</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Modificar y eliminar.</th>
                </tr>
            </thead>
       </table>
       
       <span id="resdlt"></span>
       </div>
       <br />
             
       <div class="col-md-12">
 	      <button type="button" style="margin-left: 10px;" class="btn  pull-right clearfix btn-success" onclick="ExportToExcel('herramienta', 'W3C Example Table')" value="Exportar a Excel"><span class="fa fa-file-excel-o" style="margin-left: 10px;"></span> Exportar a Excel</button>

          <button type="button" style="margin-left: 10px;" class="btn  btn-danger pull-right clearfix" onclick ="Redireccionar()"><span class="fa fa-file-pdf-o"></span> Exportar a PDF</button>
                     
        </div>
        
        <br />
        <br /><br />
    
    <fieldset>
        <legend>Modificar</legend>
    </fieldset>
    
    <form id="formal" method="POST">
        <div class="form-group">
            <label for="id">ID de la herramienta descompuesta:</label><br />
			<input type="text" class="form-control" id="xid" name="xid" placeholder="ID de la herramienta" readonly="readonly" />
		</div>

        <div class="form-group">
            <input type="hidden" class="form-control" id="xtoolid" name="xtoolid"/>
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
        <select id="xmarca" name="xmarca" class="form-control" disabled="disabled">
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
        <select id="xestado" name="xestado" class="form-control" disabled="disabled">
        <option value="0">SELECCIONE</option>
        <?php
            while($rowa = mysqli_fetch_array($rec2))
            {
                echo "<option value='".$rowa['0']."'>";
                echo $rowa['1'];
                echo "</option> 
        ";
            }
        ?>
        </select>
        </div>
        
        <div class="form-group">
            <label for="modelo">Cantidad existente de la herramienta:</label><br />
			<input type="text" maxlength="50" class="form-control" id="xcant" name="xcant" placeholder="Cantidad existente de la herramienta" readonly="readonly" />
		</div>

        <div class="form-group">
            <label for="modelo">Cantidad que actualmente esta registrada como descompuesta:</label><br />
            <input type="text" maxlength="50" class="form-control" id="xcantn" name="xcantn" placeholder="Cantidad existente de la herramienta" readonly="readonly" />
        </div>

        <div class="form-group">
            <label for="modelo">Cantidad que deseas agregar o restar a descompuesto: (no puedes agregar mas de lo que existe actualmente, para restar cantidad, coloca el numero en negativo)</label><br />
            <input type="text" maxlength="50" class="form-control" id="xcantsr" name="xcantsr" placeholder="Cantidad actual de herramientas descompuestas"/>
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
            <label for="descripcion">Razon de falla:</label><br />
            <textarea type="text" maxlength="115" onkeypress="return soloLetras(event)" class="form-control" id="xrdf" name="xrdf" placeholder="Razon de falla"></textarea>
        </div>
        
        <div class="from-group">
        <span id="resu"></span><br />
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