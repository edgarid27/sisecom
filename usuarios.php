<?php
    session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }
    
    require_once('php/conexion.php');
    $shsql ="select id, permisos from privilegio where id = 1 or id = 2 or id = 3 and estatus =1;";
    $rec1= mysqli_query($con,$shsql);
    
    $shsq2 ="select id, permisos from privilegio where id = 1 or id = 2 or id = 3 and estatus =1;";
    $rec2= mysqli_query($con,$shsq2);
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
    <script src="js/usuarios.js"></script>
    
    <script type="text/javascript">
    "use strict";jQuery.base64=(function($){var _PADCHAR="=",_ALPHA="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",_VERSION="1.0";function _getbyte64(s,i){var idx=_ALPHA.indexOf(s.charAt(i));if(idx===-1){throw"Cannot decode base64"}return idx}function _decode(s){var pads=0,i,b10,imax=s.length,x=[];s=String(s);if(imax===0){return s}if(imax%4!==0){throw"Cannot decode base64"}if(s.charAt(imax-1)===_PADCHAR){pads=1;if(s.charAt(imax-2)===_PADCHAR){pads=2}imax-=4}for(i=0;i<imax;i+=4){b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6)|_getbyte64(s,i+3);x.push(String.fromCharCode(b10>>16,(b10>>8)&255,b10&255))}switch(pads){case 1:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6);x.push(String.fromCharCode(b10>>16,(b10>>8)&255));break;case 2:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12);x.push(String.fromCharCode(b10>>16));break}return x.join("")}function _getbyte(s,i){var x=s.charCodeAt(i);if(x>255){throw"INVALID_CHARACTER_ERR: DOM Exception 5"}return x}function _encode(s){if(arguments.length!==1){throw"SyntaxError: exactly one argument required"}s=String(s);var i,b10,x=[],imax=s.length-s.length%3;if(s.length===0){return s}for(i=0;i<imax;i+=3){b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8)|_getbyte(s,i+2);x.push(_ALPHA.charAt(b10>>18));x.push(_ALPHA.charAt((b10>>12)&63));x.push(_ALPHA.charAt((b10>>6)&63));x.push(_ALPHA.charAt(b10&63))}switch(s.length-imax){case 1:b10=_getbyte(s,i)<<16;x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_PADCHAR+_PADCHAR);break;case 2:b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8);x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_ALPHA.charAt((b10>>6)&63)+_PADCHAR);break}return x.join("")}return{decode:_decode,encode:_encode,VERSION:_VERSION}}(jQuery));
    function ExportToExcel(usuarios){
           var htmltable= document.getElementById('usuarios');
           var html = htmltable.outerHTML;
           window.open('data:application/vnd.ms-excel;base64,' +  $.base64.encode(html));
        }
    </script>

    <script type="text/javascript">
        function soloLetas(e){
           key = e.keyCode || e.which;
           tecla = String.fromCharCode(key).toLowerCase();
           letras = ' qwertyuiopñlkjhgfdsazxcvbnm0123456789-/*+½¼¾¶()=.,*$#_:"?¿!¡%@';
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


        function Redireccionar(){ 
            location.href ="php/pdf/genPDFUser.php";
        };
    </script>
    

	<title>Panel principal de administración de usuarios.</title>
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
      <table id="usuarios" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="Id" data-type="numeric">ID</th>
                    <th data-column-id="Nombre">Nombre</th>
                    <th data-column-id="Apellido">Apellido</th>
                    <th data-column-id="Usuario">Usuario</th>
                    <th data-column-id="Permisos">Estado</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Modificar y eliminar.</th>
                </tr>
            </thead>
       </table>
       
       <span id="resdlt"></span>
       </div>
       <br />
             
       <div class="col-md-12">
      	    <button type="button" style="margin-left: 10px;" class="btn  pull-right clearfix btn-success" onclick="ExportToExcel('usuarios', 'W3C Example Table')" value="Export to Excel"><span class="fa fa-file-excel-o" style="margin-left: 10px;"></span> Exportar a Excel</button>
    
            <button type="button" style="margin-left: 10px;" class="btn  btn-danger pull-right clearfix" onclick ="Redireccionar()"><span class="fa fa-file-pdf-o"></span> Exportar a PDF</button>
        </div>
        
        <br />
        <br />
        <br />
        
     <form id="formal">
        
        <fieldset>
            <legend>Modificar</legend>
        </fieldset>
            <div class="form-group">
                <label for="id">ID del usuario:</label><br />
    			<input type="text" class="form-control" id="xid" name="xid" placeholder="ID del usuario" readonly="readonly" />
    		</div>
            
            <div class="form-group">
                <label for="name">Nombre</label>
                <input type="text" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="xnombre" placeholder="Nombre"/>
            </div>
                
            <div class="form-group">
                <label for="appe">Apellido</label>
                <input type="text" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="xapellido" placeholder="Apellido"/>
            </div>
            
            <div class="form-group">
                <label for="user">Usuario</label>
                <input type="text" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="xusuario" placeholder="Usuario"/>
            </div>
            
            <div class="form-group">
                <label for="pass">Contraseña:</label><br />
    			<input type="password" class="form-control" onkeypress="return soloLetas(event)" id="xpass" name="xid" placeholder="Contraseña" readonly="readonly" />
    		</div>
            
            <div class="form-group">
            <label for="Permisos">Permisos de:</label>
            <select id="xpermisos" name="xpermisos" class="form-control">
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
		
            <div class="from-group">
                <span id="cu"></span><br />
                <input type="button" id="userup" value="Modificar" class="form-control btn-success"/>
            </div>
            <br />
            <br />
            <br />
        <fieldset>
            <legend>Cambiar contraseña</legend>
        </fieldset>                   
            
            <div class="form-group">
                <label for="id">ID del usuario:</label><br />
    			<input type="text" class="form-control" id="wid" name="wid" placeholder="ID del usuario" readonly="readonly" />
    		</div>
            
            <div class="form-group">
                <label for="pass">Contraseña antigua:</label><br />
    			<input type="password" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="wpassold" name="wpassold" placeholder="Contraseña antigua" />
    		</div> 
            
            <div class="form-group">
                <label for="pass">Contraseña nueva:</label><br />
    			<input type="password" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="wpassn" name="wpassn" placeholder="Nueva contraseña" />
    		</div> 
            
            <div class="form-group">
                <label for="pass">Repetir contraseña:</label><br />
    			<input type="password" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="wpassne" name="wpassne" placeholder="Repetir contraseña nueva" />
    		</div> 
            <div class="from-group">
                <span id="passu"></span><br />
                <input type="button" id="passup" value="Modificar contraseña" class="form-control btn-success"/>
            </div>
            
            <br />
            <br />
            <br />   
               
               
        <fieldset>
            <legend>Agregar</legend>
        </fieldset>
            
            <div class="form-group">
                <label for="name">Nombre</label>
                <input type="text" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="ynombre" placeholder="Nombre"/>
            </div>
                
            <div class="form-group">
                <label for="appe">Apellido</label>
                <input type="text" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="yapellido" placeholder="Apellido"/>
            </div>
            
            <div class="form-group">
                <label for="user">Usuario</label>
                <input type="text" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="yusuario" placeholder="Usuario"/>
            </div>
            
            <div class="form-group">
                <label for="pass">Contraseña:</label><br />
    			<input type="password" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="ypass" name="xid" placeholder="Contraseña" />
    		</div>
            
            <div class="form-group">
                <label for="pass">Repetir contraseña:</label><br />
    			<input type="password" maxlength="50" onkeypress="return soloLetas(event)" class="form-control" id="ypassd" name="xid" placeholder="Repetir contraseña" />
    		</div>
            
            <div class="form-group">
            <label for="Permisos">Permisos de:</label>
            <select id="xpermiso" name="xpermiso" class="form-control">
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
		
            <div class="from-group">
                <span id="au"></span><br />
                <input type="button" id="useradd" value="Agregar" class="form-control btn-primary"/>
            </div>
  
        </form>
    <br />
    <footer class="panel-footer modal-footer">
        <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
    </footer>
    </div>


    
</body>
</html>