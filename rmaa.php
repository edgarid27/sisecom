<?php
    session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }

    require_once('php/conexion.php');
    $shsq2 ="SELECT id, proveedor, sucursal FROM `proveedor` where estatus = 1  order by proveedor";
    $rec2= mysqli_query($con,$shsq2);

    $shsq1 ="SELECT id, cliente FROM `clientes` where estatus = 1 order by cliente";
    $rec1= mysqli_query($con,$shsq1);

    $shsq3 ="SELECT id, ciudad FROM `ciudad` where estatus = 1 order by ciudad";
    $rec3= mysqli_query($con,$shsq3);
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
    <script src="js/rma.js"></script>
    
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
           letras = " 0123456789";
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
    
    

	<title>Panel principal de administración de rma</title>
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
        
        <div class="table-responsive">
    
            <table id="rma" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
                <thead>
                    <tr>
                        <th data-column-id="id" data-type="numeric">ID</th>
                        <th data-column-id="numeroorden">Numero orden</th>
                        <th data-column-id="cliente">Cliente</th>
                        <th data-column-id="direccion">Direccion</th>
                        <th data-column-id="contacto">Contacto</th>
                        <th data-column-id="telefonoa">Nº Telefono (1)</th>
                        <th data-column-id="telefonob">Nº Telefono (2)</th>
                        <th data-column-id="producto">Producto</th>
                        <th data-column-id="modelo">Modelo</th>
                        <th data-column-id="serie">Serie</th>
                        <th data-column-id="descripcion">Descripcion</th>
                        <th data-column-id="rmaproveedor">RMA Proveedor</th>
                        <th data-column-id="fechaingreso">Fecha ingreso</th>
                        <th data-column-id="fechaenvio">Fecha envio</th>
                        <th data-column-id="fecharegreso">Fecha regreso</th>
                        <th data-column-id="fechainstalacion">Fecha instalacion</th>
                        <th data-column-id="proveedor">Proveedor</th>
                        <th data-column-id="resultado">Entregado como</th>
                    </tr>
                </thead>
           </table>
       
       <span id="resdlt"></span>
       </div>
       <br />
        
             
        <!--<div class="col-md-12">
 	      <button type="button" style="margin-left: 10px;" class="btn  pull-right clearfix btn-success" onclick="ExportToExcel('herramienta', 'W3C Example Table')" value="Exportar a Excel"><span class="fa fa-file-excel-o" style="margin-left: 10px;"></span> Exportar a Excel</button>

          <button type="button" style="margin-left: 10px;" class="btn  btn-danger pull-right clearfix" onclick ="Redireccionar()"><span class="fa fa-file-pdf-o"></span> Exportar a PDF</button>         
        </div>
        
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        -->
        <fieldset>
            <legend>Agregar</legend>
        </fieldset>
        <form id="formal">

        <div class="form-group">
            <label for="norden">Numero de orden:</label>
            <input type="numeric" onkeypress="return soloNumeros(event)" id="xnorden" name="xnorden" class="form-control" placeholder="Numero de orden" >
        </div>

        <div class="form-group">
        <label for="iduser">Proveedor:</label>
        <select name="xprovee" id="xprovee" class="form-control">
            <option value="0">SELECCIONE</option>
            <?php
                while($row1 = mysqli_fetch_array($rec2))
                {
                    echo "<option value='".$row1['0']."'>";
                    echo $row1['1'].', '.$row1['2'];
                    echo "</option> 
            ";
                }
            ?>
        </select>
        </div>

        <div class="from-group">
            <input type="button" id="clientee" value="Cliente existente" class="btn  btn-primary  clearfix"/>
            <input type="button" id="clienten" value="Cliente nuevo" class="btn  btn-success  clearfix"/>
        </div>

        <div id="clienteex" class="form-group hidden">
        <label for="Cliente">Cliente:</label>
        <select id="xcliente" name="xcliente" class="form-control">
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

        <div id="xclientewform" class="form-group hidden">
            <label for="clientew">Cliente:</label>
            <input type="text" id="xclientew" name="xclientew" class="form-control" placeholder="Cliente">
        </div>

        <div id="xaddresswform" class="form-group hidden">
            <label for="address">Direccion del cliente:</label>
            <input type="text" id="xaddress" name="xaddress" class="form-control" placeholder="Direccion del cliente">
        </div>

        <div id="xcity" class="form-group hidden">
        <label for="city">Ciudad/estado:</label>
        <select id="xcityw" name="xcityw" class="form-control">
            <option value="0">SELECCIONE</option>
            <?php
                while($row2 = mysqli_fetch_array($rec3))
                {
                    echo "<option value='".$row2['0']."'>";
                    echo $row2['1'];
                    echo "</option> 
            ";
                }
            ?>
        </select>
        </div>

        <div id="xcontactform" class="form-group hidden">
            <label for="contact">Contacto:</label>
            <input type="text" id="xcontact" name="xcontact" class="form-control" placeholder="Contacto">
        </div>

        <div id="xphoneform" class="form-group hidden">
            <label for="phone">Numero de telefono:</label>
            <input type="text" id="xnphone" name="xphone" class="form-control" placeholder="Numero de telefono" onkeypress="return soloNumerospat(event)">
        </div>

        <div id="xphonealtform" class="form-group hidden">
            <label for="phone">Numero de telefono alternativo*:</label>
            <input type="text" id="xnphonealt" name="xphonealt" class="form-control" placeholder="Numero de telefono alternativo" onkeypress="return soloNumerospat(event)">
        </div>

        <div class="form-group">
        <label for="iduser">Cantidad de mercancia que se registrara a RMA:</label>
        <select name="xnas" id="xnas" class="form-control">
            <option value="0">SELECCIONE</option>
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
        </select>
        </div>

        <div class="from-group">
            
            <input type="button" id="btnhm" value="Marcar seleccion" class="btn form-group-sm btn-danger"/>
        </div>

        <div class="table-responsive">
            <table class="table table-condensed table-hover table-striped" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th class="text-left">Nº</th>
                        <th class="text-left">Producto</th>
                        <th class="text-left">Modelo</th>
                        <th class="text-left">Serie</th>
                        <th class="text-left">Descripción de falla</th>
                        <th class="text-left">RMA P.</th>
                        <th class="text-left">Fecha ingreso</th>
                        <th class="text-left">Fecha envio</th>
                        <th class="text-left">Fecha regreso</th>
                        <th class="text-left">Fecha Instalacion</th>
                        <th class="text-left">Entregado como</th>
                    </tr>
                </thead>
                <tbody id="col1" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>1</span>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xproducto1" name="xproducto1" maxlength="30" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" id="xmodelo1" name="xmodelo1" onkeypress="return soloLetras(event)" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" id="xserie1" name="xserie1" onkeypress="return soloLetras(event)" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control" onkeypress="return soloLetras(event)" id="xrazon1" name="xrazon1" maxlength="60"></textarea>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" id="xrmap1" name="xrmap1" maxlength="15" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateig1" name="xdateig1" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateen1" name="xdateen1" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdatere1" name="xdatere1" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateis1" name="xdateis1" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <select name="xec1" id="xec1" class="form-control">
                                <option value="0">SELECCIONE</option>
                                <option value="1">Reparado</option>
                                <option value="2">Nuevo</option>
                                <option value="3">Pendiente</option>
                            </select>
                        </div>
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col2" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>2</span>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xproducto2" name="xproducto2"  maxlength="30" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xmodelo2" name="xmodelo2" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xserie2" name="xserie2" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control" id="xrazon2"onkeypress="return soloLetras(event)" name="xrazon2" maxlength="60"></textarea>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xrmap2" name="xrmap2" maxlength="15" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateig2" name="xdateig2" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateen2" name="xdateen2" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdatere2" name="xdatere2" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateis2" name="xdateis2" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <select name="xec2" id="xec2" class="form-control">
                                <option value="0">SELECCIONE</option>
                                <option value="1">Reparado</option>
                                <option value="2">Nuevo</option>
                                <option value="3">Pendiente</option>
                            </select>
                        </div>
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col3" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>3</span>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xproducto3" name="xproducto3"  maxlength="30" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xmodelo3" name="xmodelo3" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xserie3" name="xserie3" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control" id="xrazon3" onkeypress="return soloLetras(event)" name="xrazon3" maxlength="60"></textarea>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xrmap3" name="xrmap3" maxlength="15" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateig3" name="xdateig3" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateen3" name="xdateen3" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdatere3" name="xdatere3" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateis3" name="xdateis3" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <select name="xec3" id="xec3" class="form-control">
                                <option value="0">SELECCIONE</option>
                                <option value="1">Reparado</option>
                                <option value="2">Nuevo</option>
                                <option value="3">Pendiente</option>
                            </select>
                        </div>
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col4" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>4</span>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xproducto4" name="xproducto4"  maxlength="30" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xmodelo4" name="xmodelo4" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control"onkeypress="return soloLetras(event)" id="xserie4" name="xserie4" onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control" onkeypress="return soloLetras(event)" id="xrazon4" name="xrazon4" maxlength="60"></textarea>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xrmap4" name="xrmap4" maxlength="15" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateig4" name="xdateig4" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateen4" name="xdateen4" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdatere4" name="xdatere4" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateis4" name="xdateis4" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <select name="xec4" id="xec4" class="form-control">
                                <option value="0">SELECCIONE</option>
                                <option value="1">Reparado</option>
                                <option value="2">Nuevo</option>
                                <option value="3">Pendiente</option>
                            </select>
                        </div>
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col5" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>5</span>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xproducto5" name="xproducto5"  maxlength="30" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xmodelo5" name="xmodelo5"  maxlength="15"  onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xserie5" name="xserie5"  maxlength="15"  onkeyup="mayus(this);"/>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control" onkeypress="return soloLetras(event)" id="xrazon5" name="xrazon5" maxlength="60"></textarea>
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group">
                            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xrmap5" name="xrmap5" maxlength="15" />
                        </div>
                        </td> 

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateig5" name="xdateig5" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateen5" name="xdateen5" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdatere5" name="xdatere5" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="date" class="form-control" id="xdateis5" name="xdateis5" />
                        </div>
                        </td>

                        <td class="text-left">
                        <div class="form-group-sm">
                            <select name="xec5" id="xec5" class="form-control">
                                <option value="0">SELECCIONE</option>
                                <option value="1">Reparado</option>
                                <option value="2">Nuevo</option>
                                <option value="3">Pendiente</option>
                            </select>
                        </div>
                        </td>
                    </tr>
                </tbody>

                <tbody id="col6" class="hidden">
                    <tr>
                        <td class="text-left"> 
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xherramienta11" name="xherramienta11" readonly="" placeholder="Tu no deberias ver esto..." />
                        </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <span id="res"></span><br />
        <div id="botonce" class="from-group hidden">
            <input type="button" id="botona" value="Agregar" class="form-control btn-primary"/>
        </div>

        <span id="resc"></span><br />
        <div id="botoncn" class="from-group hidden">
            <input type="button" id="botonacn" value="Agregar con nuevo cliente" class="form-control btn-primary"/>
        </div>
        </form>

    <footer class="panel-footer modal-footer">
        <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
    </footer>
    </div>
</body>
</html>