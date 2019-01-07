<?php
    session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }

    require_once('php/conexion.php');
    $shsql ="SELECT id, cliente FROM `clientes` where estatus = 1  order by cliente";
    $rec1= mysqli_query($con,$shsql);

    $shsq2 ="SELECT Id, Nombre, Apellido, Usuario FROM `Usuarios` where Privilegio = 1 or Privilegio = 2 order by Nombre";
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
    <script src="js/toolbackvbc.js"></script>
    
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

        function mayus(e) {
            e.value = e.value.toUpperCase();;

        }
    </script>

	<title>Panel principal de administración de regreso de herramienta</title>
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
        <input type="hidden" value="<?php echo $_SESSION['identificador']; ?>" id="iduser" name="iduser" />
        <br />
        <br />
    <div class="table-responsive">
    
      <table id="prestamosvbc" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th data-column-id="id" data-type="numeric">ID</th>
                    <th data-column-id="estatu">Estatus</th>
                    <th data-column-id="fechab">Fecha</th>
                    <th data-column-id="herramienta">Herramienta</th>
                    <th data-column-id="cliente">Cliente</th>
                    <th data-column-id="nombre">Administrador</th>
                    <th data-column-id="name">Usuario</th>
                    <th data-column-id="nota">Nota</th>
                    <th data-column-id="cantdev">Cantidad devuelta</th>
                    <th data-column-id="idloan">ID prestamo</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Modificar y eliminar</th>
                </tr>
            </thead>
       </table>
       
       <span id="resdlt"></span>
       </div>
       <br />
             
    <!--<div class="col-md-12">
 	      <button type="button" style="margin-left: 10px;" class="btn  pull-right clearfix btn-success" onclick="ExportToExcel('herramienta', 'W3C Example Table')" value="Exportar a Excel"><span class="fa fa-file-excel-o" style="margin-left: 10px;"></span> Exportar a Excel</button>

          <button type="button" style="margin-left: 10px;" class="btn  btn-danger pull-right clearfix" onclick ="Redireccionar()"><span class="fa fa-file-pdf-o"></span> Exportar a PDF</button>         
        </div>-->
        
        <br />
        <br />
        <br />
            <div class="from-group">
                <input type="button" id="botoncan" value="Cancelar bajas" class="btn  pull-left clearfix btn-danger"/>
            </div>
        <br />
        <br />
        <br />
        <fieldset>
            <legend>Modificar</legend>
        </fieldset>
        <form id="formal">

        <div class="form-group">
        <label for="Marca">Cliente:</label>
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

        <div class="form-group">
        <label for="iduser">Material otorgado para:</label>
        <select name="xuser" id="xuser" class="form-control">
            <option value="0">SELECCIONE</option>
            <?php
                while($row1 = mysqli_fetch_array($rec2))
                {
                    echo "<option value='".$row1['0']."'>";
                    echo $row1['1'].' '.$row1['2'];
                    echo "</option> 
            ";
                }
            ?>
        </select>
        </div>
        <div class="table-responsive">
            <table class="table table-condensed table-hover table-striped" width="100%" cellspacing="2">
                <thead>
                    <tr>
                        <th class="text-left">Numero de prestamo</th>
                        <th class="text-left">ID de devolución</th>
                        <th class="text-left">ID prestamo</th>
                        <th class="text-left">Herramienta</th>
                        <th class="text-left">Cantidad devuelta</th>
                        <th class="text-left">Nota</th>
                    </tr>
                </thead>
                <tbody id="col1" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>1</span> 
                        </td>

                        <td class="text-left">
                            <div class="form-group">
                                <input type="numeric" class="form-control" id="xidback1" name="xidback1" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group">
                                <input type="numeric" class="form-control" id="xidloan1" name="xidloan1" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="text" class="form-control-feedback" id="xtool1" name="xtool1" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcback1" name="xcback1" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <textarea class="form-control-feedback" id="xcoment1" onkeypress="return soloLetras(event)" name="xcoment1"></textarea>
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
                                <input type="numeric" class="form-control" id="xidback2" name="xidback2" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group">
                                <input type="numeric" class="form-control" id="xidloan2" name="xidloan2" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="text" class="form-control-feedback" id="xtool2" name="xtool2" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcback2" name="xcback2" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <textarea class="form-control-feedback" id="xcoment2" onkeypress="return soloLetras(event)" name="xcoment2"></textarea>
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
                                <input type="numeric" class="form-control" id="xidback3" name="xidback3" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group">
                                <input type="numeric" class="form-control" id="xidloan3" name="xidloan3" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="text" class="form-control-feedback" id="xtool3" name="xtool3" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcback3" name="xcback3" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <textarea class="form-control-feedback" id="xcoment3" onkeypress="return soloLetras(event)" name="xcoment3"></textarea>
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
                                <input type="numeric" class="form-control" id="xidback4" name="xidback4" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group">
                                <input type="numeric" class="form-control" id="xidloan4" name="xidloan4" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="text" class="form-control-feedback" id="xtool4" name="xtool4" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcback4" name="xcback4" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <textarea class="form-control-feedback" id="xcoment4" onkeypress="return soloLetras(event)" name="xcoment4"></textarea>
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
                                <input type="numeric" class="form-control" id="xidback5" name="xidback5" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group">
                                <input type="numeric" class="form-control" id="xidloan5" name="xidloan5" readonly="readonly"/>
                            </div>
                        </td> 

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="text" class="form-control-feedback" id="xtool5" name="xtool5" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <input type="number" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcback5" name="xcback5" readonly="" />
                            </div>
                        </td>

                        <td class="text-left">
                            <div class="form-group-sm">
                                <textarea class="form-control-feedback" id="xcoment5" onkeypress="return soloLetras(event)" name="xcoment5"></textarea>
                            </div>
                        </td>
                    </tr>
                </tbody>       

                <tbody id="col11" class="hidden">
                    <tr>
                        <td class="text-left"> 
                            <div class="form-group-sm">
                                <input type="text" class="form-control-feedback" id="xherramienta6" name="xherramienta6" readonly="" placeholder="Tú no deberias ver esto..." />
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="from-group">
            <span id="resu"></span><br />
            <input type="button" id="botonc" value="Modificar" class="form-control btn-success"/>
        </div>
        </form>

    <footer class="panel-footer modal-footer">
        <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
    </footer>
    </div>


    
</body>
</html>