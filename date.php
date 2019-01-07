<?php
    session_start();
    if(isset($_SESSION['identificador']))
    {
        header("Location: inicio.php");
    }
    else
    {
        if(isset($_SESSION['useringresa']))
        {
            header("Location: view/inicio.php");
        }
        else
        {
            
        }
    }

?>
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
	    <script>
		    setTimeout("sayonara()",120000);
		    function sayonara()
		    {
		        hoy=new Date();
		        hora=hoy.getHours();
		        minutos=hoy.getMinutes();
		        segundos=hoy.getSeconds();
		        if(hora == 13 || hora == 14 || hora == 15 || hora == 16){
		            location.href ="index.php";
		            }
		        setTimeout("sayonara()",120000);
		    }
		    </script>

<?php
	$fecha = date("Y-m-d");
	$mod_date = strtotime($fecha."- 7 days");
	$dtarreglo = date("Y-m-d",$mod_date);

	require_once('php/conexion.php');
    $shsq1 ="SELECT * FROM `viewrma` where aviso = 0  order by id limit 1;";
    $rec1= mysqli_query($con,$shsq1);
    
    while($row1 = mysqli_fetch_array($rec1))
    {
		if(($row1['13']) >= $dtarreglo)
		{
			echo "El evento aun no pasa ".$row1[13].'<br />';
		}
		else
		{
			$dateday = date("j", strtotime($row1['12']));
			$dateDay = date("l", strtotime($row1['12']));
			$datemounth = date("F", strtotime($row1['12']));
			$dateyear = date("Y", strtotime($row1['12']));

			$dias_ES = array("Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo");
			$dias_EN = array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday");
			$dayName = str_replace($dias_EN, $dias_ES, $dateDay);
			$meses_ES = array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");
			$meses_EN = array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
			$mounthName = str_replace($meses_EN, $meses_ES, $datemounth);
			

			$fechadia = date("j", strtotime($row1['13']));
			$fechaDia = date("l", strtotime($row1['13']));
			$fechames = date("F", strtotime($row1['13']));
			$fechaaño = date("Y", strtotime($row1['13']));

			$diaNombre= str_replace($dias_EN, $dias_ES, $fechaDia);
			$mesNombre= str_replace($meses_EN, $meses_ES, $fechames);
			
			$rmap=$row1['20'];
			if($rmap=='')
			{
				$rmap="n/a";
			}
			else
			{
			}
			$datoid=$row1['0'];
			$msg1= 'El numero de orden: '.$row1['1'];
			$msg2= 'Del cliente: '.$row1['3'];
			$msg3= 'De la direccion: '.$row1['4'];
			$msg4= 'Contacto del cliente: '.$row1['5'];
			$msg5= 'Numero de telefono(s): '.$row1['6'].' - '.$row1['7'];
			$msg6= 'El producto enviado a RMA es el: '.$row1['8'];
			$msg7= 'Modelo: '.$row1['9'];
			$msg8= 'Serie: '.$row1['10'];
			$msg9= 'Con la falla reportada de: '.$row1['11'];
			$msg10= 'Recibido el : '.'Dia '.$dayName.' '.$dateday.' de '.$mounthName.' del '.$dateyear;
			$msg11= 'Enviado para su reparacion el: '.'Dia '.$diaNombre.' '.$fechadia.' de '.$mesNombre.' del '.$fechaaño;
			$msg12= 'Enviado al proveedor: '.$row1['17'];
			$msg13= 'RMA de proveedor: '.$rmap;
			$msg14= 'Mas detalles en 192.168.1.250:8080/almacen/rmabcv.php, buscar el RMA con el ID: '.$row1['0'];
			?>
			
			<script>
				function comprobar()
				{
					$.ajax
					({
					type: "POST",
					url: "http://www.secom.tv/home/admin/mailrma.php",
					data: { norden: "<?php echo $msg1; ?>", cliente: "<?php echo $msg2; ?>", direccion: "<?php echo $msg3; ?>", contcliente: "<?php echo $msg4; ?>", telefono: "<?php echo $msg5; ?>", producto: "<?php echo $msg6; ?>", modelo: "<?php echo $msg7; ?>", serie: "<?php echo $msg8; ?>", repfalla: "<?php echo $msg9; ?>", recibido: "<?php echo $msg10; ?>", enviado: "<?php echo $msg11; ?>", proveedor: "<?php echo $msg12; ?>", rmap: "<?php echo $msg13; ?>", md: "<?php echo $msg14; ?>"}
					}).done(function( msg ) {
					});	
				}
			</script>
			</head>	
			<?php
			$sql = "CALL `almacen`.`YANOEMAIL`('$datoid', 1);";   
            //Tring to insert the value to db
            if(mysqli_query($con,$sql))
            {
            }
            else
            {
            }
		}
    }
    mysqli_close($con);
     
?>

<body onload="comprobar()">
	<div class="container">
		    <header class="page-header dropdown-header modal-header" >
		        <img src="img/logo-circle.png"  height="40%" class="img-circle img-responsive" />
		        <h2>Panel de administracion de almacen</h2>
		    </header>
		    <br />
		        <fieldset>
		            <legend>Login.</legend>
		        </fieldset>
		        
		        <form id="foormal" method="POST" action="./login/verificar.php">
				
		        <div class="form-group">
				  <label for="usuario">Usuario:</label><br/>
				  <input type="text" id="usuario" name="Usuario" placeholder="Usuario" class="form-control"/><br/>
		        </div>
		        
		        <div class="form-group">
				  <label for="password">Contraseña:</label><br/>
				  <input type="password" id="password" name="Password" placeholder="Contraseña" class="form-control"/><br/>
		        </div>
		        
		        <div class="form-group">
				  <input type="submit" name="aceptar" value="Ingresar" class="form-control btn btn-success pull-right"/>
		        </div>
		        
		        <?php 
				if(isset($_GET['error'])){
					echo '<center style="font-weight: bold; font-family: arial; color:red; font-size: 22px;">Datos No Validos</center>';
				}
				?>
		        <?php 
				if(isset($_GET['errorf'])){
					echo '<center style="font-weight: bold; font-family: arial; color:red; font-size: 22px;">Falta algun dato</center>';
				}
				?>
			</form>
		    <br />
		    <br />
		    <br />
		    <footer class="panel-footer modal-footer">
		        <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
		    </footer>
		    </div>
</body>