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
    
    <script type="text/javascript">
    "use strict";jQuery.base64=(function($){var _PADCHAR="=",_ALPHA="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",_VERSION="1.0";function _getbyte64(s,i){var idx=_ALPHA.indexOf(s.charAt(i));if(idx===-1){throw"Cannot decode base64"}return idx}function _decode(s){var pads=0,i,b10,imax=s.length,x=[];s=String(s);if(imax===0){return s}if(imax%4!==0){throw"Cannot decode base64"}if(s.charAt(imax-1)===_PADCHAR){pads=1;if(s.charAt(imax-2)===_PADCHAR){pads=2}imax-=4}for(i=0;i<imax;i+=4){b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6)|_getbyte64(s,i+3);x.push(String.fromCharCode(b10>>16,(b10>>8)&255,b10&255))}switch(pads){case 1:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12)|(_getbyte64(s,i+2)<<6);x.push(String.fromCharCode(b10>>16,(b10>>8)&255));break;case 2:b10=(_getbyte64(s,i)<<18)|(_getbyte64(s,i+1)<<12);x.push(String.fromCharCode(b10>>16));break}return x.join("")}function _getbyte(s,i){var x=s.charCodeAt(i);if(x>255){throw"INVALID_CHARACTER_ERR: DOM Exception 5"}return x}function _encode(s){if(arguments.length!==1){throw"SyntaxError: exactly one argument required"}s=String(s);var i,b10,x=[],imax=s.length-s.length%3;if(s.length===0){return s}for(i=0;i<imax;i+=3){b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8)|_getbyte(s,i+2);x.push(_ALPHA.charAt(b10>>18));x.push(_ALPHA.charAt((b10>>12)&63));x.push(_ALPHA.charAt((b10>>6)&63));x.push(_ALPHA.charAt(b10&63))}switch(s.length-imax){case 1:b10=_getbyte(s,i)<<16;x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_PADCHAR+_PADCHAR);break;case 2:b10=(_getbyte(s,i)<<16)|(_getbyte(s,i+1)<<8);x.push(_ALPHA.charAt(b10>>18)+_ALPHA.charAt((b10>>12)&63)+_ALPHA.charAt((b10>>6)&63)+_PADCHAR);break}return x.join("")}return{decode:_decode,encode:_encode,VERSION:_VERSION}}(jQuery));
    function ExportToExcel(altas){
           var htmltable= document.getElementById('altas');
           var html = htmltable.outerHTML;
           window.open('data:application/vnd.ms-excel;base64,' +  $.base64.encode(html));
        }
    </script>

    <script type="text/javascript">
        
        function Redireccionar(){ 
            var con = $('#consulta').val();
            location.href ="php/pdf/genPDFAlts.php?q="+con;
        };
    </script>
    

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
            
            
            
            $buscarpor  = $_POST['xbusqueda'];
            $buscar     = $_POST['ybusqueda'];
            $buscarpo   = $_POST['xbusqued'];
            $busca      = $_POST['ybusqued'];
            $orden      = $_POST['xorden']; 
            $limit      = $_POST['xlimit']; 
            $ad         = $_POST['xad'];
            $re         =  "";
            
            
            if($buscarpor == 0 and $orden == 0)
            {
                $re="select * from `viewaltas`; ";
                $buscar = 0;
                $busca = 't';
            }
            if($buscarpor == 0)
            {
                $re="select * from `viewaltas` ";
                $buscar = 0;
                $busca = 't';
            }
            else
            {
                if($buscarpor == 1)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where id between '$buscar' and '$busca' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where id LIKE '%$buscar%' ";   
                    }    
                }
                if($buscarpor == 2)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where accione LIKE '%$buscar%' ";    
                    } 
                }
                
                if($buscarpor == 3)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where fecha between '$buscar' and '$busca' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where fecha LIKE '%$buscar%' ";    
                    }     
                }
                
                if($buscarpor == 4)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where cantidad between '$buscar' and '$busca' ";    
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where cantidad LIKE '%$buscar%' ";    
                    } 
                }
                
                if($buscarpor == 5)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";   
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where tipomercancia LIKE '%$buscar%' ";   
                    }     
                }
                
                if($buscarpor == 6)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    { 
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";   
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where marcas LIKE '%$buscar%' ";  
                    }    
                }
                
                if($buscarpor == 7)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";   
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where model LIKE '%$buscar%' ";  
                    }       
                }
                
                if($buscarpor == 8)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";   
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where nota LIKE '%$buscar%' ";     
                    }
                    
                    
                }
                
                if($buscarpor == 9)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";   
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' and estado LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where proveedores LIKE '%$buscar%' ";      
                    }
                }
                
                if($buscarpor == 10)
                {
                    if($buscarpo == 1)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and id LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 2)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and accione LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 3)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and fecha LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 4)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and cantidad LIKE '%$busca%' ";   
                    }
                    
                    if($buscarpo == 5)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and tipomercancia LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 6)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and marcas LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 7)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and model LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 8)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and nota LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 9)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' and proveedores LIKE '%$busca%' ";    
                    }
                    
                    if($buscarpo == 10)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' ";    
                    }
                    
                    if($buscarpo ==  0)
                    {
                        $re="select * from `viewaltas` where estado LIKE '%$buscar%' ";      
                    }    
                }
            }
            
            if($orden == 0)
            {
                $re .= " ORDER BY id  ";
            }
            
            if($orden == 1)
            {
                $re .= " ORDER BY id ";
            }
            
            if($orden == 2)
            {
                $re .= " ORDER BY accione ";
            }
            
            if($orden == 3)
            {
                $re .= " ORDER BY fecha "; 
            }
            
            if($orden == 4)
            {
                $re .= " ORDER BY cantidad "; 
            }
            
            if($orden == 5)
            {
                $re .= "ORDER BY tipomercancia ";
            }
            
            if($orden == 6)
            {
                $re .= " ORDER BY marcas ";
            }
            
            if($orden == 7)
            {
                $re .= " ORDER BY model ";
            }
            
            if($orden == 8)
            {
                $re .= " ORDER BY nota "; 
            }
            
            if($orden == 9)
            {
                $re .= " ORDER BY proveedores "; 
            }
            
            if($orden == 10)
            {
                $re .= " ORDER BY proveedores "; 
            }
            
            if($ad == 1)
            {
                $re .= "  ";
            }
            
            if($ad == 2)
            {
                $re .= " desc ";
            }
            
            if($limit == 0)
            {
                $re .= " ";
            }
            
            if($limit == 1)
            {
                $re .= " limit 5 ";
            }
            
            if($limit == 2)
            {
                $re .= " limit 10 ";
            }
            
            if($limit == 3)
            {
                $re .= " limit 15 "; 
            }
            
            if($limit == 4)
            {
                $re .= " limit 20 "; 
            }
            
            if($limit == 5)
            {
                $re .= " limit 25 ";
            }
            
            if($limit == 6)
            {
                $re .= " limit 50 ";
            }
            
            if($limit == 7)
            {
                $re .= " limit 75 ";
            }
            
            if($limit == 8)
            {
                $re .= " limit 100 "; 
            }
            
            if($limit == 9)
            {
                $re .= " limit 150 "; 
            }
            
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
       <input type="hidden" id="consulta"  value="<?php echo $re; ?>"/>
       
       <br />
       <div class="col-md-12">
            <button type="button" style="margin-left: 10px;" class="btn  pull-right clearfix btn-success" onclick="ExportToExcel('altas', 'W3C Example Table')" value="Export to Excel"><span class="fa fa-file-excel-o" style="margin-left: 10px;"></span> Exportar a Excel</button>
    
            <button type="button" style="margin-left: 10px;" class="btn  btn-danger pull-right clearfix" onclick ="Redireccionar()"><span class="fa fa-file-pdf-o"></span> Exportar a PDF</button>
       </div>
       <br />
       <br />
       <br />
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