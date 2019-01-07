<?php
    session_start();
    if(isset($_SESSION['identificador']) || isset($_SESSION['hora'])){
    }else
    {
        header("Location: index.php");
    }
    
    $iden=$_SESSION['identificador'];
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
    
    

	<title>Bienvenido.</title>
</head>

<body>
    <div class="container">
    <header class="page-header dropdown-header modal-header" >
        <img src="img/logo-circle.png"  height="40%" class="img-circle img-responsive" />
        <?php
            require_once "php/conexion.php";                
            $re="select * from `viewuser` where id=".$_SESSION['identificador'];
            $rec1= mysqli_query($con,$re)or die(mysql_error());
            while($f = mysqli_fetch_array($rec1)) 
            {
        ?>
        <?php
                echo "<h2>Bienvenido a: " .$f['Nombre']. " al panel de administración del almacen de Secom.</h2>";
                echo "<h3>Fecha de ingreso: " .$_SESSION['hora']."<h3/>";   
            }
        ?>
        
    </header>
    <div class="container">
    
     <?php
      include_once('nav.php');
      echo $nav; 
     ?>
        
        
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <footer class="panel-footer modal-footer">
        <center> <h6 class="h6">Pagina creada por: Edgar Felipe - Team Scarlet</h6> </center>
    </footer>
    </div>

</body>
</html>