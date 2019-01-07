<?php
    session_start();
    if(isset($_SESSION['identificador']) || isset($_SESSION['hora'])){
    }else
    {
        header("Location: index.php");
    }
    
    require_once('php/conexion.php');
    
    $shsql="SELECT Id, Nombre, Apellido, Usuario FROM `Usuarios` where Privilegio = 1 order by Nombre";
    $rec1= mysqli_query($con,$shsql);
    
    $shsq2 ="SELECT Id, Nombre, Apellido, Usuario FROM `Usuarios` where Privilegio = 1 or Privilegio = 2 order by Nombre";
    $rec2= mysqli_query($con,$shsq2);
    
    $shsq3 ="SELECT * FROM `clientes` where estatus = 1 order by cliente";
    $rec3= mysqli_query($con,$shsq3);
    
    $shsq4 ="SELECT id, modelo FROM `mercancia` where estatus = 1  order by modelo";
    $rec4= mysqli_query($con,$shsq4);
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
    <script src="js/bajas.js"></script>
    
    <script type="text/javascript">
      "use strict";jQuery.base64=(function($){var _PADCHAR="=",_ALPHA="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",_VERSION="1.0";function _getbyte64(s,i){var idx=_ALPHA.indexOf(s.charAt(i));if(idx===-1){throw"Cannot decode base64"}return idx}function _decode(s){var pads=0,i,b10,imax=s.length,x=[];s=String(s);if(imax===0){return s}if(imax%4!==0){throw"Cannot decode base64"}if(s.charAt(imax-1)===_PADCHAR){pads=1;if(s.charAt(imax-2)===_PADCHAR){pads=2}imax-=4}for(i=0;i<imax;i+=4){b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6)|_getbyte64(s,i+3);x.push(String.fromCharCode(b10>>16,(b10>>8)&255,b10&255))}switch(pads){case 1:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6);x.push(String.fromCharCode(b10>>16,(b10>>8)&255));break;case 2:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12);x.push(String.fromCharCode(b10>>16));break}return x.join("")}function _getbyte(s,i){var x=s.charCodeAt(i);if(x>255){throw"INVALID_CHARACTER_ERR: DOM Exception 5"}return x}function _encode(s){if(arguments.length!==1){throw"SyntaxError: exactly one argument required"}s=String(s);var i,b10,x=[],imax=s.length-s.length%3;if(s.length===0){return s}for(i=0;i<imax;i+=3){b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8)|_getbyte(s,i+2);x.push(_ALPHA.charAt(b10>>18));x.push(_ALPHA.charAt((b10>>12)&63));x.push(_ALPHA.charAt((b10>>6)&63));x.push(_ALPHA.charAt(b10&63))}switch(s.length-imax){case 1:b10=_getbyte(s,i)<<16;x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_PADCHAR+_PADCHAR);break;case 2:b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8);x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_ALPHA.charAt((b10>>6)&63)+_PADCHAR);break}return x.join("")}return{decode:_decode,encode:_encode,VERSION:_VERSION}}(jQuery));
    function ExportToExcel(mercancia){
           var htmltable= document.getElementById('mercancia');
           var html = htmltable.outerHTML;
           window.open('data:application/vnd.ms-excel;base64,' +  $.base64.encode(html));
        }
    </script>
    
    <script type="text/javascript">
        function Redireccionar(){ 
            location.href ="php/pdf/genPDFBaja.php";
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
           letras = ' qwertyuiopñlkjhgfdsazxcvbnm0123456789-/*+½¼¾¶()=.,*$#_:"?¿!¡%';
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

	<title>Panel principal de administración de bajas modificacion.</title>
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
        <input type="hidden" value="<?php echo $_SESSION['identificador']; ?>" id="iduser" name="iduser" />
        <input type="hidden" value="<?php echo $_SESSION['hora']; ?>" id="hora" name="hora" />
    
    <div class="table-responsive">
      <table id="mercancia" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="id">ID</th>
                    <th data-column-id="accione">Accion</th>
                    <th data-column-id="fecha">Fecha</th>
                    <th data-column-id="modelob">ID mod</th>
                    <th data-column-id="model">Modelo</th>
                    <th data-column-id="usuarioao">Administrador</th>
                    <th data-column-id="usuariobo">Usuario</th>
                    <th data-column-id="clientes">Cliente</th>
                    <th data-column-id="comentario">Comentario</th>
                    <th data-column-id="cantidad">Cantidad</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Modificar y eliminar.</th>
                </tr>
            </thead>
       </table>
       <span id="resdlt"></span><br />
       </div>
    

    <br />
    <div class="col-md-12">
        	<button type="button" style="margin-left: 10px;" class="btn  pull-right clearfix btn-success" onclick="ExportToExcel('mercancia', 'W3C Example Table')" value="Export to Excel"><span class="fa fa-file-excel-o" style="margin-left: 10px;"></span> Exportar a PDF</button>

            <button type="button" style="margin-left: 10px;" class="btn  btn-danger pull-right clearfix" onclick ="Redireccionar()"><span class="fa fa-file-pdf-o"></span> Exportar a PDF</button>
        </div>
    <br />
    <br />
    <br />
    <br />
    <div class="from-group">
        <input type="button" id="botoncan" value="Cancelar bajas" class="btn  pull-left clearfix btn-danger"/>
    </div>
    <br />
    <br />
    <br />
    <br />
    <fieldset>
        <legend>Modificar bajas</legend>
    </fieldset>
    <form id="formal">
        <div class="form-group">
      <input type="hidden" class="form-control" id="xid" name="xid" placeholder="ID de la baja" />
    </div>
           
        <div class="form-group">
            <input type="hidden" value="<?php echo $_SESSION['identificador']; ?>"  id="xadmin" name="xadmin" />
        </div>
        
        <div class="form-group">
        <label for="iduser">Material otorgado para:</label>
        <select name="user" id="user" class="form-control">
            <option value="0">SELECCIONE</option>
            <?php
                while($row = mysqli_fetch_array($rec2))
                {
                    echo "<option value='".$row['0']."'>";
                    echo $row['1'].' '.$row['2'];
                    echo "</option> 
            ";
                }
            ?>
        </select>
        </div>
        
        <div class="form-group">
        <label for="cliente">Cliente:</label>
        <select name="xcliente" id="xcliente" class="form-control">
          <option value="0">SELECCIONE</option>
          <?php
                while($row4 = mysqli_fetch_array($rec3))
                {
                    echo "<option value='".$row4['0']."'>";
                    echo $row4['1'];
                    echo "</option> 
            ";
                }
            ?>
        </select>
        </div>
        
        <div class="table-responsive">
            <table class="table table-condensed table-hover table-striped" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th class="text-left">Mercancia numero</th>
                        <th class="text-left">ID</th>
                        <th class="text-left">Mercancia</th>
                        <th class="text-left">Cantidad actual del producto</th>
                        <th class="text-left">Cantidad solicitada</th>
                        <th class="text-left">Cantidad a agregar/restar</th>
                        <th class="text-left">Comentario</th>
                    </tr>
                </thead>
                <tbody id="col1" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>1</span>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid1" name="xid1" readonly="" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc1" name="xmerc1" readonly="" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant1" name="xcant1" readonly="" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta1" name="xcanta1" readonly="readonly" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre1" name="xagre1"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment1" name="xcoment1"></textarea>
                        </div>
                        </td>

                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc1" name="xvalmerc1"  />
                        </td>

                    </tr>
                </tbody>
                
                <tbody id="col2" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>2</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid2" name="xid2" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc2" name="xmerc2" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant2" name="xcant2" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta2" name="xcanta2" readonly="readonly" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre2" name="xagre2"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment2" name="xcoment2"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc2" name="xvalmerc2"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col3" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>3</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid3" name="xid3" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc3" name="xmerc3" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant3" name="xcant3" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta3" name="xcanta3" readonly="readonly"  />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre3" name="xagre3"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment3" name="xcoment3"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc3" name="xvalmerc3"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col4" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>4</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid4" name="xid4" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc4" name="xmerc4" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant4" name="xcant4" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta4" name="xcanta4" readonly="readonly" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre4" name="xagre4" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment4" name="xcoment4"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc4" name="xvalmerc4"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col5" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>5</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid5" name="xid5" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc5" name="xmerc5" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant5" name="xcant5" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta5" name="xcanta5" readonly="readonly" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre5" name="xagre5" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment5" name="xcoment5"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc5" name="xvalmerc5"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col6" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>6</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid6" name="xid6" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc6" name="xmerc6" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant6" name="xcant6" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta6" name="xcanta6" readonly="readonly"/>
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre6" name="xagre6" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment6" name="xcoment6"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc6" name="xvalmerc6"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col7" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>7</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid7" name="xid7" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc7" name="xmerc7" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant7" name="xcant7" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta7" name="xcanta7" readonly="readonly"/>
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre7" name="xagre7" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment7" name="xcoment7"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc7" name="xvalmerc7"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col8" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>8</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid8" name="xid8" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc8" name="xmerc8" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant8" name="xcant8" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta8" name="xcanta8" readonly="readonly"/>
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre8" name="xagre8" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment8" name="xcoment8"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc8" name="xvalmerc8"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col9" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>9</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid9" name="xid9" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc9" name="xmerc9" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant9" name="xcant9" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta9" name="xcanta9" readonly="readonly" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre9" name="xagre9" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment9" name="xcoment9"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc9" name="xvalmerc9"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col10" class="hidden"> 
                    <tr>
                        <td class="text-left">
                            <span>10</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xid10" name="xid10" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc10" name="xmerc10" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant10" name="xcant10" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcanta10" name="xcanta10" readonly="readonly" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xagre10" name="xagre10" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="330" id="xcoment10" name="xcoment10"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc10" name="xvalmerc10"  />
                        </td>
                    </tr>
                </tbody>

                <tbody id="col11" class="hidden">
                    <tr>
                        <td class="text-left"> 
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc16" name="xmerc11" readonly="" />
                        </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="from-group">
            <span id="res"></span><br />
            <input type="button" id="botonc" value="Modificar" class="form-control btn-success"/>
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