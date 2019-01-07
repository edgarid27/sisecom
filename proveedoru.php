<?php
    session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }

    require_once('php/conexion.php');
    $shsql ="SELECT id, ciudad FROM `ciudad` where estatus = 1 order by ciudad";
    $rec1  = mysqli_query($con,$shsql);
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
    <script src="js/proveedor.js"></script>
    
    <script type="text/javascript">
      "use strict";jQuery.base64=(function($){var _PADCHAR="=",_ALPHA="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",_VERSION="1.0";function _getbyte64(s,i){var idx=_ALPHA.indexOf(s.charAt(i));if(idx===-1){throw"Cannot decode base64"}return idx}function _decode(s){var pads=0,i,b10,imax=s.length,x=[];s=String(s);if(imax===0){return s}if(imax%4!==0){throw"Cannot decode base64"}if(s.charAt(imax-1)===_PADCHAR){pads=1;if(s.charAt(imax-2)===_PADCHAR){pads=2}imax-=4}for(i=0;i<imax;i+=4){b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6)|_getbyte64(s,i+3);x.push(String.fromCharCode(b10>>16,(b10>>8)&255,b10&255))}switch(pads){case 1:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6);x.push(String.fromCharCode(b10>>16,(b10>>8)&255));break;case 2:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12);x.push(String.fromCharCode(b10>>16));break}return x.join("")}function _getbyte(s,i){var x=s.charCodeAt(i);if(x>255){throw"INVALID_CHARACTER_ERR: DOM Exception 5"}return x}function _encode(s){if(arguments.length!==1){throw"SyntaxError: exactly one argument required"}s=String(s);var i,b10,x=[],imax=s.length-s.length%3;if(s.length===0){return s}for(i=0;i<imax;i+=3){b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8)|_getbyte(s,i+2);x.push(_ALPHA.charAt(b10>>18));x.push(_ALPHA.charAt((b10>>12)&63));x.push(_ALPHA.charAt((b10>>6)&63));x.push(_ALPHA.charAt(b10&63))}switch(s.length-imax){case 1:b10=_getbyte(s,i)<<16;x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_PADCHAR+_PADCHAR);break;case 2:b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8);x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_ALPHA.charAt((b10>>6)&63)+_PADCHAR);break}return x.join("")}return{decode:_decode,encode:_encode,VERSION:_VERSION}}(jQuery));
    function ExportToExcel(proveedores){
           var htmltable= document.getElementById('proveedores');
           var html = htmltable.outerHTML;
           window.open('data:application/vnd.ms-excel;base64,' +  $.base64.encode(html));
        }
    </script>

    <script type="text/javascript">
        function Redireccionar(){ 
            location.href ="php/pdf/genPDFProv.php";
        };
    </script>

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
      <table id="proveedores" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="id" data-type="numeric">ID</th>
                    <th data-column-id="proveedor">Proveedor</th>
                    <th data-column-id="ciudad">Ciudad</th>
                    <th data-column-id="direccion">Dirección</th>
                    <th data-column-id="telefono">Telefono</th>
                    <th data-column-id="contacto">Contacto</th>
                    <th data-column-id="sucursal">Sucursal</th>
                    <th data-column-id="webpage" data-formatter="link">Pagina web</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Modificar y eliminar.</th>
                </tr>
            </thead>
       </table>
       
       <span id="resdlt"></span>
       </div>
       <br />
             
       <div class="col-md-12">
            <button type="button" style="margin-left: 10px;" class="btn  pull-right clearfix btn-success" onclick="ExportToExcel('mercancia', 'W3C Example Table')" value="Exportar a Excel"><span class="fa fa-file-excel-o" style="margin-left: 10px;"></span> Exportar a Excel</button>

            <button type="button" style="margin-left: 10px;" class="btn  btn-danger pull-right clearfix" onclick ="Redireccionar()"><span class="fa fa-file-pdf-o"></span> Exportar a PDF</button>
        </div>
        
        <br />
        <br /><br />
    
    <fieldset>
        <legend>Modificar</legend>
    </fieldset>
    <form id="formal" method="POST">
        <div class="form-group">
            <label for="id">ID del proveedor:</label><br />
			<input type="text" class="form-control" id="xid" name="xid" placeholder="ID del proveedor" readonly="readonly" />
		</div>
        
        <div class="form-group">
            <label for="estado">Proveedor:</label><br />
			<input type="text" maxlength="50" onkeypress="return soloLetras(event)" class="form-control" id="xproveedor" name="xproveedor" placeholder="Proveedor" />
		</div>

        <div class="form-group">
        <label for="ciuest">Ciudad, Estado:</label>
        <select id="xciuest" name="xciuest" class="form-control">
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
            <label for="direccion">Dirección:</label><br />
            <input type="text" maxlength="50" class="form-control" onkeypress="return soloLetras(event)" id="xdireccion" name="xdireccion" placeholder="Direccion" />
        </div>

        <div class="form-group">
            <label for="telefono">Telefono:</label><br />
            <input type="text" maxlength="30" class="form-control" onkeypress="return telefono(event)" id="xtelefono" name="xtelefono" placeholder="Telefono" />
        </div>

        <div class="form-group">
            <label for="contacto">Contacto:</label><br />
            <input type="text" maxlength="60" class="form-control" onkeypress="return soloLetras(event)" id="xcontacto" name="xcontacto" placeholder="Contacto" />
        </div>

        <div class="form-group">
            <label for="Sucursal">Sucursal:</label><br />
            <input type="text" maxlength="45" class="form-control" onkeypress="return soloLetras(event)" id="xsucursal" name="xsucursal" placeholder="Sucursal" />
        </div>
        
        <div class="form-group">
            <label for="Sucursal">Pagina web:</label><br />
            <input type="text" maxlength="45" class="form-control" onkeypress="return soloLetras(event)" id="xwebpage" name="xwebpage" placeholder="Sucursal" />
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