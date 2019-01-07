<?php
    $norden       = $_POST['norden'];
    $cliente      = $_POST['cliente'];
    $direccion    = $_POST['direccion'];
    $contcliente  = $_POST['contcliente'];
    $telefono     = $_POST['telefono'];
    $producto     = $_POST['producto'];
    $modelo       = $_POST['modelo'];
    $serie        = $_POST['serie'];
    $repfalla     = $_POST['repfalla'];
    $recibido     = $_POST['recibido'];
    $enviado      = $_POST['enviado'];
    $proveedor    = $_POST['proveedor'];
    $rmap         = $_POST['rmap'];
    $md           = $_POST['md'];
	$destino = "resenasef@gmail.com";

	
    
    $contenido = $norden . "\n".$cliente . "\n".$direccion . "\n".$contcliente . "\n".$telefono . "\n".$producto . "\n".$modelo . "\n".$serie . "\n".$repfalla . "\n".$recibido . "\n".$enviado . "\n".$proveedor . "\n".$rmap . "\n".$md . "\n";
    if(mail($destino, "Contacto", $contenido))
    {
        echo '3';
    }
    else
    {
        echo "1";
    }
?>