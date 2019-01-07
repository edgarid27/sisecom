<?php
    session_start();
    if(isset($_SESSION['identificador']) || isset($_SESSION['hora'])){
    }else
    {
        header("Location: index.php");
    }
    
    require_once('php/conexion.php');
    
    $shsql ="SELECT Id, Nombre, Apellido, Usuario FROM `Usuarios` where Privilegio = 1 order by Nombre";
    $rec1= mysqli_query($con,$shsql);
    
    $shsq2 ="SELECT Id, Nombre, Apellido, Usuario FROM `Usuarios` where Privilegio = 1 or Privilegio < 3 order by Nombre";
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
    <script src="js/mercanciaalter.js"></script>
    
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


	<title>Panel principal de administración de bajas.</title>
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
                    <th data-column-id="marcas">Marcas</th>
                    <th data-column-id="descripciones">Cetegoria</th>
                    <th data-column-id="coment">Descripcion</th>
                    <th data-column-id="modelo">Modelo</th>
                    <th data-column-id="cantidad">Cantidad</th>
                    <th data-column-id="commands" data-formatter="commands" data-sortable="false">Mandar alta.</th>
                </tr>
            </thead>
       </table>
    </div>
    <span id="resdlt"></span><br />
    <div class="from-group">
        <input type="button" id="botoncan" value="Cancelar bajas" class="btn  pull-left clearfix btn-danger"/>
    </div>
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

        <div class="form-group">
            <label for="cant">Cliente (si este no existe):</label><br />
            <input type="text" class="form-control" onkeypress="return soloLetras(event)" id="xclient" name="xclient" placeholder="Cliente (si este no existe)" />
        </div>
        
        <div class="table-responsive">
            <table class="table table-condensed table-hover table-striped" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th class="text-left">Mercancia numero</th>
                        <th class="text-left">Mercancia</th>
                        <th class="text-left">Cantidad actual del producto</th>
                        <th class="text-left">Cantidad</th>
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
                            <input type="text" class="form-control-feedback" id="xcanta1" onkeypress="return soloNumeros(event)" name="xcanta1"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment1" name="xcoment1"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta2" name="xcanta2"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment2" name="xcoment2"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta3" name="xcanta3"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment3" name="xcoment3"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta4" name="xcanta4"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment4" name="xcoment4"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta5" name="xcanta5"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment5" name="xcoment5"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta6" name="xcanta6"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment6" name="xcoment6"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta7" name="xcanta7"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment7" name="xcoment7"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta8" name="xcanta8"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment8" name="xcoment8"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta9" name="xcanta9"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment9" name="xcoment9"></textarea>
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
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta10" name="xcanta10"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment10" name="xcoment10"></textarea>
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
                            <span>11</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc11" name="xmerc11" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant11" name="xcant11" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta11" name="xcanta11"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment11" name="xcoment11"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc11" name="xvalmerc11"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col12" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>12</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc12" name="xmerc12" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant12" name="xcant12" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta12" name="xcanta12"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment12" name="xcoment12"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc12" name="xvalmerc12"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col13" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>13</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc13" name="xmerc13" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant13" name="xcant13" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta13" name="xcanta13"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment13" name="xcoment13"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc13" name="xvalmerc13"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col14" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>14</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc14" name="xmerc14" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant14" name="xcant14" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta14" name="xcanta14"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment14" name="xcoment14"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc14" name="xvalmerc14"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col15" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>15</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc15" name="xmerc15" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant15" name="xcant15" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta15" name="xcanta15"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment15" name="xcoment15"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc15" name="xvalmerc15"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col16" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>16</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc16" name="xmerc16" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant16" name="xcant16" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta16" name="xcanta16"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment16" name="xcoment16"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc16" name="xvalmerc16"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col17" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>17</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc17" name="xmerc17" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant17" name="xcant17" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta17" name="xcanta17"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment17" name="xcoment17"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc17" name="xvalmerc17"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col18" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>18</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc18" name="xmerc18" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant18" name="xcant18" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta18" name="xcanta18"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment18" name="xcoment18"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc18" name="xvalmerc18"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col19" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>19</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc19" name="xmerc19" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant19" name="xcant19" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta19" name="xcanta19"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment19" name="xcoment19"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc19" name="xvalmerc19"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col20" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>20</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc20" name="xmerc20" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant20" name="xcant20" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta20" name="xcanta20"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment20" name="xcoment20"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc20" name="xvalmerc20"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col21" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>21</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc21" name="xmerc21" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant21" name="xcant21" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta21" name="xcanta21"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment21" name="xcoment21"></textarea>
                        </div>
                        </td >
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc21" name="xvalmerc21"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col22" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>22</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc22" name="xmerc22" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant22" name="xcant22" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta22" name="xcanta22"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment22" name="xcoment22"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc22" name="xvalmerc22"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col23" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>23</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc23" name="xmerc23" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant23" name="xcant23" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta23" name="xcanta23"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment23" name="xcoment23"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc23" name="xvalmerc23"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col24" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>24</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc24" name="xmerc24" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant24" name="xcant24" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta24" name="xcanta24"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback"onkeypress="return soloLetras(event)" maxlength="150" id="xcoment24" name="xcoment24"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc24" name="xvalmerc24"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col25" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>25</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc25" name="xmerc25" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant25" name="xcant25" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta25" name="xcanta25"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment25" name="xcoment25"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc25" name="xvalmerc25"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col26" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>26</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc26" name="xmerc26" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant26" name="xcant26" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta26" name="xcanta26"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment26" name="xcoment26"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc26" name="xvalmerc26"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col27" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>27</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc27" name="xmerc27" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant27" name="xcant27" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta27" name="xcanta27"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment27" name="xcoment27"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc27" name="xvalmerc27"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col28" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>28</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc28" name="xmerc28" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant28" name="xcant28" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta28" name="xcanta28"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment28" name="xcoment28"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc28" name="xvalmerc28"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col29" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>29</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc29" name="xmerc29" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant29" name="xcant29" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta29" name="xcanta29"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment29" name="xcoment29"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc29" name="xvalmerc29"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col30" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>30</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc30" name="xmerc30" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant30" name="xcant30" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta30" name="xcanta30"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment30" name="xcoment30"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc30" name="xvalmerc30"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col31" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>31</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc31" name="xmerc31" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant31" name="xcant31" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta31" name="xcanta31"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment31" name="xcoment31"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc31" name="xvalmerc31"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col32" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>32</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc32" name="xmerc32" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant32" name="xcant32" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback"onkeypress="return soloNumeros(event)" id="xcanta32" name="xcanta32"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment32" name="xcoment32"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc32" name="xvalmerc32"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col33" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>33</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc33" name="xmerc33" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant33" name="xcant33" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta33" name="xcanta33"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment33" name="xcoment33"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc33" name="xvalmerc33"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col34" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>34</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc34" name="xmerc34" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant34" name="xcant34" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta34" name="xcanta34"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment34" name="xcoment34"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc34" name="xvalmerc34"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col35" class="hidden">
                    <tr>
                        <td class="text-left">
                            <span>35</span>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc35" name="xmerc35" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xcant35" name="xcant35" readonly="" />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" onkeypress="return soloNumeros(event)" id="xcanta35" name="xcanta35"  />
                        </div>
                        </td>
                        <td class="text-left">
                        <div class="form-group-sm">
                            <textarea class="form-control-feedback" onkeypress="return soloLetras(event)" maxlength="150" id="xcoment35" name="xcoment35"></textarea>
                        </div>
                        </td>
                        <td class="text-left">
                            <input type="hidden" class="form-control" id="xvalmerc35" name="xvalmerc35"  />
                        </td>
                    </tr>
                </tbody>
                
                <tbody id="col36" class="hidden">
                    <tr>
                        <td class="text-left"> 
                        <div class="form-group-sm">
                            <input type="text" class="form-control-feedback" id="xmerc36" name="xmerc35" readonly="" />
                        </div>
                        </td>
                    </tr>
                </tbody>
                
            </table>
        </div>
        
        <div class="from-group">
            <span id="res"></span><br />
		  <input type="button" id="botona" value="Agregar" class="form-control btn-primary"/>
        </div>

        <div class="from-group">
            <span id="res"></span><br />
          <input type="button" id="botonac" value="Agregar + cliente" class="form-control btn-success"/>
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