<?php
session_start();
    if(isset($_SESSION['identificador'])){
    }else
    {
        header("Location: index.php");
    }
    
    $iden=$_SESSION['identificador'];
    require_once('php/conexion.php');


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
    <script src="js/combos.js"></script>
    <script src="js/mercancia.js"></script>
    

	<title>Panel principal de administración de mercancia.</title>
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
        <table id="altas" class="table table-condensed table-hover table-striped" width="100%" cellspacing="0" >
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Accion</th>
                    <th>Fecha</th>
                    <th>Cantidad</th>
                    <th>Categoria</th>
                    <th>Marca</th>
                    <th>Modelo</th>
                    <th>Nota</th>
                    <th>Proveedor</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <?php
                $re="select * from `viewaltas` order by id limit 10;";
                $rec1= mysqli_query($con,$re)or die(mysql_error());
                while($f = mysqli_fetch_array($rec1)) 
                {
            ?>
            <tbody>
                <tr>
                    <td><?php echo $f['0']; ?></td>
                    <td><?php echo $f['2']; ?></td>
                    <td><?php echo $f['3']; ?></td>
                    <td><?php echo $f['4']; ?></td>
                    <td><?php echo $f['6']; ?></td>
                    <td><?php echo $f['8']; ?></td>
                    <td><?php echo $f['10']; ?></td>
                    <td><?php echo $f['11']; ?></td>
                    <td><?php echo $f['13']; ?></td>
                    <td><?php echo $f['15']; ?></td>
                </tr>
            </tbody>
            <?php
                }
            ?>
       </table>
       </div>
       <fieldset>
            <legend>Hacer busqueda:</legend>
       </fieldset>
       
       <form action="resultados.php" method="post">
            <div class="form-group">
        <label for="brow">Busqueda por:</label>
        <select id="xbusqueda" name="xbusqueda" class="form-control">
            <option value="0">SELECCIONE</option>
            <option value="1">Id</option>
            <option value="2">Accion</option>
            <option value="3">Fecha</option>
            <option value="4">Cantidad</option>
            <option value="5">Categoria</option>
            <option value="6">Marcas</option>
            <option value="7">Modelo</option>
            <option value="8">Nota</option> 
            <option value="9">Proveerodor</option>
            <option value="10">Estado</option> 
        </select>
        </div>
        
        <div class="form-group">
            <label for="bus">Buscar:</label><br />
			<input type="text" class="form-control" id="ybusqueda" name="ybusqueda" placeholder="Buscar"/>
		</div>
        
        <div class="form-group">
        <label for="brow">Busqueda por (2):</label>
        <select id="xbusqued" name="xbusqued" class="form-control">
            <option value="0">SELECCIONE</option>
            <option value="1">Id</option>
            <option value="2">Accion</option>
            <option value="3">Fecha</option>
            <option value="4">Cantidad</option>
            <option value="5">Categoria</option>
            <option value="6">Marcas</option>
            <option value="7">Modelo</option>
            <option value="8">Nota</option> 
            <option value="9">Proveerodor</option>
            <option value="10">Estado</option> 
        </select>
        </div>
        
        <div class="form-group">
            <label for="bus">Buscar:</label><br />
			<input type="text" class="form-control" id="ybusqued" name="ybusqued" placeholder="Buscar"/>
		</div>
        
        <div class="form-group">
        <label for="brow">Ordenar por:</label>
        <select id="xorden" name="xorden" class="form-control">
            <option value="0">SELECCIONE</option>
            <option value="1">Id</option>
            <option value="2">Accion</option>
            <option value="3">Fecha</option>
            <option value="4">Cantidad</option>
            <option value="5">Categoria</option>
            <option value="6">Marcas</option>
            <option value="7">Modelo</option>
            <option value="8">Nota</option> 
            <option value="9">Proveerodor</option>
            <option value="10">Estado</option> 
        </select>
        </div>
        
        <div class="form-group">
        <label for="brow">Ordenar en:</label><br />
        <input type="radio" checked="" id="xad" name="xad" value="1" />Ascendente<br />
        <input type="radio" id="xad" name="xad" value="2" />Descendente
        </div>
        
        
        <div class="form-group">
        <label for="brow">Cantidad de campos a mostrar:</label>
        <select id="xlimit" name="xlimit" class="form-control">
            <option value="0">SELECCIONE</option>
            <option value="1">5</option>
            <option value="2">10</option>
            <option value="3">15</option>
            <option value="4">20</option>
            <option value="5">25</option>
            <option value="6">50</option>
            <option value="7">75</option>
            <option value="8">100</option>
            <option value="9">150</option> 
        </select>
        </div>
        
        <button class="form-control btn-primary">Buscar</button>
       </form>
       
       <br />
    </div>
</body>
</html>