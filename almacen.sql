-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-12-2018 a las 11:27:28
-- Versión del servidor: 10.1.21-MariaDB
-- Versión de PHP: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `almacen`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BUDBAJAS` (`ident` INT, `cantid` INT, `mc` INT, `accion` INT)  BEGIN

declare ea int;
declare re int;

if(accion = 1)
then
	set ea = (select cantidad from `mercancia` where id = mc);
	set re = ea + cantid;

	UPDATE `almacen`.`mercancia`
	SET
	`cantidad` = re
	WHERE `id` = mc;

	UPDATE `almacen`.`bajas`
	SET
	`estatus` = 2
	WHERE `id` = ident;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ejemplo` (`x` INT, `en` VARCHAR(10))  BEGIN

declare nex int;
if(x = 1)
then

set nex = (select id from `almacen`.`clientes` where `cliente` = en);
select nex;

end if; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EUDRMA` (`x` INT, `accion` INT)  BEGIN

if(accion = 1)
then 
	UPDATE `almacen`.`rma` SET `estatus` = 2 WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EUDTOOLBACK` (`x` INT, `accion` INT)  BEGIN

declare var1 int;
declare var2 int;
declare var3 int;
declare var4 int;
declare var5 int;

if(accion = 1)
then 
	set var1 = (select cantdev from toolback where id = x);
	set var2 = (select idloan from toolback where id = x);
	set var3 = (select herramientaback from toolback where id = x);

	set var4 = (select existencia  from herramienta where id = var3);

	set var5 = (var4 - var1);

	if(var5 >= 0)
	then
		UPDATE `almacen`.`toolback` SET `estatus` = 2 WHERE `id` = x;

		UPDATE `almacen`.`tooloan` SET `estatus` = 1 WHERE `id` = var2;
		
		UPDATE `almacen`.`herramienta` SET `existencia` = var5 WHERE `id` = var3;

	end if;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDALMACEN` (`x` INT, `almacen` VARCHAR(45), `accion` INT)  BEGIN

if(accion = 1)
then 
INSERT INTO `almacen`.`almacen`
(`almacen`,`estatus`)
VALUES
(almacen,1);

end if;

if(accion = 2)
then
UPDATE `almacen`.`almacen`
SET
`almacen` = almacen
WHERE `id` = x;
end if;

if(accion = 3)
then
UPDATE `almacen`.`almacen`
SET
`estatus` = 2
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDALTAS` (`a` INT, `x` INT, `acci` INT, `cantidadext` INT, `cantidadq` INT, `mercancias` INT, `marca` INT, `modelo` INT, `nota` VARCHAR(300), `proveedor` INT, `estade` INT, `estatus` INT, `usuario` INT, `accion` INT)  BEGIN

declare total int;
declare cantr int;
declare cants int;

declare var1 int;
declare var2 int;
declare var3 int;
declare var4 int; 

if (accion = 1)
then 
INSERT INTO `almacen`.`altas`
	(`accion`,`fecha`,`cantidad`,`mercancias`,`marca`,`modelo`,`nota`,`proveedor`,
	 `estade`,`estatus`,`usuario`,`cantrest`)
VALUES
	(acci,sysdate(),cantidadq,mercancias,marca,modelo,nota,proveedor,estade,estatus,usuario,modelo);

set total = cantidadq + cantidadext;

UPDATE `almacen`.`mercancia` 
SET 
    `cantidad` = total
WHERE
    `id` = x;
end if;

if(accion = 2)
then
	set cantr = (select cantidad from `altas` where id = a);
	set cants = (select cantidad from `mercancia` where id = modelo);
	set total = cants - cantr;
	
	if(total >= 0)
	then
		UPDATE `almacen`.`mercancia`
		SET
		`cantidad` = total
		WHERE `id` = modelo;
		
		UPDATE `almacen`.`altas`
		SET
		`estatus` = 2
		WHERE `id` = a;
	end if;
end if;

if(accion = 3)
then
	set var1= (select cantidad from `altas` where id = a);

	if(var1 > cantidadq)
	then 
		set var2 = var1 - cantidadq; 
		set var3 = (select cantidad from `mercancia` where id = x);
		set var4 = var3 - var2;
		
		if(var4 > 0)
		then
			UPDATE `almacen`.`altas`
			SET
			`cantidad` = cantidadq,
			`nota` = nota,
			`proveedor` = proveedor,
			`estade` = estade,
			`cantrest` = x
			WHERE `id` = a;

			UPDATE `almacen`.`mercancia`
			SET
			`cantidad` = var4
			WHERE `id` = x;
		end if; 
	end if;

	if(var1 < cantidadq)
	then
		set var2 = cantidadq - var1;
		set var3 = (select cantidad from `mercancia` where id = x);
		set var4 = var3 + var2;

		if(var4 > 0)
		then 
			UPDATE `almacen`.`altas`
			SET
			`cantidad` = cantidadq,
			`nota` = nota,
			`proveedor` = proveedor,
			`estade` = estade,
			`cantrest` = x
			WHERE `id` = a;

			UPDATE `almacen`.`mercancia`
			SET
			`cantidad` = var4
			WHERE `id` = x;
		end if; 
	end if;

	if(var1 = cantidadq)
	then
		UPDATE `altas`
		SET
		`cantidad` = cantidadq,
		`nota` = nota,
		`proveedor` = proveedor,
		`estade` = estade,
		`cantrest` = x
		WHERE `id` = a;
	end if; 
end if; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDBAJASA` (`x` INT, `accionb` INT, `usuarioa` INT, `usuariob` INT, `cliente` INT, `modeloba` INT, `cantidadba` INT, `comentarioa` VARCHAR(300), `modelobb` INT, `cantidadbb` INT, `comentariob` VARCHAR(300), `modelobc` INT, `cantidadbc` INT, `comentarioc` VARCHAR(300), `modelobd` INT, `cantidadbd` INT, `comentariod` VARCHAR(300), `modelobe` INT, `cantidadbe` INT, `comentarioe` VARCHAR(300), `modelobf` INT, `cantidadbf` INT, `comentariof` VARCHAR(300), `modelobg` INT, `cantidadbg` INT, `comentariog` VARCHAR(300), `modelobh` INT, `cantidadbh` INT, `comentarioh` VARCHAR(300), `modelobi` INT, `cantidadbi` INT, `comentarioi` VARCHAR(300), `modelobj` INT, `cantidadbj` INT, `comentarioj` VARCHAR(300), `sentencia` INT, `en` VARCHAR(50), `accion` INT)  BEGIN

declare resultado1 int;
declare num1 int;

declare resultado2 int;
declare num2 int;

declare resultado3 int;
declare num3 int;

declare resultado4 int;
declare num4 int;

declare resultado5 int;
declare num5 int;

declare resultado6 int;
declare num6 int;

declare resultado7 int;
declare num7 int;

declare resultado8 int;
declare num8 int;

declare resultado9 int;
declare num9 int;

declare resultado10 int;
declare num10 int;

declare nen int;

if(sentencia = 1)
then
	if(accion = 1)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

	end if;


	if(accion = 6)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

	end if;

	if(accion = 7)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;
	end if;

	if(accion = 8)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;
	end if;

	if(accion = 9)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,cliente,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;
	end if;

	if(accion = 10)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,cliente,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;

		set num10 = (select cantidad from mercancia where id = `modelobj`);
		set resultado10 = num10 - cantidadbj;
		if(resultado10 >= 0)
		then
			if(cantidadbj >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobj,cantidadbj,usuarioa,usuariob,cliente,comentarioj,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado10 WHERE `id` = modelobj;
			end if;
		end if;
	end if;
end if;

if(sentencia = 2)
then
	if(accion = 1)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);
		
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

	end if;


	if(accion = 6)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

	end if;

	if(accion = 7)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;
	end if;

	if(accion = 8)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;
	end if;

	if(accion = 9)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,nen,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;
	end if;

	if(accion = 10)
	then
		INSERT INTO `almacen`.`clientes`(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
		VALUES(en,'No se ha establecido...',6,1,'No se ha establecido...','(000) 000 0000','(000) 000 0000');

		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,nen,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;

		set num10 = (select cantidad from mercancia where id = `modelobj`);
		set resultado10 = num10 - cantidadbj;
		if(resultado10 >= 0)
		then
			if(cantidadbj >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobj,cantidadbj,usuarioa,usuariob,nen,comentarioj,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado10 WHERE `id` = modelobj;
			end if;
		end if;
	end if;
end if; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDBAJASB` (`x` INT, `accionb` INT, `usuarioa` INT, `usuariob` INT, `cliente` INT, `modeloba` INT, `cantidadba` INT, `comentarioa` VARCHAR(300), `modelobb` INT, `cantidadbb` INT, `comentariob` VARCHAR(300), `modelobc` INT, `cantidadbc` INT, `comentarioc` VARCHAR(300), `modelobd` INT, `cantidadbd` INT, `comentariod` VARCHAR(300), `modelobe` INT, `cantidadbe` INT, `comentarioe` VARCHAR(300), `modelobf` INT, `cantidadbf` INT, `comentariof` VARCHAR(300), `modelobg` INT, `cantidadbg` INT, `comentariog` VARCHAR(300), `modelobh` INT, `cantidadbh` INT, `comentarioh` VARCHAR(300), `modelobi` INT, `cantidadbi` INT, `comentarioi` VARCHAR(300), `modelobj` INT, `cantidadbj` INT, `comentarioj` VARCHAR(300), `sentencia` INT, `accion` INT)  BEGIN

declare resultado1 int;
declare num1 int;

declare resultado2 int;
declare num2 int;

declare resultado3 int;
declare num3 int;

declare resultado4 int;
declare num4 int;

declare resultado5 int;
declare num5 int;

declare resultado6 int;
declare num6 int;

declare resultado7 int;
declare num7 int;

declare resultado8 int;
declare num8 int;

declare resultado9 int;
declare num9 int;

declare resultado10 int;
declare num10 int;

declare nen int;

if(sentencia = 1)
then
	if(accion = 1)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

	end if;


	if(accion = 6)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

	end if;

	if(accion = 7)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;
	end if;

	if(accion = 8)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;
	end if;

	if(accion = 9)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,cliente,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;
	end if;

	if(accion = 10)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,cliente,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;

		set num10 = (select cantidad from mercancia where id = `modelobj`);
		set resultado10 = num10 - cantidadbj;
		if(resultado10 >= 0)
		then
			if(cantidadbj >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobj,cantidadbj,usuarioa,usuariob,cliente,comentarioj,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado10 WHERE `id` = modelobj;
			end if;
		end if;
	end if;
end if;

if(sentencia = 2)
then 
	if(accion = 1)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

	end if;


	if(accion = 6)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

	end if;

	if(accion = 7)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;
	end if;

	if(accion = 8)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;
	end if;

	if(accion = 9)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,nen,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;
	end if;

	if(accion = 10)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,nen,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;

		set num10 = (select cantidad from mercancia where id = `modelobj`);
		set resultado10 = num10 - cantidadbj;
		if(resultado10 >= 0)
		then
			if(cantidadbj >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobj,cantidadbj,usuarioa,usuariob,nen,comentarioj,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado10 WHERE `id` = modelobj;
			end if;
		end if;
	end if;
end if;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDBAJASC` (`x` INT, `accionb` INT, `usuarioa` INT, `usuariob` INT, `cliente` INT, `modeloba` INT, `cantidadba` INT, `comentarioa` VARCHAR(300), `modelobb` INT, `cantidadbb` INT, `comentariob` VARCHAR(300), `modelobc` INT, `cantidadbc` INT, `comentarioc` VARCHAR(300), `modelobd` INT, `cantidadbd` INT, `comentariod` VARCHAR(300), `modelobe` INT, `cantidadbe` INT, `comentarioe` VARCHAR(300), `modelobf` INT, `cantidadbf` INT, `comentariof` VARCHAR(300), `modelobg` INT, `cantidadbg` INT, `comentariog` VARCHAR(300), `modelobh` INT, `cantidadbh` INT, `comentarioh` VARCHAR(300), `modelobi` INT, `cantidadbi` INT, `comentarioi` VARCHAR(300), `modelobj` INT, `cantidadbj` INT, `comentarioj` VARCHAR(300), `sentencia` INT, `accion` INT)  BEGIN

declare resultado1 int;
declare num1 int;

declare resultado2 int;
declare num2 int;

declare resultado3 int;
declare num3 int;

declare resultado4 int;
declare num4 int;

declare resultado5 int;
declare num5 int;

declare resultado6 int;
declare num6 int;

declare resultado7 int;
declare num7 int;

declare resultado8 int;
declare num8 int;

declare resultado9 int;
declare num9 int;

declare resultado10 int;
declare num10 int;

declare nen int;

if(sentencia = 1)
then
	if(accion = 1)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

	end if;


	if(accion = 6)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

	end if;

	if(accion = 7)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;
	end if;

	if(accion = 8)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;
	end if;

	if(accion = 9)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,cliente,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;
	end if;

	if(accion = 10)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,cliente,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,cliente,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,cliente,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,cliente,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;

		set num10 = (select cantidad from mercancia where id = `modelobj`);
		set resultado10 = num10 - cantidadbj;
		if(resultado10 >= 0)
		then
			if(cantidadbj >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobj,cantidadbj,usuarioa,usuariob,cliente,comentarioj,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado10 WHERE `id` = modelobj;
			end if;
		end if;
	end if;
end if;

if(sentencia = 2)
then 
	if(accion = 1)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

	end if;


	if(accion = 6)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

	end if;

	if(accion = 7)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;
	end if;

	if(accion = 8)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;
	end if;

	if(accion = 9)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,nen,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;
	end if;

	if(accion = 10)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;

		set num6 = (select cantidad from mercancia where id = `modelobf`);
		set resultado6 = num6 - cantidadbf;
		if(resultado6 >= 0)
		then
			if(cantidadbf >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobf,cantidadbf,usuarioa,usuariob,nen,comentariof,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado6 WHERE `id` = modelobf;
			end if;
		end if;

		set num7 = (select cantidad from mercancia where id = `modelobg`);
		set resultado7 = num7 - cantidadbg;
		if(resultado7 >= 0)
		then
			if(cantidadbg >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobg,cantidadbg,usuarioa,usuariob,nen,comentariog,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado7 WHERE `id` = modelobg;
			end if;
		end if;

		set num8 = (select cantidad from mercancia where id = `modelobh`);
		set resultado8 = num8 - cantidadbh;
		if(resultado8 >= 0)
		then
			if(cantidadbh >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobh,cantidadbh,usuarioa,usuariob,nen,comentarioh,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado8 WHERE `id` = modelobh;
			end if;
		end if;

		set num9 = (select cantidad from mercancia where id = `modelobi`);
		set resultado9 = num9 - cantidadbi;
		if(resultado9 >= 0)
		then
			if(cantidadbi >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobi,cantidadbi,usuarioa,usuariob,nen,comentarioi,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado9 WHERE `id` = modelobi;
			end if;
		end if;

		set num10 = (select cantidad from mercancia where id = `modelobj`);
		set resultado10 = num10 - cantidadbj;
		if(resultado10 >= 0)
		then
			if(cantidadbj >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobj,cantidadbj,usuarioa,usuariob,nen,comentarioj,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado10 WHERE `id` = modelobj;
			end if;
		end if;
	end if;
end if;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDBAJASD` (`x` INT, `accionb` INT, `usuarioa` INT, `usuariob` INT, `cliente` INT, `modeloba` INT, `cantidadba` INT, `comentarioa` VARCHAR(300), `modelobb` INT, `cantidadbb` INT, `comentariob` VARCHAR(300), `modelobc` INT, `cantidadbc` INT, `comentarioc` VARCHAR(300), `modelobd` INT, `cantidadbd` INT, `comentariod` VARCHAR(300), `modelobe` INT, `cantidadbe` INT, `comentarioe` VARCHAR(300), `sentencia` INT, `accion` INT)  BEGIN

declare resultado1 int;
declare num1 int;

declare resultado2 int;
declare num2 int;

declare resultado3 int;
declare num3 int;

declare resultado4 int;
declare num4 int;

declare resultado5 int;
declare num5 int;

declare nen int;

if(sentencia = 1)
then
	if(accion = 1)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,cliente,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,cliente,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,cliente,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,cliente,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,cliente,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;
	end if;
end if;

if(sentencia = 2)
then
	if(accion = 1)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
	end if;

	if(accion = 2)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
	end if;

	if(accion = 3)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;
	end if;

	if(accion = 4)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

	end if;

	if(accion = 5)
	then
		set nen = (select id from clientes ORDER by id DESC LIMIT 1);

		set num1 = (select cantidad from mercancia where id = `modeloba`);
		set resultado1 = num1 - cantidadba;
		if(resultado1 >= 0)
		then
			if(cantidadba >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modeloba,cantidadba,usuarioa,usuariob,nen,comentarioa,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado1 WHERE `id` = modeloba;
			end if;
		end if;
		
		set num2 = (select cantidad from mercancia where id = `modelobb`);
		set resultado2 = num2 - cantidadbb;
		if(resultado2 >= 0)
		then
			if(cantidadbb >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobb,cantidadbb,usuarioa,usuariob,nen,comentariob,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado2 WHERE `id` = modelobb;
			end if;
		end if;
		
		set num3 = (select cantidad from mercancia where id = `modelobc`);
		set resultado3 = num3 - cantidadbc;
		if(resultado3 >= 0)
		then
			if(cantidadbc >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobc,cantidadbc,usuarioa,usuariob,nen,comentarioc,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado3 WHERE `id` = modelobc;
			end if;
		end if;

		set num4 = (select cantidad from mercancia where id = `modelobd`);
		set resultado4 = num4 - cantidadbd;
		if(resultado4 >= 0)
		then
			if(cantidadbd >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobd,cantidadbd,usuarioa,usuariob,nen,comentariod,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado4 WHERE `id` = modelobd;
			end if;
		end if;

		set num5 = (select cantidad from mercancia where id = `modelobe`);
		set resultado5 = num5 - cantidadbe;
		if(resultado5 >= 0)
		then
			if(cantidadbe >= 1)
			then
				INSERT INTO `almacen`.`bajas`
				(`fecha`,`accionb`,`modelob`,`cantidad`,`usuarioa`,`usuariob`,`cliente`,`comentario`,`estatus`)
				VALUES
				(sysdate(),accionb,modelobe,cantidadbe,usuarioa,usuariob,nen,comentarioe,1);

				UPDATE `almacen`.`mercancia` SET `cantidad` = resultado5 WHERE `id` = modelobe;
			end if;
		end if;
	end if;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDCIUDAD` (`x` INT, `ciudad` VARCHAR(50), `estatus` INT, `accion` INT)  BEGIN

if(accion = 1)
then 
INSERT INTO `almacen`.`ciudad`
(
`ciudad`,
`estatus`)
VALUES
(
ciudad,
estatus);
end if;

if(accion = 2)
then 
UPDATE `almacen`.`ciudad`
SET
`ciudad` = ciudad
WHERE `id` = x;
end if;

if(accion = 3)
then 
UPDATE `almacen`.`ciudad`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDCLIENTES` (`x` INT, `cliente` VARCHAR(50), `direccion` VARCHAR(75), `ciudad` INT, `estatus` INT, `accion` INT, `contacto` VARCHAR(50), `telefono` VARCHAR(15), `telefonoalt` VARCHAR(15))  BEGIN

if(accion = 1)
then
INSERT INTO `almacen`.`clientes`
(
`cliente`,
`direccion`,
`ciudad`,
`estatus`,
`contacto`,
`telefonoa`,
`telefonob`)
VALUES
(
cliente,
direccion,
ciudad,
estatus,
contacto,
telefono,
telefonoalt); 
end if;

if(accion = 2)
then
UPDATE `almacen`.`clientes`
SET
`cliente` = cliente,
`direccion` = direccion,
`ciudad` = ciudad,
`contacto` = contacto,
`telefonoa` = telefono, 
`telefonob` = telefonoalt
WHERE `id` = x;
end if;

if(accion = 3)
then
UPDATE `almacen`.`clientes`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDDESCOMPUESTA` (`x` INT, `tool` INT, `marca` INT, `estado` INT, `seccion` INT, `almacen` INT, `razon` VARCHAR(115), `cantidada` INT, `cantidadn` INT, `estatus` INT, `accion` INT, `sentencia` INT)  BEGIN

declare var1 int;
declare var2 int;
declare var3 int;
declare var4 int;
declare var5 int; 

if(accion = 1)
then
	set var1 = cantidada - cantidadn;
	UPDATE `almacen`.`herramienta` SET `existencia` = var1 WHERE `id` = tool;

	INSERT INTO `almacen`.`herramientaunf`
	(`tool`,`description`,`modelo`,`imagen`,`existencia`,`marcasunf`,`estadounf`,`seccionunf`,`almacenunf`,`razon`,`cantidad`,`estatus`)
	VALUES
	(tool,tool,tool,tool,tool,marca,estado,seccion,almacen,razon,cantidadn,1);
end if;

if(accion = 2)
then 
	set var1 = (select `existencia` from `almacen`.`herramienta` WHERE `id` = tool);
	set var2 = cantidada + var1;
	
	UPDATE `almacen`.`herramienta` SET `existencia` = var2 WHERE `id` = tool;
	UPDATE `almacen`.`herramientaunf` SET `estatus`= 2 WHERE `id` = x;
end if;

if(accion = 3)
then 
	if(sentencia = 1)
	then
		set var1 = (select `existencia` from `almacen`.`herramienta` WHERE `id` = tool);
		set var2 = var1 - cantidadn;
		set var3 = (select `cantidad` from `almacen`.`herramientaunf` where `id` = x);
		set var4 = cantidadn + var3;

		UPDATE `almacen`.`herramienta` SET `existencia` = var2 WHERE `id` = tool;

		UPDATE `almacen`.`herramientaunf`
		SET
		`seccionunf` = seccion,
		`almacenunf` = almacen,
		`razon` = razon,
		`cantidad` = var4,
		`estatus` = 1
		WHERE `id` = x;
	end if;

	if(sentencia = 2)
	then
		set var1 = cantidadn * -1;
		set var2 = (select `existencia` from `almacen`.`herramienta` WHERE `id` = tool);
		set var3 = cantidada + var2;
		set var4 = (select `cantidad` from `almacen`.`herramientaunf` where `id` = x);
		set var5 = (var4) - cantidada;

		UPDATE `almacen`.`herramienta` SET `existencia` = var3 WHERE `id` = tool;

		UPDATE `almacen`.`herramientaunf`
		SET
		`seccionunf` = seccion,
		`almacenunf` = almacen,
		`razon` = razon,
		`cantidad` = var5,
		`estatus` = 1
		WHERE `id` = x;
	end if; 

	if(sentencia = 3)
	then 
		UPDATE `almacen`.`herramientaunf`
		SET
		`seccionunf` = seccion,
		`almacenunf` = almacen,
		`razon` = razon,
		`estatus` = 1
		WHERE `id` = x;
	end if;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDDESCRIPCION` (`x` INT, `descripcion` VARCHAR(50), `temerca` INT, `estatus` INT, `accion` INT)  BEGIN

if(accion = 1)
then
INSERT INTO `almacen`.`descripcion`
(
`descripcion`,
`temerca`,
`estatus`)
VALUES
(
descripcion,
temerca,
estatus);
end if;

if(accion = 2)
then
UPDATE `almacen`.`descripcion`
SET
`descripcion` = descripcion,
`temerca` = temerca
WHERE `id` = x;
end if;

if(accion = 3)
then
UPDATE `almacen`.`descripcion`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDESTADO` (`x` INT, `estado` VARCHAR(50), `estatus` INT, `accion` INT)  BEGIN

if (accion = 1)
then
INSERT INTO `almacen`.`estado`
(
`estado`,
`estatus`)
VALUES
(
estado,
estatus);
end if;

if (accion = 2)
then
UPDATE `almacen`.`estado`
SET
`estado` = estado
WHERE `id` = x;
end if;

if (accion = 3)
then
UPDATE `almacen`.`estado`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDINGRESOS` (`usuarioi` INT, `accion` INT)  BEGIN

if(accion = 1)
then
	INSERT INTO `almacen`.`ingresos`
	(`usuario`,`fecha`)
	VALUES
	(usuarioi,sysdate());
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDMARCAS` (`x` INT, `marca` VARCHAR(50), `categoria` INT, `estatus` INT, `accion` INT)  BEGIN

if (accion = 1)
then
INSERT INTO `almacen`.`marcas`
(
`marca`,
`categoria`,
`estatus`)
VALUES
(
marca,
categoria,
estatus);
end if;

if (accion = 2)
then
UPDATE `almacen`.`marcas`
SET
`marca` = marca,
`categoria` = categoria
WHERE `id` = x;
end if;


if (accion = 3)
then
UPDATE `almacen`.`marcas`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDMERC` (`x` INT, `mercancia` INT, `marcas` INT, `modelo` VARCHAR(50), `descripcion` INT, `coment` VARCHAR(100), `imagenes` VARCHAR(50), `estatus` INT, `cantidad` INT, `seccione` INT, `accion` INT)  BEGIN

if (accion = 1)
then
INSERT INTO `almacen`.`mercancia`
(
`mercancia`,
`marcas`,
`modelo`,
`descripcion`,
`coment`,
`imagenes`,
`estatus`,
`cantidad`,
`seccionm`)
VALUES
(
mercancia,
marcas,
modelo,
descripcion,
coment,
imagenes,
estatus,
cantidad,
seccione);
end if;

if (accion = 2)
then
UPDATE `almacen`.`mercancia`
SET
`mercancia` = mercancia,
`marcas` = marcas,
`modelo` = modelo,
`descripcion` = descripcion,
`seccionm` = seccione,
`coment` = coment
WHERE `id` = x;

end if;

if (accion = 3)
then
UPDATE `almacen`.`mercancia`
SET
`mercancia` = mercancia,
`marcas` = marcas,
`modelo` = modelo,
`descripcion` = descripcion,
`coment` = coment,
`seccionm` = seccione,
`imagenes` = imagenes
WHERE `id` = x;
end if;

if (accion = 4)
then
UPDATE `almacen`.`mercancia`
SET
`estatus` = estatus
WHERE `id` = x;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDPRESTAMO` (`x` INT, `cliente` INT, `admin` INT, `user` INT, `herramienta1` INT, `cantloan1` INT, `nota1` VARCHAR(150), `herramienta2` INT, `cantloan2` INT, `nota2` VARCHAR(150), `herramienta3` INT, `cantloan3` INT, `nota3` VARCHAR(150), `herramienta4` INT, `cantloan4` INT, `nota4` VARCHAR(150), `herramienta5` INT, `cantloan5` INT, `nota5` VARCHAR(150), `herramienta6` INT, `cantloan6` INT, `nota6` VARCHAR(150), `herramienta7` INT, `cantloan7` INT, `nota7` VARCHAR(150), `herramienta8` INT, `cantloan8` INT, `nota8` VARCHAR(150), `herramienta9` INT, `cantloan9` INT, `nota9` VARCHAR(150), `herramienta10` INT, `cantloan10` INT, `nota10` VARCHAR(150), `accion` INT)  BEGIN

declare var11 int;
declare var12 int;

declare var21 int;
declare var22 int;

declare var31 int;
declare var32 int;

declare var41 int;
declare var42 int;

declare var51 int;
declare var52 int;

declare var61 int;
declare var62 int;

declare var71 int;
declare var72 int;

declare var81 int;
declare var82 int;

declare var91 int;
declare var92 int;

declare var101 int;
declare var102 int;

if(accion = 1)
then 
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
end if;

if(accion = 2)
then
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
end if;

if(accion = 3)
then
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
end if;

if(accion = 4)
then 
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
/*Seccion 4*/
	set var41 = (select existencia from `almacen`.`herramienta` where id = herramienta4);
	set var42 = var41 - cantloan4;
	
	if(var42 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantloan4,herramienta4,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var42 WHERE `id` = herramienta4;
	end if;
end if;

if(accion = 5)
then
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
/*Seccion 4*/
	set var41 = (select existencia from `almacen`.`herramienta` where id = herramienta4);
	set var42 = var41 - cantloan4;
	
	if(var42 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantloan4,herramienta4,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var42 WHERE `id` = herramienta4;
	end if;
/*Seccion 5*/
	set var51 = (select existencia from `almacen`.`herramienta` where id = herramienta5);
	set var52 = var51 - cantloan5;
	
	if(var52 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantloan5,herramienta5,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var52 WHERE `id` = herramienta5;
	end if;
end if;

if(accion = 6)
then
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herraamienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
/*Seccion 4*/
	set var41 = (select existencia from `almacen`.`herramienta` where id = herramienta4);
	set var42 = var41 - cantloan4;
	
	if(var42 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantloan4,herramienta4,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var42 WHERE `id` = herramienta4;
	end if;
/*Seccion 5*/
	set var51 = (select existencia from `almacen`.`herramienta` where id = herramienta5);
	set var52 = var51 - cantloan5;
	
	if(var52 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantloan5,herramienta5,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var52 WHERE `id` = herramienta5;
	end if;
/*Seccion 6*/
	set var61 = (select existencia from `almacen`.`herramienta` where id = herramienta6);
	set var62 = var61 - cantloan6;
	
	if(var62 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantloan6,herramienta6,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var62 WHERE `id` = herramienta6;
	end if;
end if;

if(accion = 7)
then 
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
/*Seccion 4*/
	set var41 = (select existencia from `almacen`.`herramienta` where id = herramienta4);
	set var42 = var41 - cantloan4;
	
	if(var42 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantloan4,herramienta4,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var42 WHERE `id` = herramienta4;
	end if;
/*Seccion 5*/
	set var51 = (select existencia from `almacen`.`herramienta` where id = herramienta5);
	set var52 = var51 - cantloan5;
	
	if(var52 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantloan5,herramienta5,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var52 WHERE `id` = herramienta5;
	end if;
/*Seccion 6*/
	set var61 = (select existencia from `almacen`.`herramienta` where id = herramienta6);
	set var62 = var61 - cantloan6;
	
	if(var62 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantloan6,herramienta6,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var62 WHERE `id` = herramienta6;
	end if;
/*Seccion 7*/
	set var71 = (select existencia from `almacen`.`herramienta` where id = herramienta7);
	set var72 = var71 - cantloan7;
	
	if(var72 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantloan7,herramienta7,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var72 WHERE `id` = herramienta7;
	end if;
end if;

if(accion = 8)
then 
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
/*Seccion 4*/
	set var41 = (select existencia from `almacen`.`herramienta` where id = herramienta4);
	set var42 = var41 - cantloan4;
	
	if(var42 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantloan4,herramienta4,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var42 WHERE `id` = herramienta4;
	end if;
/*Seccion 5*/
	set var51 = (select existencia from `almacen`.`herramienta` where id = herramienta5);
	set var52 = var51 - cantloan5;
	
	if(var52 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantloan5,herramienta5,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var52 WHERE `id` = herramienta5;
	end if;
/*Seccion 6*/
	set var61 = (select existencia from `almacen`.`herramienta` where id = herramienta6);
	set var62 = var61 - cantloan6;
	
	if(var62 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantloan6,herramienta6,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var62 WHERE `id` = herramienta6;
	end if;
/*Seccion 7*/
	set var71 = (select existencia from `almacen`.`herramienta` where id = herramienta7);
	set var72 = var71 - cantloan7;
	
	if(var72 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantloan7,herramienta7,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var72 WHERE `id` = herramienta7;
	end if;
/*Seccion 8*/
	set var81 = (select existencia from `almacen`.`herramienta` where id = herramienta8);
	set var82 = var81 - cantloan8;
	
	if(var82 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta8,sysdate(),cliente,admin,user,nota8,cantloan8,herramienta8,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var82 WHERE `id` = herramienta8;
	end if;
end if;

if(accion = 9)
then
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
/*Seccion 4*/
	set var41 = (select existencia from `almacen`.`herramienta` where id = herramienta4);
	set var42 = var41 - cantloan4;
	
	if(var42 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantloan4,herramienta4,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var42 WHERE `id` = herramienta4;
	end if;
/*Seccion 5*/
	set var51 = (select existencia from `almacen`.`herramienta` where id = herramienta5);
	set var52 = var51 - cantloan5;
	
	if(var52 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantloan5,herramienta5,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var52 WHERE `id` = herramienta5;
	end if;
/*Seccion 6*/
	set var61 = (select existencia from `almacen`.`herramienta` where id = herramienta6);
	set var62 = var61 - cantloan6;
	
	if(var62 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantloan6,herramienta6,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var62 WHERE `id` = herramienta6;
	end if;
/*Seccion 7*/
	set var71 = (select existencia from `almacen`.`herramienta` where id = herramienta7);
	set var72 = var71 - cantloan7;
	
	if(var72 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantloan7,herramienta7,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var72 WHERE `id` = herramienta7;
	end if;
/*Seccion 8*/
	set var81 = (select existencia from `almacen`.`herramienta` where id = herramienta8);
	set var82 = var81 - cantloan8;
	
	if(var82 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta8,sysdate(),cliente,admin,user,nota8,cantloan8,herramienta8,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var82 WHERE `id` = herramienta8;
	end if;
/*Seccion 9*/
	set var91 = (select existencia from `almacen`.`herramienta` where id = herramienta9);
	set var92 = var91 - cantloan9;
	
	if(var92 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta9,sysdate(),cliente,admin,user,nota9,cantloan9,herramienta9,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var92 WHERE `id` = herramienta9;
	end if;
end if;

if(accion = 10)
then 
	set var11 = (select existencia from `almacen`.`herramienta` where id = herramienta1);
	set var12 = var11 - cantloan1;
	
	if(var12 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantloan1,herramienta1,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var12 WHERE `id` = herramienta1;
	end if;
/*Seccion 2*/
	set var21 = (select existencia from `almacen`.`herramienta` where id = herramienta2);
	set var22 = var21 - cantloan2;
	
	if(var22 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantloan2,herramienta2,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var22 WHERE `id` = herramienta2;
	end if;
/*Seccion 3*/
	set var31 = (select existencia from `almacen`.`herramienta` where id = herramienta3);
	set var32 = var31 - cantloan3;
	
	if(var32 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantloan3,herramienta3,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var32 WHERE `id` = herramienta3;
	end if;
/*Seccion 4*/
	set var41 = (select existencia from `almacen`.`herramienta` where id = herramienta4);
	set var42 = var41 - cantloan4;
	
	if(var42 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantloan4,herramienta4,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var42 WHERE `id` = herramienta4;
	end if;
/*Seccion 5*/
	set var51 = (select existencia from `almacen`.`herramienta` where id = herramienta5);
	set var52 = var51 - cantloan5;
	
	if(var52 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantloan5,herramienta5,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var52 WHERE `id` = herramienta5;
	end if;
/*Seccion 6*/
	set var61 = (select existencia from `almacen`.`herramienta` where id = herramienta6);
	set var62 = var61 - cantloan6;
	
	if(var62 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantloan6,herramienta6,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var62 WHERE `id` = herramienta6;
	end if;
/*Seccion 7*/
	set var71 = (select existencia from `almacen`.`herramienta` where id = herramienta7);
	set var72 = var71 - cantloan7;
	
	if(var72 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantloan7,herramienta7,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var72 WHERE `id` = herramienta7;
	end if;
/*Seccion 8*/
	set var81 = (select existencia from `almacen`.`herramienta` where id = herramienta8);
	set var82 = var81 - cantloan8;
	
	if(var82 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta8,sysdate(),cliente,admin,user,nota8,cantloan8,herramienta8,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var82 WHERE `id` = herramienta8;
	end if;
/*Seccion 9*/
	set var91 = (select existencia from `almacen`.`herramienta` where id = herramienta9);
	set var92 = var91 - cantloan9;
	
	if(var92 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta9,sysdate(),cliente,admin,user,nota9,cantloan9,herramienta9,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var92 WHERE `id` = herramienta9;
	end if;
/*Seccion 10*/
	set var101 = (select existencia from `almacen`.`herramienta` where id = herramienta10);
	set var102 = var101 - cantloan10;
	
	if(var102 >= 0)
	then
		INSERT INTO `almacen`.`tooloan`
		(`acciontool`,`herramienta`,`fechap`,`clientes`,`usuarioadmin`,`usuariouser`,`nota`,`cantpres`,`cantext`,`estatus`)
		VALUES
		(3,herramienta10,sysdate(),cliente,admin,user,nota10,cantloan10,herramienta10,1);

		UPDATE `almacen`.`herramienta` SET `existencia` = var102 WHERE `id` = herramienta10;
	end if;
end if;

if(accion = 11)
then 
	set var11 = (select herramienta from `almacen`.`tooloan` where id = x);
	set var12 = (select existencia from `almacen`.`herramienta` where id = var11);
	
	set var21 = var12 + cantloan1;

	set var22 = (select totale from `almacen`.`herramienta` where id = var11);

	if(var22 >= var21)
	then
		set var31 = (select herramienta from `almacen`.`tooloan` where id = x);
		set var32 = (select existencia from `almacen`.`herramienta` where id = var31);
		
		set var41 = var32 + cantloan1;

		UPDATE `almacen`.`herramienta` SET `existencia` = var41 WHERE `id` = var31;

		UPDATE `almacen`.`tooloan` SET `estatus` = 2 WHERE `id` = x;
	end if;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDPROVEEDOR` (`x` INT, `proveedor` VARCHAR(50), `estatus` INT, `ciudad` INT, `direccion` VARCHAR(45), `telefono` VARCHAR(30), `contacto` VARCHAR(60), `sucursal` VARCHAR(45), `webpage` VARCHAR(45), `accion` INT)  BEGIN

if (accion = 1)
then
INSERT INTO `almacen`.`proveedor`
(
`proveedor`,
`estatus`,
`ciudesta`,
`direccion`,
`telefono`,
`contacto`,
`sucursal`,
`webpage`)
VALUES
(
proveedor,
estatus,
ciudad,
direccion,
telefono,
contacto,
sucursal,
webpage);
end if;

if (accion = 2)
then
UPDATE `almacen`.`proveedor`
SET
`proveedor` = proveedor,
`ciudesta` = ciudad,
`direccion` = direccion,
`telefono` = telefono,
`contacto` = contacto,
`sucursal` = sucursal,
`webpage` = webpage
WHERE `id` = x;
end if;

if (accion = 3)
then
UPDATE `almacen`.`proveedor`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDRMA` (`nooreden` INT, `cliente` INT, `proveedor` INT, `producto1` VARCHAR(50), `modelo1` VARCHAR(50), `serie1` VARCHAR(50), `razon1` VARCHAR(180), `dtingreso1` DATE, `dtenvio1` DATE, `dtregreso1` DATE, `dtinstalacion1` DATE, `ec1` INT, `rmap1` VARCHAR(45), `producto2` VARCHAR(50), `modelo2` VARCHAR(50), `serie2` VARCHAR(50), `razon2` VARCHAR(180), `dtingreso2` DATE, `dtenvio2` DATE, `dtregreso2` DATE, `dtinstalacion2` DATE, `ec2` INT, `rmap2` VARCHAR(45), `producto3` VARCHAR(50), `modelo3` VARCHAR(50), `serie3` VARCHAR(50), `razon3` VARCHAR(180), `dtingreso3` DATE, `dtenvio3` DATE, `dtregreso3` DATE, `dtinstalacion3` DATE, `ec3` INT, `rmap3` VARCHAR(45), `producto4` VARCHAR(50), `modelo4` VARCHAR(50), `serie4` VARCHAR(50), `razon4` VARCHAR(180), `dtingreso4` DATE, `dtenvio4` DATE, `dtregreso4` DATE, `dtinstalacion4` DATE, `ec4` INT, `rmap4` VARCHAR(45), `producto5` VARCHAR(50), `modelo5` VARCHAR(50), `serie5` VARCHAR(50), `razon5` VARCHAR(180), `dtingreso5` DATE, `dtenvio5` DATE, `dtregreso5` DATE, `dtinstalacion5` DATE, `ec5` INT, `rmap5` VARCHAR(45), `accion` INT)  BEGIN

if(accion = 1)
then
	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);
end if; 

if(accion = 2)
then 
	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);
end if;

if(accion = 3)
then
	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto3,modelo3,serie3,razon3,dtingreso3,dtenvio3,
			dtregreso3,dtinstalacion3,proveedor,1,ec3,rmap3);
end if;

if(accion = 4)
then
	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto3,modelo3,serie3,razon3,dtingreso3,dtenvio3,
			dtregreso3,dtinstalacion3,proveedor,1,ec3,rmap3);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto4,modelo4,serie4,razon4,dtingreso4,dtenvio4,
			dtregreso4,dtinstalacion4,proveedor,1,ec4,rmap4);
end if;

if(accion = 5)
then 
	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto3,modelo3,serie3,razon3,dtingreso3,dtenvio3,
			dtregreso3,dtinstalacion3,proveedor,1,ec3,rmap3);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto4,modelo4,serie4,razon4,dtingreso4,dtenvio4,
			dtregreso4,dtinstalacion4,proveedor,1,ec4,rmap4);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,cliente,producto5,modelo5,serie5,razon5,dtingreso5,dtenvio5,
			dtregreso5,dtinstalacion5,proveedor,1,ec5,rmap5);
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDRMAWC` (`nooreden` INT, `clienten` VARCHAR(50), `direccionn` VARCHAR(75), `ciudadn` INT, `contacton` VARCHAR(50), `telefonoan` VARCHAR(15), `telefonobn` VARCHAR(15), `proveedor` INT, `producto1` VARCHAR(50), `modelo1` VARCHAR(50), `serie1` VARCHAR(50), `razon1` VARCHAR(180), `dtingreso1` DATE, `dtenvio1` DATE, `dtregreso1` DATE, `dtinstalacion1` DATE, `ec1` INT, `rmap1` VARCHAR(45), `producto2` VARCHAR(50), `modelo2` VARCHAR(50), `serie2` VARCHAR(50), `razon2` VARCHAR(180), `dtingreso2` DATE, `dtenvio2` DATE, `dtregreso2` DATE, `dtinstalacion2` DATE, `ec2` INT, `rmap2` VARCHAR(45), `producto3` VARCHAR(50), `modelo3` VARCHAR(50), `serie3` VARCHAR(50), `razon3` VARCHAR(180), `dtingreso3` DATE, `dtenvio3` DATE, `dtregreso3` DATE, `dtinstalacion3` DATE, `ec3` INT, `rmap3` VARCHAR(45), `producto4` VARCHAR(50), `modelo4` VARCHAR(50), `serie4` VARCHAR(50), `razon4` VARCHAR(180), `dtingreso4` DATE, `dtenvio4` DATE, `dtregreso4` DATE, `dtinstalacion4` DATE, `ec4` INT, `rmap4` VARCHAR(45), `producto5` VARCHAR(50), `modelo5` VARCHAR(50), `serie5` VARCHAR(50), `razon5` VARCHAR(180), `dtingreso5` DATE, `dtenvio5` DATE, `dtregreso5` DATE, `dtinstalacion5` DATE, `ec5` INT, `rmap5` VARCHAR(45), `accion` INT)  BEGIN

declare var1 int;

if(accion = 1)
then
	INSERT INTO `almacen`.`clientes`
	(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
	VALUES
	(clienten,direccionn,ciudadn,1,contacton,telefonoan,telefonobn);

	set var1 = (select id  from clientes  ORDER by id DESC LIMIT 1);


	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);
end if;

if(accion = 2)
then 
	INSERT INTO `almacen`.`clientes`
	(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
	VALUES
	(clienten,direccionn,ciudadn,1,contacton,telefonoan,telefonobn);

	set var1 = (select id  from clientes  ORDER by id DESC LIMIT 1);
	
	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);
end if;

if(accion = 3)
then
	INSERT INTO `almacen`.`clientes`
	(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
	VALUES
	(clienten,direccionn,ciudadn,1,contacton,telefonoan,telefonobn);

	set var1 = (select id  from clientes  ORDER by id DESC LIMIT 1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto3,modelo3,serie3,razon3,dtingreso3,dtenvio3,
			dtregreso3,dtinstalacion3,proveedor,1,ec3,rmap3);
end if;

if(accion = 4)
then
	INSERT INTO `almacen`.`clientes`
	(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
	VALUES
	(clienten,direccionn,ciudadn,1,contacton,telefonoan,telefonobn);

	set var1 = (select id  from clientes  ORDER by id DESC LIMIT 1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto3,modelo3,serie3,razon3,dtingreso3,dtenvio3,
			dtregreso3,dtinstalacion3,proveedor,1,ec3,rmap3);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto4,modelo4,serie4,razon4,dtingreso4,dtenvio4,
			dtregreso4,dtinstalacion4,proveedor,1,ec4,rmap4);
end if;

if(accion = 5)
then 
	INSERT INTO `almacen`.`clientes`
	(`cliente`,`direccion`,`ciudad`,`estatus`,`contacto`,`telefonoa`,`telefonob`)
	VALUES
	(clienten,direccionn,ciudadn,1,contacton,telefonoan,telefonobn);

	set var1 = (select id  from clientes  ORDER by id DESC LIMIT 1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto1,modelo1,serie1,razon1,dtingreso1,dtenvio1,
			dtregreso1,dtinstalacion1,proveedor,1,ec1,rmap1);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto2,modelo2,serie2,razon2,dtingreso2,dtenvio2,
			dtregreso2,dtinstalacion2,proveedor,1,ec2,rmap2);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto3,modelo3,serie3,razon3,dtingreso3,dtenvio3,
			dtregreso3,dtinstalacion3,proveedor,1,ec3,rmap3);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto4,modelo4,serie4,razon4,dtingreso4,dtenvio4,
			dtregreso4,dtinstalacion4,proveedor,1,ec4,rmap4);

	INSERT INTO `almacen`.`rma` (`numeroorden`,`clientesrma`,`producto`,
								 `modelo`,`serie`,`descripcion`,`fechaingreso`,
								 `fechaenvio`,`fecharegreso`,`fechainstalacion`,
								 `proveedorrma`,`estatus`,`resultrmat`,`rmaproveedor`)
	VALUES (nooreden,var1,producto5,modelo5,serie5,razon5,dtingreso5,dtenvio5,
			dtregreso5,dtinstalacion5,proveedor,1,ec5,rmap5);
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDSECCION` (`x` INT, `seccion` VARCHAR(45), `accion` INT)  BEGIN

if(accion = 1)
then 
INSERT INTO `almacen`.`seccion`
(`seccion`,`estatus`)
VALUES
(seccion,1);
end if; 

if(accion = 2)
then 
UPDATE `almacen`.`seccion`
SET
`seccion` = seccion
WHERE `id` = x;
end if;

if(accion = 3)
then
UPDATE `almacen`.`seccion`
SET
`estatus` = 2
WHERE `id` = x;
end if; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDTMERC` (`x` INT, `tipomercancia` VARCHAR(50), `estatus` INT, `accion` INT)  BEGIN

if(accion = 1)
then
INSERT INTO `almacen`.`tmercancia`
(
`tipomercancia`,
`estatus`)
VALUES
(
tipomercancia,
estatus);
end if;

if(accion = 2)
then
UPDATE `almacen`.`tmercancia`
SET
`tipomercancia` = tipomercancia
WHERE `id` = x;
end if;

if(accion = 3)
then
UPDATE `almacen`.`tmercancia`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDTOOL` (`x` INT, `herramienta` VARCHAR(50), `descripcion` VARCHAR(250), `marca` INT, `modelo` VARCHAR(50), `estado` INT, `imagen` VARCHAR(50), `estatus` INT, `existenciac` INT, `seccion` INT, `almace` INT, `accion` INT)  BEGIN

declare var1 int;
declare var2 int;

if (accion = 1)
then
INSERT INTO `almacen`.`herramienta`
(
`herramienta`,
`descripcion`,
`marca`,
`modelo`,
`estado`,
`imagen`,
`existencia`,
`seccion`,
`almace`,
`estatus`,
`totale`)
VALUES
(
herramienta,
descripcion,
marca,
modelo,
estado,
imagen,
existencia,
seccion,
almace,
estatus,
existenciac);
end if;

if (accion = 2)
then
set var1 = (select `existencia` from `almacen`.`herramienta` where id = x);
set var2 = (select `totale` from `almacen`.`herramienta` where id = x);

	if(var1 = var2)
	then
		UPDATE `almacen`.`herramienta`
		SET
		`herramienta` = herramienta,
		`descripcion` = descripcion,
		`marca` = marca,
		`modelo` = modelo,
		`estado` = estado,
		`existencia` = existenciac,
		`seccion` = seccion,
		`almace` = almace,
		`estatus` = estatus,
		`totale` = existencia
		WHERE `id` = x;
	end if;
end if;

if (accion = 3)
then
set var1 = (select `existencia` from `almacen`.`herramienta` where id = x);
set var2 = (select `totale` from `almacen`.`herramienta` where id = x);

	if(var2 = var1)
	then
		UPDATE `almacen`.`herramienta`
		SET
		`herramienta` = herramienta,
		`descripcion` = descripcion,
		`marca` = marca,
		`modelo` = modelo,
		`estado` = estado,
		`imagen` = imagen,
		`existencia` = existenciac,
		`seccion` = seccion,
		`almace` = almace,
		`estatus` = estatus,
		`totale` = existencia
		WHERE `id` = x;
	end if;
end if;

if (accion = 4)
then
UPDATE `almacen`.`herramienta`
SET
`estatus` = estatus
WHERE `id` = x;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDTOOLBACK` (`cliente` INT, `admin` INT, `user` INT, `x1` INT, `nota1` VARCHAR(150), `cantidadv1` INT, `estatus1` INT, `x2` INT, `nota2` VARCHAR(150), `cantidadv2` INT, `estatus2` INT, `x3` INT, `nota3` VARCHAR(150), `cantidadv3` INT, `estatus3` INT, `x4` INT, `nota4` VARCHAR(150), `cantidadv4` INT, `estatus4` INT, `x5` INT, `nota5` VARCHAR(150), `cantidadv5` INT, `estatus5` INT, `x6` INT, `nota6` VARCHAR(150), `cantidadv6` INT, `estatus6` INT, `x7` INT, `nota7` VARCHAR(150), `cantidadv7` INT, `estatus7` INT, `x8` INT, `nota8` VARCHAR(150), `cantidadv8` INT, `estatus8` INT, `x9` INT, `nota9` VARCHAR(150), `cantidadv9` INT, `estatus9` INT, `x10` INT, `nota10` VARCHAR(150), `cantidadv10` INT, `estatus10` INT, `accion` INT)  BEGIN

declare var11 int;
declare var12 int;
declare var13 int;
declare var14 int;
declare var15 int;
declare herramienta1 int;

declare var21 int;
declare var22 int;
declare var23 int;
declare var24 int;
declare var25 int;
declare herramienta2 int;

declare var31 int;
declare var32 int;
declare var33 int;
declare var34 int;
declare var35 int;
declare herramienta3 int;

declare var41 int;
declare var42 int;
declare var43 int;
declare var44 int;
declare var45 int;
declare herramienta4 int;

declare var51 int;
declare var52 int;
declare var53 int;
declare var54 int;
declare var55 int;
declare herramienta5 int;

declare var61 int;
declare var62 int;
declare var63 int;
declare var64 int;
declare var65 int;
declare herramienta6 int;

declare var71 int;
declare var72 int;
declare var73 int;
declare var74 int;
declare var75 int;
declare herramienta7 int;

declare var81 int;
declare var82 int;
declare var83 int;
declare var84 int;
declare var85 int;
declare herramienta8 int;

declare var91 int;
declare var92 int;
declare var93 int;
declare var94 int;
declare var95 int;
declare herramienta9 int;

declare var101 int;
declare var102 int;
declare var103 int;
declare var104 int;
declare var105 int;
declare herramienta10 int;

if(accion = 1)
then 
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;
end if;

if(accion = 2)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
end if;

if(accion = 3)
then 
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
end if;

if(accion = 4)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
/* Prestamos 4 */
	set herramienta4 = (select herramienta from tooloan where id = x4);
	set var41 = (select existencia from herramienta where id = herramienta4);
	set var42 = (select totale from herramienta where id = herramienta4);
	set var43 = (select cantpres from tooloan where id = x4);

	set var44 = var43 - cantidadv4;
	set var45 = var41 + cantidadv4;

	if(var45 <= var42)
	then
		if(var44 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantidadv4,x4,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x4;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = herramienta4;
		end if;
	end if;
end if;

if(accion = 5)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
/* Prestamos 4 */
	set herramienta4 = (select herramienta from tooloan where id = x4);
	set var41 = (select existencia from herramienta where id = herramienta4);
	set var42 = (select totale from herramienta where id = herramienta4);
	set var43 = (select cantpres from tooloan where id = x4);

	set var44 = var43 - cantidadv4;
	set var45 = var41 + cantidadv4;

	if(var45 <= var42)
	then
		if(var44 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantidadv4,x4,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x4;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = herramienta4;
		end if;
	end if;
/* Prestamos 5 */
	set herramienta5 = (select herramienta from tooloan where id = x5);
	set var51 = (select existencia from herramienta where id = herramienta5);
	set var52 = (select totale from herramienta where id = herramienta5);
	set var53 = (select cantpres from tooloan where id = x5);

	set var54 = var53 - cantidadv5;
	set var55 = var51 + cantidadv5;

	if(var55 <= var52)
	then
		if(var54 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantidadv5,x5,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x5;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = herramienta5;
		end if;
	end if;
end if;

if(accion = 6)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
/* Prestamos 4 */
	set herramienta4 = (select herramienta from tooloan where id = x4);
	set var41 = (select existencia from herramienta where id = herramienta4);
	set var42 = (select totale from herramienta where id = herramienta4);
	set var43 = (select cantpres from tooloan where id = x4);

	set var44 = var43 - cantidadv4;
	set var45 = var41 + cantidadv4;

	if(var45 <= var42)
	then
		if(var44 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantidadv4,x4,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x4;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = herramienta4;
		end if;
	end if;
/* Prestamos 5 */
	set herramienta5 = (select herramienta from tooloan where id = x5);
	set var51 = (select existencia from herramienta where id = herramienta5);
	set var52 = (select totale from herramienta where id = herramienta5);
	set var53 = (select cantpres from tooloan where id = x5);

	set var54 = var53 - cantidadv5;
	set var55 = var51 + cantidadv5;

	if(var55 <= var52)
	then
		if(var54 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantidadv5,x5,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x5;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = herramienta5;
		end if;
	end if;
/* Prestamos 6 */
	set herramienta6 = (select herramienta from tooloan where id = x6);
	set var61 = (select existencia from herramienta where id = herramienta6);
	set var62 = (select totale from herramienta where id = herramienta6);
	set var63 = (select cantpres from tooloan where id = x6);

	set var64 = var63 - cantidadv6;
	set var65 = var61 + cantidadv6;

	if(var65 <= var62)
	then
		if(var64 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantidadv6,x6,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x6;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var65 WHERE `id` = herramienta6;
		end if;
	end if;
end if;

if(accion = 7)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
/* Prestamos 4 */
	set herramienta4 = (select herramienta from tooloan where id = x4);
	set var41 = (select existencia from herramienta where id = herramienta4);
	set var42 = (select totale from herramienta where id = herramienta4);
	set var43 = (select cantpres from tooloan where id = x4);

	set var44 = var43 - cantidadv4;
	set var45 = var41 + cantidadv4;

	if(var45 <= var42)
	then
		if(var44 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantidadv4,x4,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x4;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = herramienta4;
		end if;
	end if;
/* Prestamos 5 */
	set herramienta5 = (select herramienta from tooloan where id = x5);
	set var51 = (select existencia from herramienta where id = herramienta5);
	set var52 = (select totale from herramienta where id = herramienta5);
	set var53 = (select cantpres from tooloan where id = x5);

	set var54 = var53 - cantidadv5;
	set var55 = var51 + cantidadv5;

	if(var55 <= var52)
	then
		if(var54 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantidadv5,x5,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x5;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = herramienta5;
		end if;
	end if;
/* Prestamos 6 */
	set herramienta6 = (select herramienta from tooloan where id = x6);
	set var61 = (select existencia from herramienta where id = herramienta6);
	set var62 = (select totale from herramienta where id = herramienta6);
	set var63 = (select cantpres from tooloan where id = x6);

	set var64 = var63 - cantidadv6;
	set var65 = var61 + cantidadv6;

	if(var65 <= var62)
	then
		if(var64 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantidadv6,x6,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x6;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var65 WHERE `id` = herramienta6;
		end if;
	end if;
/* Prestamos 7 */
	set herramienta7 = (select herramienta from tooloan where id = x7);
	set var71 = (select existencia from herramienta where id = herramienta7);
	set var72 = (select totale from herramienta where id = herramienta7);
	set var73 = (select cantpres from tooloan where id = x7);

	set var74 = var73 - cantidadv7;
	set var75 = var71 + cantidadv7;

	if(var75 <= var72)
	then
		if(var74 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantidadv7,x7,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x7;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var75 WHERE `id` = herramienta7;
		end if;
	end if;
end if;

if(accion = 8)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
/* Prestamos 4 */
	set herramienta4 = (select herramienta from tooloan where id = x4);
	set var41 = (select existencia from herramienta where id = herramienta4);
	set var42 = (select totale from herramienta where id = herramienta4);
	set var43 = (select cantpres from tooloan where id = x4);

	set var44 = var43 - cantidadv4;
	set var45 = var41 + cantidadv4;

	if(var45 <= var42)
	then
		if(var44 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantidadv4,x4,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x4;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = herramienta4;
		end if;
	end if;
/* Prestamos 5 */
	set herramienta5 = (select herramienta from tooloan where id = x5);
	set var51 = (select existencia from herramienta where id = herramienta5);
	set var52 = (select totale from herramienta where id = herramienta5);
	set var53 = (select cantpres from tooloan where id = x5);

	set var54 = var53 - cantidadv5;
	set var55 = var51 + cantidadv5;

	if(var55 <= var52)
	then
		if(var54 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantidadv5,x5,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x5;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = herramienta5;
		end if;
	end if;
/* Prestamos 6 */
	set herramienta6 = (select herramienta from tooloan where id = x6);
	set var61 = (select existencia from herramienta where id = herramienta6);
	set var62 = (select totale from herramienta where id = herramienta6);
	set var63 = (select cantpres from tooloan where id = x6);

	set var64 = var63 - cantidadv6;
	set var65 = var61 + cantidadv6;

	if(var65 <= var62)
	then
		if(var64 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantidadv6,x6,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x6;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var65 WHERE `id` = herramienta6;
		end if;
	end if;
/* Prestamos 7 */
	set herramienta7 = (select herramienta from tooloan where id = x7);
	set var71 = (select existencia from herramienta where id = herramienta7);
	set var72 = (select totale from herramienta where id = herramienta7);
	set var73 = (select cantpres from tooloan where id = x7);

	set var74 = var73 - cantidadv7;
	set var75 = var71 + cantidadv7;

	if(var75 <= var72)
	then
		if(var74 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantidadv7,x7,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x7;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var75 WHERE `id` = herramienta7;
		end if;
	end if;
/* Prestamos 8 */
	set herramienta8 = (select herramienta from tooloan where id = x8);
	set var81 = (select existencia from herramienta where id = herramienta8);
	set var82 = (select totale from herramienta where id = herramienta8);
	set var83 = (select cantpres from tooloan where id = x8);

	set var84 = var83 - cantidadv8;
	set var85 = var81 + cantidadv8;

	if(var85 <= var82)
	then
		if(var84 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta8,sysdate(),cliente,admin,user,nota8,cantidadv8,x8,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x8;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var85 WHERE `id` = herramienta8;
		end if;
	end if;
end if;

if(accion = 9)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
/* Prestamos 4 */
	set herramienta4 = (select herramienta from tooloan where id = x4);
	set var41 = (select existencia from herramienta where id = herramienta4);
	set var42 = (select totale from herramienta where id = herramienta4);
	set var43 = (select cantpres from tooloan where id = x4);

	set var44 = var43 - cantidadv4;
	set var45 = var41 + cantidadv4;

	if(var45 <= var42)
	then
		if(var44 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantidadv4,x4,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x4;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = herramienta4;
		end if;
	end if;
/* Prestamos 5 */
	set herramienta5 = (select herramienta from tooloan where id = x5);
	set var51 = (select existencia from herramienta where id = herramienta5);
	set var52 = (select totale from herramienta where id = herramienta5);
	set var53 = (select cantpres from tooloan where id = x5);

	set var54 = var53 - cantidadv5;
	set var55 = var51 + cantidadv5;

	if(var55 <= var52)
	then
		if(var54 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantidadv5,x5,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x5;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = herramienta5;
		end if;
	end if;
/* Prestamos 6 */
	set herramienta6 = (select herramienta from tooloan where id = x6);
	set var61 = (select existencia from herramienta where id = herramienta6);
	set var62 = (select totale from herramienta where id = herramienta6);
	set var63 = (select cantpres from tooloan where id = x6);

	set var64 = var63 - cantidadv6;
	set var65 = var61 + cantidadv6;

	if(var65 <= var62)
	then
		if(var64 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantidadv6,x6,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x6;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var65 WHERE `id` = herramienta6;
		end if;
	end if;
/* Prestamos 7 */
	set herramienta7 = (select herramienta from tooloan where id = x7);
	set var71 = (select existencia from herramienta where id = herramienta7);
	set var72 = (select totale from herramienta where id = herramienta7);
	set var73 = (select cantpres from tooloan where id = x7);

	set var74 = var73 - cantidadv7;
	set var75 = var71 + cantidadv7;

	if(var75 <= var72)
	then
		if(var74 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantidadv7,x7,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x7;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var75 WHERE `id` = herramienta7;
		end if;
	end if;
/* Prestamos 8 */
	set herramienta8 = (select herramienta from tooloan where id = x8);
	set var81 = (select existencia from herramienta where id = herramienta8);
	set var82 = (select totale from herramienta where id = herramienta8);
	set var83 = (select cantpres from tooloan where id = x8);

	set var84 = var83 - cantidadv8;
	set var85 = var81 + cantidadv8;

	if(var85 <= var82)
	then
		if(var84 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta8,sysdate(),cliente,admin,user,nota8,cantidadv8,x8,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x8;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var85 WHERE `id` = herramienta8;
		end if;
	end if;
/* Prestamos 9 */
	set herramienta9 = (select herramienta from tooloan where id = x9);
	set var91 = (select existencia from herramienta where id = herramienta9);
	set var92 = (select totale from herramienta where id = herramienta9);
	set var93 = (select cantpres from tooloan where id = x9);

	set var94 = var93 - cantidadv9;
	set var95 = var91 + cantidadv9;

	if(var95 <= var92)
	then
		if(var94 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta9,sysdate(),cliente,admin,user,nota9,cantidadv9,x9,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x9;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var95 WHERE `id` = herramienta9;
		end if;
	end if;
end if;

if(accion = 10)
then
 /* Prestamos 1 */
	set herramienta1 = (select herramienta from tooloan where id = x1);
	set var11 = (select existencia from herramienta where id = herramienta1);
	set var12 = (select totale from herramienta where id = herramienta1);
	set var13 = (select cantpres from tooloan where id = x1);

	set var14 = var13 - cantidadv1;
	set var15 = var11 + cantidadv1;

	if(var15 <= var12)
	then
		if(var14 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta1,sysdate(),cliente,admin,user,nota1,cantidadv1,x1,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x1;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = herramienta1;
		end if;
	end if;

/* Prestamos 2  */
	set herramienta2 = (select herramienta from tooloan where id = x2);
	set var21 = (select existencia from herramienta where id = herramienta2);
	set var22 = (select totale from herramienta where id = herramienta2);
	set var23 = (select cantpres from tooloan where id = x2);

	set var24 = var23 - cantidadv2;
	set var25 = var21 + cantidadv2;

	if(var25 <= var22)
	then
		if(var24 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta2,sysdate(),cliente,admin,user,nota2,cantidadv2,x2,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x2;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = herramienta2;
		end if;
	end if;
/* Prestamos 3 */
	set herramienta3 = (select herramienta from tooloan where id = x3);
	set var31 = (select existencia from herramienta where id = herramienta3);
	set var32 = (select totale from herramienta where id = herramienta3);
	set var33 = (select cantpres from tooloan where id = x3);

	set var34 = var33 - cantidadv3;
	set var35 = var31 + cantidadv3;

	if(var35 <= var32)
	then
		if(var34 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta3,sysdate(),cliente,admin,user,nota3,cantidadv3,x3,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x3;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = herramienta3;
		end if;
	end if;
/* Prestamos 4 */
	set herramienta4 = (select herramienta from tooloan where id = x4);
	set var41 = (select existencia from herramienta where id = herramienta4);
	set var42 = (select totale from herramienta where id = herramienta4);
	set var43 = (select cantpres from tooloan where id = x4);

	set var44 = var43 - cantidadv4;
	set var45 = var41 + cantidadv4;

	if(var45 <= var42)
	then
		if(var44 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta4,sysdate(),cliente,admin,user,nota4,cantidadv4,x4,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x4;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = herramienta4;
		end if;
	end if;
/* Prestamos 5 */
	set herramienta5 = (select herramienta from tooloan where id = x5);
	set var51 = (select existencia from herramienta where id = herramienta5);
	set var52 = (select totale from herramienta where id = herramienta5);
	set var53 = (select cantpres from tooloan where id = x5);

	set var54 = var53 - cantidadv5;
	set var55 = var51 + cantidadv5;

	if(var55 <= var52)
	then
		if(var54 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta5,sysdate(),cliente,admin,user,nota5,cantidadv5,x5,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x5;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = herramienta5;
		end if;
	end if;
/* Prestamos 6 */
	set herramienta6 = (select herramienta from tooloan where id = x6);
	set var61 = (select existencia from herramienta where id = herramienta6);
	set var62 = (select totale from herramienta where id = herramienta6);
	set var63 = (select cantpres from tooloan where id = x6);

	set var64 = var63 - cantidadv6;
	set var65 = var61 + cantidadv6;

	if(var65 <= var62)
	then
		if(var64 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta6,sysdate(),cliente,admin,user,nota6,cantidadv6,x6,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x6;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var65 WHERE `id` = herramienta6;
		end if;
	end if;
/* Prestamos 7 */
	set herramienta7 = (select herramienta from tooloan where id = x7);
	set var71 = (select existencia from herramienta where id = herramienta7);
	set var72 = (select totale from herramienta where id = herramienta7);
	set var73 = (select cantpres from tooloan where id = x7);

	set var74 = var73 - cantidadv7;
	set var75 = var71 + cantidadv7;

	if(var75 <= var72)
	then
		if(var74 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta7,sysdate(),cliente,admin,user,nota7,cantidadv7,x7,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x7;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var75 WHERE `id` = herramienta7;
		end if;
	end if;
/* Prestamos 8 */
	set herramienta8 = (select herramienta from tooloan where id = x8);
	set var81 = (select existencia from herramienta where id = herramienta8);
	set var82 = (select totale from herramienta where id = herramienta8);
	set var83 = (select cantpres from tooloan where id = x8);

	set var84 = var83 - cantidadv8;
	set var85 = var81 + cantidadv8;

	if(var85 <= var82)
	then
		if(var84 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta8,sysdate(),cliente,admin,user,nota8,cantidadv8,x8,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x8;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var85 WHERE `id` = herramienta8;
		end if;
	end if;
/* Prestamos 9 */
	set herramienta9 = (select herramienta from tooloan where id = x9);
	set var91 = (select existencia from herramienta where id = herramienta9);
	set var92 = (select totale from herramienta where id = herramienta9);
	set var93 = (select cantpres from tooloan where id = x9);

	set var94 = var93 - cantidadv9;
	set var95 = var91 + cantidadv9;

	if(var95 <= var92)
	then
		if(var94 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta9,sysdate(),cliente,admin,user,nota9,cantidadv9,x9,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x9;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var95 WHERE `id` = herramienta9;
		end if;
	end if;
/* Prestamos 10 */
	set herramienta10 = (select herramienta from tooloan where id = x10);
	set var101 = (select existencia from herramienta where id = herramienta10);
	set var102 = (select totale from herramienta where id = herramienta10);
	set var103 = (select cantpres from tooloan where id = x10);

	set var104 = var103 - cantidadv10;
	set var105 = var101 + cantidadv10;

	if(var105 <= var102)
	then
		if(var104 >= 0)
		then
			INSERT INTO `almacen`.`toolback`
			(`acciontback`,`herramientaback`,`fechab`,`clientesb`,`admin`,`user`,`nota`,
			`cantdev`,`idloan`,`estatus`)
			VALUES
			(3,herramienta10,sysdate(),cliente,admin,user,nota10,cantidadv10,x10,1);

			UPDATE `almacen`.`tooloan` SET `estatus` = 3 WHERE `id` = x10;
			
			UPDATE `almacen`.`herramienta` SET `existencia` = var105 WHERE `id` = herramienta10;
		end if;
	end if;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDTOOLNUNF` (`x` INT, `herramienta` VARCHAR(50), `descripcion` VARCHAR(250), `marca` INT, `modelo` VARCHAR(50), `estado` INT, `imagen` VARCHAR(50), `existencia` INT, `seccion` INT, `almacen` INT, `razon` VARCHAR(115), `cantidadunf` INT, `accion` INT)  BEGIN

declare var1 int;

if(accion = 1)
then
	INSERT INTO `almacen`.`herramienta`
	(`herramienta`,`descripcion`,`marca`,`modelo`,`estado`,`imagen`,`existencia`,`seccion`,`almace`,`estatus`)
	VALUES
	(herramienta,descripcion,marca,modelo,estado,imagen,existencia,seccion,almacen,1);

	set var1 = (select id from herramienta ORDER by id DESC LIMIT 1);
	
	INSERT INTO `almacen`.`herramientaunf`
	(`tool`,`description`,`modelo`,`imagen`,`existencia`,`marcasunf`,`estadounf`,`seccionunf`,`almacenunf`,`razon`,`cantidad`,`estatus`)
	VALUES
	(var1,var1,var1,var1,var1,var1,4,seccion,almacen,razon,cantidadunf,1);

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IUDUSUARIOS` (`U` INT, `nombre` VARCHAR(50), `apellido` VARCHAR(50), `usuario` VARCHAR(50), `pass` VARCHAR(105), `Privilegio` INT, `accion` INT)  BEGIN

if (accion = 1)
then
INSERT INTO `almacen`.`usuarios`
(
`Nombre`,
`Apellido`,
`Usuario`,
`Password`,
`Privilegio`)
VALUES
(
nombre,
apellido,
usuario,
pass,
Privilegio);
end if;

if (accion = 2)
then
UPDATE `almacen`.`usuarios`
SET
`Id` = U,
`Nombre` = nombre,
`Apellido` = apellido,
`Usuario` = usuario,
`Privilegio` = Privilegio
WHERE `Id` = U;
end if;

if (accion = 3)
then
UPDATE `almacen`.`usuarios`
SET
`Privilegio` = Privilegio
WHERE `Id` = U;
end if;

if (accion = 4)
then
UPDATE `almacen`.`usuarios`
SET
`Password` = pass
WHERE `Id` = U;
end if;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MUDBAJASa` (`admin` INT, `user` INT, `cliente` INT, `idm1` INT, `datob1` INT, `coment1` VARCHAR(330), `modelo1` INT, `idm2` INT, `datob2` INT, `coment2` VARCHAR(330), `modelo2` INT, `idm3` INT, `datob3` INT, `coment3` VARCHAR(330), `modelo3` INT, `idm4` INT, `datob4` INT, `coment4` VARCHAR(330), `modelo4` INT, `idm5` INT, `datob5` INT, `coment5` VARCHAR(330), `modelo5` INT, `idm6` INT, `datob6` INT, `coment6` VARCHAR(330), `modelo6` INT, `idm7` INT, `datob7` INT, `coment7` VARCHAR(330), `modelo7` INT, `idm8` INT, `datob8` INT, `coment8` VARCHAR(330), `modelo8` INT, `idm9` INT, `datob9` INT, `coment9` VARCHAR(330), `modelo9` INT, `idm10` INT, `datob10` INT, `coment10` VARCHAR(330), `modelo10` INT, `accion` INT)  BEGIN

declare var11 int;
declare var12 int;
declare var13 int;
declare var14 int;

declare var21 int;
declare var22 int;
declare var23 int;
declare var24 int;

declare var31 int;
declare var32 int;
declare var33 int;
declare var34 int;

declare var41 int;
declare var42 int;
declare var43 int;
declare var44 int;

declare var51 int;
declare var52 int;
declare var53 int;
declare var54 int;

declare var61 int;
declare var62 int;
declare var63 int;
declare var64 int;

declare var71 int;
declare var72 int;
declare var73 int;
declare var74 int;

declare var81 int;
declare var82 int;
declare var83 int;
declare var84 int;

declare var91 int;
declare var92 int;
declare var93 int;
declare var94 int;

declare var101 int;
declare var102 int;
declare var103 int;
declare var104 int;

if(accion = 1)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
end if;

if(accion = 2)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;
end if;

if(accion = 3)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;
end if;

if(accion = 4)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

/* Seccion 4*/
	if(datob4 > 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = datob4 + var41;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 < 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = var41 + datob4;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;
end if;

if(accion = 5)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

/* Seccion 4*/
	if(datob4 > 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = datob4 + var41;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 < 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = var41 + datob4;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

/* Seccion 5*/
	if(datob5 > 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = datob5 + var51;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 < 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = var51 + datob5;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;
end if;

if(accion = 6)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

/* Seccion 4*/
	if(datob4 > 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = datob4 + var41;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 < 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = var41 + datob4;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

/* Seccion 5*/
	if(datob5 > 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = datob5 + var51;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 < 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = var51 + datob5;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;
/* Seccion 6*/
	if(datob6 > 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = datob6 + var61;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;

	if(datob6 < 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = var61 + datob6;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;

	if(datob6 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment6
		WHERE `id` = idm6;
	end if;
end if;

if(accion = 7)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

/* Seccion 4*/
	if(datob4 > 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = datob4 + var41;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 < 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = var41 + datob4;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

/* Seccion 5*/
	if(datob5 > 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = datob5 + var51;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 < 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = var51 + datob5;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;
/* Seccion 6*/
	if(datob6 > 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = datob6 + var61;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;

	if(datob6 < 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = var61 + datob6;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;
/* Seccion 7*/
	if(datob7 > 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = datob7 + var71;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 < 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = var71 + datob7;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment7
		WHERE `id` = idm7;
	end if;
end if;

if(accion = 8)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

/* Seccion 4*/
	if(datob4 > 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = datob4 + var41;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 < 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = var41 + datob4;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

/* Seccion 5*/
	if(datob5 > 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = datob5 + var51;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 < 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = var51 + datob5;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;
/* Seccion 6*/
	if(datob6 > 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = datob6 + var61;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;

	if(datob6 < 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = var61 + datob6;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;
/* Seccion 7*/
	if(datob7 > 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = datob7 + var71;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 < 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = var71 + datob7;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment7
		WHERE `id` = idm7;
	end if;

/* Seccion 8*/
	if(datob8 > 0)
	then 
		set var81 = (select cantidad from bajas where id = idm8);
		set var82 = (select cantidad from mercancia where id = modelo8);
		set var83 = datob8 + var81;
		set var84 = var82 - datob8;

		if(var84 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var84 WHERE `id` = modelo8;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var83,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment8
			WHERE `id` = idm8;
		end if;
	end if;

	if(datob8 < 0)
	then 
		set var81 = (select cantidad from bajas where id = idm8);
		set var82 = (select cantidad from mercancia where id = modelo8);
		set var83 = var81 + datob8;
		set var84 = var82 - datob8;

		if(var84 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var84 WHERE `id` = modelo8;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var83,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment8
			WHERE `id` = idm8;
		end if;
	end if;

	if(datob8 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment8
		WHERE `id` = idm8;
	end if;
end if;

if(accion = 9)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

/* Seccion 4*/
	if(datob4 > 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = datob4 + var41;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 < 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = var41 + datob4;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

/* Seccion 5*/
	if(datob5 > 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = datob5 + var51;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 < 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = var51 + datob5;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;
/* Seccion 6*/
	if(datob6 > 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = datob6 + var61;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;

	if(datob6 < 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = var61 + datob6;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;
/* Seccion 7*/
	if(datob7 > 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = datob7 + var71;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 < 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = var71 + datob7;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment7
		WHERE `id` = idm7;
	end if;

/* Seccion 8*/
	if(datob8 > 0)
	then 
		set var81 = (select cantidad from bajas where id = idm8);
		set var82 = (select cantidad from mercancia where id = modelo8);
		set var83 = datob8 + var81;
		set var84 = var82 - datob8;

		if(var84 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var84 WHERE `id` = modelo8;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var83,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment8
			WHERE `id` = idm8;
		end if;
	end if;

	if(datob8 < 0)
	then 
		set var81 = (select cantidad from bajas where id = idm8);
		set var82 = (select cantidad from mercancia where id = modelo8);
		set var83 = var81 + datob8;
		set var84 = var82 - datob8;

		if(var84 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var84 WHERE `id` = modelo8;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var83,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment8
			WHERE `id` = idm8;
		end if;
	end if;

	if(datob8 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment8
		WHERE `id` = idm8;
	end if;

/* Seccion 9*/
	if(datob9 > 0)
	then 
		set var91 = (select cantidad from bajas where id = idm9);
		set var92 = (select cantidad from mercancia where id = modelo9);
		set var93 = datob9 + var91;
		set var94 = var92 - datob9;

		if(var94 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var94 WHERE `id` = modelo9;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var93,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment9
			WHERE `id` = idm9;
		end if;
	end if;

	if(datob9 < 0)
	then 
		set var91 = (select cantidad from bajas where id = idm9);
		set var92 = (select cantidad from mercancia where id = modelo9);
		set var93 = var91 + datob9;
		set var94 = var92 - datob9;

		if(var94 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var94 WHERE `id` = modelo9;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var93,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment9
			WHERE `id` = idm9;
		end if;
	end if;

	if(datob9 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment9
		WHERE `id` = idm9;
	end if;
end if;

if(accion = 10)
then
	if(datob1 > 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = datob1 + var11;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 < 0)
	then 
		set var11 = (select cantidad from bajas where id = idm1);
		set var12 = (select cantidad from mercancia where id = modelo1);
		set var13 = var11 + datob1;
		set var14 = var12 - datob1;

		if(var14 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var14 WHERE `id` = modelo1;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var13,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment1
			WHERE `id` = idm1;
		end if;
	end if;

	if(datob1 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
/* Seccion 2*/
	if(datob2 > 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = datob2 + var21;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 < 0)
	then 
		set var21 = (select cantidad from bajas where id = idm2);
		set var22 = (select cantidad from mercancia where id = modelo2);
		set var23 = var21 + datob2;
		set var24 = var22 - datob2;

		if(var24 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var24 WHERE `id` = modelo2;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var23,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment2
			WHERE `id` = idm2;
		end if;
	end if;

	if(datob2 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

/* Seccion 3*/
	if(datob3 > 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = datob3 + var31;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 < 0)
	then 
		set var31 = (select cantidad from bajas where id = idm3);
		set var32 = (select cantidad from mercancia where id = modelo3);
		set var33 = var31 + datob3;
		set var34 = var32 - datob3;

		if(var34 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var34 WHERE `id` = modelo3;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var33,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment3
			WHERE `id` = idm3;
		end if;
	end if;

	if(datob3 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

/* Seccion 4*/
	if(datob4 > 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = datob4 + var41;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 < 0)
	then 
		set var41 = (select cantidad from bajas where id = idm4);
		set var42 = (select cantidad from mercancia where id = modelo4);
		set var43 = var41 + datob4;
		set var44 = var42 - datob4;

		if(var44 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var44 WHERE `id` = modelo4;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var43,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment4
			WHERE `id` = idm4;
		end if;
	end if;

	if(datob4 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

/* Seccion 5*/
	if(datob5 > 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = datob5 + var51;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 < 0)
	then 
		set var51 = (select cantidad from bajas where id = idm5);
		set var52 = (select cantidad from mercancia where id = modelo5);
		set var53 = var51 + datob5;
		set var54 = var52 - datob5;

		if(var54 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var54 WHERE `id` = modelo5;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var53,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment5
			WHERE `id` = idm5;
		end if;
	end if;

	if(datob5 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;
/* Seccion 6*/
	if(datob6 > 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = datob6 + var61;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;

	if(datob6 < 0)
	then 
		set var61 = (select cantidad from bajas where id = idm6);
		set var62 = (select cantidad from mercancia where id = modelo6);
		set var63 = var61 + datob6;
		set var64 = var62 - datob6;

		if(var64 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var64 WHERE `id` = modelo6;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var63,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment6
			WHERE `id` = idm6;
		end if;
	end if;
/* Seccion 7*/
	if(datob7 > 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = datob7 + var71;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 < 0)
	then 
		set var71 = (select cantidad from bajas where id = idm7);
		set var72 = (select cantidad from mercancia where id = modelo7);
		set var73 = var71 + datob7;
		set var74 = var72 - datob7;

		if(var74 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var74 WHERE `id` = modelo7;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var73,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment7
			WHERE `id` = idm7;
		end if;
	end if;

	if(datob7 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment7
		WHERE `id` = idm7;
	end if;

/* Seccion 8*/
	if(datob8 > 0)
	then 
		set var81 = (select cantidad from bajas where id = idm8);
		set var82 = (select cantidad from mercancia where id = modelo8);
		set var83 = datob8 + var81;
		set var84 = var82 - datob8;

		if(var84 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var84 WHERE `id` = modelo8;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var83,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment8
			WHERE `id` = idm8;
		end if;
	end if;

	if(datob8 < 0)
	then 
		set var81 = (select cantidad from bajas where id = idm8);
		set var82 = (select cantidad from mercancia where id = modelo8);
		set var83 = var81 + datob8;
		set var84 = var82 - datob8;

		if(var84 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var84 WHERE `id` = modelo8;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var83,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment8
			WHERE `id` = idm8;
		end if;
	end if;

	if(datob8 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment8
		WHERE `id` = idm8;
	end if;

/* Seccion 9*/
	if(datob9 > 0)
	then 
		set var91 = (select cantidad from bajas where id = idm9);
		set var92 = (select cantidad from mercancia where id = modelo9);
		set var93 = datob9 + var91;
		set var94 = var92 - datob9;

		if(var94 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var94 WHERE `id` = modelo9;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var93,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment9
			WHERE `id` = idm9;
		end if;
	end if;

	if(datob9 < 0)
	then 
		set var91 = (select cantidad from bajas where id = idm9);
		set var92 = (select cantidad from mercancia where id = modelo9);
		set var93 = var91 + datob9;
		set var94 = var92 - datob9;

		if(var94 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var94 WHERE `id` = modelo9;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var93,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment9
			WHERE `id` = idm9;
		end if;
	end if;

	if(datob9 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment9
		WHERE `id` = idm9;
	end if;	
/* Seccion 10*/
	if(datob10 > 0)
	then 
		set var101 = (select cantidad from bajas where id = idm10);
		set var102 = (select cantidad from mercancia where id = modelo10);
		set var103 = datob10 + var101;
		set var104 = var102 - datob10;

		if(var104 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var104 WHERE `id` = modelo10;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var103,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment10
			WHERE `id` = idm10;
		end if;
	end if;

	if(datob10 < 0)
	then 
		set var101 = (select cantidad from bajas where id = idm10);
		set var102 = (select cantidad from mercancia where id = modelo10);
		set var103 = var101 + datob10;
		set var104 = var102 - datob10;

		if(var104 > 0)
		then
			UPDATE `almacen`.`mercancia` SET `cantidad` = var104 WHERE `id` = modelo10;
			
			UPDATE `almacen`.`bajas`
			SET
			`cantidad` = var103,
			`usuarioa` = admin,
			`usuariob` = user,
			`cliente` = cliente,
			`comentario` = coment10
			WHERE `id` = idm10;
		end if;
	end if;

	if(datob10 = 0)
	then 
		UPDATE `almacen`.`bajas`
		SET
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment10
		WHERE `id` = idm10;
	end if;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MUDBAJASb` (`admin` INT, `user` INT, `cliente` INT, `idm1` INT, `datob1` INT, `coment1` VARCHAR(330), `modelo1` INT, `idm2` INT, `datob2` INT, `coment2` VARCHAR(330), `modelo2` INT, `idm3` INT, `datob3` INT, `coment3` VARCHAR(330), `modelo3` INT, `idm4` INT, `datob4` INT, `coment4` VARCHAR(330), `modelo4` INT, `idm5` INT, `datob5` INT, `coment5` VARCHAR(330), `modelo5` INT, `accion` INT)  BEGIN

declare datan1 int;
declare op1 int;
declare datmer1 int;
declare result1 int;

declare datan2 int;
declare op2 int;
declare datmer2 int;
declare result2 int;

declare datan3 int;
declare op3 int;
declare datmer3 int;
declare result3 int;

declare datan4 int;
declare op4 int;
declare datmer4 int;
declare result4 int;

declare datan5 int;
declare op5 int;
declare datmer5 int;
declare result5 int;

if(accion = 1)
then
	set datan1 = (select cantidad from bajas where id = idm1);
	

	if(datan1 > datob1)
	then 
		set op1 = datan1 - datob1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 + op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 < datob1)
	then 
		set op1 = datob1 - datan1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 - op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 = datob1)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;
end if;

if(accion = 2)
then
	set datan1 = (select cantidad from bajas where id = idm1);
	

	if(datan1 > datob1)
	then 
		set op1 = datan1 - datob1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 + op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 < datob1)
	then 
		set op1 = datob1 - datan1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 - op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 = datob1)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	set datan2 = (select cantidad from bajas where id = idm2);
	

	if(datan2 > datob2)
	then 
		set op2 = datan2 - datob2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 + op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 < datob2)
	then 
		set op2 = datob2 - datan2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 - op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 = datob2)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;
end if;

if(accion = 3)
then
	set datan1 = (select cantidad from bajas where id = idm1);
	

	if(datan1 > datob1)
	then 
		set op1 = datan1 - datob1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 + op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 < datob1)
	then 
		set op1 = datob1 - datan1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 - op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 = datob1)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	set datan2 = (select cantidad from bajas where id = idm2);
	

	if(datan2 > datob2)
	then 
		set op2 = datan2 - datob2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 + op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 < datob2)
	then 
		set op2 = datob2 - datan2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 - op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 = datob2)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	set datan3 = (select cantidad from bajas where id = idm3);

	if(datan3 > datob3)
	then 
		set op3 = datan3 - datob3;
		set datmer3 = (select cantidad from mercancia where id = modelo3);
		set result3 = datmer3 + op3;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result3 WHERE `id` = modelo3;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	if(datan3 < datob3)
	then 
		set op3 = datob3 - datan3;
		set datmer3 = (select cantidad from mercancia where id = modelo3);
		set result3 = datmer3 - op3;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result3 WHERE `id` = modelo3;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	if(datan3 = datob3)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;
end if;

if(accion = 4)
then
	set datan1 = (select cantidad from bajas where id = idm1);
	

	if(datan1 > datob1)
	then 
		set op1 = datan1 - datob1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 + op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 < datob1)
	then 
		set op1 = datob1 - datan1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 - op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 = datob1)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	set datan2 = (select cantidad from bajas where id = idm2);
	

	if(datan2 > datob2)
	then 
		set op2 = datan2 - datob2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 + op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 < datob2)
	then 
		set op2 = datob2 - datan2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 - op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 = datob2)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	set datan3 = (select cantidad from bajas where id = idm3);

	if(datan3 > datob3)
	then 
		set op3 = datan3 - datob3;
		set datmer3 = (select cantidad from mercancia where id = modelo3);
		set result3 = datmer3 + op3;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result3 WHERE `id` = modelo3;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	if(datan3 < datob3)
	then 
		set op3 = datob3 - datan3;
		set datmer3 = (select cantidad from mercancia where id = modelo3);
		set result3 = datmer3 - op3;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result3 WHERE `id` = modelo3;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	if(datan3 = datob3)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	set datan4 = (select cantidad from bajas where id = idm4);

	if(datan4 > datob4)
	then 
		set op4 = datan4 - datob4;
		set datmer4 = (select cantidad from mercancia where id = modelo4);
		set result4 = datmer4 + op4;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result4 WHERE `id` = modelo4;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob4,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

	if(datan4 < datob4)
	then 
		set op4 = datob4 - datan4;
		set datmer4 = (select cantidad from mercancia where id = modelo4);
		set result4 = datmer4 - op4;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result4 WHERE `id` = modelo4;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob4,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

	if(datan4 = datob4)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob4,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;
end if;

if(accion = 4)
then
	set datan1 = (select cantidad from bajas where id = idm1);
	

	if(datan1 > datob1)
	then 
		set op1 = datan1 - datob1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 + op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 < datob1)
	then 
		set op1 = datob1 - datan1;
		set datmer1 = (select cantidad from mercancia where id = modelo1);
		set result1 = datmer1 - op1;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result1 WHERE `id` = modelo1;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	if(datan1 = datob1)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob1,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment1
		WHERE `id` = idm1;
	end if;

	set datan2 = (select cantidad from bajas where id = idm2);
	

	if(datan2 > datob2)
	then 
		set op2 = datan2 - datob2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 + op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 < datob2)
	then 
		set op2 = datob2 - datan2;
		set datmer2 = (select cantidad from mercancia where id = modelo2);
		set result2 = datmer2 - op2;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result2 WHERE `id` = modelo2;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	if(datan2 = datob2)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob2,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment2
		WHERE `id` = idm2;
	end if;

	set datan3 = (select cantidad from bajas where id = idm3);

	if(datan3 > datob3)
	then 
		set op3 = datan3 - datob3;
		set datmer3 = (select cantidad from mercancia where id = modelo3);
		set result3 = datmer3 + op3;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result3 WHERE `id` = modelo3;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	if(datan3 < datob3)
	then 
		set op3 = datob3 - datan3;
		set datmer3 = (select cantidad from mercancia where id = modelo3);
		set result3 = datmer3 - op3;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result3 WHERE `id` = modelo3;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	if(datan3 = datob3)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob3,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment3
		WHERE `id` = idm3;
	end if;

	set datan4 = (select cantidad from bajas where id = idm4);

	if(datan4 > datob4)
	then 
		set op4 = datan4 - datob4;
		set datmer4 = (select cantidad from mercancia where id = modelo4);
		set result4 = datmer4 + op4;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result4 WHERE `id` = modelo4;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob4,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

	if(datan4 < datob4)
	then 
		set op4 = datob4 - datan4;
		set datmer4 = (select cantidad from mercancia where id = modelo4);
		set result4 = datmer4 - op4;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result4 WHERE `id` = modelo4;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob4,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

	if(datan4 = datob4)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob4,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment4
		WHERE `id` = idm4;
	end if;

	set datan5 = (select cantidad from bajas where id = idm5);

	if(datan5 > datob5)
	then 
		set op5 = datan5 - datob5;
		set datmer5 = (select cantidad from mercancia where id = modelo5);
		set result5 = datmer5 + op5;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result5 WHERE `id` = modelo5;
		
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob5,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;

	if(datan5 < datob5)
	then 
		set op5 = datob5 - datan5;
		set datmer5 = (select cantidad from mercancia where id = modelo5);
		set result5 = datmer5 - op5;

		UPDATE `almacen`.`mercancia` SET `cantidad` = result5 WHERE `id` = modelo5;

		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob5,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;

	if(datan5 = datob5)
	then
		UPDATE `almacen`.`bajas`
		SET
		`cantidad` = datob5,
		`usuarioa` = admin,
		`usuariob` = user,
		`cliente` = cliente,
		`comentario` = coment5
		WHERE `id` = idm5;
	end if;
end if;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MUDLOAN` (`cliente` INT, `usuario` INT, `x1` INT, `cantsr1` INT, `comentario1` VARCHAR(150), `x2` INT, `cantsr2` INT, `comentario2` VARCHAR(150), `x3` INT, `cantsr3` INT, `comentario3` VARCHAR(150), `x4` INT, `cantsr4` INT, `comentario4` VARCHAR(150), `x5` INT, `cantsr5` INT, `comentario5` VARCHAR(150), `accion` INT)  BEGIN

declare var11 int; 
declare var12 int;
declare var13 int; 
declare var14 int;
declare var15 int;
declare var16 int;

declare var21 int;
declare var22 int;
declare var23 int;
declare var24 int;
declare var25 int;
declare var26 int;

declare var31 int;
declare var32 int;
declare var33 int;
declare var34 int;
declare var35 int;
declare var36 int;

declare var41 int;
declare var42 int;
declare var43 int;
declare var44 int;
declare var45 int;
declare var46 int;

declare var51 int;
declare var52 int;
declare var53 int;
declare var54 int;
declare var55 int;  
declare var56 int;

if(accion = 1)
then 
	if(cantsr1 > 0)
	then
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;

		if(var15 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario1,
			`cantpres` = var16
			WHERE `id` = x1;

			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
		end if;
	end if;

	if(cantsr1 < 0)
	then 
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;
		
		if(var13 >= var15)
		then 
			if(var16 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario1,
				`cantpres` = var16
				WHERE `id` = x1;

				UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
			end if;
		end if;
	end if;

	if(cantsr1 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario1
		WHERE `id` = x1;

	end if;
end if; 

if(accion = 2)
then 
	if(cantsr1 > 0)
	then
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;

		if(var15 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario1,
			`cantpres` = var16
			WHERE `id` = x1;

			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
		end if;
	end if;

	if(cantsr1 < 0)
	then 
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;
		
		if(var13 >= var15)
		then 
			if(var16 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario1,
				`cantpres` = var16
				WHERE `id` = x1;

				UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
			end if;
		end if;
	end if;

	if(cantsr1 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario1
		WHERE `id` = x1;

	end if;

/*Seccion 2*/
	if(cantsr2 > 0)
	then
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;

		if(var25 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario2,
			`cantpres` = var26
			WHERE `id` = x2;

			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
		end if;
	end if;

	if(cantsr2 < 0)
	then 
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;
		
		if(var23 >= var25)
		then 
			if(var26 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario2,
				`cantpres` = var26
				WHERE `id` = x2;

				UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
			end if;
		end if;
	end if;

	if(cantsr2 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario2
		WHERE `id` = x2;

	end if;
end if;

if(accion = 3)
then 
	if(cantsr1 > 0)
	then
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;

		if(var15 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario1,
			`cantpres` = var16
			WHERE `id` = x1;

			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
		end if;
	end if;

	if(cantsr1 < 0)
	then 
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;
		
		if(var13 >= var15)
		then 
			if(var16 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario1,
				`cantpres` = var16
				WHERE `id` = x1;

				UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
			end if;
		end if;
	end if;

	if(cantsr1 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario1
		WHERE `id` = x1;

	end if;

/*Seccion 2*/
	if(cantsr2 > 0)
	then
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;

		if(var25 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario2,
			`cantpres` = var26
			WHERE `id` = x2;

			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
		end if;
	end if;

	if(cantsr2 < 0)
	then 
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;
		
		if(var23 >= var25)
		then 
			if(var26 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario2,
				`cantpres` = var26
				WHERE `id` = x2;

				UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
			end if;
		end if;
	end if;

	if(cantsr2 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario2
		WHERE `id` = x2;

	end if;

/*Seccion 3*/
	if(cantsr3 > 0)
	then
		set var31 = (select herramienta from tooloan where id = x3);
		set var32 = (select existencia from herramienta where id = var31);
		set var33 = (select totale from herramienta where id = var31);
		set var34 = (select cantpres from tooloan where id = x3);

		set var35 = var32 - cantsr3;
		set var36 = var34 + cantsr3;

		if(var35 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario3,
			`cantpres` = var36
			WHERE `id` = x3;

			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = var31;
		end if;
	end if;

	if(cantsr3 < 0)
	then 
		set var31 = (select herramienta from tooloan where id = x3);
		set var32 = (select existencia from herramienta where id = var31);
		set var33 = (select totale from herramienta where id = var31);
		set var34 = (select cantpres from tooloan where id = x3);

		set var35 = var32 - cantsr3;
		set var36 = var34 + cantsr3;
		
		if(var33 >= var35)
		then 
			if(var36 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario3,
				`cantpres` = var36
				WHERE `id` = x3;

				UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = var31;
			end if;
		end if;
	end if;

	if(cantsr3 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario3
		WHERE `id` = x3;
	end if;
end if;

if(accion = 4)
then
	if(cantsr1 > 0)
	then
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;

		if(var15 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario1,
			`cantpres` = var16
			WHERE `id` = x1;

			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
		end if;
	end if;

	if(cantsr1 < 0)
	then 
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;
		
		if(var13 >= var15)
		then 
			if(var16 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario1,
				`cantpres` = var16
				WHERE `id` = x1;

				UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
			end if;
		end if;
	end if;

	if(cantsr1 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario1
		WHERE `id` = x1;

	end if;

/*Seccion 2*/
	if(cantsr2 > 0)
	then
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;

		if(var25 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario2,
			`cantpres` = var26
			WHERE `id` = x2;

			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
		end if;
	end if;

	if(cantsr2 < 0)
	then 
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;
		
		if(var23 >= var25)
		then 
			if(var26 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario2,
				`cantpres` = var26
				WHERE `id` = x2;

				UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
			end if;
		end if;
	end if;

	if(cantsr2 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario2
		WHERE `id` = x2;

	end if;

/*Seccion 3*/
	if(cantsr3 > 0)
	then
		set var31 = (select herramienta from tooloan where id = x3);
		set var32 = (select existencia from herramienta where id = var31);
		set var33 = (select totale from herramienta where id = var31);
		set var34 = (select cantpres from tooloan where id = x3);

		set var35 = var32 - cantsr3;
		set var36 = var34 + cantsr3;

		if(var35 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario3,
			`cantpres` = var36
			WHERE `id` = x3;

			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = var31;
		end if;
	end if;

	if(cantsr3 < 0)
	then 
		set var31 = (select herramienta from tooloan where id = x3);
		set var32 = (select existencia from herramienta where id = var31);
		set var33 = (select totale from herramienta where id = var31);
		set var34 = (select cantpres from tooloan where id = x3);

		set var35 = var32 - cantsr3;
		set var36 = var34 + cantsr3;
		
		if(var33 >= var35)
		then 
			if(var36 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario3,
				`cantpres` = var36
				WHERE `id` = x3;

				UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = var31;
			end if;
		end if;
	end if;

	if(cantsr3 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario3
		WHERE `id` = x3;
	end if;

/*Seccion 4*/
	if(cantsr4 > 0)
	then
		set var41 = (select herramienta from tooloan where id = x4);
		set var42 = (select existencia from herramienta where id = var41);
		set var43 = (select totale from herramienta where id = var41);
		set var44 = (select cantpres from tooloan where id = x4);

		set var45 = var42 - cantsr4;
		set var46 = var44 + cantsr4;

		if(var45 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario4,
			`cantpres` = var46
			WHERE `id` = x4;

			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = var41;
		end if;
	end if;

	if(cantsr4 < 0)
	then 
		set var41 = (select herramienta from tooloan where id = x4);
		set var42 = (select existencia from herramienta where id = var41);
		set var43 = (select totale from herramienta where id = var41);
		set var44 = (select cantpres from tooloan where id = x4);

		set var45 = var32 - cantsr4;
		set var46 = var34 + cantsr4;
		
		if(var43 >= var45)
		then 
			if(var46 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario4,
				`cantpres` = var46
				WHERE `id` = x4;

				UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = var41;
			end if;
		end if;
	end if;

	if(cantsr4 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario4
		WHERE `id` = x4;
	end if;
end if;

if(accion = 5)
then 
	if(cantsr1 > 0)
	then
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;

		if(var15 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario1,
			`cantpres` = var16
			WHERE `id` = x1;

			UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
		end if;
	end if;

	if(cantsr1 < 0)
	then 
		set var11 = (select herramienta from tooloan where id = x1);
		set var12 = (select existencia from herramienta where id = var11);
		set var13 = (select totale from herramienta where id = var11);
		set var14 = (select cantpres from tooloan where id = x1);

		set var15 = var12 - cantsr1;
		set var16 = var14 + cantsr1;
		
		if(var13 >= var15)
		then 
			if(var16 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario1,
				`cantpres` = var16
				WHERE `id` = x1;

				UPDATE `almacen`.`herramienta` SET `existencia` = var15 WHERE `id` = var11;
			end if;
		end if;
	end if;

	if(cantsr1 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario1
		WHERE `id` = x1;

	end if;

/*Seccion 2*/
	if(cantsr2 > 0)
	then
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;

		if(var25 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario2,
			`cantpres` = var26
			WHERE `id` = x2;

			UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
		end if;
	end if;

	if(cantsr2 < 0)
	then 
		set var21 = (select herramienta from tooloan where id = x2);
		set var22 = (select existencia from herramienta where id = var21);
		set var23 = (select totale from herramienta where id = var21);
		set var24 = (select cantpres from tooloan where id = x2);

		set var25 = var22 - cantsr2;
		set var26 = var24 + cantsr2;
		
		if(var23 >= var25)
		then 
			if(var26 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario2,
				`cantpres` = var26
				WHERE `id` = x2;

				UPDATE `almacen`.`herramienta` SET `existencia` = var25 WHERE `id` = var21;
			end if;
		end if;
	end if;

	if(cantsr2 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario2
		WHERE `id` = x2;

	end if;

/*Seccion 3*/
	if(cantsr3 > 0)
	then
		set var31 = (select herramienta from tooloan where id = x3);
		set var32 = (select existencia from herramienta where id = var31);
		set var33 = (select totale from herramienta where id = var31);
		set var34 = (select cantpres from tooloan where id = x3);

		set var35 = var32 - cantsr3;
		set var36 = var34 + cantsr3;

		if(var35 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario3,
			`cantpres` = var36
			WHERE `id` = x3;

			UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = var31;
		end if;
	end if;

	if(cantsr3 < 0)
	then 
		set var31 = (select herramienta from tooloan where id = x3);
		set var32 = (select existencia from herramienta where id = var31);
		set var33 = (select totale from herramienta where id = var31);
		set var34 = (select cantpres from tooloan where id = x3);

		set var35 = var32 - cantsr3;
		set var36 = var34 + cantsr3;
		
		if(var33 >= var35)
		then 
			if(var36 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario3,
				`cantpres` = var36
				WHERE `id` = x3;

				UPDATE `almacen`.`herramienta` SET `existencia` = var35 WHERE `id` = var31;
			end if;
		end if;
	end if;

	if(cantsr3 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario3
		WHERE `id` = x3;
	end if;

/*Seccion 4*/
	if(cantsr4 > 0)
	then
		set var41 = (select herramienta from tooloan where id = x4);
		set var42 = (select existencia from herramienta where id = var41);
		set var43 = (select totale from herramienta where id = var41);
		set var44 = (select cantpres from tooloan where id = x4);

		set var45 = var42 - cantsr4;
		set var46 = var44 + cantsr4;

		if(var45 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario4,
			`cantpres` = var46
			WHERE `id` = x4;

			UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = var41;
		end if;
	end if;

	if(cantsr4 < 0)
	then 
		set var41 = (select herramienta from tooloan where id = x4);
		set var42 = (select existencia from herramienta where id = var41);
		set var43 = (select totale from herramienta where id = var41);
		set var44 = (select cantpres from tooloan where id = x4);

		set var45 = var42 - cantsr4;
		set var46 = var44 + cantsr4;
		
		if(var43 >= var45)
		then 
			if(var46 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario4,
				`cantpres` = var46
				WHERE `id` = x4;

				UPDATE `almacen`.`herramienta` SET `existencia` = var45 WHERE `id` = var41;
			end if;
		end if;
	end if;

	if(cantsr4 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario4
		WHERE `id` = x4;
	end if;

/*Seccion 5*/
	if(cantsr5 > 0)
	then
		set var51 = (select herramienta from tooloan where id = x5);
		set var52 = (select existencia from herramienta where id = var51);
		set var53 = (select totale from herramienta where id = var51);
		set var54 = (select cantpres from tooloan where id = x5);

		set var55 = var52 - cantsr5;
		set var56 = var54 + cantsr5;

		if(var55 >= 0)
		then 
			UPDATE `almacen`.`tooloan`
			SET
			`clientes` = cliente,
			`usuariouser` = usuario,
			`nota` = comentario5,
			`cantpres` = var56
			WHERE `id` = x5;

			UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = var51;
		end if;
	end if;

	if(cantsr5 < 0)
	then 
		set var51 = (select herramienta from tooloan where id = x5);
		set var52 = (select existencia from herramienta where id = var51);
		set var53 = (select totale from herramienta where id = var51);
		set var54 = (select cantpres from tooloan where id = x5);

		set var55 = var52 - cantsr5;
		set var56 = var54 + cantsr5;
		
		if(var53 >= var55)
		then 
			if(var56 >= 0)
			then
				UPDATE `almacen`.`tooloan`
				SET
				`clientes` = cliente,
				`usuariouser` = usuario,
				`nota` = comentario5,
				`cantpres` = var56
				WHERE `id` = x5;

				UPDATE `almacen`.`herramienta` SET `existencia` = var55 WHERE `id` = var51;
			end if;
		end if;
	end if;

	if(cantsr5 = 0)
	then 
		UPDATE `almacen`.`tooloan`
		SET
		`clientes` = cliente,
		`usuariouser` = usuario,
		`nota` = comentario5
		WHERE `id` = x5;
	end if;
end if; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MUDRMA` (`idrma` INT, `norden` INT, `proveedor` INT, `cliente` INT, `productox` VARCHAR(50), `modelox` VARCHAR(50), `seriex` VARCHAR(50), `razon` VARCHAR(150), `dateig` DATE, `ec` INT, `dtinstalacion` DATE, `dtregreso` DATE, `dtenvio` DATE, `rmap` VARCHAR(45), `accion` INT)  BEGIN

if(accion = 1)
then 
	UPDATE `almacen`.`rma` 
	SET `numeroorden` = norden, `clientesrma` = cliente, `producto` = productox, 
		`modelo` = modelox, `serie` = seriex, `descripcion` = razon, 
		`fechaingreso` = dateig, `fechaenvio` = dtenvio,  `fecharegreso` = dtregreso,
		`fechainstalacion` = dtinstalacion, `proveedorrma` = proveedor, `estatus` = 1,
		`resultrmat` = ec, `rmaproveedor` =  rmap
	WHERE `id` = idrma;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mudtoolback` (`cliente` INT, `usuario` INT, `x1` INT, `comentario1` VARCHAR(150), `x2` INT, `comentario2` VARCHAR(150), `x3` INT, `comentario3` VARCHAR(150), `x4` INT, `comentario4` VARCHAR(150), `x5` INT, `comentario5` VARCHAR(150), `accion` INT)  BEGIN

if(accion = 1)
then 
	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario1 WHERE `id` = x1;
end if;

if(accion = 2)
then 
	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario1 WHERE `id` = x1;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario2 WHERE `id` = x2;
end if;

if(accion = 3)
then 
	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario1 WHERE `id` = x1;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario2 WHERE `id` = x2;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario3 WHERE `id` = x3;
end if;

if(accion = 4)
then
	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario1 WHERE `id` = x1;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario2 WHERE `id` = x2;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario3 WHERE `id` = x3;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario4 WHERE `id` = x4;
end if;

if(accion = 5)
then
	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario1 WHERE `id` = x1;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario2 WHERE `id` = x2;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario3 WHERE `id` = x3;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario4 WHERE `id` = x4;

	UPDATE `almacen`.`toolback` 
	SET `clientesb` = cliente, `user` = usuario, `nota` = comentario5 WHERE `id` = x5;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prueba` (`s` INT)  BEGIN


declare val int;

set val = (select cantidad from mercancia where id = `s`);

select val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `YANOEMAIL` (`x` INT, `accion` INT)  BEGIN

if(accion = 1)
then 
UPDATE `almacen`.`rma` SET `aviso` = 1 WHERE `id` = x;
end if;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `accion`
--

CREATE TABLE `accion` (
  `id` int(11) NOT NULL,
  `accion` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `accion`
--

INSERT INTO `accion` (`id`, `accion`, `estatus`) VALUES
(1, 'Alta', 1),
(2, 'Baja', 1),
(3, 'Prestamo', 1),
(4, 'Devolucion', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen`
--

CREATE TABLE `almacen` (
  `id` int(11) NOT NULL,
  `almacen` varchar(45) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen`
--

INSERT INTO `almacen` (`id`, `almacen`, `estatus`) VALUES
(1, 'Almacen 1', 1),
(2, 'Almacen 2', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `altas`
--

CREATE TABLE `altas` (
  `id` int(11) NOT NULL,
  `accion` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `cantidad` int(11) NOT NULL,
  `mercancias` int(11) NOT NULL,
  `marca` int(11) NOT NULL,
  `modelo` int(11) NOT NULL,
  `nota` varchar(360) COLLATE utf8_spanish_ci NOT NULL,
  `proveedor` int(11) NOT NULL,
  `estade` int(11) NOT NULL,
  `estatus` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `cantrest` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `altas`
--

INSERT INTO `altas` (`id`, `accion`, `fecha`, `cantidad`, `mercancias`, `marca`, `modelo`, `nota`, `proveedor`, `estade`, `estatus`, `usuario`, `cantrest`) VALUES
(55, 1, '2018-06-12 12:50:26', 2, 5, 12, 28, '2', 2, 2, 2, 10, 28),
(56, 1, '2018-06-12 12:53:00', 1, 5, 12, 28, 'Agregado de Mercancia', 5, 2, 2, 10, 28),
(57, 1, '2018-06-12 13:15:18', 2, 5, 12, 29, '2', 7, 2, 2, 10, 29),
(58, 1, '2018-06-12 15:45:00', 9, 21, 12, 44, '9,', 7, 2, 2, 12, 44),
(59, 1, '2018-06-12 16:03:36', 3, 21, 12, 45, '3', 7, 2, 2, 12, 45),
(60, 1, '2018-06-12 16:04:06', 8, 21, 12, 46, '8', 7, 2, 2, 12, 46),
(61, 1, '2018-06-12 16:04:24', 5, 21, 12, 47, '5', 7, 2, 2, 12, 47),
(62, 1, '2018-06-12 16:04:40', 10, 21, 12, 48, '10', 7, 2, 2, 12, 48),
(63, 1, '2018-06-12 16:09:44', 7, 21, 12, 49, '7', 9, 2, 2, 12, 49),
(64, 1, '2018-06-12 16:30:42', 6, 21, 12, 50, '6', 9, 2, 2, 12, 50),
(65, 1, '2018-06-12 16:31:16', 33, 21, 12, 51, 'Eliminarr', 9, 2, 2, 12, 51),
(66, 1, '2018-06-12 16:31:53', 18, 21, 12, 52, '18', 9, 2, 2, 12, 52),
(67, 1, '2018-06-12 16:32:21', 36, 21, 12, 53, '36', 9, 2, 2, 12, 53),
(68, 1, '2018-06-12 16:32:51', 11, 21, 12, 54, '11', 9, 2, 2, 12, 54),
(69, 1, '2018-06-12 16:33:12', 8, 21, 12, 55, '8', 9, 2, 2, 12, 55),
(70, 1, '2018-06-12 16:33:28', 4, 21, 12, 56, '4', 9, 2, 2, 12, 56),
(71, 1, '2018-06-12 16:33:53', 3, 21, 12, 57, '3', 9, 2, 2, 12, 57),
(77, 1, '2018-06-19 18:12:04', 1, 67, 59, 202, '2', 9, 2, 2, 12, 202),
(78, 1, '2018-06-19 18:12:11', 1, 67, 59, 202, '2', 9, 2, 2, 12, 202),
(79, 1, '2018-06-23 11:59:05', 3, 61, 37, 295, '--------->( 295 )<---------\ntzc4ea328w00091\ntzc4lx383w00200\nTZC4LA380W00052\n', 9, 2, 2, 12, 295),
(80, 1, '2018-06-23 12:01:10', 1, 61, 68, 294, '--------->( 294 )<---------\nPTO34595028494\n', 9, 2, 2, 12, 294),
(81, 1, '2018-06-23 12:03:39', 1, 61, 52, 293, '--------->( 293 )<---------\n$S160721042736\n', 9, 2, 2, 12, 293),
(82, 1, '2018-06-23 12:04:52', 1, 61, 37, 292, '--------->( 292 )<---------\n3k01f1cpar06890\n', 9, 2, 2, 12, 292),
(83, 1, '2018-06-25 10:24:48', 2, 61, 33, 296, '--------->( 296 )<---------\nC25532081E41L30082\nC25532081E41L30085', 9, 2, 2, 12, 296),
(84, 1, '2018-06-25 10:33:19', 1, 61, 30, 297, '--------->( 297 )<---------\n\n3459-5012809', 9, 2, 2, 12, 297),
(85, 1, '2018-06-25 10:47:22', 1, 61, 157, 298, '--------->( 298 )<---------\n1140002636', 9, 2, 2, 12, 298),
(86, 1, '2018-06-25 15:38:11', 1, 61, 51, 299, '--------->( 299 )<---------\nc29102011u4b20235', 9, 2, 2, 12, 299),
(87, 1, '2018-06-25 15:39:48', 1, 61, 51, 300, '--------->( 300 )<---------\nc29020061d4k10060', 9, 2, 2, 12, 300),
(88, 1, '2018-06-25 15:45:35', 1, 61, 152, 301, '--------->( 301 )<---------\n0002D11BCF92', 9, 2, 2, 12, 301),
(89, 1, '2018-06-25 16:01:18', 2, 61, 157, 302, '0945000769\n0945000770', 9, 2, 2, 12, 302),
(90, 1, '2018-06-25 16:08:08', 3, 61, 157, 302, '0945000602\n0945000769\n0945000770', 9, 3, 2, 12, 302),
(91, 1, '2018-06-25 16:41:35', 1, 61, 157, 302, '0945000602\n0945000769\n0945000770', 9, 3, 2, 12, 302),
(92, 1, '2018-06-25 16:53:13', 3, 61, 157, 302, '--------->( 302 )<---------\n0945000602\n0945000769\n0945000770', 9, 7, 2, 12, 302),
(93, 1, '2018-06-25 17:03:25', 2, 61, 152, 303, '--------->( 303 )<---------\n0002D10F857C\n0002D10F6F3D', 9, 7, 2, 12, 303),
(94, 1, '2018-06-27 13:32:27', 1, 61, 67, 304, '--------->( 304 )<---------\nSYS04090429', 9, 2, 2, 12, 304),
(95, 1, '2018-06-27 13:33:57', 1, 61, 80, 305, '--------->( 305 )<---------\n498287453', 9, 3, 2, 12, 305),
(96, 1, '2018-06-27 13:44:03', 1, 61, 80, 306, '--------->( 306 )<---------\n641681030', 9, 2, 2, 12, 306),
(97, 1, '2018-06-27 13:49:55', 1, 61, 152, 307, '--------->( 307 )<---------\n0002D111AF85', 9, 2, 2, 12, 307),
(98, 1, '2018-06-27 14:02:24', 1, 61, 44, 308, '--------->( 308 )<---------\nBJCH00098', 9, 2, 2, 12, 308),
(99, 1, '2018-06-27 15:43:43', 1, 61, 152, 309, '--------->( 309 )<---------\n0002D1164EA7', 9, 2, 2, 12, 309),
(100, 1, '2018-06-28 10:26:25', 1, 61, 127, 322, '--------->( 322 )<---------\n1210D18161200236', 9, 2, 2, 12, 322),
(101, 1, '2018-06-28 11:06:14', 1, 61, 127, 323, '--------->( 323 )<---------\n1220D18170400013', 9, 2, 2, 12, 323),
(102, 1, '2018-06-28 12:01:19', 2, 61, 145, 324, '--------->( 324 )<---------\nTVN4000051511270133\n******************************', 9, 3, 2, 12, 324),
(103, 1, '2018-06-28 12:13:57', 1, 61, 136, 325, '--------->( 325 )<---------\n06372', 9, 2, 2, 12, 325),
(104, 1, '2018-06-28 12:21:25', 2, 61, 136, 326, '00150\n13652', 9, 3, 2, 12, 326),
(105, 1, '2018-06-28 12:45:19', 1, 61, 151, 327, 'Kit #1:\nSM34909044\nSM34909043', 9, 2, 2, 12, 327),
(106, 1, '2018-06-28 13:07:12', 1, 61, 134, 328, '7501483102388', 9, 3, 2, 12, 328),
(107, 1, '2018-06-28 13:58:16', 15, 61, 127, 330, '445014170828001', 9, 2, 2, 12, 330),
(108, 1, '2018-06-28 14:02:19', 2, 61, 127, 331, '--------->( 331 )<---------\n46372 141203 001', 9, 3, 2, 12, 331),
(109, 1, '2018-06-28 15:57:50', 1, 61, 127, 332, '--------->( 332 )<---------\n052052160601001', 9, 3, 2, 12, 332),
(110, 1, '2018-06-28 15:58:48', 2, 61, 136, 333, '6931851605967', 9, 3, 2, 12, 333),
(111, 1, '2018-06-28 16:21:02', 1, 61, 173, 334, 'E199899', 9, 3, 2, 12, 334),
(112, 1, '2018-06-28 16:28:14', 2, 61, 30, 335, '812032542\n910050528', 9, 3, 2, 12, 335),
(113, 1, '2018-06-28 16:34:30', 1, 61, 30, 336, '--------->( 336 )<---------\n7702003201', 9, 3, 2, 12, 336),
(114, 1, '2018-06-28 16:43:35', 1, 61, 30, 337, '--------->( 337 )<---------\n_______', 9, 3, 2, 12, 337),
(115, 1, '2018-06-28 17:10:54', 1, 61, 134, 338, '--------->( 338 )<---------\n_______', 9, 3, 2, 12, 338),
(116, 1, '2018-06-28 17:11:29', 3, 61, 136, 339, '--------->( 339 )<---------', 9, 3, 2, 12, 339),
(117, 1, '2018-06-28 17:20:18', 6, 61, 67, 340, '--------->( 340 )<---------\n6_Transeptores\n1_Receptor', 9, 3, 2, 12, 340),
(118, 1, '2018-06-28 17:24:14', 2, 61, 30, 341, '--------->( 341 )<---------', 9, 3, 2, 12, 341),
(119, 1, '2018-06-28 17:31:03', 1, 61, 127, 329, '--------->( 329 )<---------\n052003170313001\n052003170327001', 9, 2, 2, 12, 329),
(120, 1, '2018-06-30 10:47:53', 51, 67, 106, 263, '--------->( 263 )<---------', 9, 2, 2, 12, 263),
(121, 1, '2018-06-30 11:14:05', 2, 67, 108, 262, '--------->( 262 )<---------', 9, 2, 2, 12, 262),
(122, 1, '2018-06-30 11:37:48', 8, 67, 106, 264, '--------->( 264 )<---------', 9, 2, 2, 12, 264),
(123, 1, '2018-06-30 11:39:35', 2, 67, 106, 261, '--------->( 261 )<---------', 9, 2, 2, 12, 261),
(124, 1, '2018-06-30 11:40:05', 1, 67, 106, 260, '--------->( 260 )<---------', 9, 2, 2, 12, 260),
(125, 1, '2018-06-30 11:44:26', 5, 67, 108, 265, '--------->( 265 )<---------', 9, 2, 2, 12, 265),
(126, 1, '2018-06-30 11:45:21', 1, 67, 106, 266, '--------->( 266 )<---------', 9, 2, 2, 12, 266),
(127, 1, '2018-06-30 11:46:24', 8, 67, 106, 268, '--------->( 268 )<---------', 9, 2, 2, 12, 268),
(128, 1, '2018-06-30 11:50:32', 41, 67, 108, 267, '--------->( 267 )<---------', 9, 2, 2, 12, 267),
(129, 1, '2018-06-30 11:51:55', 9, 67, 106, 270, '--------->( 270 )<---------', 9, 2, 2, 12, 270),
(130, 1, '2018-06-30 11:52:47', 7, 67, 106, 271, '--------->( 271 )<---------', 9, 2, 2, 12, 271),
(131, 1, '2018-06-30 11:53:43', 9, 67, 106, 272, '--------->( 272 )<---------', 9, 2, 2, 12, 272),
(132, 1, '2018-06-30 11:55:08', 21, 67, 108, 269, '--------->( 269 )<---------', 9, 2, 2, 12, 269),
(133, 1, '2018-06-30 12:07:07', 2, 67, 108, 273, '--------->( 273 )<---------', 9, 2, 2, 12, 273),
(134, 1, '2018-06-30 12:08:12', 8, 67, 108, 275, '--------->( 275 )<---------', 9, 2, 2, 12, 275),
(135, 1, '2018-06-30 12:10:14', 29, 67, 106, 278, '--------->( 278 )<---------', 9, 2, 2, 12, 278),
(136, 1, '2018-06-30 12:11:38', 5, 67, 108, 280, '--------->( 280 )<---------', 9, 2, 2, 12, 280),
(137, 1, '2018-06-30 12:14:25', 1, 67, 108, 279, '--------->( 279 )<---------', 9, 2, 2, 12, 279),
(138, 1, '2018-06-30 12:16:33', 3, 67, 108, 277, '--------->( 277 )<---------', 9, 2, 2, 12, 277),
(139, 1, '2018-06-30 12:19:13', 9, 67, 108, 276, '--------->( 276 )<---------\nNK2FWHY = 5\nNK2FIWY = 4', 9, 2, 2, 12, 276),
(140, 1, '2018-06-30 12:30:32', 8, 67, 108, 274, '--------->( 274 )<---------', 9, 2, 2, 12, 274),
(141, 1, '2018-06-30 12:42:41', 1, 61, 127, 364, '--------->( 364 )<---------\ntvt052062', 9, 2, 2, 12, 364),
(142, 1, '2018-06-30 12:59:01', 1, 61, 127, 365, '--------->( 365 )<---------\n46358 14101400122', 9, 3, 2, 12, 365),
(143, 1, '2018-06-30 13:11:24', 2, 61, 127, 366, '--------->( 366 )<---------\ntt101at20130300043\ntt101at201303000416(No transmite bien la Imágen)', 9, 3, 2, 12, 366),
(144, 1, '2018-07-02 10:15:39', 1, 67, 59, 208, '--------->( 208 )<---------', 9, 3, 2, 12, 208),
(145, 1, '2018-07-02 10:42:23', 2, 67, 59, 210, '--------->( 210 )<---------', 9, 3, 2, 12, 210),
(146, 1, '2018-07-02 11:13:43', 1, 67, 59, 216, '--------->( 216 )<---------', 9, 3, 2, 12, 216),
(147, 1, '2018-07-02 12:04:43', 3, 67, 59, 222, '--------->( 222 )<---------\n1 Completo\n2 Incompleto', 9, 3, 2, 12, 222),
(148, 1, '2018-07-02 12:06:33', 2, 67, 59, 227, '--------->( 227 )<---------', 9, 3, 2, 12, 227),
(149, 1, '2018-07-02 12:07:02', 1, 67, 59, 224, '--------->( 224 )<---------', 9, 3, 2, 12, 224),
(150, 1, '2018-07-02 12:07:42', 3, 67, 59, 221, '--------->( 221 )<---------', 9, 3, 2, 12, 221),
(151, 1, '2018-07-02 12:08:14', 4, 67, 59, 213, '--------->( 213 )<---------', 9, 3, 2, 12, 213),
(152, 1, '2018-07-02 12:08:41', 2, 67, 59, 223, '--------->( 223 )<---------', 9, 3, 2, 12, 223),
(153, 1, '2018-07-02 12:23:10', 8, 67, 59, 220, '--------->( 220 )<---------\n4 Completas\n4 Incompletas', 9, 3, 2, 12, 220),
(154, 1, '2018-07-02 13:12:28', 10, 67, 59, 228, '--------->( 228 )<---------', 9, 2, 2, 12, 228),
(155, 1, '2018-07-02 13:14:30', 8, 67, 59, 231, '--------->( 231 )<---------', 9, 2, 2, 12, 231),
(156, 1, '2018-07-02 13:14:50', 5, 67, 59, 229, '--------->( 229 )<---------', 9, 2, 2, 12, 229),
(157, 1, '2018-07-02 13:30:49', 6, 67, 59, 226, '--------->( 226 )<---------', 9, 2, 2, 12, 226),
(158, 1, '2018-07-02 13:35:13', 7, 67, 59, 230, '--------->( 230 )<---------', 9, 2, 2, 12, 230),
(159, 1, '2018-07-02 13:40:21', 8, 67, 59, 235, '--------->( 235 )<---------', 9, 2, 2, 12, 235),
(160, 1, '2018-07-02 13:42:48', 18, 67, 59, 237, '--------->( 237 )<---------', 9, 2, 2, 12, 237),
(161, 1, '2018-07-02 13:47:30', 1, 67, 59, 236, '--------->( 236 )<---------', 9, 2, 2, 12, 236),
(162, 1, '2018-07-02 13:53:59', 10, 67, 59, 232, '--------->( 232 )<---------', 9, 2, 2, 12, 232),
(163, 1, '2018-07-02 13:57:52', 33, 67, 59, 233, '--------->( 233 )<---------\n27 en Caja\n6 en bolsa', 9, 2, 2, 12, 233),
(164, 1, '2018-07-02 15:19:23', 20, 67, 156, 255, '--------->( 255 )<--------- ', 9, 2, 2, 12, 255),
(165, 1, '2018-07-02 15:21:28', 25, 67, 156, 256, '--------->( 256 )<--------- \n10 Blancos\n5 Negros', 9, 3, 2, 12, 256),
(166, 1, '2018-07-02 15:23:38', 3, 67, 139, 257, '--------->( 257 )<---------25', 9, 3, 2, 12, 257),
(167, 1, '2018-07-02 15:24:37', 100, 67, 30, 258, '--------->( 258 )<---------', 9, 2, 2, 12, 258),
(168, 1, '2018-07-02 15:30:31', 97, 67, 139, 259, '--------->( 259 )<---------\n37_Caja + 30_Bolsa #1+ 30_Bolsa #2', 9, 2, 2, 12, 259),
(169, 1, '2018-07-02 15:43:07', 22, 67, 171, 253, '--------->( 253 )<--------- \n', 9, 2, 2, 12, 253),
(170, 1, '2018-07-02 15:43:18', 7, 67, 171, 254, '--------->( 254 )<---------', 9, 3, 2, 12, 254),
(171, 1, '2018-07-02 16:04:45', 126, 67, 94, 284, '--------->( 284 )<---------', 9, 2, 2, 12, 284),
(172, 1, '2018-07-02 16:09:28', 19, 67, 94, 281, '--------->( 281 )<---------', 9, 2, 2, 12, 281),
(173, 1, '2018-07-02 16:09:45', 271, 67, 94, 283, '--------->( 283 )<---------\n123_Bolsa#1 + 148_Bolsa#2', 9, 2, 2, 12, 283),
(174, 1, '2018-07-02 16:48:35', 2, 67, 80, 253, '--------->( 253 )<---------\nB100188773\nB100174258', 9, 3, 2, 12, 253),
(175, 1, '2018-07-02 17:08:32', 2, 67, 80, 367, '--------->( 367 )<---------\nB100188773 \nB100174258', 9, 3, 2, 12, 367),
(176, 1, '2018-07-02 17:35:57', 46, 67, 59, 242, '--------->( 242)<---------', 9, 2, 2, 12, 242),
(177, 1, '2018-07-02 17:36:55', 2, 67, 59, 243, '--------->( 243 )<---------', 9, 2, 2, 12, 243),
(178, 1, '2018-07-02 17:45:08', 36, 67, 59, 238, '--------->( 238 )<---------', 9, 2, 2, 12, 238),
(179, 1, '2018-07-02 17:47:11', 14, 67, 59, 239, '--------->( 239 )<---------', 9, 2, 2, 12, 239),
(180, 1, '2018-07-02 17:51:18', 23, 67, 59, 241, '--------->( 241 )<---------', 9, 2, 2, 12, 241),
(181, 1, '2018-07-02 17:54:11', 24, 67, 59, 240, '--------->( 240 )<---------', 9, 2, 2, 12, 240),
(182, 1, '2018-07-02 18:00:53', 2, 67, 59, 249, '--------->( 249 )<---------', 9, 2, 2, 12, 249),
(183, 1, '2018-07-02 18:01:22', 1, 67, 59, 245, '--------->( 245 )<---------', 9, 2, 2, 12, 245),
(184, 1, '2018-07-02 18:17:42', 36, 67, 108, 287, '--------->( 287 )<---------', 9, 2, 2, 12, 287),
(185, 1, '2018-07-02 18:22:36', 40, 67, 106, 285, '--------->( 285 )<---------', 9, 2, 2, 12, 285),
(186, 1, '2018-07-02 18:25:14', 15, 67, 108, 290, '--------->( 290 )<---------', 9, 2, 2, 12, 290),
(187, 1, '2018-07-02 18:27:44', 6, 67, 106, 286, '--------->( 286)<---------', 9, 2, 2, 12, 286),
(188, 1, '2018-07-02 18:29:34', 3, 67, 108, 291, '--------->( 291)<---------', 9, 2, 2, 12, 291),
(189, 1, '2018-07-03 09:40:58', 16, 67, 108, 288, '--------->( 288 )<---------\nNKP5E88MWH = 9\nNKP5E88MIW = 7\n', 9, 2, 2, 12, 288),
(190, 1, '2018-07-03 09:45:35', 1, 67, 108, 289, '--------->( 289 )<---------\n', 9, 2, 2, 12, 289),
(191, 1, '2018-07-05 09:43:08', 4, 67, 59, 234, '--------->( 234 )<--------- ', 9, 2, 2, 12, 234),
(192, 1, '2018-07-05 10:05:44', 37, 67, 59, 206, '--------->( 206 )<--------- ', 9, 2, 2, 12, 206),
(193, 1, '2018-07-10 15:00:50', 1, 61, 136, 313, '--------->( 313 )<---------', 9, 3, 2, 12, 313),
(194, 1, '2018-07-16 11:01:38', 33, 70, 181, 8, '', 9, 2, 1, 12, 8),
(195, 1, '2018-07-16 11:02:58', 1, 70, 179, 9, '', 9, 2, 1, 12, 9),
(196, 1, '2018-07-16 11:03:30', 5, 70, 181, 10, '', 9, 2, 1, 12, 10),
(197, 1, '2018-07-16 11:04:30', 10, 70, 181, 11, '', 9, 2, 1, 12, 11),
(198, 1, '2018-07-16 11:04:59', 7, 70, 181, 13, '', 9, 2, 1, 12, 13),
(199, 1, '2018-07-16 11:06:44', 8, 70, 181, 46, '', 9, 2, 1, 12, 46),
(200, 1, '2018-07-16 11:09:07', 1, 70, 179, 48, '', 9, 2, 1, 12, 48),
(201, 1, '2018-07-16 11:09:21', 6, 70, 181, 49, '', 9, 2, 1, 12, 49),
(202, 1, '2018-07-16 11:09:48', 2, 70, 179, 52, '', 9, 2, 1, 12, 52),
(203, 1, '2018-07-16 11:10:07', 16, 70, 181, 53, '', 9, 2, 1, 12, 53),
(204, 1, '2018-07-16 11:11:13', 2, 70, 181, 54, '', 9, 2, 1, 12, 54),
(205, 1, '2018-07-16 11:12:27', 6, 70, 181, 56, '', 9, 2, 1, 12, 56),
(206, 1, '2018-07-16 11:12:42', 1, 70, 181, 57, '', 9, 2, 1, 12, 57),
(207, 1, '2018-07-16 11:12:57', 2, 70, 179, 58, '', 9, 2, 1, 12, 58),
(208, 1, '2018-07-16 11:13:34', 18, 70, 181, 63, '', 9, 2, 1, 12, 63),
(209, 1, '2018-07-16 11:13:54', 5, 70, 181, 66, '', 9, 2, 1, 12, 66),
(210, 1, '2018-07-16 11:14:14', 1, 70, 181, 67, '', 9, 2, 1, 12, 67),
(211, 1, '2018-07-16 11:15:06', 18, 70, 181, 70, '', 9, 2, 1, 12, 70),
(212, 1, '2018-07-16 11:15:30', 13, 70, 181, 71, '', 9, 2, 1, 12, 71),
(213, 1, '2018-07-16 11:15:57', 19, 70, 181, 73, '', 9, 2, 1, 12, 73),
(214, 1, '2018-07-16 11:16:18', 4, 70, 181, 74, '', 9, 2, 1, 12, 74),
(215, 1, '2018-07-16 11:16:36', 35, 70, 181, 78, '', 9, 2, 1, 12, 78),
(216, 1, '2018-07-16 11:16:52', 5, 70, 181, 80, '', 9, 2, 1, 12, 80),
(217, 1, '2018-07-16 11:17:43', 12, 70, 181, 83, '', 9, 2, 1, 12, 83),
(218, 1, '2018-07-16 11:18:59', 24, 70, 181, 85, '', 9, 2, 1, 12, 85),
(219, 1, '2018-07-16 11:19:15', 4, 70, 179, 86, '', 9, 2, 1, 12, 86),
(220, 1, '2018-07-16 11:19:32', 19, 70, 181, 87, '', 9, 2, 1, 12, 87),
(221, 1, '2018-07-16 11:19:51', 14, 70, 181, 88, '', 9, 2, 1, 12, 88),
(222, 1, '2018-07-16 11:20:05', 9, 70, 181, 89, '', 9, 2, 1, 12, 89),
(223, 1, '2018-07-16 11:20:22', 36, 70, 181, 90, '', 9, 2, 1, 12, 90),
(224, 1, '2018-07-16 11:20:39', 30, 70, 181, 91, '', 9, 2, 1, 12, 91),
(225, 1, '2018-07-16 11:20:52', 11, 70, 179, 92, '', 9, 2, 1, 12, 92),
(226, 1, '2018-07-16 11:22:52', 7, 70, 181, 96, '', 9, 2, 1, 12, 96),
(227, 1, '2018-07-16 11:23:48', 46, 70, 181, 97, '', 9, 2, 1, 12, 97),
(228, 1, '2018-07-16 11:24:04', 18, 70, 181, 98, '', 9, 2, 1, 12, 98),
(229, 1, '2018-07-16 11:25:15', 31, 70, 181, 100, '', 9, 2, 1, 12, 100),
(230, 1, '2018-07-16 11:25:40', 29, 70, 181, 101, '', 9, 2, 1, 12, 101),
(231, 1, '2018-07-16 11:26:03', 25, 70, 181, 102, '', 9, 2, 1, 12, 102),
(232, 1, '2018-07-16 11:26:32', 6, 70, 179, 103, '', 9, 2, 1, 12, 103),
(233, 1, '2018-07-16 11:27:11', 40, 70, 181, 104, '', 9, 2, 1, 12, 104),
(234, 1, '2018-07-16 11:28:16', 39, 70, 181, 105, '', 9, 2, 1, 12, 105),
(235, 1, '2018-07-16 11:28:52', 13, 70, 181, 106, '', 9, 2, 1, 12, 106),
(236, 1, '2018-07-16 11:29:19', 83, 70, 181, 107, '', 9, 2, 1, 12, 107),
(237, 1, '2018-07-16 11:29:45', 16, 70, 181, 108, '', 9, 2, 1, 12, 108),
(238, 1, '2018-07-16 11:36:51', 15, 70, 179, 109, '', 9, 2, 1, 12, 109),
(239, 1, '2018-07-16 11:37:12', 12, 70, 179, 110, '', 9, 2, 1, 12, 110),
(240, 1, '2018-07-16 11:37:33', 7, 70, 179, 111, '', 9, 2, 1, 12, 111),
(241, 1, '2018-07-16 11:40:45', 7, 70, 181, 113, '', 9, 2, 1, 12, 113),
(242, 1, '2018-07-16 11:41:31', 27, 70, 181, 114, '', 9, 2, 1, 12, 114),
(243, 1, '2018-07-16 11:43:07', 32, 70, 181, 115, '', 9, 2, 1, 12, 115),
(244, 1, '2018-07-16 11:45:03', 3, 70, 179, 116, '', 9, 2, 1, 12, 116),
(245, 1, '2018-07-16 11:45:29', 43, 70, 181, 117, '', 9, 2, 1, 12, 117),
(246, 1, '2018-07-16 11:45:51', 92, 70, 181, 118, '', 9, 2, 1, 12, 118),
(247, 1, '2018-07-16 11:46:25', 23, 70, 181, 119, '', 9, 2, 1, 12, 119),
(248, 1, '2018-07-16 11:46:51', 8, 70, 179, 120, '', 9, 2, 1, 12, 120),
(249, 1, '2018-07-16 11:47:21', 29, 70, 181, 121, '', 9, 2, 1, 12, 121),
(250, 1, '2018-07-16 11:47:53', 40, 70, 181, 122, '', 9, 2, 1, 12, 122),
(251, 1, '2018-07-16 11:48:19', 12, 70, 181, 123, '', 9, 2, 1, 12, 123),
(252, 1, '2018-07-16 11:48:43', 61, 70, 181, 124, '', 9, 2, 1, 12, 124),
(253, 1, '2018-07-16 11:49:03', 20, 70, 181, 125, '', 9, 2, 1, 12, 125),
(254, 1, '2018-07-16 11:49:24', 18, 70, 179, 126, '', 9, 2, 1, 12, 126),
(255, 1, '2018-07-16 11:49:49', 3, 70, 179, 127, '', 9, 2, 1, 12, 127),
(256, 1, '2018-07-16 11:50:08', 12, 70, 179, 128, '', 9, 2, 1, 12, 128),
(257, 1, '2018-07-16 11:50:47', 18, 70, 181, 129, '', 9, 2, 1, 12, 129),
(258, 1, '2018-07-16 11:51:36', 2, 70, 181, 130, '', 9, 2, 1, 12, 130),
(259, 1, '2018-07-16 11:53:22', 78, 70, 181, 131, '', 9, 2, 1, 12, 131),
(260, 1, '2018-07-16 11:53:50', 10, 70, 181, 132, '', 9, 2, 1, 12, 132),
(261, 1, '2018-07-16 11:54:13', 4, 70, 179, 133, '', 9, 2, 1, 12, 133),
(262, 1, '2018-07-16 11:54:37', 51, 70, 181, 134, '', 9, 2, 1, 12, 134),
(263, 1, '2018-07-16 11:57:24', 16, 70, 181, 139, '', 9, 2, 1, 12, 139),
(264, 1, '2018-07-16 11:57:52', 8, 70, 181, 140, '', 9, 2, 1, 12, 140),
(265, 1, '2018-07-16 11:58:36', 2, 70, 181, 146, '', 9, 2, 1, 12, 146),
(266, 1, '2018-07-16 12:01:49', 4, 68, 89, 152, '', 9, 2, 1, 12, 152),
(267, 1, '2018-07-16 12:02:28', 1, 68, 30, 153, '', 9, 2, 1, 12, 153),
(268, 1, '2018-07-16 12:02:54', 4, 68, 30, 154, '', 9, 3, 1, 12, 154),
(269, 1, '2018-07-16 12:03:22', 1, 68, 30, 155, '', 9, 2, 1, 12, 155),
(270, 1, '2018-07-16 12:08:50', 1, 68, 30, 156, '', 9, 2, 1, 12, 156),
(271, 1, '2018-07-16 12:09:34', 1, 68, 89, 157, '', 9, 2, 1, 12, 157),
(272, 1, '2018-07-16 12:09:46', 3, 68, 30, 158, '', 9, 2, 1, 12, 158),
(273, 1, '2018-07-16 12:09:57', 12, 68, 182, 159, '', 9, 2, 1, 12, 159),
(274, 1, '2018-07-16 12:10:15', 1, 58, 49, 160, '', 9, 2, 1, 12, 160),
(275, 1, '2018-07-16 12:10:25', 3, 58, 67, 161, '', 9, 2, 1, 12, 161),
(276, 1, '2018-07-16 12:10:46', 1, 58, 81, 162, '', 9, 2, 1, 12, 162),
(277, 1, '2018-07-16 12:11:01', 5, 58, 81, 163, '886618177071', 9, 2, 1, 12, 163),
(278, 1, '2018-07-16 12:11:42', 1, 58, 183, 164, '', 9, 2, 1, 12, 164),
(279, 1, '2018-07-16 12:11:54', 1, 58, 183, 165, '', 9, 2, 1, 12, 165),
(280, 1, '2018-07-16 12:12:06', 10, 58, 30, 166, '', 9, 2, 1, 12, 166),
(281, 1, '2018-07-16 12:12:18', 1, 58, 130, 167, '', 9, 2, 1, 12, 167),
(282, 1, '2018-07-16 12:12:33', 15, 58, 130, 168, '', 9, 2, 1, 12, 168),
(283, 1, '2018-07-16 12:12:48', 7, 58, 130, 169, '', 9, 2, 1, 12, 169),
(284, 1, '2018-07-16 12:13:43', 14, 58, 130, 170, '', 9, 2, 1, 12, 170),
(285, 1, '2018-07-16 12:14:03', 21, 58, 130, 171, '', 9, 2, 1, 12, 171),
(286, 1, '2018-07-16 12:14:16', 10, 58, 130, 172, '', 9, 2, 1, 12, 172),
(287, 1, '2018-07-16 12:14:31', 22, 58, 128, 173, '', 9, 2, 1, 12, 173),
(288, 1, '2018-07-16 12:14:44', 1, 58, 81, 174, '', 9, 2, 1, 12, 174),
(289, 1, '2018-07-16 12:15:05', 8, 58, 54, 175, '', 9, 2, 1, 12, 175),
(290, 1, '2018-07-16 12:15:23', 8, 58, 130, 176, '', 9, 2, 1, 12, 176),
(291, 1, '2018-07-16 12:15:33', 1, 58, 61, 177, '', 9, 2, 1, 12, 177),
(292, 1, '2018-07-16 12:15:39', 1, 58, 81, 178, '', 9, 2, 1, 12, 178),
(293, 1, '2018-07-16 12:15:56', 3, 58, 54, 179, '', 9, 2, 1, 12, 179),
(294, 1, '2018-07-16 12:16:12', 3, 58, 81, 180, '', 9, 2, 1, 12, 180),
(295, 1, '2018-07-16 12:16:27', 138, 58, 127, 181, '', 9, 2, 1, 12, 181),
(296, 1, '2018-07-16 12:26:58', 28, 67, 59, 206, '', 9, 2, 1, 12, 206),
(297, 1, '2018-07-16 12:27:17', 1, 67, 59, 208, '', 9, 3, 1, 12, 208),
(298, 1, '2018-07-16 12:27:35', 2, 67, 59, 210, '7 702496 006032', 9, 3, 1, 12, 210),
(299, 1, '2018-07-16 12:27:48', 4, 67, 59, 213, '7 702496 010350', 9, 3, 1, 12, 213),
(300, 1, '2018-07-16 12:28:04', 1, 67, 59, 216, '7 702496 006025', 9, 3, 1, 12, 216),
(301, 1, '2018-07-16 12:28:24', 8, 67, 59, 220, '7702496005714\n4_Completas \n4_Incompletas', 9, 3, 1, 12, 220),
(302, 1, '2018-07-16 12:28:34', 2, 67, 59, 221, '', 9, 3, 1, 12, 221),
(303, 1, '2018-07-16 12:28:50', 3, 67, 59, 223, '', 9, 2, 2, 12, 223),
(304, 1, '2018-07-16 12:29:04', 1, 67, 59, 224, '', 9, 2, 2, 12, 224),
(305, 1, '2018-07-16 12:32:31', 3, 67, 59, 222, '1_Completo \n2_Incompleto', 9, 3, 1, 12, 222),
(306, 1, '2018-07-16 12:33:04', 3, 67, 59, 223, '', 9, 3, 1, 12, 223),
(307, 1, '2018-07-16 12:33:13', 1, 67, 59, 224, '7 702496 010114', 9, 3, 1, 12, 224),
(308, 1, '2018-07-16 12:34:53', 6, 67, 59, 226, '7 702496 005707', 9, 2, 1, 12, 226),
(309, 1, '2018-07-16 12:35:04', 2, 67, 59, 227, '7 702496 005851', 9, 3, 1, 12, 227),
(310, 1, '2018-07-16 12:35:15', 10, 67, 59, 228, '7 702496 006001', 9, 2, 1, 12, 228),
(311, 1, '2018-07-16 12:35:24', 5, 67, 59, 229, '7 702496 006339', 9, 2, 1, 12, 229),
(312, 1, '2018-07-16 12:35:40', 7, 67, 59, 230, '7 702496 010121', 9, 2, 1, 12, 230),
(313, 1, '2018-07-16 12:35:51', 8, 67, 59, 231, '7 702496 010329', 9, 2, 1, 12, 231),
(314, 1, '2018-07-16 12:36:41', 10, 67, 59, 232, '7 702496 005691', 9, 2, 1, 12, 232),
(315, 1, '2018-07-16 12:36:54', 32, 67, 59, 233, '7 702496 005844', 9, 2, 1, 12, 233),
(316, 1, '2018-07-16 12:37:07', 4, 67, 59, 234, '7 702496 005998', 9, 2, 1, 12, 234),
(317, 1, '2018-07-16 12:37:18', 6, 67, 59, 235, '7 702496 006322', 9, 2, 1, 12, 235),
(318, 1, '2018-07-16 12:37:34', 1, 67, 59, 236, '7 702496 010114', 9, 2, 1, 12, 236),
(319, 1, '2018-07-16 12:37:45', 18, 67, 59, 237, '7 702496 010312', 9, 2, 1, 12, 237),
(320, 1, '2018-07-16 12:38:00', 32, 67, 59, 238, '7 702496 005684', 9, 2, 1, 12, 238),
(321, 1, '2018-07-16 12:38:53', 7, 67, 59, 239, '7 702496 005837', 9, 2, 1, 12, 239),
(322, 1, '2018-07-16 12:39:47', 60, 67, 59, 240, '7 702496 005981', 9, 2, 1, 12, 240),
(323, 1, '2018-07-16 12:39:59', 11, 67, 59, 241, '7 702496 006315', 9, 2, 1, 12, 241),
(324, 1, '2018-07-16 12:40:16', 38, 67, 59, 242, '7 702496 010107', 9, 2, 1, 12, 242),
(325, 1, '2018-07-16 12:40:27', 1, 67, 59, 243, '7 702496 010305', 9, 2, 1, 12, 243),
(326, 1, '2018-07-16 12:41:11', 1, 67, 59, 245, '', 9, 2, 1, 12, 245),
(327, 1, '2018-07-16 12:41:59', 2, 67, 59, 249, '7 702496 010299', 9, 2, 1, 12, 249),
(328, 1, '2018-07-16 12:43:03', 23, 67, 30, 253, '', 4, 2, 1, 12, 253),
(329, 1, '2018-07-16 12:43:17', 53, 67, 30, 254, '', 4, 2, 1, 12, 254),
(330, 1, '2018-07-16 12:43:31', 25, 72, 156, 255, '', 9, 2, 1, 12, 255),
(331, 1, '2018-07-16 12:43:48', 25, 72, 156, 256, '10_Blancos \n5_Negros', 9, 3, 1, 12, 256),
(332, 1, '2018-07-16 12:45:31', 100, 67, 30, 258, '', 9, 2, 1, 12, 258),
(333, 1, '2018-07-16 12:45:42', 100, 67, 139, 259, '', 9, 2, 1, 12, 259),
(334, 1, '2018-07-16 12:45:54', 1, 67, 106, 260, '', 9, 2, 1, 12, 260),
(335, 1, '2018-07-16 12:46:04', 2, 67, 106, 261, '', 9, 2, 1, 12, 261),
(336, 1, '2018-07-16 12:46:16', 2, 67, 108, 262, '074983055593', 9, 2, 1, 12, 262),
(337, 1, '2018-07-16 12:46:30', 51, 67, 106, 263, '', 9, 2, 1, 12, 263),
(338, 1, '2018-07-16 12:46:40', 8, 67, 106, 264, '', 9, 2, 1, 12, 264),
(339, 1, '2018-07-16 12:46:50', 5, 67, 108, 265, '074983055647', 9, 2, 1, 12, 265),
(340, 1, '2018-07-16 12:47:05', 1, 67, 106, 266, '', 9, 2, 1, 12, 266),
(341, 1, '2018-07-16 12:47:18', 44, 67, 108, 267, ' 074983055708', 9, 2, 1, 12, 267),
(342, 1, '2018-07-16 12:48:22', 8, 67, 106, 268, '', 9, 2, 1, 12, 268),
(343, 1, '2018-07-16 12:49:01', 22, 67, 108, 269, '074983055456', 9, 2, 1, 12, 269),
(344, 1, '2018-07-16 12:49:13', 8, 67, 106, 270, '', 9, 2, 1, 12, 270),
(345, 1, '2018-07-16 12:49:26', 7, 67, 106, 271, '', 9, 2, 1, 12, 271),
(346, 1, '2018-07-16 12:49:36', 9, 67, 106, 272, '', 9, 2, 1, 12, 272),
(347, 1, '2018-07-16 12:49:56', 2, 67, 108, 273, '074983033218', 9, 2, 1, 12, 273),
(348, 1, '2018-07-16 12:50:13', 5, 67, 108, 274, '074983054497', 9, 2, 1, 12, 274),
(349, 1, '2018-07-16 12:51:16', 4, 67, 108, 275, '074983033294', 9, 2, 1, 12, 275),
(350, 1, '2018-07-16 12:51:29', 6, 67, 108, 276, '074983054534', 9, 2, 1, 12, 276),
(351, 1, '2018-07-16 12:52:30', 2, 67, 108, 277, '074983652624', 9, 2, 1, 12, 277),
(352, 1, '2018-07-16 12:53:11', 29, 67, 106, 278, '', 9, 2, 1, 12, 278),
(353, 1, '2018-07-16 12:53:27', 1, 67, 108, 279, '074983575657', 9, 2, 1, 12, 279),
(354, 1, '2018-07-16 12:53:41', 10, 67, 108, 280, '074983054817', 9, 2, 1, 12, 280),
(355, 1, '2018-07-16 12:53:51', 8, 67, 94, 281, '', 9, 2, 1, 12, 281),
(356, 1, '2018-07-16 12:57:08', 254, 67, 94, 283, '', 9, 2, 1, 12, 283),
(357, 1, '2018-07-16 12:57:39', 119, 67, 94, 284, '', 9, 2, 1, 12, 284),
(358, 1, '2018-07-16 12:58:09', 39, 67, 106, 285, '', 9, 2, 1, 12, 285),
(359, 1, '2018-07-16 12:58:21', 6, 67, 106, 286, '', 9, 2, 1, 12, 286),
(360, 1, '2018-07-16 12:58:33', 28, 67, 108, 287, '074983574698 ', 9, 2, 1, 12, 287),
(361, 1, '2018-07-16 12:58:44', 8, 67, 108, 288, '074983097135 NKP5E88MWH=8\nNKP5E88MIW=0', 9, 2, 2, 12, 288),
(362, 1, '2018-07-16 12:59:43', 1, 67, 108, 289, '', 9, 2, 1, 12, 289),
(363, 1, '2018-07-16 12:59:54', 15, 67, 108, 290, '074983054992', 9, 2, 1, 12, 290),
(364, 1, '2018-07-16 13:00:10', 2, 67, 108, 291, '074983574704', 9, 2, 1, 12, 291),
(365, 1, '2018-07-16 13:00:32', 1, 61, 37, 292, '3k01f1cpar06890', 9, 2, 1, 12, 292),
(366, 1, '2018-07-16 13:00:40', 1, 61, 52, 293, 'S160721042736NT', 9, 2, 1, 12, 293),
(367, 1, '2018-07-16 13:00:45', 1, 61, 68, 294, 'PTO34595028494', 9, 2, 1, 12, 294),
(368, 1, '2018-07-16 13:01:08', 3, 61, 37, 295, 'TZC4L4380W00161 TZC4LX383W00200 TZC4LA380W00052', 9, 2, 1, 12, 295),
(369, 1, '2018-07-16 13:57:36', 2, 61, 33, 296, 'C25532081E41L30082 \nC25532081E41L30085', 9, 2, 1, 12, 296),
(370, 1, '2018-07-16 13:59:52', 1, 61, 30, 297, '3459-5012809', 9, 2, 1, 12, 297),
(371, 1, '2018-07-16 14:00:01', 1, 61, 157, 298, '1140002636', 9, 2, 1, 12, 298),
(372, 1, '2018-07-16 14:00:26', 1, 61, 51, 299, 'c29102011u4b20235', 9, 2, 1, 12, 299),
(373, 1, '2018-07-16 14:00:44', 1, 61, 51, 300, 'C29020061D4K10060', 9, 2, 1, 12, 300),
(374, 1, '2018-07-16 14:01:02', 1, 61, 152, 301, '0002D11BCF92', 9, 2, 1, 12, 301),
(375, 1, '2018-07-16 14:51:54', 3, 61, 157, 302, '0945000602 \n0945000769 \n0945000770', 9, 7, 1, 12, 302),
(376, 1, '2018-07-16 14:55:57', 2, 61, 152, 303, '0002D10F857C \n0002D10F6F3D', 9, 7, 1, 12, 303),
(378, 1, '2018-07-16 14:58:42', 1, 61, 67, 304, '498287453', 9, 2, 2, 12, 304),
(379, 1, '2018-07-16 15:02:28', 1, 61, 80, 305, '498287453', 9, 2, 2, 12, 305),
(380, 1, '2018-07-16 15:03:10', 1, 61, 80, 306, '641681030', 9, 2, 2, 12, 306),
(382, 1, '2018-07-16 15:28:09', 1, 61, 67, 304, 'SYS04090429', 9, 2, 1, 12, 304),
(383, 1, '2018-07-16 15:29:21', 1, 61, 80, 305, '498287453', 9, 3, 1, 12, 305),
(384, 1, '2018-07-16 15:29:48', 1, 61, 80, 306, '641681030', 9, 2, 1, 12, 306),
(385, 1, '2018-07-16 15:30:04', 1, 61, 152, 307, '0002D111AF85', 9, 2, 1, 12, 307),
(386, 1, '2018-07-16 15:30:23', 1, 61, 44, 308, 'BJCH00098', 9, 2, 1, 12, 308),
(387, 1, '2018-07-16 15:31:40', 1, 61, 152, 309, '0002D1164EA7', 9, 2, 1, 12, 309),
(388, 1, '2018-07-16 15:34:11', 1, 61, 136, 313, '170609', 9, 3, 1, 12, 313),
(389, 1, '2018-07-16 15:36:09', 2, 61, 127, 322, '1210D18161200236 EDE00041312010553', 9, 2, 1, 12, 322),
(390, 1, '2018-07-16 15:36:39', 1, 61, 127, 323, '1220D18170400013', 9, 2, 1, 12, 323),
(391, 1, '2018-07-16 15:37:51', 3, 61, 145, 324, 'TVN4000051511270133 R120902107 R111201548', 9, 3, 1, 12, 324),
(392, 1, '2018-07-16 15:38:21', 1, 61, 136, 325, '06372', 9, 2, 1, 12, 325),
(393, 1, '2018-07-16 15:39:54', 6, 61, 136, 326, '13652 00269 00121 09009 00029 00150 ', 9, 3, 1, 12, 326),
(394, 1, '2018-07-16 15:40:41', 1, 61, 151, 327, 'Kit #1: \nSM34909044, SM34909043', 9, 2, 1, 12, 327),
(395, 1, '2018-07-16 15:41:09', 1, 61, 134, 328, '7501483102388', 9, 3, 1, 12, 328),
(396, 1, '2018-07-16 15:46:13', 1, 61, 127, 329, '052003170327001', 9, 2, 2, 12, 329),
(397, 1, '2018-07-16 15:50:49', 1, 61, 127, 330, '', 9, 2, 2, 12, 330),
(398, 1, '2018-07-16 16:03:33', 1, 61, 127, 332, '', 9, 2, 1, 12, 332),
(399, 1, '2018-07-16 16:06:23', 1, 61, 136, 333, '', 9, 3, 2, 12, 333),
(400, 1, '2018-07-16 16:08:45', 1, 61, 173, 334, 'Q1351', 9, 3, 2, 12, 334),
(401, 1, '2018-07-16 16:10:24', 1, 61, 30, 335, '1104204011', 9, 3, 1, 12, 335),
(402, 1, '2018-07-16 16:13:10', 2, 61, 30, 337, '', 9, 3, 1, 12, 337),
(403, 1, '2018-07-16 16:14:50', 1, 61, 134, 338, '', 9, 3, 1, 12, 338),
(404, 1, '2018-07-16 16:18:58', 3, 61, 136, 339, '6931851605950', 9, 3, 2, 12, 339),
(405, 1, '2018-07-16 16:22:58', 1, 61, 67, 340, '', 9, 3, 2, 12, 340),
(406, 1, '2018-07-16 16:28:16', 2, 61, 30, 341, '7702002100', 9, 3, 2, 12, 341),
(407, 1, '2018-07-16 16:31:00', 1, 61, 127, 364, 'tvt052062', 9, 2, 1, 12, 364),
(408, 1, '2018-07-16 16:32:10', 1, 61, 127, 365, '4635814101400122', 9, 3, 1, 12, 365),
(409, 1, '2018-07-16 16:34:01', 2, 61, 127, 366, 'tt101at20130300043 \ntt101at201303000416_(No transmite bien la Imágen)', 9, 3, 1, 12, 366),
(410, 1, '2018-07-16 16:34:33', 2, 67, 80, 367, 'B100188773 \nB100174258', 9, 3, 1, 12, 367),
(411, 1, '2018-07-21 12:30:14', 15, 69, 75, 187, '20ez1zbj20d24afa\n20ez1zbj20d24af8\n20ez1zbj20d24af1\n20ez1zbj20d24af0\n20ez1zbj20d24aef\n20ez1zbj20d24aed\n20ez1zbj20d24aee\n20ez1zbj20d24aec\n20ez1zbj20d24af6\n20ez1zbj20d24af4\n20ez1zbj20d24afb\n20ez1zbj20d24af2\n20ez1zbj20d24af3\n20ez1zbj20d24af5\n20ez1zbj20d24af7', 1, 2, 1, 12, 187),
(412, 1, '2018-07-23 17:41:19', 1, 59, 147, 188, 'FCECDA837586', 5, 2, 1, 12, 188),
(413, 1, '2018-07-24 11:20:08', 5, 63, 154, 189, '746270\n746262\n746290\n746307\n746144', 4, 2, 1, 12, 189),
(414, 1, '2018-07-24 13:10:58', 117, 67, 108, 368, '', 9, 2, 1, 12, 368),
(415, 1, '2018-07-24 13:12:09', 1, 67, 108, 369, '', 9, 3, 1, 12, 369),
(416, 1, '2018-07-24 13:16:59', 245, 67, 127, 370, '', 9, 3, 1, 12, 370),
(417, 1, '2018-07-24 13:17:21', 238, 67, 127, 371, '', 9, 3, 1, 12, 371),
(418, 1, '2018-07-24 13:17:47', 1, 67, 108, 372, '', 9, 3, 1, 12, 372),
(419, 1, '2018-07-26 17:56:12', 1, 58, 130, 190, '171082717', 1, 2, 1, 12, 190),
(420, 1, '2018-07-26 17:59:30', 4, 59, 146, 191, '', 1, 2, 1, 12, 191),
(421, 1, '2018-07-27 09:29:17', 305, 67, 30, 379, '', 9, 2, 1, 12, 379),
(422, 1, '2018-07-27 09:33:34', 33, 67, 127, 386, '', 9, 3, 1, 12, 386),
(423, 1, '2018-07-27 09:36:21', 167, 67, 30, 390, '', 4, 2, 1, 12, 390),
(424, 1, '2018-07-27 09:40:15', 1, 67, 30, 391, '', 9, 3, 1, 12, 391),
(425, 1, '2018-07-27 10:37:48', 2, 61, 58, 314, '3G03614PAR02487\n3G03614PAR02886', 4, 2, 1, 12, 314),
(426, 1, '2018-07-27 11:20:43', 1, 62, 185, 192, 'WCC7K7DDTRED', 4, 2, 1, 12, 192),
(427, 1, '2018-07-31 12:24:30', 2, 62, 76, 193, '888462323055  4547597916759\n888462323055  4547597916759\n', 5, 2, 1, 12, 193),
(428, 1, '2018-08-02 10:33:43', 2, 61, 67, 194, '34598016403 104515089', 1, 2, 1, 12, 194),
(429, 1, '2018-08-03 16:52:27', 1, 64, 127, 195, 'TVN083024', 5, 2, 1, 12, 195),
(430, 1, '2018-08-03 17:00:20', 46, 71, 94, 196, '', 9, 2, 1, 12, 196),
(431, 1, '2018-08-03 17:03:27', 13, 71, 30, 198, '', 9, 3, 1, 12, 198),
(432, 1, '2018-08-13 12:29:05', 1, 61, 30, 393, '54346316', 5, 2, 1, 12, 393),
(433, 1, '2018-08-13 12:49:11', 7, 61, 58, 315, '4C05ED6PAL15DF5 4C05ED6PALC10BD 4C05ED6PALB3068 4C05ED6PALA0F1D 4C05ED6PAL5A262 4C05ED6PALBB9A9 4C05ED6PALB2687', 5, 2, 1, 12, 315),
(434, 1, '2018-08-13 12:59:20', 3, 61, 58, 316, '2L051B6PAL00170 3F0232DPAL00298 3F0232DPAL00068', 5, 2, 1, 12, 316),
(435, 1, '2018-08-13 13:10:28', 2, 61, 58, 317, '3K01E2APAL02684 3K01E2APAL02654 ', 4, 2, 1, 12, 317),
(436, 1, '2018-08-13 13:25:30', 5, 61, 58, 394, '', 4, 2, 1, 12, 394),
(437, 1, '2018-08-20 16:41:45', 1, 59, 147, 395, '', 5, 2, 1, 12, 395),
(438, 1, '2018-08-20 16:43:42', 4, 61, 142, 396, '2183178000600 2183178000579 2183178000571 2183178000598', 5, 2, 1, 12, 396),
(439, 1, '2018-08-20 16:45:05', 2, 67, 94, 397, '', 5, 2, 1, 12, 397),
(440, 1, '2018-08-20 17:32:28', 4, 63, 123, 398, '', 5, 2, 1, 12, 398),
(441, 1, '2018-09-01 11:45:02', 3, 59, 146, 399, '', 5, 2, 1, 12, 399),
(442, 1, '2018-09-01 11:46:43', 1, 59, 30, 400, '4E06B10PAJCD111', 4, 2, 1, 12, 400),
(443, 1, '2018-09-26 10:14:44', 1, 62, 185, 192, 'WD40PURZ', 9, 2, 1, 12, 192),
(444, 1, '2018-09-28 10:13:47', 1, 61, 37, 428, '4D04481PAZ0DDA8', 4, 2, 1, 12, 428),
(445, 1, '2018-09-28 10:28:49', 1, 61, 58, 317, '4E0699EPAL38433', 4, 2, 1, 12, 317),
(446, 1, '2018-09-28 10:41:22', 2, 61, 37, 318, '4e069a6par59448 4e0699fpar4787c', 4, 2, 1, 12, 318),
(447, 1, '2018-09-28 10:46:27', 2, 61, 37, 320, '4d04983paf5055b 4d04983paf4ae30', 4, 2, 1, 12, 320),
(448, 1, '2018-09-28 10:50:36', 1, 61, 37, 321, '4d044e2par7fe95', 4, 2, 1, 12, 321),
(449, 1, '2018-09-28 11:02:47', 3, 61, 37, 404, '4D044E4PAFD32FC 4D044E4PAF137A2 4D044E4PAFC3CB4', 4, 2, 1, 12, 404),
(450, 1, '2018-09-28 11:02:47', 3, 61, 37, 404, '4d044e4pafc3cb4 4d044e4paf137a2 4d044e4pafd32fc', 4, 2, 2, 12, 404),
(451, 1, '2018-09-28 11:06:04', 3, 61, 37, 404, '4d044e4pafc3cb4 4d044e4paf137a2 4d044e4pafd32fc', 4, 2, 2, 12, 404),
(452, 1, '2018-09-28 11:46:40', 1, 62, 187, 399, 'WX11D38E2HL2', 4, 2, 1, 12, 399),
(453, 1, '2018-09-28 15:23:07', 1, 61, 37, 429, '4E06DDCPAG99E04', 4, 2, 1, 12, 429),
(454, 1, '2018-09-28 15:27:28', 1, 61, 37, 319, '4e0484cpag5bc03', 4, 2, 1, 12, 319),
(455, 1, '2018-09-28 17:47:04', 1, 61, 37, 403, '4E0494DPAZFB1D6', 4, 2, 1, 12, 403),
(456, 1, '2018-09-28 17:50:25', 1, 61, 37, 401, '3K01B26PAZDD79A', 4, 2, 1, 12, 401),
(457, 1, '2018-09-28 18:01:12', 1, 58, 188, 405, 'LGH015129269', 4, 2, 1, 12, 405),
(458, 1, '2018-10-05 10:38:32', 4, 63, 34, 431, '', 1, 2, 1, 12, 431),
(459, 1, '2018-10-05 10:43:46', 3, 67, 94, 413, 'OP21644M', 1, 2, 1, 12, 413),
(460, 1, '2018-10-16 12:34:36', 2, 71, 140, 424, '', 1, 2, 1, 12, 424),
(461, 1, '2018-10-16 12:36:44', 1, 71, 140, 419, '', 1, 2, 1, 12, 419),
(462, 1, '2018-10-16 12:39:24', 10, 64, 140, 415, '', 1, 2, 1, 12, 415),
(463, 1, '2018-10-16 12:41:26', 2, 58, 81, 162, '', 1, 2, 2, 12, 162),
(464, 1, '2018-10-16 12:43:08', 1, 58, 30, 418, '', 1, 2, 1, 12, 418),
(465, 1, '2018-10-16 12:45:18', 5, 58, 81, 421, '', 1, 2, 1, 12, 421),
(466, 1, '2018-10-16 12:48:56', 2, 58, 130, 412, '', 1, 2, 1, 12, 412),
(467, 1, '2018-10-16 12:51:32', 2, 58, 69, 416, '', 1, 2, 1, 12, 416),
(468, 1, '2018-10-16 12:57:13', 2, 58, 81, 163, '', 1, 2, 2, 12, 163),
(469, 1, '2018-10-16 13:12:29', 2, 59, 146, 414, '788a201825e5', 1, 2, 1, 12, 414),
(470, 1, '2018-10-16 13:15:46', 1, 71, 108, 420, '074983055388', 1, 2, 1, 12, 420),
(471, 1, '2018-10-16 13:17:25', 2, 71, 108, 422, '074983376490', 1, 2, 1, 12, 422),
(472, 1, '2018-10-16 13:24:46', 2, 71, 94, 426, '', 1, 2, 1, 12, 426),
(473, 1, '2018-10-16 13:26:21', 12, 67, 108, 288, '074983097142', 1, 2, 1, 12, 288),
(474, 1, '2018-10-16 13:27:01', 10, 67, 108, 274, '', 1, 2, 1, 12, 274),
(475, 1, '2018-10-16 13:28:56', 305, 67, 108, 385, '', 1, 2, 1, 12, 385),
(476, 1, '2018-10-16 13:31:00', 12, 71, 140, 427, '', 1, 2, 1, 12, 427),
(477, 1, '2018-10-16 13:31:41', 10, 64, 140, 417, '', 1, 2, 1, 12, 417),
(478, 1, '2018-10-16 13:32:16', 1, 71, 140, 423, '', 1, 2, 1, 12, 423),
(479, 1, '2018-10-16 13:47:57', 305, 64, 130, 425, '', 1, 2, 1, 12, 425),
(480, 1, '2018-10-16 14:13:56', 2, 61, 37, 430, '4E06DD5PAGF4946 4E06DD5PAGC1063', 4, 2, 1, 12, 430),
(481, 1, '2018-10-16 15:41:25', 1, 64, 127, 436, '', 4, 2, 1, 12, 436),
(482, 1, '2018-10-16 15:49:14', 1, 63, 58, 437, '3J00ABAPAN00177', 4, 2, 1, 12, 437),
(483, 1, '2018-10-16 15:55:16', 1, 61, 58, 438, '', 4, 2, 1, 12, 438),
(484, 1, '2018-10-16 16:01:26', 1, 63, 58, 439, '4C0059APAZ21C95', 4, 2, 1, 12, 439),
(485, 1, '2018-10-16 16:09:35', 1, 73, 192, 440, '1838016', 5, 2, 1, 12, 440),
(486, 1, '2018-10-16 16:26:29', 1, 73, 192, 441, '1730090', 5, 2, 1, 12, 441),
(487, 1, '2018-10-16 17:57:25', 4, 61, 37, 429, '4E06DDCPAG4A9CD 4E06DDCPAG4069C 4E06DDCPAG9AA78 4E06DDCPAG4DA8E', 4, 2, 1, 12, 429),
(488, 1, '2018-10-31 10:31:03', 6, 61, 58, 442, '4C05F74PAF130EE 4C05F74PAF7734C 4C05F74PAF0749B 4C05F74PAF2260F 4C05F74PAFC431F 4C05F74PAF2F769', 4, 2, 1, 12, 442),
(489, 1, '2018-10-31 10:34:51', 1, 61, 37, 428, '4D04481PAZ7A141', 4, 2, 1, 12, 428),
(490, 1, '2018-10-31 10:47:14', 1, 61, 58, 443, '4D06578PAG55E80', 4, 2, 1, 12, 443),
(491, 1, '2018-10-31 10:53:54', 1, 61, 58, 444, '4E069A9PAF06972', 4, 2, 1, 12, 444),
(492, 1, '2018-10-31 10:56:22', 1, 61, 127, 323, '1230d18180400001', 4, 2, 1, 12, 323),
(493, 1, '2018-10-31 11:04:54', 2, 61, 127, 445, '1220d9180601146 1220d9180601142', 4, 2, 1, 12, 445),
(494, 1, '2018-10-31 11:07:03', 1, 62, 187, 399, 'WX61D68N49EK', 4, 2, 1, 12, 399),
(495, 1, '2018-10-31 11:14:24', 2, 63, 154, 446, '676048 676001', 4, 2, 1, 12, 446),
(496, 1, '2018-11-06 14:13:37', 3, 62, 88, 447, 'E17H13082 E17H13132', 5, 2, 1, 12, 447),
(497, 1, '2018-11-12 12:10:48', 1, 61, 79, 448, 'JC04R00164-00043', 9, 3, 1, 12, 448),
(498, 1, '2018-11-23 09:45:29', 1, 58, 130, 449, '', 9, 2, 1, 12, 449),
(499, 1, '2018-11-23 11:15:23', 1, 63, 191, 450, 'AOBZ181662318', 9, 2, 1, 12, 450),
(500, 1, '2018-11-23 11:28:03', 2, 63, 34, 451, '', 9, 2, 1, 12, 451),
(501, 1, '2018-11-23 11:45:34', 1, 61, 44, 452, 'DLJD00100', 9, 2, 1, 12, 452),
(502, 1, '2018-11-23 11:52:45', 1, 61, 71, 453, 'TTVGA7520131100073', 9, 2, 1, 12, 453),
(503, 1, '2018-11-23 12:30:47', 1, 61, 136, 454, '20100309-5-0006', 1, 2, 1, 12, 454),
(504, 1, '2018-11-23 12:58:30', 1, 61, 71, 455, '803080047000008', 9, 2, 1, 12, 455),
(505, 1, '2018-11-23 13:15:07', 1, 61, 44, 456, 'ELME00871', 9, 2, 1, 12, 456),
(506, 1, '2018-11-23 13:29:39', 1, 63, 80, 458, '168516060 (183293984)', 5, 2, 1, 12, 458),
(507, 1, '2018-11-23 13:41:03', 2, 61, 30, 408, '4A0222BPAJEF4DC 2L056E0PAM00118', 4, 2, 1, 12, 408),
(508, 1, '2018-11-27 11:34:13', 5, 61, 194, 460, '', 5, 2, 1, 12, 460),
(509, 1, '2018-11-27 11:44:08', 1, 58, 193, 461, '676544000495', 5, 2, 1, 12, 461),
(510, 1, '2018-11-27 11:54:33', 6, 58, 54, 462, '7290015112222', 5, 2, 1, 12, 462),
(511, 1, '2018-11-27 13:40:22', 7, 71, 108, 463, '074983097128', 9, 2, 1, 12, 463),
(512, 1, '2018-11-27 14:18:31', 8, 59, 122, 464, '', 9, 2, 1, 12, 464),
(513, 1, '2018-11-27 14:18:50', 5, 59, 132, 465, '', 9, 2, 1, 12, 465),
(514, 1, '2018-11-27 14:55:41', 1, 71, 106, 466, '', 9, 2, 1, 12, 466),
(515, 1, '2018-11-27 16:16:47', 1, 63, 195, 467, '15675743', 9, 2, 1, 12, 467),
(516, 1, '2018-11-27 16:28:48', 1, 64, 196, 468, 'OM1702018', 5, 2, 1, 12, 468),
(517, 1, '2018-11-27 16:41:58', 1, 64, 197, 469, '2KEINT15125SIS1R', 5, 2, 1, 12, 469),
(518, 1, '2018-11-27 17:07:26', 1, 58, 154, 470, '510734', 5, 2, 1, 12, 470),
(519, 1, '2018-11-27 17:23:25', 1, 66, 131, 471, '0ABG1RCJ603599', 5, 2, 1, 12, 471),
(520, 1, '2018-11-27 17:36:10', 5, 61, 58, 472, '', 4, 2, 1, 12, 472),
(521, 1, '2018-11-27 18:26:21', 5, 63, 101, 473, '', 5, 2, 1, 12, 473),
(522, 1, '2018-11-28 15:43:14', 1, 58, 41, 474, '7501850419026', 5, 2, 1, 12, 474),
(523, 1, '2018-11-28 17:02:40', 2, 64, 67, 475, '10P00114070466 10P00114070470', 9, 2, 1, 12, 475),
(524, 1, '2018-11-28 17:38:14', 4, 63, 64, 476, '', 5, 2, 1, 12, 476),
(525, 1, '2018-11-28 17:38:28', 2, 63, 64, 477, '', 5, 2, 1, 12, 477),
(526, 1, '2018-11-29 12:39:44', 1, 63, 123, 478, '4897027880014', 5, 3, 1, 12, 478),
(527, 1, '2018-11-29 12:40:17', 1, 63, 34, 479, '', 5, 2, 1, 12, 479),
(528, 1, '2018-11-29 12:40:41', 1, 63, 136, 480, '16645140037', 5, 2, 1, 12, 480),
(529, 1, '2018-11-29 12:41:38', 1, 63, 156, 481, '134601', 5, 2, 1, 12, 481),
(530, 1, '2018-11-29 13:19:57', 10, 63, 34, 482, '', 5, 2, 1, 12, 482),
(531, 1, '2018-11-29 13:20:18', 1, 63, 34, 483, '', 5, 2, 1, 12, 483),
(532, 1, '2018-11-29 13:20:45', 3, 63, 34, 484, '', 5, 2, 1, 12, 484),
(533, 1, '2018-11-29 13:26:28', 2, 63, 34, 486, '', 5, 2, 1, 12, 486),
(534, 1, '2018-11-29 13:31:19', 1, 63, 34, 487, '', 5, 2, 1, 12, 487),
(535, 1, '2018-11-29 13:55:28', 2, 63, 154, 488, '73016', 5, 2, 1, 12, 488),
(536, 1, '2018-11-29 13:56:10', 1, 63, 154, 489, 'YLI 069022', 5, 2, 1, 12, 489),
(537, 1, '2018-11-29 14:35:13', 1, 63, 154, 490, '73015', 5, 2, 1, 12, 490),
(538, 1, '2018-11-29 14:35:56', 2, 64, 88, 491, '660077805511', 5, 2, 1, 12, 491),
(539, 1, '2018-11-29 14:42:01', 4, 63, 69, 492, 'OP18668M 14130 OP14685M OP14685M', 5, 2, 1, 12, 492),
(540, 1, '2018-11-29 14:53:41', 1, 63, 191, 434, 'AOCZ181160458', 5, 2, 1, 12, 434),
(541, 1, '2018-11-29 14:59:09', 3, 63, 34, 493, '*000005* *000023* *000031*', 5, 2, 1, 12, 493),
(542, 1, '2018-11-29 15:04:56', 2, 63, 67, 435, '', 5, 2, 1, 12, 435),
(543, 1, '2018-11-29 17:18:00', 2, 71, 108, 494, '074983033409', 5, 2, 1, 12, 494),
(544, 1, '2018-11-30 11:35:35', 1, 69, 199, 410, '212703093148', 9, 2, 1, 12, 410),
(545, 1, '2018-11-30 13:01:39', 1, 61, 37, 495, '2G0497CPAGNJT66', 4, 3, 1, 12, 495),
(546, 1, '2018-11-30 13:03:06', 1, 61, 37, 496, 'TZA3GL34400097', 4, 3, 1, 12, 496),
(547, 1, '2018-11-30 13:28:41', 1, 61, 148, 497, 'Grabador:........... 210235C19W9152N00296 Camaras:........... 1=210235C1443152000394 2=210235C1443152000011 3=210235C1443151000243 4=210235C1443151000015(NO_ESTA)', 5, 2, 1, 12, 497),
(548, 1, '2018-12-05 18:11:24', 2, 63, 52, 498, '$S11092159635 $s11092159424', 9, 3, 1, 12, 498),
(549, 1, '2018-12-05 18:12:45', 1, 63, 52, 499, '$S160522015635', 9, 3, 1, 12, 499),
(550, 1, '2018-12-05 18:13:25', 1, 63, 52, 500, 'DP-2S=($s141222028161) DR-2GN=(No tiene)', 9, 3, 1, 12, 500),
(551, 1, '2018-12-05 18:17:20', 1, 63, 52, 501, 'DP-2HP=(S10062128657) DR-2G=($S10062157370)', 9, 3, 1, 12, 501),
(552, 1, '2018-12-05 18:18:52', 2, 63, 52, 502, '$S11102163083 $s160522017575', 9, 3, 1, 12, 502),
(553, 1, '2018-12-05 18:20:09', 1, 63, 52, 503, '$S11062213233', 9, 3, 1, 12, 503),
(554, 1, '2018-12-07 17:19:45', 3, 64, 44, 504, '8GY600064 8GY600067 8GY600083', 9, 2, 1, 12, 504),
(555, 1, '2018-12-07 17:24:29', 1, 64, 122, 505, '1012026137', 9, 2, 1, 12, 505),
(556, 1, '2018-12-07 17:52:38', 1, 64, 136, 506, 'SCI 1102201141008-002', 9, 2, 1, 12, 506),
(557, 1, '2018-12-07 17:53:34', 2, 61, 145, 507, '52104', 9, 2, 1, 12, 507),
(558, 1, '2018-12-11 11:08:36', 2, 58, 128, 508, 'K4E919T4J', 9, 2, 1, 12, 508),
(559, 1, '2018-12-11 11:09:52', 10, 63, 30, 509, 'T23 433MHz', 9, 2, 1, 12, 509),
(560, 1, '2018-12-11 11:13:22', 3, 58, 81, 510, '0510004 1017007 0486228', 9, 2, 1, 12, 510),
(561, 1, '2018-12-11 11:27:16', 5, 60, 77, 511, '', 9, 2, 1, 12, 511),
(562, 1, '2018-12-11 11:28:13', 3, 60, 30, 512, 'B4 B23 B45', 9, 3, 1, 12, 512),
(563, 1, '2018-12-11 11:32:20', 2, 60, 30, 513, '', 9, 3, 1, 12, 513),
(564, 1, '2018-12-11 11:35:08', 1, 63, 30, 514, '434548', 9, 3, 1, 12, 514),
(565, 1, '2018-12-11 11:36:19', 1, 63, 30, 515, '21020002', 9, 3, 1, 12, 515),
(566, 1, '2018-12-11 18:14:48', 1, 59, 110, 516, 'AF00157101976', 9, 2, 1, 12, 516),
(567, 1, '2018-12-11 18:15:48', 1, 59, 121, 517, '', 9, 2, 1, 12, 517),
(568, 1, '2018-12-11 18:17:22', 1, 59, 39, 518, '782239952816', 9, 2, 1, 12, 518),
(569, 1, '2018-12-11 18:18:09', 1, 59, 123, 519, '4897027880656', 9, 2, 1, 12, 519),
(570, 1, '2018-12-12 11:35:46', 1, 61, 193, 457, '00985198', 9, 2, 1, 12, 457),
(571, 1, '2018-12-12 11:52:35', 8, 61, 30, 351, 'TVC047016', 4, 2, 1, 12, 351),
(572, 1, '2018-12-12 13:02:37', 1, 63, 61, 522, '88016013', 5, 2, 1, 12, 522),
(573, 1, '2018-12-12 13:07:23', 1, 69, 119, 521, '*024020*', 5, 2, 1, 12, 521),
(574, 1, '2018-12-12 13:17:51', 2, 58, 122, 523, '', 5, 3, 1, 12, 523),
(575, 1, '2018-12-12 13:29:22', 1, 58, 136, 525, '', 5, 3, 1, 12, 525),
(576, 1, '2018-12-12 13:35:22', 1, 69, 75, 524, '21AWM9UEB0739F86', 5, 3, 1, 12, 524),
(577, 1, '2018-12-12 13:43:53', 1, 58, 61, 526, '', 5, 3, 1, 12, 526),
(578, 1, '2018-12-13 10:23:19', 1, 71, 106, 527, '', 5, 2, 1, 12, 527),
(579, 1, '2018-12-13 10:23:47', 2, 71, 200, 528, '766623163286', 5, 2, 1, 12, 528),
(580, 1, '2018-12-13 10:24:12', 1, 71, 108, 529, '074983666805', 5, 2, 1, 12, 529),
(581, 1, '2018-12-13 10:31:16', 1, 61, 37, 407, '7101950ACA44A410KC0', 5, 2, 1, 12, 407),
(582, 1, '2018-12-13 10:58:32', 2, 58, 81, 530, '886618176821', 5, 2, 1, 12, 530),
(583, 1, '2018-12-13 11:09:33', 1, 71, 108, 531, '074983838448', 5, 2, 1, 12, 531),
(584, 1, '2018-12-13 11:15:34', 2, 71, 108, 532, '074983376490', 5, 2, 2, 12, 532),
(585, 1, '2018-12-13 11:34:39', 3, 71, 189, 409, '37212', 5, 2, 1, 12, 409),
(586, 1, '2018-12-13 11:36:17', 1, 61, 127, 406, '81032', 5, 2, 1, 12, 406),
(587, 1, '2018-12-13 11:52:13', 1, 59, 136, 533, '111MPRE0033', 5, 2, 1, 12, 533),
(588, 1, '2018-12-13 11:56:49', 1, 67, 127, 532, 'TVT05206917010400101', 4, 2, 1, 12, 532),
(589, 1, '2018-12-13 12:00:30', 1, 67, 105, 534, '1VD29A3R0072B', 5, 3, 1, 12, 534),
(590, 1, '2018-12-13 12:09:38', 2, 67, 50, 535, 'SUW00M111285 SUW00LB15973', 5, 2, 1, 12, 535),
(591, 1, '2018-12-13 12:34:43', 2, 59, 146, 536, '1447-0016690 1643-0004691', 5, 2, 1, 12, 536),
(592, 1, '2018-12-13 12:34:53', 1, 59, 146, 537, '1106-0018504', 5, 2, 1, 12, 537),
(593, 1, '2018-12-13 12:35:00', 7, 59, 146, 538, '1541-0073159 1549-0193415 1605-0250060 1536-0012400 1546-0120153 1604-0187008 1609-0045951', 5, 2, 1, 12, 538),
(594, 1, '2018-12-13 12:35:09', 2, 59, 146, 539, '1251-0093361 1251-0096133', 5, 2, 1, 12, 539),
(595, 1, '2018-12-13 12:35:18', 1, 59, 146, 540, '0909-0018299', 5, 2, 1, 12, 540),
(596, 1, '2018-12-13 12:35:25', 1, 59, 146, 541, '1107-0242918', 5, 2, 1, 12, 541),
(597, 1, '2018-12-13 12:35:32', 4, 59, 146, 542, '', 5, 2, 2, 12, 542),
(598, 1, '2018-12-13 12:46:46', 4, 59, 147, 395, '', 5, 3, 1, 12, 395),
(599, 1, '2018-12-13 12:51:05', 3, 59, 146, 542, '1301KDC9FDB1E0CEB 1301KDC9FDB18D13C 1301KDC9FDB18D461', 5, 3, 1, 12, 542),
(600, 1, '2018-12-13 14:13:36', 1, 60, 201, 544, '', 5, 3, 1, 12, 544),
(601, 1, '2018-12-13 14:19:08', 1, 60, 126, 545, 'R08031-1147-0274', 9, 3, 1, 12, 545),
(602, 1, '2018-12-13 14:23:45', 1, 59, 147, 543, '', 9, 3, 1, 12, 543),
(603, 1, '2018-12-13 14:27:03', 1, 60, 202, 546, '', 9, 3, 1, 12, 546),
(604, 1, '2018-12-13 14:30:28', 1, 60, 60, 547, '', 9, 3, 1, 12, 547),
(605, 1, '2018-12-13 14:33:02', 1, 60, 87, 548, '1406', 9, 3, 1, 12, 548),
(606, 1, '2018-12-13 14:37:00', 1, 64, 44, 549, '4B1248P41881', 9, 3, 1, 12, 549),
(607, 1, '2018-12-14 11:20:49', 3, 61, 204, 550, '', 5, 2, 1, 12, 550),
(608, 1, '2018-12-14 11:34:51', 1, 73, 205, 551, '7503021802538', 5, 2, 1, 12, 551),
(609, 1, '2018-12-14 11:48:39', 174, 71, 127, 387, '', 9, 2, 1, 12, 387),
(610, 1, '2018-12-14 12:21:32', 1, 70, 181, 51, '', 9, 2, 1, 12, 51),
(611, 1, '2018-12-14 16:03:13', 5, 70, 179, 93, '', 9, 2, 1, 12, 93),
(612, 1, '2018-12-14 16:05:01', 4, 70, 179, 99, '', 9, 2, 1, 12, 99),
(613, 1, '2018-12-14 16:06:19', 5, 70, 179, 94, '', 9, 2, 1, 12, 94),
(614, 1, '2018-12-15 12:15:14', 2, 59, 146, 552, 'FCECDAAC8AFF FCECDAAC8831', 5, 2, 1, 12, 552),
(615, 1, '2018-12-15 12:26:25', 1, 67, 206, 553, 'UGC09700818091300050', 5, 2, 1, 12, 553),
(616, 1, '2018-12-15 12:39:36', 1, 64, 30, 554, '', 5, 2, 1, 12, 554),
(617, 1, '2018-12-15 12:57:40', 2, 63, 123, 555, '*00008592612800* *00008592612801*', 5, 2, 1, 12, 555),
(618, 1, '2018-12-15 13:03:03', 1, 63, 145, 556, '', 4, 2, 1, 12, 556),
(619, 1, '2018-12-15 13:08:01', 1, 71, 134, 557, '7506250900907', 5, 2, 1, 12, 557),
(620, 1, '2018-12-15 13:12:24', 11, 61, 30, 360, '', 5, 2, 1, 12, 360),
(621, 1, '2018-12-17 11:35:10', 11, 71, 108, 558, '074983097135', 1, 2, 1, 12, 558),
(622, 1, '2018-12-17 12:11:10', 3, 71, 108, 559, '074983054527', 9, 2, 1, 12, 559),
(623, 1, '2018-12-17 12:21:19', 1, 71, 108, 560, '0749830332332', 9, 2, 1, 12, 560),
(624, 1, '2018-12-17 15:23:13', 14, 64, 53, 561, '032664707162', 5, 2, 1, 12, 561),
(625, 1, '2018-12-17 15:24:02', 18, 64, 53, 562, '032664751721', 5, 2, 1, 12, 562),
(626, 1, '2018-12-17 15:25:16', 21, 70, 30, 563, '', 5, 2, 1, 12, 563);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bajas`
--

CREATE TABLE `bajas` (
  `id` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `accionb` int(11) NOT NULL,
  `modelob` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `usuarioa` int(11) NOT NULL,
  `usuariob` int(11) NOT NULL,
  `cliente` int(11) NOT NULL,
  `comentario` varchar(350) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bajas`
--

INSERT INTO `bajas` (`id`, `fecha`, `accionb`, `modelob`, `cantidad`, `usuarioa`, `usuariob`, `cliente`, `comentario`, `estatus`) VALUES
(1, '2018-04-10 15:44:51', 2, 7, 1, 2, 2, 4, 'Hola', 2),
(2, '2018-04-10 16:04:08', 2, 7, 5, 2, 9, 7, 'Aqui', 2),
(3, '2018-04-10 16:04:31', 2, 7, 2, 2, 9, 7, 'Pueden', 2),
(4, '2018-04-11 16:40:36', 2, 11, 3, 2, 2, 7, 'Ir', 2),
(5, '2018-04-12 09:42:44', 2, 7, 2, 2, 8, 7, 'Los', 2),
(6, '2018-04-12 09:43:14', 2, 7, 2, 2, 8, 7, 'Codigos', 2),
(7, '2018-04-12 09:43:27', 2, 7, 2, 2, 8, 7, 'De', 2),
(8, '2018-04-12 09:46:53', 2, 7, 2, 2, 8, 7, 'Barras', 2),
(9, '2018-04-12 09:48:52', 2, 7, 2, 2, 8, 7, ':v', 2),
(10, '2018-04-12 09:49:30', 2, 7, 2, 2, 8, 7, '.jpg', 2),
(11, '2018-04-12 09:52:11', 2, 9, 3, 2, 8, 7, 'Comentario', 2),
(12, '2018-04-12 09:54:11', 2, 11, 3, 2, 8, 5, 'asd', 2),
(13, '2018-04-12 10:07:22', 2, 9, 3, 2, 8, 7, 'Hola como estas?', 2),
(14, '2018-04-12 10:07:23', 2, 11, 2, 2, 8, 7, 'Bien we', 2),
(15, '2018-04-12 10:27:12', 2, 8, 1, 2, 2, 7, 'Aqui no hay pan', 2),
(16, '2018-04-12 10:27:12', 2, 7, 2, 2, 2, 7, 'Aqui tampco we', 2),
(17, '2018-04-12 10:36:56', 2, 9, 1, 2, 9, 7, 'No c papu ', 2),
(18, '2018-04-12 10:39:58', 2, 9, 1, 2, 8, 5, 'Negas :v', 2),
(19, '2018-04-12 10:45:31', 2, 9, 1, 2, 8, 5, 'l:l', 2),
(20, '2018-04-12 10:47:16', 2, 9, 1, 2, 8, 5, 'l:l', 2),
(21, '2018-04-12 10:47:33', 2, 9, 1, 2, 8, 5, 'l:l', 2),
(22, '2018-04-12 10:48:40', 2, 9, 1, 2, 8, 5, 'l:l', 2),
(23, '2018-06-08 17:59:58', 2, 7, 3, 2, 9, 12, '3J02FB8PAF00536 3J02FB8PAF00536 3J02FB8PAF00536 ', 2),
(24, '2018-06-12 16:41:08', 2, 51, 6, 2, 13, 7, '', 2),
(25, '2018-06-19 18:09:58', 2, 205, 45, 12, 12, 13, '45', 2),
(26, '2018-06-25 11:58:10', 2, 202, 2, 2, 2, 13, '4902506074874', 2),
(27, '2018-06-30 10:34:06', 2, 332, 2, 12, 9, 13, '052052160601001 * 2', 2),
(28, '2018-07-09 10:29:00', 2, 257, 3, 12, 14, 15, '', 2),
(29, '2018-07-10 16:02:57', 2, 202, 200, 12, 2, 13, '', 2),
(30, '2018-07-21 12:43:04', 2, 187, 15, 12, 13, 41, '20ez1zbj20d24afa\n20ez1zbj20d24af8\n20ez1zbj20d24af1\n20ez1zbj20d24af0\n20ez1zbj20d24aef\n20ez1zbj20d24aed\n20ez1zbj20d24aee\n20ez1zbj20d24aec\n20ez1zbj20d24a', 1),
(31, '2018-07-24 11:24:26', 2, 189, 5, 12, 13, 41, '746270 \n746262 \n746290 \n746307 \n746144', 1),
(32, '2018-07-24 11:48:59', 2, 188, 1, 12, 13, 42, 'FCECDA837586', 1),
(33, '2018-07-27 11:55:47', 2, 314, 2, 12, 13, 53, '3G03614PAR02487 3G03614PAR02886', 1),
(34, '2018-07-27 11:57:00', 2, 192, 1, 12, 13, 54, 'WCC7K7DDTRED', 1),
(35, '2018-07-31 12:29:33', 2, 193, 2, 12, 13, 57, '888462323055 4547597916759 888462323055 4547597916759', 1),
(36, '2018-07-31 12:35:05', 2, 191, 4, 12, 13, 57, '', 1),
(37, '2018-08-02 10:38:01', 2, 194, 1, 12, 14, 58, '34598016403', 1),
(38, '2018-08-13 12:35:31', 2, 393, 1, 12, 16, 59, '54346316', 1),
(39, '2018-08-20 16:47:57', 2, 395, 1, 12, 16, 61, '', 1),
(40, '2018-08-20 16:50:55', 2, 396, 4, 12, 17, 62, '	2183178000600 2183178000579 2183178000571 2183178000598', 1),
(41, '2018-08-20 16:52:26', 2, 397, 2, 12, 17, 62, '', 1),
(42, '2018-08-20 17:35:19', 2, 398, 4, 12, 17, 63, '', 1),
(43, '2018-09-01 11:45:47', 2, 399, 3, 12, 17, 61, '', 1),
(44, '2018-09-26 10:15:26', 2, 192, 1, 12, 13, 54, 'WD40PURZ', 1),
(45, '2018-10-16 12:35:49', 2, 424, 2, 12, 13, 68, '', 1),
(46, '2018-10-16 12:37:24', 2, 419, 1, 12, 13, 68, '', 1),
(47, '2018-10-16 12:39:48', 2, 415, 10, 12, 13, 68, '', 1),
(48, '2018-10-16 12:41:49', 2, 162, 1, 12, 13, 68, '', 1),
(49, '2018-10-16 12:43:45', 2, 418, 1, 12, 13, 68, '', 1),
(50, '2018-10-16 12:45:42', 2, 421, 5, 12, 13, 68, '', 1),
(51, '2018-10-16 12:49:19', 2, 412, 1, 12, 13, 68, '', 1),
(52, '2018-10-16 12:51:50', 2, 416, 1, 12, 13, 68, '', 1),
(53, '2018-10-16 12:59:19', 2, 163, 1, 12, 13, 68, '886618177071', 1),
(54, '2018-10-16 13:12:49', 2, 414, 2, 12, 13, 68, '788a201825e5', 1),
(55, '2018-10-16 13:23:05', 2, 8, 5, 12, 13, 68, '', 2),
(56, '2018-10-16 13:23:05', 2, 11, 5, 12, 13, 68, '', 2),
(57, '2018-10-16 13:41:56', 2, 426, 2, 12, 13, 68, '', 1),
(58, '2018-10-16 13:41:57', 2, 288, 12, 12, 13, 68, '074983097142', 1),
(59, '2018-10-16 13:41:57', 2, 274, 10, 12, 13, 68, '074983054497', 1),
(60, '2018-10-16 13:41:57', 2, 385, 305, 12, 13, 68, '', 1),
(61, '2018-10-16 13:41:57', 2, 427, 12, 12, 13, 68, '', 1),
(62, '2018-10-16 13:41:57', 2, 417, 10, 12, 13, 68, '', 1),
(63, '2018-10-16 13:41:57', 2, 423, 1, 12, 13, 68, '', 1),
(64, '2018-10-16 13:48:18', 2, 425, 305, 12, 13, 68, '', 1),
(65, '2018-10-16 13:58:30', 2, 428, 1, 12, 16, 69, '4D04481PAZ0DDA8', 1),
(66, '2018-10-16 13:58:31', 2, 323, 1, 12, 16, 69, '', 1),
(67, '2018-10-16 13:58:31', 2, 399, 1, 12, 16, 69, '', 1),
(68, '2018-10-16 13:58:31', 2, 404, 3, 12, 16, 69, '4D044E4PAFD32FC 4D044E4PAF137A2 4D044E4PAFC3CB4', 1),
(69, '2018-10-16 13:58:31', 2, 320, 2, 12, 16, 69, '4D04983PAF5055B 4D04983PAF4AE30', 1),
(70, '2018-10-16 13:58:31', 2, 413, 1, 12, 16, 69, '', 1),
(71, '2018-10-16 14:12:27', 2, 317, 1, 12, 18, 70, '4E0699EPAL38433', 1),
(72, '2018-10-16 14:19:25', 2, 430, 2, 12, 13, 71, '4E06DD5PAGC1063 4E06DD5PAGF4946', 1),
(73, '2018-10-16 14:19:25', 2, 429, 1, 12, 13, 71, '4E06DDCPAG99E04', 1),
(74, '2018-10-16 14:19:25', 2, 319, 1, 12, 13, 71, '4E0484CPAG5BC03', 1),
(75, '2018-10-16 14:19:25', 2, 403, 1, 12, 13, 71, '4E0494DPAZFB1D6', 1),
(76, '2018-10-16 14:31:20', 2, 316, 1, 12, 18, 72, '3F0232DPAL00068', 1),
(77, '2018-10-16 15:42:29', 2, 436, 1, 12, 13, 71, '', 1),
(78, '2018-10-16 15:49:45', 2, 437, 1, 12, 13, 71, '3J00ABAPAN00177', 1),
(79, '2018-10-16 15:57:10', 2, 438, 1, 12, 13, 71, '4C05B8DPAZ34DBB', 1),
(80, '2018-10-16 16:02:09', 2, 439, 1, 12, 13, 71, '4C0059APAZ21C95', 1),
(81, '2018-10-16 16:11:38', 2, 440, 1, 12, 18, 73, '1838016', 2),
(82, '2018-10-16 16:21:50', 2, 428, 1, 12, 16, 69, '4D04481PAZ0DDA8', 2),
(83, '2018-10-16 16:26:56', 2, 441, 1, 12, 13, 73, '1730090', 2),
(84, '2018-10-16 17:58:20', 2, 429, 4, 12, 13, 71, '4E06DDCPAG4A9CD 4E06DDCPAG4069C 4E06DDCPAG4DA8E 4E06DDCPAG9AA78', 1),
(85, '2018-11-06 14:14:21', 2, 447, 1, 12, 13, 74, 'E17H13082', 1),
(86, '2018-11-06 14:15:44', 2, 413, 1, 12, 13, 74, '', 1),
(87, '2018-11-06 16:11:55', 2, 428, 1, 12, 16, 68, '4D04481PAZ7A141', 1),
(88, '2018-11-06 16:13:01', 2, 323, 1, 12, 16, 68, '1230d18180400001', 1),
(89, '2018-11-06 16:13:40', 2, 445, 2, 12, 16, 68, '1220d9180601142 1220d9180601146', 1),
(90, '2018-11-06 16:29:21', 2, 399, 1, 12, 16, 68, 'WX61D68N49EK', 1),
(91, '2018-11-06 16:31:15', 2, 442, 6, 12, 16, 68, '4C05F74PAF130EE 4C05F74PAF7734C 4C05F74PAF0749B 4C05F74PAF2260F   4C05F74PAFC431F 4C05F74PAF2F769', 1),
(92, '2018-11-06 16:32:53', 2, 444, 1, 12, 16, 68, '4E069A9PAF06972', 1),
(93, '2018-11-06 16:34:20', 2, 443, 1, 12, 16, 68, '4D06578PAG55E80', 1),
(94, '2018-11-12 09:55:22', 2, 318, 2, 12, 16, 75, '4E0699FPAR4787C 4E069A6PAR59448', 1),
(95, '2018-11-12 09:55:42', 2, 321, 1, 12, 16, 75, '4D044E2PAR7FE95', 1),
(96, '2018-12-01 09:27:34', 2, 440, 1, 12, 14, 73, '1838016', 1),
(97, '2018-12-01 09:27:34', 2, 441, 1, 12, 14, 73, '1730090', 1),
(98, '2018-12-13 16:02:23', 2, 447, 1, 12, 13, 76, 'E17H13132', 1),
(99, '2018-12-15 12:16:29', 2, 552, 2, 12, 13, 76, 'FCECDAAC8AFF FCECDAAC8831', 1),
(100, '2018-12-15 12:27:11', 2, 553, 1, 12, 13, 76, 'UGC09700818091300050', 1),
(101, '2018-12-15 12:31:29', 2, 163, 1, 12, 18, 77, '886618177071', 1),
(102, '2018-12-15 12:32:39', 2, 530, 1, 12, 18, 77, '886618176821', 1),
(103, '2018-12-15 12:40:00', 2, 554, 1, 12, 18, 77, '', 1),
(104, '2018-12-17 10:51:15', 2, 274, 4, 12, 16, 78, '074983054497', 2),
(105, '2018-12-17 11:01:17', 2, 276, 1, 12, 16, 78, '074983054527', 2),
(106, '2018-12-17 11:36:31', 2, 558, 4, 12, 16, 78, '074983097135', 2),
(107, '2018-12-17 15:31:46', 2, 274, 4, 12, 16, 78, '074983054497', 1),
(108, '2018-12-17 15:31:46', 2, 277, 2, 12, 16, 78, '074983652624', 1),
(109, '2018-12-17 15:31:46', 2, 558, 4, 12, 16, 78, '074983097135', 1),
(110, '2018-12-17 15:31:46', 2, 559, 1, 12, 16, 78, '074983054527', 1),
(111, '2018-12-17 15:31:46', 2, 561, 14, 12, 16, 78, '032664707162', 1),
(112, '2018-12-17 15:31:46', 2, 562, 14, 12, 16, 78, '032664751721', 1),
(113, '2018-12-17 15:31:46', 2, 563, 5, 12, 16, 78, '', 1),
(114, '2018-12-17 15:33:42', 2, 480, 1, 12, 13, 63, '16645140037', 1),
(115, '2018-12-18 09:25:23', 2, 287, 2, 12, 15, 76, 'NK688MBU', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id` int(11) NOT NULL,
  `categoria` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id`, `categoria`, `estatus`) VALUES
(1, 'Mercancia', 1),
(2, 'Herramienta', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudad`
--

CREATE TABLE `ciudad` (
  `id` int(11) NOT NULL,
  `ciudad` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `ciudad`
--

INSERT INTO `ciudad` (`id`, `ciudad`, `estatus`) VALUES
(1, 'Torreon, Coahuila', 1),
(2, 'Gomez Placio, Durango', 1),
(3, 'Lerdo, Durango', 1),
(4, 'Matamoros, Coahuila', 1),
(5, 'San Pedro, Coahuila', 1),
(6, 'No se ha establecido...', 3),
(7, 'Delegación Cuauhtemoc, CDMX ', 1),
(8, 'Chihuahua, Chihuahua', 1),
(9, 'Francisco Madero', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `cliente` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT '871 116 1195',
  `direccion` varchar(75) COLLATE utf8_spanish_ci NOT NULL,
  `ciudad` int(11) NOT NULL,
  `estatus` int(11) NOT NULL,
  `contacto` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `telefonoa` varchar(15) COLLATE utf8_spanish_ci NOT NULL COMMENT '(871) 116 1195',
  `telefonob` varchar(15) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `cliente`, `direccion`, `ciudad`, `estatus`, `contacto`, `telefonoa`, `telefonob`) VALUES
(4, 'Prueba', '', 3, 2, '', '0', '0'),
(5, 'Otro', 'asd', 3, 2, '', '0', '0'),
(7, 'Ejemplo', 'accc', 4, 2, '', '0', '0'),
(12, 'WQ', 'No se ha establecido...ggg', 1, 2, '', '0', '0'),
(13, 'Julio Villa Lobos', 'Villas las Tortugas 3', 1, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(15, 'Plaza las Tortugas', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(40, 'Monika', 'Col. FV Calle 26 No. 269', 2, 2, 'lilmonix3@gmail.com', '(200) 720 1895', '(200) 720 1896'),
(41, 'Financieras AFI', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(42, 'Hotel Calvete July Vazquez', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(43, 'Secom', 'Av. Francisco Ortiz 380 col. las margaritas ', 1, 1, 'info@secom.tv', '8717127155', '8717110325'),
(53, 'Carta Blanca Gumex', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(54, 'Erick', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(55, 'Alice Margatroid', 'Gensokyo', 2, 2, 'alice.margatroidth47@gmail.com', '8712646421', '8512384542'),
(56, 'Rugal', 'Calle KoF Colonia AoF #789', 2, 2, 'rugal@gmail.com', '74612461', '456421'),
(57, 'WoodCrafters', 'No se ha establecido...', 2, 1, '..', '(000) 000 0000', '(000) 000 0000'),
(58, 'Casa 400 (Roberto Murra)', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(59, 'Celso', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(60, 'ADM', 'Blvd. Miguel Alemán KM-11-40', 2, 1, 'Hugo.Centeno@adm.com', '8717490700', ''),
(61, '......', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(62, 'SIMSA (Gas Natural)', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(63, 'Sanatorio Español', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(64, 'Lic. Luis Alfonso Mejia Calderón', 'Blvd. Revolucion no. 1416 ote', 1, 1, 'luismejia@gmail.com', '7182377', ''),
(65, 'ARI IV (GUMEX)', 'BLVD. RODRIGUEZ TRIANA N°888 COL. RESIDENCIAL LAS MISIONES', 1, 1, 'DANIEL LOZANO', '7056125', ''),
(66, 'ADINSA', 'Av. Degollado 231 Col. Centro', 1, 1, 'Juanis', '7114245', '8711374436'),
(67, 'Guemx', 'calle Aurelio Anaya #270 cd. industrial ', 1, 1, 'Ing. sonia amaya', '7056110', '871 278 5509'),
(68, 'ATR Ing. Saul Vargas', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(69, 'ATR Bodega', '...', 1, 1, '...', '123', ''),
(70, '....', '....', 1, 1, '....', '1', ''),
(71, 'Ing. Esteban', '...', 1, 1, '...', '1', ''),
(72, 'Clinica San Francisco', '...', 1, 1, '...', '1', ''),
(73, 'Casa del Anciano', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(74, 'MILSA', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(75, 'Carta Blanca Madero', '...', 9, 1, '....', '111', '111'),
(76, 'Campestre Liseo de la Garsa', 'No se ha establecido...', 1, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(77, 'MOL 4 Caminos', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000'),
(78, 'Creditup', 'No se ha establecido...', 6, 1, 'No se ha establecido...', '(000) 000 0000', '(000) 000 0000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descripcion`
--

CREATE TABLE `descripcion` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `temerca` int(11) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `descripcion`
--

INSERT INTO `descripcion` (`id`, `descripcion`, `temerca`, `estatus`) VALUES
(4, 'Telefono IP', 1, 2),
(5, 'Camara de tipo domo', 2, 2),
(6, 'Camara de tipo bala', 2, 2),
(7, 'Lector de huella', 2, 2),
(8, 'Módulo de registro', 2, 2),
(9, 'Reja', 2, 2),
(10, 'Alambre aluminio', 2, 2),
(11, 'Accesorio de Canaleta', 5, 2),
(12, 'Ángulo Externo', 21, 2),
(13, 'Ángulo Interno', 21, 2),
(14, 'Ángulo Plano', 21, 2),
(15, 'Derivación en \"T\"', 21, 2),
(16, 'Tapa Final', 21, 2),
(17, 'Unión', 21, 2),
(18, 'Tapa Final 32*12', 21, 2),
(19, 'Ángulo Externo 32*12', 21, 2),
(20, 'Ángulo Plano 25*25', 21, 2),
(21, 'Unión 25*25', 21, 2),
(22, 'Ángulo Interno 25*25', 21, 2),
(23, 'Ángulo Externo 25*25', 21, 2),
(24, 'T 25*25', 21, 2),
(25, 'Unión 60*40', 21, 2),
(26, 'T 40*25', 21, 2),
(27, 'ASAs', 23, 2),
(28, 'Ganchos para Cable UTP Negro', 23, 2),
(29, 'Ganchos para cable UTP Negro', 28, 2),
(30, 'Aislador de Paso Blanco', 28, 2),
(31, 'Aislador de Esquina Blanco', 28, 2),
(32, 'Tensor con taquete Negro', 28, 2),
(33, 'Tapa Final 20*12', 21, 2),
(34, 'Unión 20*12', 21, 2),
(35, 'Ángulo Plano 20*12', 21, 2),
(36, 'T 20*12', 21, 2),
(37, 'Ángulo Interno 20*12', 21, 2),
(38, 'Ángulo Externo 20*12', 21, 2),
(39, 'Ángulo Interno 13*17', 21, 2),
(40, 'Grapadora para Pared', 28, 2),
(41, 'Rematadora', 28, 2),
(42, 'Sugeta Cable Beige', 28, 2),
(43, 'Abrazadera Unistrut.....', 51, 2),
(44, 'CC....', 51, 2),
(45, 'Conector Flexible..', 51, 2),
(46, 'Conector Flexible', 29, 2),
(47, 'Conector Flexible', 30, 2),
(48, 'Conector Liquati....', 51, 2),
(49, 'Cople....', 51, 2),
(50, 'Cople Roscado', 29, 2),
(51, 'LB', 29, 2),
(52, 'LR', 29, 2),
(53, 'LL', 29, 2),
(54, 'Mufa', 29, 2),
(55, 'Omega', 29, 2),
(56, 'Opresor de Cable', 29, 2),
(57, 'T', 29, 2),
(58, 'Uña', 29, 2),
(59, 'Abrazadera Unistrut', 30, 2),
(60, 'Abrazadera Tipo Pera', 30, 2),
(61, 'C', 30, 2),
(62, 'Conector', 30, 2),
(63, 'Conector Liquati', 30, 2),
(64, 'Cople', 30, 2),
(65, 'Cople Roscado', 30, 2),
(66, 'LB', 30, 2),
(67, 'LL', 30, 2),
(68, 'LR', 30, 2),
(69, 'Mufa', 30, 2),
(70, 'Omega', 30, 2),
(71, 'Opresor de Cable', 30, 2),
(72, 'T', 30, 2),
(73, 'Uña', 30, 2),
(74, 'C', 31, 2),
(75, 'CC', 31, 2),
(76, 'Conector', 31, 2),
(77, 'Conector Flexible', 31, 2),
(78, 'Conector Liquati', 31, 2),
(79, 'Cople', 31, 2),
(80, 'Cople Roscado', 31, 2),
(81, 'LB', 31, 2),
(82, 'Mufa', 31, 2),
(83, 'Omega', 31, 2),
(84, 'Opresor de Cable', 31, 2),
(85, 'T', 31, 2),
(86, 'Uña', 31, 2),
(87, 'Abrazadera Tipo Pera', 29, 2),
(88, 'Abrazadera Unistrut', 31, 2),
(89, 'Ángulo Externo 60*40', 21, 2),
(90, 'Ángulo Interno 60*40', 21, 2),
(91, 'Ángulo Plano 40*40', 21, 2),
(92, 'Tapa Final 25*25', 21, 2),
(93, 'Ángulo Interno 32*12', 21, 2),
(94, 'Ángulo Plano 40*25', 21, 2),
(95, '1m. (3FT.) Gris', 34, 2),
(96, '1m. (3FT.) Gris Cat', 34, 2),
(97, 'Categoría 6', 34, 2),
(98, 'Categoría 5e', 34, 2),
(99, 'Categoría 5', 35, 2),
(100, 'Categoría 5e ', 35, 2),
(101, 'Categoria 6', 35, 2),
(102, 'Categoria 6A', 35, 2),
(103, 'Categoría 5', 38, 2),
(104, 'Categoría 5e', 38, 2),
(105, 'Categoría 6', 38, 2),
(106, 'Categoría 6A', 38, 2),
(107, 'Categoría 5', 40, 2),
(108, 'Categoría 5e', 40, 2),
(109, 'Categoría 6', 40, 2),
(110, 'Categoría 6A', 40, 2),
(111, 'Categoría 5', 34, 2),
(112, 'Categoría 5e', 34, 2),
(113, 'Categoría 6', 34, 2),
(114, 'Categoría 6A', 34, 2),
(115, 'CategorÍa 5', 38, 2),
(116, 'CategorÍa 5e', 38, 2),
(117, 'CategorÍa 6', 38, 2),
(118, 'CategorÍa 6A', 38, 2),
(119, '?', 38, 2),
(120, 'Tapa', 38, 2),
(121, 'C', 51, 2),
(122, 'CC', 51, 2),
(123, 'LB', 51, 2),
(124, 'LL', 51, 2),
(125, 'LR', 51, 2),
(126, 'T', 51, 2),
(127, 'Abrazadera Tipo Pera', 51, 2),
(128, 'Abrazadera Unistrut', 51, 2),
(129, 'Conector', 51, 2),
(130, 'Conector Flexible', 51, 2),
(131, 'Conector Liquati', 51, 2),
(132, 'Cople', 51, 2),
(133, 'Cople Roscado', 51, 2),
(134, 'Mufa', 51, 2),
(135, 'Omega', 51, 2),
(136, 'Opresor de Cable', 51, 2),
(137, 'Uña', 51, 2),
(138, 'Caja Aparente', 51, 2),
(139, 'Caja FS', 51, 2),
(140, 'Chalupa (Registro) Metálica', 51, 2),
(141, 'Chalupa (Registro) Plastico', 51, 2),
(142, 'Tapa Ciega Metálica (2 Orificios)', 51, 2),
(143, 'Tapa Ciega Metálica (4 Orificios)', 51, 2),
(144, 'Tapa Ciega de Plástico', 51, 2),
(145, 'Accesorio Inalámbrico', 58, 2),
(146, 'Baliza', 58, 2),
(147, 'Batería de Respaldo', 58, 2),
(148, 'Batería Gel', 58, 2),
(149, 'Botón de Pánico', 58, 2),
(150, 'Cable', 58, 2),
(151, 'Contacto Magnético', 58, 2),
(152, 'Contacto Magnético Blindado', 58, 2),
(153, 'Detector', 58, 2),
(154, 'Fotoeléctrico', 58, 2),
(155, 'Llaves', 58, 2),
(156, 'Panel', 58, 2),
(157, 'Sirena', 58, 2),
(158, 'Teclado', 58, 2),
(159, 'Adaptador POE', 59, 2),
(160, 'Antena', 59, 2),
(161, 'Antena Celular', 59, 2),
(162, 'Antena GPS', 59, 2),
(163, 'Bracket', 59, 2),
(164, 'Loco', 59, 2),
(165, 'Aceite', 60, 2),
(166, 'Balata', 60, 2),
(167, 'Cargador', 60, 2),
(168, 'Líquidos', 60, 2),
(169, 'Accesorio', 61, 2),
(170, 'Cable', 61, 2),
(171, 'Cámara', 61, 2),
(172, 'Controlador de Domos', 61, 2),
(173, 'DVR', 61, 2),
(174, 'Panel', 61, 2),
(175, 'Cable', 62, 2),
(176, 'CPU', 62, 2),
(177, 'Monitor', 62, 2),
(178, 'Mouse', 62, 2),
(179, 'Teclado', 62, 2),
(180, 'Accesorio', 63, 2),
(181, 'Cable', 63, 2),
(182, 'Chapa Eléctrica', 63, 2),
(183, 'Botón', 63, 2),
(184, 'Interphone', 63, 2),
(185, 'Lectror', 63, 2),
(186, 'Teclado', 63, 2),
(187, 'Accesorio', 64, 2),
(188, 'Apagador', 64, 2),
(189, 'Benjamín', 64, 2),
(190, 'Bombillo', 64, 2),
(191, 'Cable', 64, 2),
(192, 'Cable Ties', 64, 2),
(193, 'Cinta Aislante de Vinil', 64, 2),
(194, 'Clavija', 64, 2),
(195, 'Conector', 64, 2),
(196, 'Contacto', 64, 2),
(197, 'Eliminador', 64, 2),
(198, 'Enchufe', 64, 2),
(199, 'Foco', 64, 2),
(200, 'Fuente', 64, 2),
(201, 'Inversor', 64, 2),
(202, 'Juego de Bases', 64, 2),
(203, 'Lámpara', 64, 2),
(204, 'Regulador', 64, 2),
(205, 'Soquet', 64, 2),
(206, 'Tapa', 64, 2),
(207, 'Terminal de baja tención', 64, 2),
(208, 'Timbre', 64, 2),
(209, 'Toma Superficial', 64, 2),
(210, 'Tomacorriente', 64, 2),
(211, 'Transformador', 64, 2),
(212, 'Pintura', 65, 2),
(213, '.', 65, 2),
(214, '.', 65, 2),
(215, '.', 65, 2),
(216, 'Bolígrafos', 66, 2),
(217, 'Estuche', 66, 2),
(218, 'Hojas de Servicio', 66, 2),
(219, 'Plumas', 66, 2),
(220, 'Accesorio', 67, 2),
(221, 'Canaleta', 67, 2),
(222, 'Canaleta (Accesorio)', 67, 2),
(223, 'Caja Aparente', 67, 2),
(224, 'Coraza', 67, 2),
(225, 'Espiral', 67, 2),
(226, 'Gabinete', 67, 2),
(227, 'Grapa', 67, 2),
(228, 'Grapadora', 67, 2),
(229, 'Jack', 67, 2),
(230, 'Modem', 67, 2),
(231, 'Patchcord', 67, 2),
(232, 'Rack', 67, 2),
(233, 'RJ-45', 67, 2),
(234, 'Tapa', 67, 2),
(235, 'Tapa Ciega', 67, 2),
(236, 'UTP (Accesorio)', 67, 2),
(237, 'UTP (Cable Exterior)', 67, 2),
(238, 'UTP (Cable Interior)', 67, 2),
(239, 'UTP (Pedacería)', 67, 2),
(240, 'Arnes', 68, 2),
(241, 'Barbuquejo', 68, 2),
(242, 'Casco', 68, 2),
(243, 'Casco con Barbuquejo', 68, 2),
(244, 'Chaleco', 68, 2),
(245, 'Cinturon', 68, 2),
(246, 'Guantes Dieléctricos', 68, 2),
(247, 'Guantes Resistentes a Productos Químicos', 68, 2),
(248, 'Línea de vida', 68, 2),
(249, 'Mascarilla Desechable', 68, 2),
(250, 'Monogafas', 68, 2),
(251, 'Mosquetones y Eslingas', 68, 2),
(252, 'Tapón para Oído', 68, 2),
(253, '.', 68, 2),
(254, '.', 68, 2),
(255, '.', 68, 2),
(256, '.', 68, 2),
(257, '.', 68, 2),
(258, '.', 68, 2),
(259, 'Accesorio', 69, 2),
(260, 'Analógica', 69, 2),
(261, 'Digital', 69, 2),
(262, 'Filtros', 69, 2),
(263, 'Rosetas', 69, 2),
(264, '.', 69, 2),
(265, '.', 69, 2),
(266, '.', 69, 2),
(267, 'Coduit', 70, 2),
(268, 'Corrugado', 70, 2),
(269, 'Flexible', 70, 2),
(270, 'Liquitay', 70, 2),
(271, 'PVC', 70, 2),
(272, 'Timbol', 70, 2),
(273, '.', 67, 2),
(274, '.', 67, 2),
(275, '.', 67, 2),
(276, 'g', 70, 2),
(277, 'g', 70, 2),
(278, 'g', 70, 2),
(279, 'g', 70, 2),
(280, 'g', 70, 2),
(281, 'g', 70, 2),
(282, 'g', 70, 2),
(283, 'g', 70, 2),
(284, 'g', 70, 2),
(285, 'g', 70, 2),
(286, 'g', 70, 2),
(287, 'g', 70, 2),
(288, 'g', 69, 2),
(289, 'g', 70, 2),
(290, 'g', 69, 2),
(291, 'g', 70, 2),
(292, 'g', 69, 2),
(293, 'g', 69, 2),
(294, 'g', 70, 2),
(295, 'b', 69, 2),
(296, 'b', 70, 2),
(297, 'b', 69, 2),
(298, 'd', 69, 2),
(299, 'd', 69, 2),
(300, 'f', 68, 2),
(301, 'Accesorio Inalámbrico', 58, 1),
(302, 'Baliza', 58, 1),
(303, 'Batería de Respaldo', 58, 1),
(304, 'Batería Gel', 58, 1),
(305, 'Botón', 58, 1),
(306, 'Cable', 58, 1),
(307, 'Contacto Magnético', 58, 1),
(308, 'Contacto Magnético Blindado', 58, 1),
(309, 'Detector', 58, 1),
(310, 'Fotoeléctrico', 58, 1),
(311, 'Llaves', 58, 1),
(312, 'Panel', 58, 1),
(313, 'Sensor', 58, 1),
(314, 'Sirena', 58, 1),
(315, 'Tamper Switch', 58, 1),
(316, 'Teclado', 58, 1),
(317, 'Cable (Pedaceria)', 58, 1),
(318, 'Transformador', 58, 1),
(319, 'Gabinete', 58, 1),
(320, 'Comunicador', 58, 1),
(321, 'Control Rremoto', 58, 1),
(322, '3', 58, 1),
(323, '2', 58, 1),
(324, '1', 58, 1),
(325, 'Adaptador POE', 59, 1),
(326, 'Antena', 59, 1),
(327, 'Antena Celular', 59, 1),
(328, 'Antena GPS', 59, 1),
(329, 'Bracket', 59, 1),
(330, 'Loco', 59, 1),
(331, 'NanoBeam', 59, 1),
(332, 'KIT', 59, 1),
(333, 'Convertidor', 59, 1),
(334, 'GPS', 59, 1),
(335, '6', 59, 1),
(336, '5', 59, 1),
(337, '4', 59, 1),
(338, '3', 59, 1),
(339, '2', 59, 1),
(340, '1', 59, 1),
(341, 'Aceite', 60, 1),
(342, 'Balata', 60, 1),
(343, 'Cargador', 60, 1),
(344, 'Líquidos', 60, 1),
(345, 'Control Remoto', 60, 1),
(346, 'Inversor', 60, 1),
(347, 'Cable', 60, 1),
(348, '7', 60, 1),
(349, '6', 60, 1),
(350, '5', 60, 1),
(351, 'Micrófono', 61, 1),
(352, 'Digital', 61, 1),
(353, 'Terminal', 61, 1),
(354, 'Video Web Server', 61, 1),
(355, 'Accesorio (CAM)', 61, 1),
(356, 'Siames', 61, 1),
(357, 'Cámara', 61, 1),
(358, 'Conector', 61, 1),
(359, 'Controlador', 61, 1),
(360, 'Fuente de Poder', 61, 1),
(361, 'Grabador de Video', 61, 1),
(362, 'KIT', 61, 1),
(363, 'Amplificador de Señal', 61, 1),
(364, 'Transeptor', 61, 1),
(365, 'Receptor', 61, 1),
(366, 'Transmisor', 61, 1),
(367, 'Convertidor', 61, 1),
(368, 'Siames (Pedacería)', 61, 1),
(369, 'VGA', 61, 1),
(370, 'Switch', 61, 1),
(371, 'Cable Impresora', 62, 1),
(372, 'Cable Monitor', 62, 1),
(373, 'CPU', 62, 1),
(374, 'HDMI', 62, 1),
(375, 'Monitor', 62, 1),
(376, 'Mouse', 62, 1),
(377, 'Teclado', 62, 1),
(378, 'VGA', 62, 1),
(379, 'Disco Duro', 62, 1),
(380, 'Regulador', 62, 1),
(381, '5', 62, 1),
(382, '4', 62, 1),
(383, '3', 62, 1),
(384, '2', 62, 1),
(385, '1', 62, 1),
(386, 'Accesorio', 63, 1),
(387, 'Botón', 63, 1),
(388, 'Cable', 63, 1),
(389, 'Cerradura Magnética ', 63, 1),
(390, 'Chapa Magnética', 63, 1),
(391, 'Fuente', 63, 1),
(392, 'Gabinete', 63, 1),
(393, 'Interphone ', 63, 1),
(394, 'Lector', 63, 1),
(395, 'Teclado', 63, 1),
(396, 'Targeta', 63, 1),
(397, 'Relevador', 63, 1),
(398, 'Receptor', 63, 1),
(399, 'Videoportero', 63, 1),
(400, 'Modulo', 63, 1),
(401, 'Sensor', 63, 1),
(402, 'KIT', 63, 1),
(403, 'Control Remoto', 63, 1),
(404, 'Accesorio', 64, 1),
(405, 'Apagador', 64, 1),
(406, 'Benjamín', 64, 1),
(407, 'Bombillo', 64, 1),
(408, 'Cable', 64, 1),
(409, 'Cable Ties', 64, 1),
(410, 'Cinta Aislante de Vinil', 64, 1),
(411, 'Clavija', 64, 1),
(412, 'Conector ', 64, 1),
(413, 'Contacto de resorte (Capuchón)', 64, 1),
(414, 'Eliminador', 64, 1),
(415, 'Enchufe', 64, 1),
(416, 'Foco', 64, 1),
(417, 'Fuente', 64, 1),
(418, 'Inversor', 64, 1),
(419, 'Juego de Bases', 64, 1),
(420, 'Lámpara', 64, 1),
(421, 'Pastilla', 64, 1),
(422, 'Regulador', 64, 1),
(423, 'Soquet', 64, 1),
(424, 'Tapa', 64, 1),
(425, 'Terminal de baja tención', 64, 1),
(426, 'Timbre', 64, 1),
(427, 'Toma Superficial', 64, 1),
(428, 'Tomacorriente', 64, 1),
(429, 'Transformador', 64, 1),
(430, 'KIT', 64, 1),
(431, 'Soporte y Tapa', 64, 1),
(432, 'Interruptor', 64, 1),
(433, 'Gabinete', 64, 1),
(434, 'Celda Solar', 64, 1),
(435, 'Balastra', 64, 1),
(436, 'Adaptador', 64, 1),
(437, 'Protector', 64, 1),
(438, 'UPS', 64, 1),
(439, 'Pila', 64, 1),
(440, '.', 64, 1),
(441, '.', 64, 1),
(442, 'Pintura', 65, 1),
(443, '7', 65, 1),
(444, '6', 65, 1),
(445, '5', 65, 1),
(446, '4', 65, 1),
(447, '3', 65, 1),
(448, '2', 65, 1),
(449, '1', 65, 1),
(450, 'Bolígrafos', 66, 1),
(451, 'Estuche', 66, 1),
(452, 'Hojas de Servicio', 66, 1),
(453, 'Plumas', 66, 1),
(454, 'Blu ray', 66, 1),
(455, '9', 66, 1),
(456, '8', 66, 1),
(457, '7', 66, 1),
(458, '6', 66, 1),
(459, '5', 66, 1),
(460, '4', 66, 1),
(461, '3', 66, 1),
(462, '2', 66, 1),
(463, 'PatchLink', 71, 1),
(464, 'Accesorio', 67, 1),
(465, 'Tomacorriente', 71, 1),
(466, 'Cable', 67, 1),
(467, 'Caja Aparente', 71, 1),
(468, 'Canaletaa', 71, 1),
(469, 'Canaleta (Accesorio)', 71, 1),
(470, 'Coraza', 71, 1),
(471, 'Espiral', 71, 1),
(472, 'Gancho', 67, 1),
(473, 'Grapaa', 71, 1),
(474, 'Grapadora', 71, 1),
(475, 'Jack', 71, 1),
(476, 'Modem', 67, 1),
(477, 'Patchcord', 71, 1),
(478, 'Placa para Pared', 71, 1),
(479, 'Charola', 71, 1),
(480, 'Remachadora', 71, 1),
(481, 'RJ-45', 71, 1),
(482, 'Sujeta Cable', 71, 1),
(483, 'Switch', 67, 1),
(484, 'Tapa Ciega', 71, 1),
(485, 'Tensor', 71, 1),
(486, 'UTP (Accesorio)', 71, 1),
(487, 'UTP (Exterior)', 71, 1),
(488, 'UTP (Ext. Pedacería)', 71, 1),
(489, 'UTP (Interior)', 71, 1),
(490, 'UTP (Int. Pedacería)', 71, 1),
(491, 'Distribuidor', 67, 1),
(492, 'Panel de Parcheo', 71, 1),
(493, 'Organizador', 71, 1),
(494, 'Rutreador', 67, 1),
(495, '1', 67, 1),
(496, 'Arnes', 68, 1),
(497, 'Barbuquejo', 68, 1),
(498, 'Casco', 68, 1),
(499, 'Casco con Barbuquejo', 68, 1),
(500, 'Chaleco', 68, 1),
(501, 'Cinturon', 68, 1),
(502, 'Facial de Media Cara', 68, 1),
(503, 'Gafas', 68, 1),
(504, 'Gorro o Cofia', 68, 1),
(505, 'Guantes de Plástico Desechables', 68, 1),
(506, 'Guantes Dieléctricos', 68, 1),
(507, 'Guantes Resistentes a Productos Químicos', 68, 1),
(508, 'Línea de vida', 68, 1),
(509, 'Mascarilla Desechable', 68, 1),
(510, 'Monogafas', 68, 1),
(511, 'Mosquetones y Eslingas', 68, 1),
(512, 'Sombrero', 68, 1),
(513, 'Tapón para Oído', 68, 1),
(514, '8', 68, 1),
(515, '7', 68, 1),
(516, '6', 68, 1),
(517, '5', 68, 1),
(518, '4', 68, 1),
(519, '3', 68, 1),
(520, '2', 68, 1),
(521, '1', 68, 1),
(522, 'Accesorio', 69, 1),
(523, 'Analógica', 69, 1),
(524, 'Cable', 69, 1),
(525, 'Digital', 69, 1),
(526, 'Filtro', 69, 1),
(527, 'Roseta', 69, 1),
(528, 'IP', 69, 1),
(529, 'Unidad de Control', 69, 1),
(530, 'Interruptor', 69, 1),
(531, 'Central', 69, 1),
(532, '5', 69, 1),
(533, '4', 69, 1),
(534, '3', 69, 1),
(535, '2', 69, 1),
(536, '1', 69, 1),
(537, 'Accesorio', 70, 1),
(538, 'Accesorio 2.', 70, 1),
(539, 'Accesorio 1 1/2.', 70, 1),
(540, 'Accesorio 1 1/4.', 70, 1),
(541, 'Accesorio 1.', 70, 1),
(542, 'Accesorio 1/2.', 70, 1),
(543, 'Accesorio 3/4.', 70, 1),
(544, 'Accesorio 3/8.', 70, 1),
(545, 'Tubo', 70, 1),
(546, 'Corrugado', 70, 1),
(547, 'Flexible', 70, 1),
(548, 'Liquitay', 70, 1),
(549, 'Chalupa', 70, 1),
(550, '3', 70, 1),
(551, '2', 70, 1),
(552, '1', 70, 1),
(553, 'Aislador', 72, 1),
(554, 'Alambre de Aluminio', 72, 1),
(555, '9', 72, 1),
(556, '8', 72, 1),
(557, '7', 72, 1),
(558, '6', 72, 1),
(559, '5', 72, 1),
(560, '4', 72, 1),
(561, '3', 72, 1),
(562, '2', 72, 1),
(563, 'Consola', 73, 1),
(564, '*', 71, 2),
(565, 'Amplificador', 73, 1),
(566, 'Microfono', 73, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `id` int(11) NOT NULL,
  `estado` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`id`, `estado`, `estatus`) VALUES
(2, 'Nuevo', 1),
(3, 'Usuado', 1),
(4, 'Descompuesto', 1),
(5, 'F', 2),
(6, 'Emplallado', 1),
(7, 'Incompleto', 1),
(8, 'Francisco Madero', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `herramienta`
--

CREATE TABLE `herramienta` (
  `id` int(11) NOT NULL,
  `herramienta` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` varchar(250) COLLATE utf8_spanish_ci NOT NULL,
  `marca` int(11) NOT NULL,
  `modelo` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estado` int(11) NOT NULL,
  `imagen` varchar(75) COLLATE utf8_spanish_ci NOT NULL,
  `existencia` int(11) NOT NULL,
  `seccion` int(11) NOT NULL,
  `almace` int(11) NOT NULL,
  `estatus` int(11) NOT NULL,
  `totale` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `herramienta`
--

INSERT INTO `herramienta` (`id`, `herramienta`, `descripcion`, `marca`, `modelo`, `estado`, `imagen`, `existencia`, `seccion`, `almace`, `estatus`, `totale`) VALUES
(16, 'Guía', 'Color Rojo', 15, '**', 3, 'na.jpg', 1, 31, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `herramientaunf`
--

CREATE TABLE `herramientaunf` (
  `id` int(11) NOT NULL,
  `tool` int(11) NOT NULL,
  `description` int(11) NOT NULL,
  `modelo` int(11) NOT NULL,
  `imagen` int(11) NOT NULL,
  `existencia` int(11) NOT NULL,
  `marcasunf` int(11) NOT NULL,
  `estadounf` int(11) NOT NULL,
  `seccionunf` int(11) NOT NULL,
  `almacenunf` int(11) NOT NULL,
  `razon` varchar(115) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `herramientaunf`
--

INSERT INTO `herramientaunf` (`id`, `tool`, `description`, `modelo`, `imagen`, `existencia`, `marcasunf`, `estadounf`, `seccionunf`, `almacenunf`, `razon`, `cantidad`, `estatus`) VALUES
(1, 16, 16, 16, 16, 16, 15, 4, 5, 1, 'Ninguna papu :v', 1, 2),
(2, 16, 16, 16, 16, 16, 15, 4, 5, 1, 'Falta cambiar los carbones...', 1, 2),
(3, 16, 16, 16, 16, 16, 15, 4, 5, 1, 'Desconociodo', 1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagen`
--

CREATE TABLE `imagen` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `imagen` varchar(75) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `imagen`
--

INSERT INTO `imagen` (`id`, `nombre`, `imagen`, `estatus`) VALUES
(2, 'imagen1', 'prueba.png', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingresos`
--

CREATE TABLE `ingresos` (
  `id` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `fecha` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `ingresos`
--

INSERT INTO `ingresos` (`id`, `usuario`, `fecha`) VALUES
(5, 2, '2018-07-19 10:14:35'),
(6, 15, '2018-07-19 10:16:05'),
(7, 15, '2018-07-19 10:31:07'),
(8, 2, '2018-07-19 10:44:13'),
(9, 2, '2018-07-19 16:11:53'),
(10, 2, '2018-07-21 09:44:27'),
(11, 12, '2018-07-21 12:18:58'),
(12, 15, '2018-07-21 12:20:48'),
(13, 2, '2018-07-21 13:00:04'),
(14, 12, '2018-07-21 13:31:10'),
(15, 15, '2018-07-23 08:52:34'),
(16, 2, '2018-07-23 09:05:17'),
(17, 2, '2018-07-23 11:17:42'),
(18, 12, '2018-07-23 17:32:25'),
(19, 2, '2018-07-24 10:11:25'),
(20, 12, '2018-07-27 09:23:19'),
(21, 10, '2018-07-27 10:25:59'),
(22, 12, '2018-07-27 10:27:13'),
(23, 2, '2018-07-30 15:06:25'),
(24, 15, '2018-07-30 18:11:22'),
(25, 12, '2018-07-31 12:13:01'),
(26, 2, '2018-07-31 12:36:26'),
(27, 10, '2018-07-31 18:16:51'),
(28, 15, '2018-08-01 09:08:31'),
(29, 10, '2018-08-01 09:10:24'),
(30, 12, '2018-08-01 09:18:28'),
(31, 15, '2018-08-01 09:56:12'),
(32, 2, '2018-08-01 11:20:21'),
(33, 2, '2018-08-01 12:25:18'),
(34, 12, '2018-08-03 09:25:24'),
(35, 12, '2018-08-04 09:57:16'),
(36, 12, '2018-08-06 12:21:51'),
(37, 12, '2018-08-06 15:10:59'),
(38, 12, '2018-08-07 10:07:55'),
(39, 2, '2018-08-07 10:22:15'),
(40, 12, '2018-08-08 08:57:53'),
(41, 12, '2018-08-09 10:33:37'),
(42, 12, '2018-08-13 11:22:05'),
(43, 2, '2018-08-13 12:22:18'),
(44, 2, '2018-08-16 16:51:54'),
(45, 2, '2018-08-16 17:10:21'),
(46, 10, '2018-08-16 17:39:43'),
(47, 12, '2018-08-17 15:56:03'),
(48, 2, '2018-08-20 09:29:34'),
(49, 12, '2018-08-20 16:14:34'),
(50, 2, '2018-08-23 09:18:06'),
(51, 2, '2018-08-28 16:44:36'),
(52, 12, '2018-08-30 08:49:39'),
(53, 2, '2018-09-04 15:59:43'),
(54, 2, '2018-09-10 18:22:59'),
(55, 12, '2018-09-19 12:11:13'),
(56, 12, '2018-09-28 11:29:10'),
(57, 2, '2018-09-28 13:51:32'),
(58, 2, '2018-10-10 18:20:51'),
(59, 2, '2018-10-10 18:25:09'),
(60, 2, '2018-10-16 10:07:41'),
(61, 12, '2018-10-16 11:07:24'),
(62, 10, '2018-10-16 15:04:00'),
(63, 12, '2018-10-17 18:12:39'),
(64, 10, '2018-10-30 15:38:12'),
(65, 12, '2018-10-31 09:34:03'),
(66, 10, '2018-10-31 10:47:49'),
(67, 12, '2018-11-07 13:05:20'),
(68, 12, '2018-11-08 10:21:17'),
(69, 10, '2018-11-08 13:06:14'),
(70, 12, '2018-11-13 12:45:49'),
(71, 2, '2018-11-16 11:21:17'),
(72, 10, '2018-11-26 10:47:54'),
(73, 2, '2018-11-26 12:54:11'),
(74, 10, '2018-11-27 10:02:19'),
(75, 12, '2018-11-27 11:07:31'),
(76, 12, '2018-11-28 09:19:56'),
(77, 10, '2018-11-28 09:36:20'),
(78, 12, '2018-11-29 09:22:38'),
(79, 12, '2018-11-30 10:51:53'),
(80, 10, '2018-11-30 12:37:11'),
(81, 12, '2018-12-01 09:25:14'),
(82, 12, '2018-12-04 16:47:38'),
(83, 12, '2018-12-05 18:06:29'),
(84, 12, '2018-12-06 12:05:24'),
(85, 12, '2018-12-07 16:17:09'),
(86, 12, '2018-12-08 14:11:00'),
(87, 12, '2018-12-10 11:00:14'),
(88, 12, '2018-12-12 09:58:03'),
(89, 12, '2018-12-13 09:24:06'),
(90, 12, '2018-12-14 09:29:33'),
(91, 12, '2018-12-14 15:52:57'),
(92, 12, '2018-12-15 10:41:23'),
(93, 12, '2018-12-15 12:00:09'),
(94, 12, '2018-12-18 09:23:51'),
(95, 12, '2018-12-18 10:00:06'),
(96, 2, '2018-12-18 11:21:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `loanback`
--

CREATE TABLE `loanback` (
  `id` int(11) NOT NULL,
  `estatus` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `loanback`
--

INSERT INTO `loanback` (`id`, `estatus`) VALUES
(1, 'En prestamo'),
(2, 'Eliminado'),
(3, 'Devuelto'),
(4, 'Devuelto una parte');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `id` int(11) NOT NULL,
  `marca` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `categoria` int(11) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`id`, `marca`, `categoria`, `estatus`) VALUES
(1, 'Dahua', 1, 2),
(2, 'Makita', 2, 2),
(4, 'Truper', 2, 2),
(5, 'Dremel', 2, 2),
(6, 'Urrea', 2, 2),
(7, 'Ubiquite', 1, 2),
(8, 'Dahua', 2, 2),
(9, 'CROW', 1, 2),
(10, 'HONEYWELL', 1, 2),
(11, 'Alhua', 1, 2),
(12, 'DEXON', 1, 1),
(13, 'DESCONOCIDO', 1, 2),
(14, 'YONUSA', 1, 2),
(15, 'N/A', 2, 1),
(16, 'Optronics', 1, 2),
(17, 'Panduit', 1, 2),
(18, '*', 1, 2),
(19, '****', 1, 2),
(20, 'N/A', 1, 2),
(21, 'N / A', 1, 2),
(22, '.N/A', 1, 2),
(23, 'LINKEDPRO', 1, 2),
(24, 'Ubiquiti', 1, 2),
(25, 'HIK VISION', 1, 2),
(26, 'AXIS', 1, 2),
(27, 'VIVOTEK', 1, 2),
(28, '.n/a', 1, 2),
(29, '.N/A', 1, 1),
(30, '*', 1, 1),
(31, '.S/M', 1, 1),
(32, '3M', 1, 1),
(33, '600 Resolution ULTRA TVL', 1, 1),
(34, 'ACCESSPRO', 1, 1),
(35, 'ACCESSPRO ADVANCED', 1, 1),
(36, 'AccessPro*Lite', 1, 1),
(37, 'Dahua', 1, 1),
(38, 'ALL-STATES', 1, 1),
(39, 'ALTRONIX', 1, 1),
(40, 'ANBEC', 1, 1),
(41, 'ARGOS', 1, 1),
(42, 'Armonia', 1, 1),
(43, 'Armorall', 1, 1),
(44, 'AVTECH', 1, 1),
(45, 'Berel', 1, 1),
(46, 'BISEN SMART', 1, 1),
(47, 'BRADY', 1, 1),
(48, 'Bticino', 1, 1),
(49, 'CASIL', 1, 1),
(50, 'CISCO', 1, 1),
(51, 'CNB', 1, 1),
(52, 'COMMAX', 1, 1),
(53, 'Cooper', 1, 1),
(54, 'CROW', 1, 1),
(55, 'CTW', 1, 1),
(56, 'CUSTER', 1, 1),
(57, 'CyberPower', 1, 1),
(58, 'Dahua', 1, 1),
(59, 'DEXSON', 1, 1),
(60, 'Die Hard', 1, 1),
(61, 'DSC', 1, 1),
(62, 'EATÓN', 1, 1),
(63, 'ECO MR16 Halogen', 1, 1),
(64, 'ELK PRODUCTS', 1, 1),
(65, 'enercell', 1, 1),
(66, 'EnGenius', 1, 1),
(67, 'EPCOM', 1, 1),
(68, 'EPCOM ELEMENT', 1, 1),
(69, 'EPCOM Industrial', 1, 1),
(70, 'EPCOM POWER-LINE', 1, 1),
(71, 'EPCOM TITANIUM', 1, 1),
(72, 'EQ MEDIC', 1, 1),
(73, 'GENERAL PAINT', 1, 1),
(74, 'Gigaware', 1, 1),
(75, 'GrandStream', 1, 1),
(76, 'Apple', 1, 1),
(77, 'HAGROY', 1, 1),
(78, 'Hawk Vision', 1, 1),
(79, 'HD VISION', 1, 1),
(80, 'HIKVISION ', 1, 1),
(81, 'HONEYWELL', 1, 1),
(82, 'HP', 1, 1),
(83, 'IGESA', 1, 1),
(84, 'IMPAC', 1, 1),
(85, 'Indiana Wire&Cable', 1, 1),
(86, 'Insta bulb', 1, 1),
(87, 'INSTANT POWER', 1, 1),
(88, 'ISB SOLA BASIC', 1, 1),
(89, 'JYRSA', 1, 1),
(90, 'Kenword', 1, 1),
(91, 'Kimberly Clark', 1, 1),
(92, 'LAYMON', 1, 1),
(93, 'Leviton', 1, 1),
(94, 'LinkedPro', 1, 1),
(95, 'LIQUI MOLY', 1, 1),
(96, 'LOCK', 1, 1),
(97, 'Lumiaction', 1, 1),
(98, 'MAG LITE', 1, 1),
(99, 'Makita', 1, 1),
(100, 'manhattan ', 1, 1),
(101, 'MICROCOM', 1, 1),
(102, 'Mobil Super', 1, 1),
(103, 'Motana', 1, 1),
(104, 'Motorola', 1, 1),
(105, 'NETGEAR', 1, 1),
(106, 'Optronics', 1, 1),
(107, 'OSRAM', 1, 1),
(108, 'Panduit', 1, 1),
(109, 'PHILIPS', 1, 1),
(110, 'PLANET', 1, 1),
(111, 'Plus Lighting', 1, 1),
(112, 'PolyPhaser', 1, 1),
(113, 'Power Beam', 1, 1),
(114, 'PRO One', 1, 1),
(115, 'Products pennsylvania', 1, 1),
(116, 'Prolok', 1, 1),
(117, 'PRYME RADIO', 1, 1),
(118, 'QUIMICA TF', 1, 1),
(119, 'Radi Shack', 1, 1),
(120, 'RADOX', 1, 1),
(121, 'RF ELEMENTS NORT', 1, 1),
(122, 'ROHS', 1, 1),
(123, 'ROSSLARE', 1, 1),
(124, 'ROWAN', 1, 1),
(125, 'Rowelt', 1, 1),
(126, 'SamlexPower', 1, 1),
(127, 'SAXXON', 1, 1),
(128, 'SECO-LARM', 1, 1),
(129, 'SFIRE', 1, 2),
(130, 'S-FIRE', 1, 1),
(131, 'SHINE & BRIGTH', 1, 1),
(132, 'SKYPATROL', 1, 1),
(133, 'STAR', 1, 1),
(134, 'STEREN', 1, 1),
(135, 'SYSCOM BY KOCOM', 2, 2),
(136, 'SYSCOM', 1, 1),
(137, 'SYSCOM BY KOCOM', 1, 1),
(138, 'Tecno Lite', 1, 1),
(139, 'TELMEX', 1, 1),
(140, 'THORSMAN', 1, 1),
(141, 'TICON POWER', 1, 1),
(142, 'TP-LINK', 1, 1),
(143, 'TRUPER', 1, 1),
(144, 'Turtle Max', 1, 1),
(145, 'TVC', 1, 1),
(146, 'UBIQUITI', 1, 1),
(147, 'UBIQUITI NETWORKS', 1, 1),
(148, 'Uniview', 1, 1),
(149, 'Urmet', 1, 1),
(150, 'Urrea', 1, 1),
(151, 'VIDEOCOM', 1, 1),
(152, 'VIVOTEK', 1, 1),
(153, 'WAGNER', 1, 1),
(154, 'YLI', 1, 1),
(155, 'YLI ELECTRONIC', 1, 1),
(156, 'Yonusa', 1, 1),
(157, 'ZAVIO', 1, 1),
(158, '****************************', 1, 1),
(159, 'Black&Decker', 2, 2),
(160, '.N/A', 2, 1),
(161, 'Black&Decker', 2, 1),
(162, 'DAI', 2, 1),
(163, 'DeWalt', 2, 1),
(164, 'Dremel', 2, 1),
(165, 'HITACHI', 2, 1),
(166, 'Milwakee', 2, 1),
(167, 'RIOBI', 2, 1),
(168, 'SURE BILT', 2, 1),
(169, 'Arrow', 1, 2),
(170, '********************************', 1, 1),
(171, 'ARROW FASTENER', 1, 1),
(172, 'NetKey', 1, 1),
(173, 'NVT', 1, 1),
(174, '********************************', 2, 1),
(175, 'TOOLCRAFT', 2, 1),
(176, 'ARROW FASTENER', 2, 1),
(177, '********************************', 1, 1),
(178, 'Coduit', 1, 1),
(179, 'Condulet', 1, 1),
(180, 'PVC', 1, 1),
(181, 'Timbol', 1, 1),
(182, 'Derma Care', 1, 1),
(183, 'Warnex', 1, 1),
(184, 'By Lack', 1, 1),
(185, 'WESTERN', 1, 1),
(186, 'MEAN WELL', 1, 1),
(187, 'WD', 1, 1),
(188, 'HORN', 1, 1),
(189, 'ADTEK', 1, 1),
(190, 'Panasonic', 1, 1),
(191, 'ZKTECO', 1, 1),
(192, 'RADSON', 1, 1),
(193, 'ENFORCER', 1, 1),
(194, 'ANDREW', 1, 1),
(195, 'ADEMCO', 1, 1),
(196, 'SIEMENS', 1, 1),
(197, 'ALCODM', 1, 1),
(198, 'SAMSUNG', 1, 1),
(199, 'THOMSON', 1, 1),
(200, 'INTELLINET', 1, 1),
(201, 'HARDEN', 1, 1),
(202, 'BLACK DECKER', 1, 1),
(203, 'EN388', 1, 1),
(204, 'StarTech', 1, 1),
(205, 'LIENPRO', 1, 1),
(206, 'UTEPO', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mercancia`
--

CREATE TABLE `mercancia` (
  `id` int(11) NOT NULL,
  `mercancia` int(11) NOT NULL,
  `marcas` int(11) NOT NULL,
  `modelo` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` int(11) NOT NULL,
  `coment` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `imagenes` varchar(75) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `seccionm` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `mercancia`
--

INSERT INTO `mercancia` (`id`, `mercancia`, `marcas`, `modelo`, `descripcion`, `coment`, `imagenes`, `estatus`, `cantidad`, `seccionm`) VALUES
(7, 70, 181, 'x', 538, 'Abrazadera tipo Pera', '7.jpg', 1, 0, 76),
(8, 70, 181, 'x', 538, 'Abrazadera Unistrut', '8.jpg', 1, 33, 59),
(9, 70, 179, 'x', 538, 'CC', '9.jpg', 1, 1, 59),
(10, 70, 181, 'x', 538, 'Conector', '10.jpg', 1, 5, 59),
(11, 70, 181, 'x', 538, 'Conector Flexible', '11.jpg', 1, 10, 59),
(12, 70, 181, 'x', 538, 'Conector Liquati', '12.jpg', 1, 0, 76),
(13, 70, 181, 'x', 538, 'Cople', '13.jpg', 1, 7, 59),
(14, 70, 181, 'x', 538, 'Cople Roscado', '14.jpg', 1, 0, 76),
(15, 70, 179, 'x', 538, 'LB', '15.jpg', 1, 0, 76),
(28, 70, 179, 'x', 538, 'LL', '0.png', 1, 0, 76),
(29, 70, 179, 'x', 538, 'LR', '29.png', 1, 0, 76),
(44, 70, 181, 'x', 538, 'Mordaza', '0.png', 1, 0, 76),
(45, 70, 181, 'x', 538, 'Mufa', '45.jpg', 1, 0, 76),
(46, 70, 181, 'x', 538, 'Omega', '46.jpg', 1, 8, 59),
(47, 70, 181, 'x', 538, 'Opresor', '0.png', 1, 0, 76),
(48, 70, 179, 'x', 538, 'T', '48.png', 1, 1, 59),
(49, 70, 181, 'x', 538, 'Uña', '49.jpg', 1, 6, 59),
(50, 70, 181, 'x', 539, 'Abrazadera tipo Pera', '0.png', 1, 0, 76),
(51, 70, 181, 'x', 539, 'Abrazadera Unistrut', '0.png', 1, 33, 60),
(52, 70, 179, 'x', 539, 'CC', '0.png', 1, 2, 60),
(53, 70, 181, 'x', 539, 'Conector', '53.jpg', 1, 16, 60),
(54, 70, 181, 'x', 539, 'Conector Flexible', '54.jpg', 1, 2, 60),
(55, 70, 181, 'x', 539, 'Conector Liquati', '0.png', 1, 0, 76),
(56, 70, 181, 'x', 539, 'Cople', '56.jpg', 1, 6, 60),
(57, 70, 181, 'x', 539, 'Cople Roscado', '57.png', 1, 1, 76),
(58, 70, 179, 'x', 539, 'LB', '58.jpg', 1, 2, 60),
(59, 70, 179, 'x', 539, 'LL', '0.png', 1, 0, 76),
(60, 70, 179, 'x', 539, 'LR', '0.png', 1, 0, 76),
(61, 70, 181, 'x', 539, 'Mordaza', '0.png', 1, 0, 76),
(62, 70, 181, 'x', 539, 'Mufa', '62.jpg', 1, 0, 76),
(63, 70, 181, 'x', 539, 'Omega', '63.jpg', 1, 18, 60),
(64, 70, 181, 'x', 539, 'Opresor\r\n', '0.png', 1, 0, 76),
(65, 70, 179, 'x', 539, 'T', '0.png', 1, 0, 76),
(66, 70, 181, 'x', 539, 'Uña', '66.jpg', 1, 5, 60),
(67, 70, 181, 'x', 540, 'Abrazadera tipo Pera', '67.jpg', 1, 1, 61),
(68, 70, 181, 'x', 540, 'Abrazadera Unistrut', '0.png', 1, 0, 76),
(69, 70, 179, 'x', 540, 'CC', '0.png', 1, 0, 76),
(70, 70, 181, 'x', 540, 'Conector', '70.jpg', 1, 18, 61),
(71, 70, 181, 'x', 540, 'Conector Flexible', '71.jpg', 1, 13, 61),
(72, 70, 181, 'x', 540, 'Conector Liquati', '72.jpg', 1, 0, 76),
(73, 70, 181, 'x', 540, 'Cople', '73.jpg', 1, 19, 61),
(74, 70, 181, 'x', 540, 'Cople Roscado', '74.jpg', 1, 4, 61),
(75, 70, 179, 'x', 540, 'LB', '75.jpg', 1, 0, 76),
(76, 70, 179, 'x', 540, 'LL', '0.png', 1, 0, 76),
(77, 70, 179, 'x', 540, 'LR', '0.png', 1, 0, 76),
(78, 70, 181, 'x', 540, 'Mordaza', '0.png', 1, 35, 61),
(79, 70, 181, 'x', 540, 'Mufa', '0.png', 1, 0, 76),
(80, 70, 181, 'x', 540, 'Omega', '80.jpg', 1, 5, 61),
(81, 70, 181, 'x', 540, 'Opresor', '0.png', 1, 0, 76),
(82, 70, 179, 'x', 540, 'T', '0.png', 1, 0, 76),
(83, 70, 181, 'x', 540, 'Uña', '83.jpg', 1, 12, 61),
(84, 70, 181, 'x', 541, 'Abrazadera tipo Pera', '0.png', 1, 0, 76),
(85, 70, 181, 'x', 541, 'Abrazadera Unistrut', '85.jpg', 1, 24, 40),
(86, 70, 179, 'x', 541, 'CC', '0.png', 1, 4, 40),
(87, 70, 181, 'x', 541, 'Conector', '87.jpg', 1, 19, 40),
(88, 70, 181, 'x', 541, 'Conector Flexible', '0.png', 1, 14, 40),
(89, 70, 181, 'x', 541, 'Conector Liquati', '89.jpg', 1, 9, 40),
(90, 70, 181, 'x', 541, 'Cople', '90.jpg', 1, 36, 40),
(91, 70, 181, 'x', 541, 'Cople Roscado', '91.jpg', 1, 30, 40),
(92, 70, 179, 'x', 541, 'LB', '92.jpg', 1, 11, 40),
(93, 70, 179, 'x', 541, 'LL', '93.jpg', 1, 5, 40),
(94, 70, 179, 'x', 541, 'LR', '94.png', 1, 5, 40),
(95, 70, 181, 'x', 541, 'Mordaza', '0.png', 1, 0, 40),
(96, 70, 181, 'x', 541, 'Mufa', '96.jpg', 1, 7, 40),
(97, 70, 181, 'x', 541, 'Omega', '97.png', 1, 46, 40),
(98, 70, 181, 'x', 541, 'Opresor', '0.png', 1, 18, 40),
(99, 70, 179, 'x', 541, 'T', '99.png', 1, 4, 40),
(100, 70, 181, 'x', 541, 'Uña', '100.jpg', 1, 31, 40),
(101, 70, 181, 'x', 542, 'Abrazadera tipo Pera', '101.jpg', 1, 29, 41),
(102, 70, 181, 'x', 542, 'Abrazadera Unistrut', '102.png', 1, 25, 41),
(103, 70, 179, 'x', 542, 'CC', '103.jpg', 1, 6, 41),
(104, 70, 181, 'x', 542, 'Conector', '104.jpg', 1, 40, 41),
(105, 70, 181, 'x', 542, 'Conector Flexible', '105.jpg', 1, 39, 41),
(106, 70, 181, 'x', 542, 'Conector Liquati', '106.jpg', 1, 13, 41),
(107, 70, 181, 'x', 542, 'Cople', '107.jpg', 1, 83, 41),
(108, 70, 181, 'x', 542, 'Cople Roscado', '108.jpg', 1, 16, 41),
(109, 70, 179, 'x', 542, 'LB', '109.png', 1, 15, 41),
(110, 70, 179, 'x', 542, 'LL', '110.png', 1, 12, 41),
(111, 70, 179, 'x', 542, 'LR', '111.png', 1, 7, 41),
(112, 70, 181, 'x', 542, 'Mordaza', '0.png', 1, 0, 41),
(113, 70, 181, 'x', 542, 'Mufa', '113.jpg', 1, 7, 41),
(114, 70, 181, 'x', 542, 'Omega', '114.jpg', 1, 27, 41),
(115, 70, 181, 'x', 542, 'Opresor', '115.jpg', 1, 32, 41),
(116, 70, 179, 'x', 542, 'T', '116.jpg', 1, 3, 41),
(117, 70, 181, 'x', 542, 'Uña', '117.jpg', 1, 43, 41),
(118, 70, 181, 'x', 543, 'Abrazadera tipo Pera', '118.jpg', 1, 92, 42),
(119, 70, 181, 'x', 543, 'Abrazadera Unistrut', '119.jpg', 1, 23, 42),
(120, 70, 179, 'x', 543, 'CC', '120.jpg', 1, 8, 42),
(121, 70, 181, 'x', 543, 'Conector', '121.jpg', 1, 29, 42),
(122, 70, 181, 'x', 543, 'Conector Flexible', '122.png', 1, 40, 42),
(123, 70, 181, 'x', 543, 'Conector Liquati', '123.jpg', 1, 12, 42),
(124, 70, 181, 'x', 543, 'Cople', '124.jpg', 1, 61, 42),
(125, 70, 181, 'x', 543, 'Cople Roscado', '125.jpg', 1, 20, 42),
(126, 70, 179, 'x', 543, 'LB', '126.jpg', 1, 18, 42),
(127, 70, 179, 'x', 543, 'LL', '127.jpg', 1, 3, 42),
(128, 70, 179, 'x', 543, 'LR', '128.jpg', 1, 12, 42),
(129, 70, 181, 'x', 543, 'Mordaza', '0.png', 1, 18, 42),
(130, 70, 181, 'x', 543, 'Mufa', '130.jpg', 1, 2, 42),
(131, 70, 181, 'x', 543, 'Omega', '131.jpg', 1, 78, 42),
(132, 70, 181, 'x', 543, 'Opresor', '132.jpg', 1, 10, 42),
(133, 70, 179, 'x', 543, 'T', '133.jpg', 1, 4, 42),
(134, 70, 181, 'x', 543, 'Uña', '134.jpg', 1, 51, 42),
(135, 70, 181, 'x', 544, 'Abrazadera tipo Pera', '0.png', 1, 0, 76),
(136, 70, 181, 'x', 544, 'Abrazadera Unistrut', '0.png', 1, 0, 76),
(137, 70, 179, 'x', 544, 'CC', '0.png', 1, 0, 76),
(138, 70, 181, 'x', 544, 'Conector', '0.png', 1, 0, 76),
(139, 70, 181, 'x', 544, 'Conector Flexible', '139.jpg', 1, 16, 43),
(140, 70, 181, 'x', 544, 'Conector Liquati', '140.jpg', 1, 8, 43),
(141, 70, 181, 'x', 544, 'Cople', '0.png', 1, 0, 76),
(142, 70, 181, 'x', 544, 'Cople Roscado', '0.png', 1, 0, 76),
(143, 70, 179, 'x', 544, 'LB', '0.png', 1, 0, 76),
(144, 70, 179, 'x', 544, 'LL', '0.png', 1, 0, 76),
(145, 70, 179, 'x', 544, 'LR', '0.png', 1, 0, 76),
(146, 70, 181, 'x', 544, 'Mordaza', '146.png', 1, 2, 43),
(147, 70, 181, 'x', 544, 'Mufa', '0.png', 1, 0, 76),
(148, 70, 181, 'x', 544, 'Omega', '0.png', 1, 0, 76),
(149, 70, 181, 'x', 544, 'Opresor', '0.png', 1, 0, 76),
(150, 70, 179, 'x', 544, 'T', '0.png', 1, 0, 76),
(151, 70, 181, 'x', 544, 'Uña', '0.png', 1, 0, 76),
(152, 68, 89, '*', 497, 'Verde con Negro.', '152.jpg', 1, 4, 47),
(153, 68, 30, '*', 498, 'Amarillo', '153.jpg', 1, 1, 47),
(154, 68, 184, '*', 498, 'Blanco', '154.jpg', 1, 4, 47),
(155, 68, 30, '*', 498, 'Naranja', '155.jpg', 1, 1, 47),
(156, 68, 203, '3121', 506, 'Negros', '156.jpg', 1, 1, 47),
(157, 68, 89, 'x', 503, 'Transparentes', '157.png', 1, 1, 76),
(158, 68, 30, '*', 512, 'De Paja', '158.jpg', 1, 3, 46),
(159, 68, 182, 'HA-026-C', 513, 'Azul con Amarillo', '159.jpg', 1, 12, 47),
(160, 58, 49, 'CA1240', 304, 'Negra de 12V. 4Ah', '160.jpg', 1, 1, 76),
(161, 58, 67, 'PL-7-12', 303, 'Negra de 12V. 7Ah', '161.jpg', 1, 3, 33),
(162, 58, 81, 'VISTA48/6162RF', 312, '48 Zonas con Teclado 6162RF', '162.png', 1, 0, 76),
(163, 58, 81, '1361', 318, 'De corriente', '163.jpg', 1, 3, 33),
(164, 58, 183, 'RT-5253', 314, 'Blanca Grande', '164.jpg', 1, 1, 76),
(165, 58, 183, 'RT-5252', 314, 'Blanca Chica', '165.jpg', 1, 1, 76),
(166, 58, 30, 'PROEMERB', 305, 'De Emergencia Blanco', '166.jpg', 1, 10, 34),
(167, 58, 130, 'DC1561WH', 307, 'Blanco', '167.jpg', 1, 1, 34),
(168, 58, 130, 'SF-1012', 307, 'Blanco', '168.jpg', 1, 15, 34),
(169, 58, 130, 'SF-2012', 307, 'Blanco', '169.png', 1, 7, 34),
(170, 58, 130, 'SF-2031BR', 307, 'Café', '170.jpg', 1, 14, 34),
(171, 58, 130, 'SF-2033', 307, 'Blanco', '171.jpg', 1, 21, 34),
(172, 58, 130, 'SF-2061', 307, 'Blanco', '172.png', 1, 10, 34),
(173, 58, 128, 'SS072', 315, 'Blanco', '173.jpg', 1, 22, 34),
(174, 58, 81, '268', 305, 'De Pánico', '174.jpg', 1, 1, 34),
(175, 58, 54, 'SWANQUAD', 309, 'Digital Inmune a Mascotas', '175.jpg', 1, 8, 34),
(176, 58, 130, 'SF1192L', 309, 'Fotoelectrico de Humo 2 Hilos', '176.png', 1, 8, 34),
(177, 58, 61, 'DG-50AU', 309, 'Glassbreak Blanco', '177.jpg', 1, 1, 34),
(178, 58, 81, '5800PIR', 309, 'Inalambrico de Movimiento Inmune a Mascotas', '178.jpg', 1, 1, 34),
(179, 58, 54, 'NEOQUAD', 309, 'PIR QUAD Digital', '179.png', 1, 3, 34),
(180, 58, 81, 'AURORA', 313, 'De Movimiento Inmune a Mascotas', '180.png', 1, 3, 34),
(181, 58, 127, '*', 306, '4 Hilos Blanco #1', '181.jpg', 1, 138, 73),
(182, 58, 127, '*', 306, '*', '182.jpg', 1, 0, 76),
(183, 58, 127, '*', 317, '*', '183.jpg', 1, 0, 76),
(184, 58, 127, 'x', 306, '6 Hilos Blanco #1', '184.png', 1, 0, 76),
(185, 58, 127, '*', 306, '*', '185.png', 1, 0, 76),
(186, 58, 127, '*', 317, '*', '186.png', 1, 0, 76),
(187, 69, 75, 'GXP1625', 528, 'Telefono IP SMB 2 Lineas 3 Teclas Func y Conf 3 Vias POE', '187.png', 1, 0, 76),
(188, 59, 147, 'UAPACLITE', 330, 'Punto de Acceso UNIFI Doble Banda', '188.jpg', 1, 0, 76),
(189, 63, 154, 'ABK400', 403, 'Para ABK400112, de 2 Botones', '189.jpg', 1, 0, 76),
(190, 58, 130, 'SFX01', 305, 'De Pánico para línea telefónica', '190.jpg', 1, 1, 34),
(191, 59, 146, 'POE4824W', 325, 'Negro', '191.jpg', 1, 0, 76),
(192, 62, 185, 'WD40PURZ', 379, '4 TB', '192.jpg', 1, 0, 76),
(193, 62, 76, 'MD825AM/A', 378, 'Adaptador', '193.jpg', 1, 0, 76),
(194, 61, 67, 'TTBNCVGA', 367, 'De BNC a VGA', '194.jpg', 1, 1, 35),
(195, 64, 127, 'PSU1250-D4-D', 417, 'De Alimentacion 12 VDC, 4 Canales a 5 Amperes', '195.jpg', 1, 1, 7),
(196, 71, 94, 'LPFP33', 467, 'Blanca de Plástico', '196..jpg', 1, 46, 54),
(197, 71, 30, '*', 484, 'Blanca de Plástico', '197.jpg', 1, 0, 76),
(198, 71, 30, '*', 484, 'Blanca de Plástico', '198.jpg', 1, 13, 54),
(199, 51, 22, 'x', 136, '1\"', 'na.jpg', 2, 0, 5),
(200, 51, 22, 'x', 137, '1\"', 'na.jpg', 2, 0, 5),
(201, 71, 59, 'Sin División', 468, '60*40', '201.jpg', 1, 0, 76),
(202, 71, 59, 'Sin División', 468, '40*40', '202.jpg', 1, 0, 76),
(203, 71, 59, 'Sin Divición', 468, '40*25', 'na.jpg', 1, 0, 76),
(204, 71, 59, 'Sin División', 468, '32*12', 'na.jpg', 1, 0, 76),
(205, 71, 59, 'Sin Divición', 468, '25*25', 'na.jpg', 1, 0, 76),
(206, 71, 59, 'Sin División', 468, '20*12', '206.jpg', 1, 28, 78),
(207, 71, 59, 'Sin Divición', 468, '13*7', 'na.jpg', 1, 0, 76),
(208, 71, 59, '*', 469, 'Ángulo Externo 60*40', '208.jpg', 1, 1, 27),
(209, 71, 59, '*', 469, 'Ángulo Interno	60*40', 'na.jpg', 1, 0, 76),
(210, 71, 59, '*', 469, 'Ángulo Plano	60*40', '210.jpg', 1, 2, 27),
(211, 71, 59, '*', 469, 'Derivación en T 60*40', 'na.jpg', 1, 0, 76),
(212, 71, 59, '*', 469, 'Tapa Final 60*40', 'na.jpg', 1, 0, 76),
(213, 71, 59, '*', 469, 'Unión 60*40', '213.jpg', 1, 4, 27),
(214, 71, 59, '*', 469, 'Ángulo Externo 40*40', 'na.jpg', 1, 0, 76),
(215, 71, 59, '*', 469, 'Ángulo Interno 40*40', 'na.jpg', 1, 0, 76),
(216, 71, 59, '*', 469, 'Ángulo Plano 40*40', '216.jpg', 1, 1, 27),
(217, 71, 59, '*', 469, 'Derivación en T 40*40', 'na.jpg', 1, 0, 76),
(218, 71, 59, '*', 469, 'Tapa Final 40*40', 'na.jpg', 1, 0, 76),
(219, 71, 59, '*', 469, 'Unión 40*40', 'na.jpg', 1, 0, 76),
(220, 71, 59, 'DXN11081', 469, 'Ángulo Externo 40*25', '220.jpg', 1, 8, 27),
(221, 71, 59, '*', 469, 'Ángulo Interno 40*25', '221.jpg', 1, 2, 27),
(222, 71, 59, '*', 469, 'Ángulo Plano 40*25', '222.jpg', 1, 3, 27),
(223, 71, 59, '*', 469, 'Derivación en T 40*25', '223.jpg', 1, 3, 27),
(224, 71, 59, '*', 469, 'Tapa Final 40*25', '224.jpg', 1, 1, 27),
(225, 71, 59, '*', 469, 'Unión 40*25', 'na.jpg', 1, 0, 76),
(226, 71, 59, '*', 469, 'Ángulo Externo 32*12', '226.jpg', 1, 6, 27),
(227, 71, 59, '*', 469, 'Ángulo Interno 32*12', '227.jpg', 1, 2, 27),
(228, 71, 59, '*', 469, 'Ángulo Plano 32*12', '228.jpg', 1, 10, 27),
(229, 71, 59, '*', 469, 'Derivación en T 32*12', '229.jpg', 1, 5, 27),
(230, 71, 59, '*', 469, 'Tapa Final 32*12', '230.jpg', 1, 7, 27),
(231, 71, 59, '*', 469, 'Unión 32*12', '231.jpg', 1, 8, 27),
(232, 71, 59, '*', 469, 'Ángulo Externo 25*25', '232.jpg', 1, 10, 27),
(233, 71, 59, '*', 469, 'Ángulo Interno 25*25', '233.jpg', 1, 32, 27),
(234, 71, 59, '*', 469, 'Ángulo Plano 25*25', '234.jpg', 1, 4, 27),
(235, 71, 59, '*', 469, 'Derivación en T 25*25', '235.jpg', 1, 6, 27),
(236, 71, 59, '*', 469, 'Tapa Final 25*25', '236.jpg', 1, 1, 27),
(237, 71, 59, '*', 469, 'Unión 25*25', '237.jpg', 1, 18, 27),
(238, 71, 59, 'DXN11041', 469, 'Ángulo Externo 20*12', '238.jpg', 1, 32, 28),
(239, 71, 59, '*', 469, 'Ángulo Interno 20*12', '239.jpg', 1, 7, 28),
(240, 71, 59, 'DXN11043', 469, 'Ángulo Plano 20*12', '240.jpg', 1, 60, 28),
(241, 71, 59, '*', 469, 'Derivación en T 20*12', '241.jpg', 1, 11, 28),
(242, 71, 59, '*', 469, 'Tapa Final 20*12', '242.jpg', 1, 38, 28),
(243, 71, 59, '*', 469, 'Unión 20*12', '243.jpeg', 1, 1, 76),
(244, 71, 59, '*', 469, 'Ángulo Externo 13*7', 'na.jpg', 1, 0, 76),
(245, 71, 59, '*', 469, 'Ángulo Interno 13*7', '245.jpeg', 1, 1, 28),
(246, 71, 59, '*', 469, 'Ángulo Plano 13*7', 'na.jpg', 1, 0, 76),
(247, 71, 59, '*', 469, 'Derivación en T 13*7	', 'na.jpg', 1, 0, 76),
(248, 71, 59, '*', 469, 'Tapa Final 13*7', 'na.jpg', 1, 0, 76),
(249, 71, 59, '*', 469, 'Unión 13*7', '249.jpg', 1, 2, 28),
(250, 67, 171, '*', 473, '3/8\", 10 mm', '250.jpg', 1, 0, 5),
(251, 67, 171, '*', 473, '5/16\", 8 mm', '251.png', 1, 0, 5),
(252, 67, 171, '*', 473, '7/16\", 11 mm', '252.jpg', 1, 0, 5),
(253, 61, 30, '*', 367, 'De Corriente 12v. Macho', '253.jpg', 1, 23, 35),
(254, 61, 30, '*', 367, 'De Corriente 12v. Hembra', '254.jpg', 1, 53, 35),
(255, 72, 156, 'AP201', 553, 'De Esquina Blanco', '255.jpg', 1, 25, 28),
(256, 72, 156, 'AP101', 553, 'De Paso Blanco Y Negro', '256.jpg', 1, 25, 28),
(257, 71, 139, '*', 485, 'Con Gancho para cable UTP color Negro de 3 mm.', '257.jpg', 1, 3, 29),
(258, 71, 30, '*', 482, 'Color Beige', '258.jpg', 1, 100, 28),
(259, 67, 139, '*', 485, 'Con taquete color Negro', '259.jpg', 1, 100, 29),
(260, 71, 106, 'OPCAPCC603PAM', 477, '1 m. (3 FT) Amarillo, Cat. 6\r\n', '260.jpg', 1, 1, 5),
(261, 71, 106, 'OPCAPCC503PAZ', 477, '1 m. (3 FT) Azul, Cat. 5e', '261.jpg', 1, 2, 5),
(262, 71, 108, 'NK6PC3Y', 477, '1 m. (3 FT) Blanco, Cat. 6', '262.jpg', 1, 2, 5),
(263, 71, 106, 'OPCAPCC603PGR', 477, '1 m. (3 FT) Gris, Cat. 6', '263.jpg', 1, 51, 5),
(264, 71, 106, 'OPCAPCC603PRO', 477, '1 m. (3 FT) Rojo, Cat. 6', '264.jpg', 1, 8, 5),
(265, 71, 108, 'NK6PC5Y', 477, '1.5 m. (3 FT) Blanco, Cat. 6', '265.jpg', 1, 5, 5),
(266, 71, 106, 'OPCAPCC507PAZ', 477, '2 m. (7 FT) Azul, Cat. 5e', '266.jpg', 1, 1, 5),
(267, 71, 108, 'NK6PC7BUY', 477, '2 m. (7 FT) Azul, Cat. 6', '267.jpg', 1, 44, 5),
(268, 71, 106, 'OPCAPCC507PBL', 477, '2 m. (7 FT) Blanco, Cat. 5e', '268.jpg', 1, 8, 5),
(269, 71, 108, 'NK6PC10BUY', 477, '3 m. (10 FT) Azul, Cat. 6', '269.jpg', 1, 22, 10),
(270, 71, 106, 'OPCAPCC610PBL', 477, '3 m. (10 FT) Blanco, Cat. 6', '270.jpg', 1, 8, 5),
(271, 71, 106, 'OPCAPCC510PVE', 477, '3 m. (10 FT) Verde, Cat. 5e', '271.jpg', 1, 7, 10),
(272, 71, 106, 'OP6-05-BL-MA', 477, '5 m. () Azul, Cat. 6', '272.jpg', 1, 9, 10),
(273, 71, 108, 'CFPE1IWY ', 478, '1 Ventana', '273..jpg', 1, 2, 13),
(274, 71, 108, 'NK1FWHY', 478, '1 Ventana', '274.jpg', 1, 1, 13),
(275, 71, 108, 'CFPE21WY', 478, '2 Ventanas (Vertical)', '275.jpg', 1, 4, 13),
(276, 71, 108, 'NK2FWHY', 478, '2 Ventanas (Horizontal)', '276..jpg', 1, 6, 13),
(277, 71, 108, 'NK2FNWH', 478, '2 Ventanas (Vertical)', '277.jpg', 1, 0, 76),
(278, 71, 106, 'OPCAPLS2', 478, '2 Ventanas (Horizontal)', '278.jpg', 1, 29, 13),
(279, 71, 108, 'NK3FNIW', 478, '3 Ventanas (Horizontal)', '279.jpg', 1, 1, 13),
(280, 71, 108, 'NK4FWHY', 478, '4 Ventanas', '280.jpg', 1, 10, 13),
(281, 71, 94, 'TC5', 481, 'Cat. 5', '281.jpg', 1, 8, 12),
(282, 71, 94, '*', 481, 'Cat. 5e', 'na.jpg', 1, 0, 76),
(283, 71, 94, 'TC6', 481, 'Cat. 6', '283_2.jpg', 1, 254, 12),
(284, 71, 94, 'TC6A', 481, 'Cat. 6A', '284.jpg', 1, 119, 12),
(285, 71, 106, 'OPCAJP504180AZ', 475, 'Azul Cat. 6', '285.JPG', 1, 39, 12),
(286, 71, 106, 'OPCAJP505RO', 475, 'Rojo Cat.5e', '286.jpg', 1, 6, 12),
(287, 71, 108, 'NK688MBU', 475, 'Azul Cat. 6', '287.jpg', 1, 26, 12),
(288, 71, 108, 'NKP5E88MIW', 475, 'Blanco Cat. 5e', '288..jpg', 1, 0, 76),
(289, 71, 108, 'NK688MWH', 475, 'Blanco Cat. 6', '464.jpg', 1, 1, 11),
(290, 71, 108, 'NK5E88MEIY', 475, 'Marfil Cat. 5e', '290.jpg', 1, 15, 12),
(291, 71, 108, 'NK688MBL', 475, 'Negro Cat. 6', '291.jpg', 1, 2, 12),
(292, 61, 37, 'DH-HAC-HFW1100SN-0280B-S3', 357, 'HDCVI tipo Bala', '292.png', 1, 1, 36),
(293, 61, 52, 'DRC-4L/DR-3L', 357, 'De puerta color', '293.jpg', 1, 1, 36),
(294, 61, 68, 'EYH009FAP', 357, 'Oculta en Sensor PIP\r\n', '294.jpg', 1, 1, 37),
(295, 61, 37, 'DH-IPC-HDW4100SN-0360B', 357, 'De Red tipo Domo\r\n', '295.jpg', 1, 3, 36),
(296, 61, 33, 'DSL-20SA', 357, 'Digital Color', '296.jpg', 1, 2, 37),
(297, 61, 30, 'B2MB3W', 357, '720P WDR HD tipo ______', '297.jpg', 1, 1, 5),
(298, 61, 157, 'F3206', 357, 'IP de Vigilancia', '298.jpg', 1, 1, 36),
(299, 61, 51, 'LML-205', 357, 'Gran angular Vehicular 145G', '299.jpg', 1, 1, 37),
(300, 61, 51, 'MBP-50S', 357, 'Mini tipo PIN', '300.jpg', 1, 1, 37),
(301, 61, 152, 'MD7560', 357, 'De Vigilancia', '301.jpg', 1, 1, 36),
(302, 61, 157, 'F210A', 357, 'IP', '302.jpg', 1, 3, 36),
(303, 61, 152, 'IP7134', 357, 'Network', '303.jpg', 1, 2, 36),
(304, 61, 67, 'ONDV660NIR', 357, 'Domo Antivand 620L,3.7- 12MM.D/N,P/SUPERF. O PLAFON (Color/Infrarojo)', '304.jpg', 1, 1, 37),
(305, 61, 80, 'DS2CD6412FWD', 357, 'IP oculta Pinhole', '305.jpg', 1, 1, 37),
(306, 61, 80, 'DS2CE16C8TIW3Z', 357, 'Bala Turbo HD 720P. Lente 6-22MM', '306.jpg', 1, 1, 37),
(307, 61, 152, 'IP8162P', 357, 'De Vigilancia', '307.jpg', 1, 1, 37),
(308, 61, 44, 'AVN80XZ(US)/F40-SPA', 357, 'IP IVS de megapíxeles', '308.jpg', 1, 1, 36),
(309, 61, 152, 'MD8562', 357, 'De Vigilancia', '309.jpg', 1, 1, 37),
(310, 61, 37, 'DH-HAC-HFW1200BN-0360B-S3', 357, 'HDCVI tipo Bala', '310.png', 1, 0, 76),
(311, 61, 37, 'DH-HAC-HFW2231EN-0360B', 357, 'HDCVI tipo Bala', '311.jpg', 1, 0, 76),
(312, 61, 37, 'DH-HAC-HDW2221EMN-A-0280B', 357, 'HDCVI tipo Domo', '312.jpg', 1, 0, 76),
(313, 61, 136, 'EYH003FAP', 357, 'Oculta Det. Mov. SprhadII 1/3 Effio 600L L3.7/Audrv', '313.jpg', 1, 1, 37),
(314, 61, 58, 'HFAW1100B36S3', 357, 'Bullet Alta definición HDCVI 720P', '314.png', 1, 0, 76),
(315, 61, 58, 'DH-HAC-HUM1220GN-B-0280B', 357, 'HDCVI', '0.png', 1, 7, 56),
(316, 61, 58, 'DH-HAC-HDBW2221RN-Z', 357, 'HDCVI tipo Domo', '316.png', 1, 2, 37),
(317, 61, 58, 'DH-HAC-HDW1100MN-0280B-S3', 357, 'HDCVI tipo Domo', '317.JPG', 1, 2, 36),
(318, 61, 37, 'DH-HAC-HDW1000RN-0280B-S3', 357, 'HDCVI tipo Domo', '318.png', 1, 0, 76),
(319, 61, 37, 'DH-IPC-HFW2431RN-ZS-IRE6', 357, 'De Red tipo Bala', '319.jpg', 1, 0, 76),
(320, 61, 37, 'DH-HAC-HFW2401EN-0360B', 357, 'HDCVI', '320.png', 1, 0, 76),
(321, 61, 37, 'DH-HAC-HFW1100BN-0360B-S3', 357, 'HDCVI', '321.png', 1, 0, 76),
(322, 61, 127, 'PSU1210-D18', 360, '12 Volts 10 Amperes con Distribuidor para 18 Canales', '322.jpg', 1, 2, 38),
(323, 61, 127, 'PSU1220-D18', 360, '12 Volts 20 Amperes con Distribuidor para 18 Canales', '323.jpg', 1, 0, 76),
(324, 61, 145, '12V10A9PBAT (TVN400005)', 360, '12 Volts 10 Amperes con Distribuidor para 9 Cámaras & Batería de Respaldo', '324.jpg', 1, 3, 38),
(325, 61, 136, 'GRT1202VDC', 360, 'Regulada 12 VDC, 4A, para 4 Cámaras', '325.jpg', 1, 1, 38),
(326, 61, 136, 'GRT1204VDCT', 360, 'Para Cámaras de 12 Vcd /4A, con Fusibles Térmicos', '326.jpg', 1, 6, 38),
(327, 61, 151, 'TC5808', 362, 'Inhalambrico de 5.8 Ghz. P/ Video-Audio', '327.jpg', 1, 1, 37),
(328, 61, 134, 'BOS-950', 363, 'Booster para Audio y Video de 2 Entradas y 6 Salidas', '328.jpg', 1, 1, 37),
(329, 61, 127, 'UTP101P-HD4', 364, 'Pasivo 4 en 1', '329.jpg', 2, 0, 5),
(330, 61, 127, 'UTP101P-HD4B', 364, 'Pasivo 4 en 1', '330.jpg', 2, 0, 5),
(331, 61, 127, 'TVC46372', 364, 'De Video Pasivo', '331.jpg', 2, 0, 5),
(332, 61, 127, 'TVT052052', 364, 'De HD Video Pasivo', '332.png', 1, 1, 76),
(333, 61, 136, 'NT-611B', 364, 'Video Balun', '333.jpg', 2, 0, 5),
(334, 61, 173, 'NV-214A-M', 364, 'Video Transceiver', '334.jpg', 2, 0, 5),
(335, 61, 30, 'PVB862BPC', 364, 'Passive Balun', 'na.jpg', 1, 1, 35),
(336, 61, 30, 'VPB100L', 364, 'Passive Baslun / Pigtail', '336.jpg', 2, 0, 5),
(337, 61, 30, 'LLT-213', 364, 'Adaptadores de Impedencia (BALUN) Pasivo, 1 Canal', '337.jpg', 1, 2, 35),
(338, 61, 134, 'CCTV-402', 364, 'Extensor de Video para Cat. 5 Versión 1.1', 'na.jpg', 1, 1, 35),
(339, 61, 136, 'NT-611', 364, '*', '339.png', 2, 0, 5),
(340, 61, 67, 'NT101PC, UTP101P-HD1R', 364, 'Passive Video Transceiver', '340.jpg', 2, 0, 5),
(341, 61, 30, 'VPB100', 364, '*', 'na.jpg', 2, 0, 5),
(342, 61, 30, '*', 412, 'BNC Con clavija Macho a RCA Macho', '342.jpg', 1, 0, 76),
(343, 61, 30, '*', 412, 'BNC Derivador ', '343.jpg', 1, 0, 76),
(344, 61, 30, '*', 358, 'BNC Hembra a BNC Hembra', '344.jpg', 1, 0, 76),
(345, 61, 30, '*', 358, 'BNC Hembra a RCA Hembra', '345.jpg', 1, 0, 76),
(346, 61, 30, '*', 358, 'BNC Hembra a RCA Macho', '346.jpg', 1, 0, 76),
(347, 61, 30, '*', 358, 'BNC Hembra con salida +/- de 2 terminales', '347.jpg', 1, 0, 76),
(348, 61, 30, '*', 358, 'BNC Macho a BNC Macho', '348.jpg', 1, 0, 76),
(349, 61, 30, '*', 358, 'BNC Macho a RCA Hembra', '349.jpg', 1, 0, 76),
(350, 61, 30, '*', 358, 'BNC Macho con salida +/- de 2 terminales', '350.jpg', 1, 0, 76),
(351, 61, 127, 'PSUBR08', 358, 'BNC Siames Macho para Crimpar, compatible con cable RG59', '351.jpg', 1, 8, 35),
(352, 61, 30, '*', 358, 'BNC Macho rápido para enroscar RG59. No requiere Crimpadora', '352.jpg', 1, 0, 76),
(353, 61, 30, '*', 358, 'BNC Macho salida +/- de 2 terminales y con fácil conexionado', '353.jpg', 1, 0, 76),
(354, 61, 30, '*', 358, 'BNC Universal Macho para atornillar sin soldadura y con funda', '354.jpg', 1, 0, 76),
(355, 61, 30, '*', 358, 'DC Hembra con salida +/- de 2 terminales', '355.jpg', 1, 0, 76),
(356, 61, 30, '*', 358, 'DC Hembra con salida +/ de 2 terminales y de fácil conexión', '356.jpg', 1, 0, 76),
(357, 61, 30, '*', 358, 'DC Hembra con salida +/- de dos terminales', '357.jpg', 1, 0, 76),
(358, 61, 30, '*', 358, 'DC Macho salida +/- de 2 terminales y con fácil conexionado', '358.jpg', 1, 0, 76),
(359, 61, 30, '*', 358, 'RCA Hembra a RCA Hembra', '359.jpg', 1, 0, 76),
(360, 61, 30, '*', 358, 'RCA Hembra con salida +/- de 2 terminales', '360.jpg', 1, 11, 35),
(361, 61, 30, '*', 358, 'RCA Macho a RCA Macho', '361.jpg', 1, 0, 76),
(362, 61, 30, '*', 358, 'RCA Macho salida +/ de 2 terminales', '362.jpg', 1, 0, 76),
(363, 61, 30, '*', 358, 'RCA Macho salida +/- de 2 terminales y con fácil conexionado', '363.jpg', 1, 0, 76),
(364, 61, 127, 'UTP101AR-HD', 365, 'UTP Activo de un Canal HD', '364.jpg', 1, 1, 35),
(365, 61, 127, 'TVC46358', 366, 'De Video', '365.jpg', 1, 1, 35),
(366, 61, 127, 'TT101AT', 366, 'De Video', '366.jpg', 1, 2, 35),
(367, 61, 80, 'DS-6101HFI-IP-A', 352, 'Video Server ', '367.jpg', 1, 2, 35),
(368, 71, 108, 'NUC6C04BU-C', 489, 'Cat. 6 Azul #1', '368.jpg', 1, 117, 70),
(369, 71, 108, 'NUC6C04BU-C', 489, '*', '369.jpg', 1, 1, 76),
(370, 71, 127, '*', 489, 'Cat. 6 Azul #3', '370.png', 1, 245, 70),
(371, 71, 127, '*', 489, 'Cat. 6 Azul #4', '371.png', 1, 238, 70),
(372, 71, 108, 'NUC6C04BU-C', 489, '*', '372.jpg', 1, 1, 76),
(373, 71, 30, '*', 490, 'Cat. 6 Azul\r\n', '373.jpg', 1, 0, 74),
(374, 71, 30, '*', 490, 'Cat. 6 Blanco', '374.jpg', 1, 0, 74),
(375, 71, 30, '*', 487, '*', '375.jpg', 1, 0, 76),
(376, 71, 30, '*', 487, '*', '376.jpg', 1, 0, 76),
(377, 71, 30, '*', 487, '*', '377.jpg', 1, 0, 76),
(378, 71, 30, '*', 488, '*', '378.png', 1, 0, 76),
(379, 71, 30, '*', 489, 'Cat. 6A Azul #1', '379.jpg', 1, 305, 75),
(380, 71, 30, '*', 489, '*', '380.jpg', 1, 0, 76),
(381, 71, 30, '*', 489, '*', '0.png', 1, 0, 76),
(382, 71, 30, '*', 490, 'Cat. 6A Azul', '382.jpg', 1, 0, 75),
(383, 71, 30, '*', 490, '*', 'na.jpg', 1, 0, 76),
(384, 71, 108, 'NUC6C04BU-C', 489, 'Cat. 5e Azul #', '384.jpg', 1, 0, 76),
(385, 71, 108, 'NUC5C04BU-C', 489, '*', '385.jpg', 1, 0, 76),
(386, 71, 127, '*', 489, 'Cat. 5e Blanco #3', '386.png', 1, 33, 72),
(387, 71, 127, '*', 489, 'Cat. 5e Blanco #4', '387.png', 1, 174, 72),
(388, 71, 30, '*', 490, 'Cat. 5e Azul', 'na.jpg', 1, 0, 72),
(389, 71, 30, '*', 490, 'Cat. 5e Blanco', 'na.jpg', 1, 0, 72),
(390, 71, 127, '*', 487, 'Cat. 5e Negro #1', 'na.jpg', 1, 167, 72),
(391, 71, 127, '*', 487, '*', 'na.jpg', 1, 1, 76),
(392, 71, 30, '*', 488, 'Cat. 5e Negro', 'na.jpg', 1, 0, 72),
(393, 61, 30, '6-568B', 369, 'Audio Extender Cat. 5e Receiver', '453.jpg', 1, 0, 76),
(394, 61, 58, 'DH-PFA13A-E', 355, 'Camera Mount', '394.jpg', 1, 5, 37),
(395, 59, 147, 'LOCO M2', 330, 'NanoStation', '395.jpg', 1, 4, 11),
(396, 61, 142, 'MC200CM(UN)', 367, 'Gigabit Multi-Mode Media Converter', '396.jpg', 1, 0, 76),
(397, 67, 94, 'LPODF8002', 491, 'De Fibra Optica 24 Puertos', '397.jpg', 1, 0, 76),
(398, 63, 123, 'ATR11', 396, 'De Proximidad Estándar tipo ISO (Delgada)', '398.jpg', 1, 0, 76),
(399, 62, 187, 'WD60PURZ', 379, '6 TB', '399.jpg', 1, 0, 76),
(400, 61, 37, 'DH-PFS3006-4ET-60', 370, 'Interruptor Negro', '400.jpg', 1, 1, 16),
(401, 61, 37, 'DHI-XVR4104C-B-S2', 361, 'Digital Blanco, de 4 Canales', '401.jpg', 1, 1, 39),
(402, 62, 187, 'WD10PURZ', 379, '1 TB\r\n', '402.jpg', 1, 0, 76),
(403, 61, 37, 'DHI-NVR4208-8P-4KS2', 361, 'Por Red Blanco', '403.jpg', 1, 0, 76),
(404, 61, 37, 'DH-HAC-HFW1400TN-0280B', 357, 'HDCVI', '404.jpg', 1, 0, 76),
(405, 58, 188, 'HC-626-320', 314, 'Alambrica Negra', '405.jpg', 1, 1, 76),
(406, 61, 127, 'CABLE20MH', 356, 'Rollo de cable', '406.png', 1, 1, 66),
(407, 61, 37, 'DH-PFM321D-US', 355, 'Power Adapter', '407.jpg', 1, 1, 36),
(408, 61, 30, 'PFM820', 359, 'UTC', '408.jpg', 1, 2, 35),
(409, 71, 189, 'PC6UMC10FTGY', 477, '3 m. (10 FT) Gris , Cat. 6', '409.jpg', 1, 3, 11),
(410, 69, 199, 'EDDA', 529, 'Telefónico', '410..jpg', 1, 1, 18),
(411, 69, 190, 'KX-T7730X', 528, 'Blanco', '410.jpg', 1, 0, 76),
(412, 58, 130, 'SF-581L', 314, '2 Tonos 30 Wats 119DB 12 VCD', '412.jpg', 1, 1, 76),
(413, 71, 94, 'SCH19X1U', 479, 'Para Soportar Equipos en Rack de 19\"', '413.jpg', 1, 1, 6),
(414, 59, 146, 'NBE5ACGEN2-3', 331, 'Bridge Inhalambrico Airmax AC Generacion 2', '414.jpg', 1, 0, 76),
(415, 64, 140, 'TEK100DUPLEX', 430, 'Soporte Tapa y Contagto (5591-10200)', '415.jpg', 1, 0, 76),
(416, 58, 69, 'IMP30', 319, 'Para Sirena de 30 Wats ', '416.jpg', 1, 1, 33),
(417, 64, 140, 'TEK100UNI', 431, 'Contacto Universal TEK 100', '417.jpg', 1, 0, 76),
(418, 58, 30, 'MINI014GV2', 320, 'Dual SIM Via Celular 8G/4G', '418.PNG', 1, 0, 76),
(419, 71, 140, 'TEK100F', 469, 'Tapa Final 100 * 52', '419.jpg', 1, 0, 76),
(420, 71, 108, 'NK5EPPG24Y', 492, 'De 24 Puertos Categoria 5e de impacto, para Rack', '420.jpg', 1, 1, 6),
(421, 58, 81, '958', 307, 'De Uso Rudo, Para Cortina', '421.jpg', 1, 0, 76),
(422, 71, 108, 'WMP1E', 493, 'PatchLink Horizontal Doble de 2 UR de 19\", para Rack', '422.jpg', 1, 2, 6),
(423, 71, 140, 'TEK100L', 469, 'Ángulo Externo 100 * 52', '423.png', 1, 0, 76),
(424, 71, 140, 'TEK100EI', 469, 'Ángulo Interno 100 * 52', '424.jpg', 1, 0, 76),
(425, 64, 130, 'SF2206LE', 408, 'Calibre 22', '425.png', 1, 0, 76),
(426, 71, 94, 'SR1906GFP', 319, 'Para Montaje en Pared Cuerpo Fijo de 6 Unidades', '426.jpg', 1, 0, 76),
(427, 71, 140, 'TEK100', 468, '100 * 52', '427.jpg', 1, 0, 76),
(428, 61, 37, 'DH-XVR5216A-X', 361, 'Digital', '428.jpg', 1, 1, 32),
(429, 61, 37, 'IPC-B1B40N', 357, 'De Red tipo Bala', '429.jpg', 1, 0, 76),
(430, 61, 37, 'IPC-B1B20N-L', 357, 'De Red tipo Bala', '430.png', 1, 0, 76),
(431, 63, 34, 'PRORELAY', 397, 'Con Contacto NC/NO', '431.png', 1, 4, 21),
(432, 58, 81, '5802WXT', 305, 'De Panico Inalambrico tipo Col.', '432.png', 1, 0, 76),
(433, 63, 34, 'APR50', 398, 'Con Relevador Doble', '433.jpg', 1, 0, 77),
(434, 63, 191, 'K2', 387, 'De Salida Sin Contacto con Recepcion Inalambrica', '434.jpg', 1, 1, 21),
(435, 61, 67, 'EP-MIC', 351, 'De alta sensibilidad con cancelación de ruido.', '435.jpg', 1, 2, 35),
(436, 64, 127, 'PSU1202-E', 417, 'De Poder Regulada 12V a 2A', '436.jpg', 1, 0, 76),
(437, 63, 58, 'DHI-VTO2000A', 399, 'Exterior', '437.jpg', 1, 0, 76),
(438, 61, 58, 'DHI-VTNS1060A', 370, 'Interruptor Blanco', '438.png', 1, 0, 76),
(439, 63, 58, 'DH-VTH1520A', 399, 'Interior', '439.JPG', 1, 0, 76),
(440, 73, 192, '800USB', 565, 'Mezclador', '440.jpg', 1, 0, 76),
(441, 73, 192, 'MR-204', 566, 'Sistema Profesional de Microfonos Inhalambricos', '441.jpg', 1, 0, 76),
(442, 61, 58, 'DH-HAC-HFW1400BN-0360B', 357, 'HDCVI tipo Bala', '442.jpg', 1, 0, 76),
(443, 61, 58, 'DH-IPC-HDBW4231EN-ASE-0280B', 357, 'IP tipo Domo Antivandalico', '443.jpg', 1, 0, 76),
(444, 61, 58, 'DH-HAC-HDBW1400EN-0280B', 357, 'HDCVI tipo Domo', '444.jpg', 1, 0, 76),
(445, 61, 127, 'PSU1220-D9', 360, '12 Volts 20 Amperes con Distribuidor para 9 Canales', '445.jpg', 1, 0, 76),
(446, 63, 154, 'PCB-505', 400, 'De Control de Retardo de Tiempo', '446.jpg', 1, 2, 21),
(447, 62, 88, 'SLIM VOLT', 380, 'Negro', '447.jpg', 1, 1, 77),
(448, 61, 79, 'HCL18L', 357, 'De Seguridad', '448.jpg', 1, 1, 36),
(449, 58, 130, 'SF119412', 309, 'Fotoelectrico de Humo 4 Hilos', '449.jpg', 1, 1, 34),
(450, 63, 191, 'K1-1', 387, 'Liberador SIN', '450.jpg', 1, 1, 77),
(451, 63, 34, 'XBS-SLDET', 401, 'Vehicular de Masa de 1 Canal', '451.jpg', 1, 2, 22),
(452, 61, 44, 'AVX931ZVA(US)-TD', 354, 'De 1 Canal', '452.png', 1, 1, 35),
(453, 61, 71, 'TTVGA75', 362, 'Extensor de VGA para UTP 35 metros', '453.jpg', 1, 1, 35),
(454, 61, 136, 'NT2404RDSA', 365, 'De Video Activo, 4 Canales', '454.JPG', 1, 1, 35),
(455, 61, 71, 'TVC46347', 362, 'Extensor de VGA para UTP 35 metros', '455.jpg', 1, 1, 35),
(456, 61, 44, 'VGA02B(US)-TD', 367, 'De Televisor a VGA', '456.jpg', 1, 1, 35),
(457, 61, 193, 'SK910R4Q', 365, '4 Canales inalambrico', '457.png', 1, 1, 35),
(458, 63, 80, 'DSKIS203', 402, 'TV Portero Digital', '458.jpg', 1, 1, 16),
(459, 71, 108, '*', 475, 'Blanco Cat. 6A', 'na.jpg', 1, 0, 76),
(460, 61, 194, 'L4TNMPS', 358, 'N Macho con Pin', '460.jpg', 1, 5, 35),
(461, 58, 193, 'E931S35RR', 313, 'Con rayo fotoelectrico de 11 metros', '461.jpg', 1, 1, 34),
(462, 58, 54, '0011700', 309, 'De movimiento, SWAN QUAD PIR INTRUSION', '462.jpg', 1, 6, 34),
(463, 71, 108, 'NKP5E88MBU', 475, 'Azul Cat. 5e', '463.jpg', 1, 7, 12),
(464, 59, 122, 'ANT046', 326, 'GPS para equipo GSM2358', '464.jpg', 1, 8, 11),
(465, 59, 132, 'ANT041', 326, 'Celular para TT8540k', '465.jpg', 1, 5, 11),
(466, 71, 106, 'OPCAJP504180BL', 475, 'Blanco Cat. 6', '466.jpg', 1, 1, 12),
(467, 63, 195, '588IEN', 398, 'Inalámbrico de alta seguridad', '467.jpg', 1, 1, 22),
(468, 64, 196, 'ED23B070MX', 432, 'Termomagnetico', '468.jpg', 1, 1, 77),
(469, 64, 197, 'SM 15-125', 433, 'Para Interruptor Termomagnetico', '469.jpg', 1, 1, 77),
(470, 58, 154, 'PBK-814C(LED)', 305, 'Liberador', '470.JPG', 1, 1, 22),
(471, 66, 131, 'BD-J4500R', 454, 'DVD Player', '471.jpg', 1, 1, 77),
(472, 61, 58, 'DH-PFA134', 355, 'Camera Mount', '472.png', 1, 5, 36),
(473, 63, 101, 'ENC196YG', 392, 'Para Exterior color Gris', '473.jpg', 1, 5, 21),
(474, 58, 41, 'AEM3025/150PM', 319, 'Metalico', '474.jpg', 1, 1, 33),
(475, 64, 67, 'PROSE1012', 434, 'Modulo Fotovoltaico de 10w 12v Policristalino', '475.jpg', 1, 2, 33),
(476, 63, 64, 'ELKP624', 391, 'De Alimentacion con Carga', '476.jpg', 1, 4, 21),
(477, 63, 64, 'ELK960', 400, 'Relevador con Retardo de Tiempo', '477.jpg', 1, 2, 21),
(478, 63, 123, 'AC-115', 395, 'Control de 1 Puerta', '478.jpg', 1, 1, 22),
(479, 63, 34, 'XBREC2', 398, 'Inalambrico Externo RF', '479.JPG', 1, 1, 22),
(480, 63, 136, 'SYSKR602EKB', 394, 'De Proximidad con Teclado', '480.jpg', 1, 0, 76),
(481, 63, 156, 'KL 2', 398, 'D/2 CH, incluye 2 Controles', '481.jpg', 1, 1, 22),
(482, 63, 34, 'BL1200', 390, 'Montaje para MAG1200 tipo L', '482.png', 1, 10, 22),
(483, 63, 34, 'MAG1200', 390, '1200LBS', '483.JPG', 1, 1, 22),
(484, 63, 34, 'BZ600', 390, 'Montaje para MAG600 tipo Z', '484.jpg', 1, 3, 22),
(485, 63, 34, 'MAG600', 390, '600LBS tipo Z', '485.png', 1, 0, 76),
(486, 63, 34, 'BLZ600', 390, 'Montaje para MAG600LED tipo L y Z', '486.jpg', 1, 2, 22),
(487, 63, 34, 'MAG1200W', 390, '1200LBS para Exterior ', '487.jpg', 1, 1, 22),
(488, 63, 154, 'ABK-280ZL', 389, 'Soporte', '488.JPG', 1, 2, 22),
(489, 63, 154, 'YM-2400SL', 389, 'Uso Rudo', '489.jpg', 1, 1, 22),
(490, 63, 154, 'ABK-280UL', 390, 'Bracket', '490.jpg', 1, 1, 22),
(491, 64, 88, '10-230/232-MC', 435, 'Electronica', '491.jpg', 1, 2, 51),
(492, 63, 69, 'GOF01XT', 392, 'Metalico para Fuente de Poder SYSEMTXT/SP4000S', '492.jpg', 1, 4, 21),
(493, 63, 34, 'PRO6V1A', 391, 'Con Cargador de Baterias 6Vdc., con Transformador 12 Vca.', '493.png', 1, 3, 21),
(494, 71, 108, 'CFPE4IWY', 478, '4 Ventanas', '494.png', 1, 2, 13),
(495, 61, 37, 'DHI-HCVR4108C-S3-N', 361, 'Digital Negro, de 8 Canales', '495.png', 1, 1, 39),
(496, 61, 37, 'DH-DVR5108B', 361, 'Digital Negro, de 8 Canales', '496.jpg', 1, 1, 39),
(497, 61, 148, 'IPKIT4D', 362, 'IP pz NVR201-04EP (1 Grabador de Video en RED y 4 Camaras)', '497.jpg', 1, 1, 39),
(498, 63, 52, 'DP-2HP', 393, 'Blanco', '498.jpg', 1, 2, 23),
(499, 63, 52, 'DP-2S', 393, 'Blanco', '499.png', 1, 1, 23),
(500, 63, 52, 'DP-2S', 393, 'Blanco, con Video Portero DR-2GN', '500.jpg', 1, 1, 23),
(501, 63, 52, 'DP-2HP ', 393, 'Blanco, con Video Portero DR-2G', '501.jpg', 1, 1, 23),
(502, 63, 52, 'DP-4VHP', 393, 'Blanco', '502.jpg', 1, 2, 23),
(503, 63, 52, 'CDV-35N', 393, 'Blanco, con monitor', '503.jpg', 1, 1, 23),
(504, 64, 44, 'AP010', 436, 'Switch', '504..jpg', 1, 3, 8),
(505, 64, 122, 'SP001P', 437, 'De Voltaje', '505.jpg', 1, 1, 8),
(506, 64, 136, 'SCI-110', 434, 'Controlador con Indicador', '506.jpg', 1, 1, 8),
(507, 61, 145, 'TVC52104 (T8DCAC)', 353, 'Para distribuir corriente a 8 Canales DC/AC', '507.jpg', 1, 2, 35),
(508, 58, 128, 'SK919TP4JNU', 321, '4 Botones', '508..jpg', 1, 2, 22),
(509, 63, 30, 'XBT23', 403, 'Inalámbrico RF, de 4 Botones', '509.png', 1, 10, 22),
(510, 58, 81, '58344', 321, 'Tipo Llavero, de 4 Botones', '510.jpg', 1, 3, 22),
(511, 58, 77, 'RF881 (SFH4KB)', 321, 'Pulsador Inalambrico, de 4 Botones', '411.jpg', 1, 5, 22),
(512, 58, 30, '*', 321, '4 Botones', '512.jpg', 1, 3, 22),
(513, 63, 30, '*', 403, '2 Botones', '513.jpg', 1, 2, 22),
(514, 63, 34, 'APR50', 403, '2 Botones', '514.jpg', 1, 1, 22),
(515, 63, 30, '*', 403, '2 Botones', '515.jpg', 1, 1, 22),
(516, 59, 110, 'POE152', 325, 'Inyector de 1 Puerto, Blanco', '516.jpg', 1, 1, 11),
(517, 59, 121, 'NBLOCOM', 329, 'Para LOCOM', '517.png', 1, 1, 11),
(518, 59, 39, 'PACE1PRMT', 332, 'Extensor IP POE X CBLE UTP Cat. 5e hasta 500 Mts. a 100 Mbs.', '518.jpg', 1, 1, 11),
(519, 59, 123, 'MD-N32', 332, 'De Datos de RS232 a Ethernet compatible con AC215', '519.jpg', 1, 1, 11),
(520, 61, 127, 'PSU1205-D9B', 360, '12 Volts 5 Amperes con Distribuidor para 9 Canales con Batería de Respaldo', 'na.jpg', 1, 0, 76),
(521, 69, 119, '43-445', 530, 'De línea telefónica', '521.jpg', 1, 1, 23),
(522, 63, 61, 'WS4939', 403, 'Wireless Key', '522.jpg', 1, 1, 77),
(523, 58, 122, 'WS4904P', 309, 'Infrarrojo Inalámbrico', '523.jpg', 1, 2, 34),
(524, 69, 75, 'UCM6510', 531, 'Telefónica', '524.jpg', 1, 1, 23),
(525, 58, 136, 'SGRPRU', 319, 'Para Alarma', '525.png', 1, 1, 33),
(526, 58, 61, 'TS-443S', 314, 'Blanca', '526.jpg', 1, 1, 33),
(527, 71, 106, 'OPCAPLS4', 478, '4 Ventanas', '527.jpg', 1, 1, 13),
(528, 71, 200, '163286', 478, '1 Ventana', '528.jpg', 1, 2, 13),
(529, 71, 108, 'NKF2S', 478, '2 Ventanas (Horizontal)', '528.jpg', 1, 1, 13),
(530, 58, 81, 'K10145WH-1', 318, 'De Corriente, 9 VAC', '529.jpg', 1, 1, 33),
(531, 71, 108, 'SRM19FM1', 479, 'Para Rack de 19\", de 1 Unidad de Rack', '531.jpg', 1, 1, 6),
(532, 67, 127, 'UTP3-SW08-TP120', 483, 'Ethernet de 8 Puertos PoE', '532.png', 1, 1, 8),
(533, 59, 136, 'EZTRAQ', 334, 'Grabador de registros ', '533.jpg', 1, 1, 11),
(534, 67, 105, 'FS116P', 483, 'Ethernet de 16 Puertos PoE', '534.png', 1, 1, 8),
(535, 67, 50, 'WAG120N', 494, 'Para RED', '535.jpg', 1, 2, 8),
(536, 59, 146, 'GP-B240-100', 325, 'Negro', '536.jpg', 1, 2, 11),
(537, 59, 146, 'UBI-POE-24-1', 325, 'Negro ', '537.jpg', 1, 1, 11),
(538, 59, 146, 'POE245A', 325, 'Negro', '538.jpg', 1, 7, 11),
(539, 59, 146, 'GP-A240-050', 325, 'Negro', '539.jpg', 1, 2, 11),
(540, 59, 146, 'UBI-POE-15-8', 325, 'Negro', '540.jpg', 1, 1, 11),
(541, 59, 146, 'UBI-POE-24-5', 325, 'Negro', '541.jpg', 1, 1, 11),
(542, 59, 147, '*', 325, '*', '.0.png', 1, 3, 11),
(543, 59, 147, 'ROCKETM5', 330, 'NanoStation', '543.png', 1, 1, 11),
(544, 60, 201, 'HIC-1200', 346, 'De Corriente', '544.jpg', 1, 1, 45),
(545, 60, 126, 'SEC-2A15A', 343, 'De Bateria', '545.jpg', 1, 1, 45),
(546, 60, 202, 'PI400AB', 347, 'SD', '546.jpg', 1, 1, 45),
(547, 60, 60, '*', 347, 'Para pasar corriente', '547..jpg', 1, 1, 45),
(548, 60, 87, 'XP750W', 348, 'AS', '548.jpg', 1, 1, 45),
(549, 64, 44, 'BE350G-LM', 438, 'Negro', '549.png', 1, 1, 45),
(550, 61, 204, 'MDP2HDW', 355, 'Display Adaptador', '550.jpg', 1, 3, 8),
(551, 73, 205, 'DMX 192CH', 563, 'Sin antena, negra', '551.jpg', 1, 1, 77),
(552, 59, 146, 'UAP-AC-IW (810354025549)', 335, '*', '552.png', 1, 0, 76),
(553, 67, 206, 'UTP1-SW0801-TP120', 483, 'Ethernet de 8 Puertos PoE', '553.jpg', 1, 0, 76),
(554, 64, 30, 'K0257', 439, 'Verde', '554.png', 1, 0, 76),
(555, 63, 123, 'ATR14', 396, 'De Proximidad Estándar tipo PROX (Gruesa)', '555.jpg', 1, 2, 8),
(556, 63, 145, '73031', 390, 'De Piso', '556.jpg', 1, 1, 22),
(557, 71, 134, '500-550', 478, 'Con Conector VGA, Blanco', '557.jpg', 1, 1, 13),
(558, 71, 108, 'NKP5E88MWH', 475, 'Blanco Cat. 5e', '558.jpg', 1, 7, 12),
(559, 71, 108, 'NK2FIWY', 478, '2 Ventanas (Horizontal)', '559.jpg', 1, 2, 13),
(560, 71, 108, 'CFPE1WHY', 478, '1 Ventana', '560.jpg', 1, 1, 13),
(561, 64, 53, '268W', 428, 'Dúplex con conexión a tierra, Blanca', '561.jpg', 1, 0, 76),
(562, 64, 53, '2132W', 424, 'Para Tomacorriente doble de plástico, Blanca', '562.jpg', 1, 4, 48),
(563, 70, 30, '*', 549, '2*4', '563.jpg', 1, 16, 53),
(564, 59, 30, 'SGS', 334, 'Antena', 'na.jpg', 1, 0, 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `privilegio`
--

CREATE TABLE `privilegio` (
  `id` int(11) NOT NULL,
  `Permisos` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `privilegio`
--

INSERT INTO `privilegio` (`id`, `Permisos`, `estatus`) VALUES
(1, 'Administrador', 1),
(2, 'Usuario', 1),
(3, 'Desempleado', 1),
(4, 'Eliminado', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `id` int(11) NOT NULL,
  `proveedor` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL,
  `ciudesta` int(11) NOT NULL,
  `direccion` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` varchar(30) COLLATE utf8_spanish_ci NOT NULL,
  `contacto` varchar(60) COLLATE utf8_spanish_ci NOT NULL,
  `sucursal` varchar(45) COLLATE utf8_spanish_ci NOT NULL,
  `webpage` varchar(45) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`id`, `proveedor`, `estatus`, `ciudesta`, `direccion`, `telefono`, `contacto`, `sucursal`, `webpage`) VALUES
(1, 'Syscom', 1, 8, 'Calle 20 de Noviembre 805, Bolívar, Zona Cent', '0180099925', 'eveldusea@syscom.mx bchavez@syscom.mx', 'Matriz Chihuahua', 'https://www.syscom.mx/'),
(2, 'asd', 2, 1, '', '', '', '', ''),
(3, 'Editado, modificado y cambiado papu. :v ', 2, 1, '', '', '', '', ''),
(4, 'TVC', 1, 1, '', '', '', '', ''),
(5, 'DESCONOCIDO', 1, 1, '', '', '', '', ''),
(6, 'N/A', 2, 1, '', '', '', '', ''),
(7, 'Industrial de Terminales, S.A de C.V', 1, 1, '', '', '', '', ''),
(8, 'N/A', 1, 1, '', '', '', '', ''),
(9, 'Almacen', 1, 1, '', '', '', '', ''),
(10, 'Mantenimiento de Seguridad MDS', 1, 1, '', '', '', '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultrma`
--

CREATE TABLE `resultrma` (
  `id` int(11) NOT NULL,
  `resultado` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `resultrma`
--

INSERT INTO `resultrma` (`id`, `resultado`) VALUES
(1, 'Reparado'),
(2, 'Nuevo'),
(3, 'Pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rma`
--

CREATE TABLE `rma` (
  `id` int(11) NOT NULL,
  `numeroorden` int(11) NOT NULL,
  `clientesrma` int(11) NOT NULL,
  `producto` varchar(50) NOT NULL,
  `modelo` varchar(50) NOT NULL,
  `serie` varchar(50) NOT NULL,
  `descripcion` varchar(180) NOT NULL,
  `fechaingreso` date NOT NULL,
  `fechaenvio` date NOT NULL,
  `fecharegreso` date NOT NULL,
  `fechainstalacion` date NOT NULL,
  `proveedorrma` int(11) NOT NULL,
  `estatus` int(11) NOT NULL,
  `resultrmat` int(11) NOT NULL,
  `rmaproveedor` varchar(45) NOT NULL,
  `aviso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `rma`
--

INSERT INTO `rma` (`id`, `numeroorden`, `clientesrma`, `producto`, `modelo`, `serie`, `descripcion`, `fechaingreso`, `fechaenvio`, `fecharegreso`, `fechainstalacion`, `proveedorrma`, `estatus`, `resultrmat`, `rmaproveedor`, `aviso`) VALUES
(1, 1, 15, 'Camara tipo bala', 'DH4568712', 'SCP751123484', 'No funciona el sensor de luz  ', '2018-07-20', '2018-07-25', '2018-07-26', '2018-07-27', 4, 2, 1, '159s', 0),
(4, 1000, 43, 'SWITCH ', 'FGSW-2620PVM', 'A920424C000186', 'NO RESPONDE PUERTOS POE', '2018-07-26', '2018-07-27', '0000-00-00', '0000-00-00', 1, 1, 3, '', 1),
(10, 1008, 56, 'sw', 'ER', 'AS', 'Avdol', '2018-07-27', '0000-00-00', '0000-00-00', '0000-00-00', 4, 2, 3, '342', 0),
(11, 1001, 58, 'convertidor de vídeo BNC-VGA ', 'TTBNCVGA', '000', 'NO VEDEO', '2018-08-02', '2018-08-03', '0000-00-00', '0000-00-00', 1, 1, 2, '1086929', 1),
(13, 1002, 43, 'DVR', 'HCVR5104H-S2', '1C00E01PAED1JAV', 'NO RECONOCE DD', '2018-08-06', '2018-08-06', '0000-00-00', '0000-00-00', 4, 1, 3, '', 1),
(14, 365, 60, 'Caja de superficie', 'BB4-PG-E', 'AAL-ACL3', 'revisión ', '2018-08-04', '2018-08-16', '0000-00-00', '0000-00-00', 10, 1, 1, '', 1),
(15, 365, 60, 'Domo', 'DD4CBW35', 'AAL-FU93', 'se en recorrido guardado', '2018-08-04', '2018-08-16', '0000-00-00', '0000-00-00', 10, 1, 1, '', 1),
(16, 366, 64, 'Camara', 'DH-HAC-HFW120BN-0360B-S3', 'D02B2APAR01125', 'No enciende', '2018-08-21', '0000-00-00', '0000-00-00', '0000-00-00', 4, 1, 3, '', 1),
(17, 751, 65, 'DVR', 'HCVR5216A-S3', '3G036A0PAZ60DCE', 'SE REINICIA', '2018-08-27', '2018-08-28', '0000-00-00', '0000-00-00', 4, 1, 1, '', 1),
(18, 380, 66, 'Switch', 'FGSW-1816HPS', 'AK80087200093', 'no responde', '2018-08-30', '2018-09-01', '0000-00-00', '0000-00-00', 1, 1, 1, '1090274', 1),
(19, 381, 57, 'Biometrico', 'ACCES PRO', 'AIP8180361169', 'Falla en los botones ', '2018-09-04', '0000-00-00', '0000-00-00', '0000-00-00', 1, 1, 3, '1090612', 1),
(20, 1034, 67, 'camara', 'IPC-HFW5431EN-Z-S2', '3M04C01PAG79F78', 'no video', '2018-10-05', '2018-10-08', '0000-00-00', '0000-00-00', 4, 1, 1, '', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seccion`
--

CREATE TABLE `seccion` (
  `id` int(11) NOT NULL,
  `seccion` varchar(50) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `seccion`
--

INSERT INTO `seccion` (`id`, `seccion`, `estatus`) VALUES
(1, 'ACCC', 2),
(2, 'B', 2),
(4, 'C', 2),
(5, 'A1.', 1),
(6, 'A2.', 1),
(7, 'A3.', 1),
(8, 'A4.', 1),
(9, 'A5.', 1),
(10, 'B1.', 1),
(11, 'B2.', 1),
(12, 'B3.', 1),
(13, 'B4.', 1),
(14, 'B5.', 1),
(15, 'C1.', 1),
(16, 'C2.', 1),
(17, 'C3.', 1),
(18, 'C4.', 1),
(19, 'C5.', 1),
(20, 'D1.', 1),
(21, 'D2.', 1),
(22, 'D3.', 1),
(23, 'D4.', 1),
(24, 'D5.', 1),
(25, 'E1.', 1),
(26, 'E2.', 1),
(27, 'E3.', 1),
(28, 'E4.', 1),
(29, 'E5.', 1),
(30, 'E6.', 1),
(31, 'E7.', 1),
(32, 'F1.', 1),
(33, 'F2.', 1),
(34, 'F3.', 1),
(35, 'F4.', 1),
(36, 'F5.', 1),
(37, 'F6.', 1),
(38, 'F7.', 1),
(39, 'G1.', 1),
(40, 'G2.', 1),
(41, 'G3.', 1),
(42, 'G4.', 1),
(43, 'G5.', 1),
(44, 'G6.', 1),
(45, 'G7.', 1),
(46, 'H1.', 1),
(47, 'H2.', 1),
(48, 'H3.', 1),
(49, 'H4.', 1),
(50, 'H5.', 1),
(51, 'H6.', 1),
(52, 'I1.', 1),
(53, 'I2.', 1),
(54, 'I3.', 1),
(55, 'I4.', 1),
(56, 'I5.', 1),
(57, 'I6.', 1),
(58, 'J1.', 1),
(59, 'J2.', 1),
(60, 'J3.', 1),
(61, 'J4.', 1),
(62, 'J5.', 1),
(63, 'J6.', 1),
(64, 'K1.', 1),
(65, 'K2.', 1),
(66, 'K3.', 1),
(67, 'K4.', 1),
(68, 'L1.', 1),
(69, 'L2.', 1),
(70, 'L3.', 1),
(71, 'L4.', 1),
(72, 'M1.', 1),
(73, 'M2.', 1),
(74, 'M3.', 1),
(75, 'M4.', 1),
(76, 'NO HAY', 1),
(77, 'Almacen', 1),
(78, 'Canaletas.', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tmercancia`
--

CREATE TABLE `tmercancia` (
  `id` int(11) NOT NULL,
  `tipomercancia` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tmercancia`
--

INSERT INTO `tmercancia` (`id`, `tipomercancia`, `estatus`) VALUES
(1, 'Telefonía', 2),
(2, 'Control de Acceso', 2),
(3, 'Cámara', 2),
(4, 'Cerca electrificada', 2),
(5, 'Ángulo Plano 60*40', 2),
(21, 'Canaleta', 2),
(22, 'Accesorio para Cables', 2),
(23, 'Ganchos para Cable', 2),
(24, 'Aislador de paso Blanco', 2),
(25, 'Aislador de Esquina', 2),
(26, 'Aislador de Esquina Blaco', 2),
(27, 'Tendor con taquete negro', 2),
(28, 'UTP (Accesorio)', 2),
(29, 'Tuberia de ½\"', 2),
(30, 'Tuberia de ¾\"', 2),
(31, 'Tuberia de 1\"', 2),
(32, 'Tuberia de 1 ½\"', 2),
(33, 'Tuberia de 1 ¼\"', 2),
(34, 'UTP (Cable)', 2),
(35, 'Patchcord', 2),
(36, 'Categoría 5e', 2),
(37, 'Categoría 5e', 2),
(38, 'Jack', 2),
(39, 'Tapa p/Jack', 2),
(40, 'RJ-45', 2),
(41, 'Extención', 2),
(42, 'Extención', 2),
(43, 'Sensor de Movimiento', 2),
(44, 'Focos', 2),
(45, 'Caja p/ Registro', 2),
(46, 'Caja FS', 2),
(47, 'Tapa Ciega', 2),
(48, 'Contacto', 2),
(49, 'Clavija', 2),
(50, '1/2\"', 2),
(51, 'Tubería Coduit', 2),
(52, 'Tubo Corrugado', 2),
(53, 'Electrico (Accesorios)', 2),
(54, 'Electrico', 2),
(55, 'Tubería PVC', 2),
(56, 'Red', 2),
(57, 'Tubería Timbol', 2),
(58, 'Alarma', 1),
(59, 'Antena', 1),
(60, 'Automóvil', 1),
(61, 'CCTV', 1),
(62, 'Cómputo', 1),
(63, 'Control de Acceso', 1),
(64, 'Eléctrico', 1),
(65, 'Hogar', 1),
(66, 'Oficina', 1),
(67, 'Red', 1),
(68, 'Seguridad', 1),
(69, 'Telefonía', 1),
(70, 'Tubería', 1),
(71, 'Cableado Estructurado', 1),
(72, 'Cerca Eléctrica', 1),
(73, 'Equipos Audio', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `toolback`
--

CREATE TABLE `toolback` (
  `id` int(11) NOT NULL,
  `acciontback` int(11) NOT NULL,
  `herramientaback` int(11) NOT NULL,
  `fechab` datetime NOT NULL,
  `clientesb` int(11) NOT NULL,
  `admin` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `nota` varchar(150) NOT NULL,
  `cantdev` int(11) NOT NULL,
  `idloan` int(11) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tooloan`
--

CREATE TABLE `tooloan` (
  `id` int(11) NOT NULL,
  `acciontool` int(11) NOT NULL,
  `herramienta` int(11) NOT NULL,
  `fechap` datetime NOT NULL,
  `clientes` int(11) NOT NULL,
  `usuarioadmin` int(11) NOT NULL,
  `usuariouser` int(11) NOT NULL,
  `nota` varchar(150) NOT NULL,
  `cantpres` int(11) NOT NULL,
  `cantext` int(11) NOT NULL,
  `estatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `Id` int(11) NOT NULL,
  `Nombre` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `Apellido` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `Usuario` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `Password` varchar(105) COLLATE utf8_spanish_ci NOT NULL,
  `Privilegio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`Id`, `Nombre`, `Apellido`, `Usuario`, `Password`, `Privilegio`) VALUES
(2, 'Edgar Felipe', 'Hernandéz García', 'EdgarF', '$2y$12$Bu9Wkv9GW0yK2rDNqsIxNut8h0jMygfUkBQCNExM/J31R7lUIpPIy', 1),
(8, 'Spider ', 'Luis', 'Prueba', '$2y$12$H3dVNoYHRbq6R6p1zg5Nfe0KI16/GYGiQ1toYGttihcxJLC5RHWLq', 4),
(9, 'Martin Donaldo', 'Perez Flores', 'MartinD', '$2y$12$CPILNgJi6fliPdFHinGzE.OOYmnoOLRdPPlPTZ9NSL0GdtS6/FMzW', 3),
(10, 'Secom', 'Global', 'SecomGlobal', '$2y$12$ANgyKH/7DaImGVyW5CXFVui6Q1J7eYmGoG8ttfIM6NAKcH/EnG/EC', 1),
(11, 'Xochi', 'Esparza', 'Xochi Esparza', '$2y$12$GEIw/XrBWfZCd9EbPrAYCOt/HkEswYlsCRDtkfgn2Ve9Ik4/b8rjy', 4),
(12, 'Xochi', 'Esparza', 'XochiE', '$2y$12$pVULYQX720HFWyVSTlJdm.LVave2VKmv3tfQlaKuBCthYVJyUrF3G', 1),
(13, 'Juan I.', 'Ibarra', 'Juan Ibarra', '$2y$12$2Rho8qTpGpodSIpXgXs56edmGWw8ajbLSLHNGAulvppPPqBC2fZum', 2),
(14, 'Juan O.', 'Ojeda', 'Juan Ojeda', '$2y$12$bmGX/ENTcBEmk8Ogf0KqqO/3Dgc7XNrUzTWuX2wxb0ixtHpI6k9Vu', 2),
(15, 'Ruben', 'Torres Gallegos', 'RubenT', '$2y$12$qqQnjLLkBQUhra/wb68V..cfo7Hlwlt8bhtMF1fA37SNpyLhKJ6H6', 2),
(16, 'Edwing', 'Sanchez', 'Edwing', '$2y$12$r1REqJvMj6vx7IeR6icCCOnA3msv.Qr0179dRkOBsIvUC14gHa78S', 2),
(17, 'Nayely', 'Hernandez', 'Nayely', '$2y$12$6VhFrLerfzMoPRZ3Q2FBoOrOHBmYkUkrx/9c8vhrzx6B3zMy00rwG', 2),
(18, '....', '...', '...', '$2y$12$MVHRT4b7YCeCsek9/dvMD.mx4dSVFe52JFdHiMRNvElc8J9RljE.y', 2);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewalmacen`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewalmacen` (
`id` int(11)
,`almacen` varchar(45)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewaltas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewaltas` (
`id` int(11)
,`accion` int(11)
,`accione` varchar(50)
,`fecha` datetime
,`cantidad` int(11)
,`mercancias` int(11)
,`tipomercancia` varchar(50)
,`marca` int(11)
,`marcas` varchar(45)
,`modelo` int(11)
,`model` varchar(45)
,`nota` varchar(360)
,`proveedor` int(11)
,`proveedores` varchar(50)
,`estade` int(11)
,`estado` varchar(50)
,`usuario` int(11)
,`catidadrestm` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewbajas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewbajas` (
`id` int(11)
,`fecha` datetime
,`accionb` int(11)
,`accione` varchar(50)
,`modelob` int(11)
,`model` varchar(45)
,`canta` int(11)
,`cantidad` int(11)
,`usuarioa` int(11)
,`usuarioao` varchar(50)
,`usuariob` int(11)
,`usuariobo` varchar(50)
,`cliente` int(11)
,`clientes` varchar(50)
,`comentario` varchar(350)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewclient`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewclient` (
`id` int(11)
,`cliente` varchar(50)
,`direccion` varchar(75)
,`ciudad` int(11)
,`ciudades` varchar(45)
,`estatus` int(11)
,`contacto` varchar(50)
,`telefonoa` varchar(15)
,`telefonob` varchar(15)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewestado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewestado` (
`id` int(11)
,`estado` varchar(50)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewingresos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewingresos` (
`id` int(11)
,`Nombre` varchar(50)
,`Privilegio` int(11)
,`Permisos` varchar(50)
,`fecha` datetime
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewmarc`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewmarc` (
`id` int(11)
,`marca` varchar(45)
,`categoria` int(11)
,`categorias` varchar(45)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewmerc`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewmerc` (
`id` int(11)
,`mercancias` int(11)
,`tipomercancia` varchar(50)
,`marca` int(11)
,`marcas` varchar(45)
,`modelo` varchar(45)
,`descripcion` int(11)
,`coment` varchar(100)
,`descripciones` varchar(50)
,`imagenes` varchar(75)
,`cantidad` int(11)
,`seccionm` int(11)
,`seccion` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewprestamos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewprestamos` (
`id` int(11)
,`acciontool` int(11)
,`accion` varchar(50)
,`herramientas` int(11)
,`herramienta` varchar(50)
,`fecha` datetime
,`clientes` int(11)
,`cliente` varchar(50)
,`usuarioadmin` int(11)
,`Nombre` varchar(50)
,`usuariouser` int(11)
,`Nombreu` varchar(50)
,`nota` varchar(150)
,`cantpres` int(11)
,`existencia` int(11)
,`totale` int(11)
,`estatu` int(11)
,`estatus` varchar(45)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewproveedor`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewproveedor` (
`id` int(11)
,`proveedor` varchar(50)
,`estatus` int(11)
,`ciudesta` int(11)
,`ciudad` varchar(45)
,`direccion` varchar(45)
,`telefono` varchar(30)
,`contacto` varchar(60)
,`sucursal` varchar(45)
,`webpage` varchar(45)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewrma`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewrma` (
`id` int(11)
,`numeroorden` int(11)
,`clientesrma` int(11)
,`cliente` varchar(50)
,`direccion` varchar(75)
,`contacto` varchar(50)
,`telefonoa` varchar(15)
,`telefonob` varchar(15)
,`producto` varchar(50)
,`modelo` varchar(50)
,`serie` varchar(50)
,`descripcion` varchar(180)
,`fechaingreso` date
,`fechaenvio` date
,`fecharegreso` date
,`fechainstalacion` date
,`proveedorrma` int(11)
,`proveedor` varchar(50)
,`resultrmat` int(11)
,`resultado` varchar(45)
,`rmaproveedor` varchar(45)
,`aviso` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewseccion`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewseccion` (
`id` int(11)
,`seccion` varchar(50)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewtemerca`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewtemerca` (
`id` int(11)
,`tipomercancia` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewtool`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewtool` (
`id` int(11)
,`herramienta` varchar(50)
,`descripcion` varchar(250)
,`marca` int(11)
,`marcas` varchar(45)
,`modelo` varchar(50)
,`estado` int(11)
,`estad` varchar(50)
,`imagen` varchar(75)
,`existencia` int(11)
,`seccion` int(11)
,`seccionb` varchar(50)
,`almace` int(11)
,`almacen` varchar(45)
,`estatus` int(11)
,`totale` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewtoolback`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewtoolback` (
`id` int(11)
,`acciontback` int(11)
,`estatu` varchar(45)
,`herramientaback` int(11)
,`herramienta` varchar(50)
,`fechab` datetime
,`clientesb` int(11)
,`cliente` varchar(50)
,`admin` int(11)
,`nombre` varchar(50)
,`user` int(11)
,`name` varchar(50)
,`nota` varchar(150)
,`cantdev` int(11)
,`idloan` int(11)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewtoolunf`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewtoolunf` (
`id` int(11)
,`tool` int(11)
,`herramienta` varchar(50)
,`descripcion` varchar(250)
,`modelo` varchar(50)
,`imagen` varchar(75)
,`existencia` int(11)
,`marcasunf` int(11)
,`marca` varchar(45)
,`estadounf` int(11)
,`estado` varchar(50)
,`seccionunf` int(11)
,`seccion` varchar(50)
,`almacenunf` int(11)
,`almacen` varchar(45)
,`razon` varchar(115)
,`cantidad` int(11)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viewuser`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viewuser` (
`Id` int(11)
,`Nombre` varchar(50)
,`Apellido` varchar(50)
,`Usuario` varchar(50)
,`Password` varchar(105)
,`privilegio` int(11)
,`Permisos` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viweciudad`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viweciudad` (
`id` int(11)
,`ciudad` varchar(45)
,`estatus` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `viwedesc`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `viwedesc` (
`id` int(11)
,`descripcion` varchar(50)
,`temerca` int(11)
,`tipomercancia` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `viewalmacen`
--
DROP TABLE IF EXISTS `viewalmacen`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewalmacen`  AS  select `id` AS `id`,`almacen` AS `almacen`,`estatus` AS `estatus` from `almacen` where (`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewaltas`
--
DROP TABLE IF EXISTS `viewaltas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewaltas`  AS  select `altas`.`id` AS `id`,`altas`.`accion` AS `accion`,`accion`.`accion` AS `accione`,`altas`.`fecha` AS `fecha`,`altas`.`cantidad` AS `cantidad`,`altas`.`mercancias` AS `mercancias`,`tmercancia`.`tipomercancia` AS `tipomercancia`,`altas`.`marca` AS `marca`,`marcas`.`marca` AS `marcas`,`altas`.`modelo` AS `modelo`,`a`.`modelo` AS `model`,`altas`.`nota` AS `nota`,`altas`.`proveedor` AS `proveedor`,`proveedor`.`proveedor` AS `proveedores`,`altas`.`estade` AS `estade`,`estado`.`estado` AS `estado`,`altas`.`usuario` AS `usuario`,`b`.`cantidad` AS `catidadrestm` from (((((((`altas` join `accion` on((`altas`.`accion` = `accion`.`id`))) join `tmercancia` on((`altas`.`mercancias` = `tmercancia`.`id`))) join `marcas` on((`altas`.`marca` = `marcas`.`id`))) join `mercancia` `a` on((`altas`.`modelo` = `a`.`id`))) join `mercancia` `b` on((`altas`.`cantrest` = `b`.`id`))) join `proveedor` on((`altas`.`proveedor` = `proveedor`.`id`))) join `estado` on((`altas`.`estade` = `estado`.`id`))) where (`altas`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewbajas`
--
DROP TABLE IF EXISTS `viewbajas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewbajas`  AS  select `bajas`.`id` AS `id`,`bajas`.`fecha` AS `fecha`,`bajas`.`accionb` AS `accionb`,`accion`.`accion` AS `accione`,`bajas`.`modelob` AS `modelob`,`c`.`modelo` AS `model`,`d`.`cantidad` AS `canta`,`bajas`.`cantidad` AS `cantidad`,`bajas`.`usuarioa` AS `usuarioa`,`a`.`Nombre` AS `usuarioao`,`bajas`.`usuariob` AS `usuariob`,`b`.`Nombre` AS `usuariobo`,`bajas`.`cliente` AS `cliente`,`clientes`.`cliente` AS `clientes`,`bajas`.`comentario` AS `comentario`,`bajas`.`estatus` AS `estatus` from ((((((`bajas` join `accion` on((`bajas`.`accionb` = `accion`.`id`))) join `mercancia` `c` on((`bajas`.`modelob` = `c`.`id`))) join `mercancia` `d` on((`bajas`.`modelob` = `d`.`id`))) join `usuarios` `a` on((`bajas`.`usuarioa` = `a`.`Id`))) join `usuarios` `b` on((`bajas`.`usuariob` = `b`.`Id`))) join `clientes` on((`bajas`.`cliente` = `clientes`.`id`))) where (`bajas`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewclient`
--
DROP TABLE IF EXISTS `viewclient`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewclient`  AS  select `clientes`.`id` AS `id`,`clientes`.`cliente` AS `cliente`,`clientes`.`direccion` AS `direccion`,`clientes`.`ciudad` AS `ciudad`,`ciudad`.`ciudad` AS `ciudades`,`clientes`.`estatus` AS `estatus`,`clientes`.`contacto` AS `contacto`,`clientes`.`telefonoa` AS `telefonoa`,`clientes`.`telefonob` AS `telefonob` from (`clientes` join `ciudad` on((`clientes`.`ciudad` = `ciudad`.`id`))) where (`clientes`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewestado`
--
DROP TABLE IF EXISTS `viewestado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewestado`  AS  select `estado`.`id` AS `id`,`estado`.`estado` AS `estado`,`estado`.`estatus` AS `estatus` from `estado` where (`estado`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewingresos`
--
DROP TABLE IF EXISTS `viewingresos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewingresos`  AS  select `ingresos`.`id` AS `id`,`usuarios`.`Nombre` AS `Nombre`,`usuarios`.`Privilegio` AS `Privilegio`,`privilegio`.`Permisos` AS `Permisos`,`ingresos`.`fecha` AS `fecha` from ((`ingresos` join `usuarios` on((`ingresos`.`usuario` = `usuarios`.`Id`))) join `privilegio` on((`usuarios`.`Privilegio` = `privilegio`.`id`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewmarc`
--
DROP TABLE IF EXISTS `viewmarc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewmarc`  AS  select `marcas`.`id` AS `id`,`marcas`.`marca` AS `marca`,`marcas`.`categoria` AS `categoria`,`categoria`.`categoria` AS `categorias`,`marcas`.`estatus` AS `estatus` from (`marcas` join `categoria` on((`marcas`.`categoria` = `categoria`.`id`))) where (`marcas`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewmerc`
--
DROP TABLE IF EXISTS `viewmerc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewmerc`  AS  select `mercancia`.`id` AS `id`,`mercancia`.`mercancia` AS `mercancias`,`tmercancia`.`tipomercancia` AS `tipomercancia`,`mercancia`.`marcas` AS `marca`,`marcas`.`marca` AS `marcas`,`mercancia`.`modelo` AS `modelo`,`mercancia`.`descripcion` AS `descripcion`,`mercancia`.`coment` AS `coment`,`descripcion`.`descripcion` AS `descripciones`,`mercancia`.`imagenes` AS `imagenes`,`mercancia`.`cantidad` AS `cantidad`,`mercancia`.`seccionm` AS `seccionm`,`seccion`.`seccion` AS `seccion` from ((((`mercancia` join `marcas` on((`mercancia`.`marcas` = `marcas`.`id`))) join `tmercancia` on((`mercancia`.`mercancia` = `tmercancia`.`id`))) join `descripcion` on((`mercancia`.`descripcion` = `descripcion`.`id`))) join `seccion` on((`mercancia`.`seccionm` = `seccion`.`id`))) where (`mercancia`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewprestamos`
--
DROP TABLE IF EXISTS `viewprestamos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewprestamos`  AS  select `tooloan`.`id` AS `id`,`tooloan`.`acciontool` AS `acciontool`,`accion`.`accion` AS `accion`,`tooloan`.`herramienta` AS `herramientas`,`c`.`herramienta` AS `herramienta`,`tooloan`.`fechap` AS `fecha`,`tooloan`.`clientes` AS `clientes`,`clientes`.`cliente` AS `cliente`,`tooloan`.`usuarioadmin` AS `usuarioadmin`,`a`.`Nombre` AS `Nombre`,`tooloan`.`usuariouser` AS `usuariouser`,`b`.`Nombre` AS `Nombreu`,`tooloan`.`nota` AS `nota`,`tooloan`.`cantpres` AS `cantpres`,`d`.`existencia` AS `existencia`,`e`.`totale` AS `totale`,`tooloan`.`estatus` AS `estatu`,`loanback`.`estatus` AS `estatus` from ((((((((`tooloan` join `accion` on((`tooloan`.`acciontool` = `accion`.`id`))) join `herramienta` `c` on((`tooloan`.`herramienta` = `c`.`id`))) join `clientes` on((`tooloan`.`clientes` = `clientes`.`id`))) join `usuarios` `a` on((`tooloan`.`usuarioadmin` = `a`.`Id`))) join `usuarios` `b` on((`tooloan`.`usuariouser` = `b`.`Id`))) join `herramienta` `d` on((`tooloan`.`cantext` = `d`.`id`))) join `herramienta` `e` on((`tooloan`.`cantext` = `e`.`id`))) join `loanback` on((`tooloan`.`estatus` = `loanback`.`id`))) where ((`tooloan`.`estatus` = 1) or (`tooloan`.`estatus` = 3) or (`tooloan`.`estatus` = 4)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewproveedor`
--
DROP TABLE IF EXISTS `viewproveedor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewproveedor`  AS  select `proveedor`.`id` AS `id`,`proveedor`.`proveedor` AS `proveedor`,`proveedor`.`estatus` AS `estatus`,`proveedor`.`ciudesta` AS `ciudesta`,`ciudad`.`ciudad` AS `ciudad`,`proveedor`.`direccion` AS `direccion`,`proveedor`.`telefono` AS `telefono`,`proveedor`.`contacto` AS `contacto`,`proveedor`.`sucursal` AS `sucursal`,`proveedor`.`webpage` AS `webpage` from (`proveedor` join `ciudad` on((`proveedor`.`ciudesta` = `ciudad`.`id`))) where (`proveedor`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewrma`
--
DROP TABLE IF EXISTS `viewrma`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewrma`  AS  select `rma`.`id` AS `id`,`rma`.`numeroorden` AS `numeroorden`,`rma`.`clientesrma` AS `clientesrma`,`clientes`.`cliente` AS `cliente`,`clientes`.`direccion` AS `direccion`,`clientes`.`contacto` AS `contacto`,`clientes`.`telefonoa` AS `telefonoa`,`clientes`.`telefonob` AS `telefonob`,`rma`.`producto` AS `producto`,`rma`.`modelo` AS `modelo`,`rma`.`serie` AS `serie`,`rma`.`descripcion` AS `descripcion`,`rma`.`fechaingreso` AS `fechaingreso`,`rma`.`fechaenvio` AS `fechaenvio`,`rma`.`fecharegreso` AS `fecharegreso`,`rma`.`fechainstalacion` AS `fechainstalacion`,`rma`.`proveedorrma` AS `proveedorrma`,`proveedor`.`proveedor` AS `proveedor`,`rma`.`resultrmat` AS `resultrmat`,`resultrma`.`resultado` AS `resultado`,`rma`.`rmaproveedor` AS `rmaproveedor`,`rma`.`aviso` AS `aviso` from (((`rma` join `clientes` on((`rma`.`clientesrma` = `clientes`.`id`))) join `proveedor` on((`rma`.`proveedorrma` = `proveedor`.`id`))) join `resultrma` on((`rma`.`resultrmat` = `resultrma`.`id`))) where (`rma`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewseccion`
--
DROP TABLE IF EXISTS `viewseccion`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewseccion`  AS  select `seccion`.`id` AS `id`,`seccion`.`seccion` AS `seccion`,`seccion`.`estatus` AS `estatus` from `seccion` where (`seccion`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewtemerca`
--
DROP TABLE IF EXISTS `viewtemerca`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewtemerca`  AS  select `tmercancia`.`id` AS `id`,`tmercancia`.`tipomercancia` AS `tipomercancia` from `tmercancia` where (`tmercancia`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewtool`
--
DROP TABLE IF EXISTS `viewtool`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewtool`  AS  select `herramienta`.`id` AS `idt`,`herramienta`.`herramienta` AS `herramienta`,`herramienta`.`descripcion` AS `descripcion`,`herramienta`.`marca` AS `marca`,`marcas`.`marca` AS `marcas`,`herramienta`.`modelo` AS `modelo`,`herramienta`.`estado` AS `estado`,`estado`.`estado` AS `estad`,`herramienta`.`imagen` AS `imagen`,`herramienta`.`existencia` AS `existencia`,`herramienta`.`seccion` AS `seccion`,`seccion`.`seccion` AS `seccionb`,`herramienta`.`almace` AS `almace`,`almacen` AS `almacen`,`herramienta`.`estatus` AS `estatus`,`herramienta`.`totale` AS `totale` from ((((`herramienta` join `marcas` on((`herramienta`.`marca` = `marcas`.`id`))) join `estado` on((`herramienta`.`estado` = `estado`.`id`))) join `seccion` on((`herramienta`.`seccion` = `seccion`.`id`))) join `almacen` on((`herramienta`.`almace` = `id`))) where ((`herramienta`.`estatus` = 1) and (`herramienta`.`estado` <> 4)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewtoolback`
--
DROP TABLE IF EXISTS `viewtoolback`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewtoolback`  AS  select `toolback`.`id` AS `idtb`,`toolback`.`acciontback` AS `acciontback`,`loanback`.`estatus` AS `estatu`,`toolback`.`herramientaback` AS `herramientaback`,`herramienta`.`herramienta` AS `herramienta`,`toolback`.`fechab` AS `fechab`,`toolback`.`clientesb` AS `clientesb`,`clientes`.`cliente` AS `cliente`,`toolback`.`admin` AS `admin`,`a`.`Nombre` AS `nombre`,`toolback`.`user` AS `user`,`b`.`Nombre` AS `name`,`toolback`.`nota` AS `nota`,`toolback`.`cantdev` AS `cantdev`,`toolback`.`idloan` AS `idloan`,`toolback`.`estatus` AS `estatus` from (((((`toolback` join `loanback` on((`toolback`.`acciontback` = `loanback`.`id`))) join `herramienta` on((`toolback`.`herramientaback` = `herramienta`.`id`))) join `clientes` on((`toolback`.`clientesb` = `clientes`.`id`))) join `usuarios` `a` on((`toolback`.`admin` = `a`.`Id`))) join `usuarios` `b` on((`toolback`.`user` = `b`.`Id`))) where (`toolback`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewtoolunf`
--
DROP TABLE IF EXISTS `viewtoolunf`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewtoolunf`  AS  select `herramientaunf`.`id` AS `idunf`,`herramientaunf`.`tool` AS `tool`,`a`.`herramienta` AS `herramienta`,`b`.`descripcion` AS `descripcion`,`c`.`modelo` AS `modelo`,`d`.`imagen` AS `imagen`,`e`.`existencia` AS `existencia`,`herramientaunf`.`marcasunf` AS `marcasunf`,`marcas`.`marca` AS `marca`,`herramientaunf`.`estadounf` AS `estadounf`,`estado`.`estado` AS `estado`,`herramientaunf`.`seccionunf` AS `seccionunf`,`seccion`.`seccion` AS `seccion`,`herramientaunf`.`almacenunf` AS `almacenunf`,`almacen` AS `almacen`,`herramientaunf`.`razon` AS `razon`,`herramientaunf`.`cantidad` AS `cantidad`,`herramientaunf`.`estatus` AS `estatus` from (((((((((`herramientaunf` join `herramienta` `a` on((`herramientaunf`.`tool` = `a`.`id`))) join `herramienta` `b` on((`herramientaunf`.`description` = `b`.`id`))) join `herramienta` `c` on((`herramientaunf`.`modelo` = `c`.`id`))) join `herramienta` `d` on((`herramientaunf`.`imagen` = `d`.`id`))) join `herramienta` `e` on((`herramientaunf`.`existencia` = `e`.`id`))) join `marcas` on((`herramientaunf`.`marcasunf` = `marcas`.`id`))) join `estado` on((`herramientaunf`.`estadounf` = `estado`.`id`))) join `seccion` on((`herramientaunf`.`seccionunf` = `seccion`.`id`))) join `almacen` on((`herramientaunf`.`almacenunf` = `id`))) where ((`herramientaunf`.`estatus` = 1) and (`herramientaunf`.`estadounf` = 4)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viewuser`
--
DROP TABLE IF EXISTS `viewuser`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewuser`  AS  select `usuarios`.`Id` AS `Id`,`usuarios`.`Nombre` AS `Nombre`,`usuarios`.`Apellido` AS `Apellido`,`usuarios`.`Usuario` AS `Usuario`,`usuarios`.`Password` AS `Password`,`usuarios`.`Privilegio` AS `privilegio`,`privilegio`.`Permisos` AS `Permisos` from (`usuarios` join `privilegio` on((`usuarios`.`Privilegio` = `privilegio`.`id`))) where ((`usuarios`.`Privilegio` = 1) or (`usuarios`.`Privilegio` = 2) or (`usuarios`.`Privilegio` = 3)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viweciudad`
--
DROP TABLE IF EXISTS `viweciudad`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viweciudad`  AS  select `ciudad`.`id` AS `id`,`ciudad`.`ciudad` AS `ciudad`,`ciudad`.`estatus` AS `estatus` from `ciudad` where (`ciudad`.`estatus` = 1) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `viwedesc`
--
DROP TABLE IF EXISTS `viwedesc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viwedesc`  AS  select `descripcion`.`id` AS `id`,`descripcion`.`descripcion` AS `descripcion`,`descripcion`.`temerca` AS `temerca`,`tmercancia`.`tipomercancia` AS `tipomercancia` from (`descripcion` join `tmercancia` on((`descripcion`.`temerca` = `tmercancia`.`id`))) where (`descripcion`.`estatus` = 1) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `accion`
--
ALTER TABLE `accion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `altas`
--
ALTER TABLE `altas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accion_idx` (`accion`),
  ADD KEY `cantprodact_idx` (`marca`),
  ADD KEY `cantprod_idx` (`marca`),
  ADD KEY `mercancias_idx` (`mercancias`),
  ADD KEY `modelo_idx` (`modelo`),
  ADD KEY `proveedor_idx` (`proveedor`),
  ADD KEY `estade_idx` (`estade`),
  ADD KEY `usuarios_idx` (`usuario`);

--
-- Indices de la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accion_idx` (`accionb`),
  ADD KEY `modelo_idx` (`modelob`),
  ADD KEY `usuarioa_idx` (`usuarioa`),
  ADD KEY `usuariob_idx` (`usuariob`),
  ADD KEY `cliente_idx` (`cliente`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ciudad`
--
ALTER TABLE `ciudad`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cliente_UNIQUE` (`cliente`),
  ADD KEY `ciudad_idx` (`ciudad`);

--
-- Indices de la tabla `descripcion`
--
ALTER TABLE `descripcion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `temerca_idx` (`temerca`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `herramienta`
--
ALTER TABLE `herramienta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `estado_idx` (`estado`),
  ADD KEY `marca_idx` (`marca`),
  ADD KEY `almacen_idx` (`almace`),
  ADD KEY `almace_idx` (`almace`),
  ADD KEY `seccion_idx` (`seccion`);

--
-- Indices de la tabla `herramientaunf`
--
ALTER TABLE `herramientaunf`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tool_idx` (`tool`),
  ADD KEY `marcasunf_idx` (`marcasunf`),
  ADD KEY `estadounf_idx` (`estadounf`),
  ADD KEY `seccionunf_idx` (`seccionunf`),
  ADD KEY `almacenunf_idx` (`almacenunf`),
  ADD KEY `description_idx` (`description`);

--
-- Indices de la tabla `imagen`
--
ALTER TABLE `imagen`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ingresos`
--
ALTER TABLE `ingresos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_idx` (`usuario`);

--
-- Indices de la tabla `loanback`
--
ALTER TABLE `loanback`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_idx` (`categoria`);

--
-- Indices de la tabla `mercancia`
--
ALTER TABLE `mercancia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `marca_idx` (`marcas`),
  ADD KEY `imagenes_idx` (`imagenes`),
  ADD KEY `mercancia_idx` (`mercancia`),
  ADD KEY `descripcion_idx` (`descripcion`),
  ADD KEY `seccionm_idx` (`seccionm`);

--
-- Indices de la tabla `privilegio`
--
ALTER TABLE `privilegio`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ciuest_idx` (`ciudesta`);

--
-- Indices de la tabla `resultrma`
--
ALTER TABLE `resultrma`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rma`
--
ALTER TABLE `rma`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clientesrma_idx` (`clientesrma`),
  ADD KEY `proveedorrma_idx` (`proveedorrma`),
  ADD KEY `resultrma_idx` (`resultrmat`);

--
-- Indices de la tabla `seccion`
--
ALTER TABLE `seccion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tmercancia`
--
ALTER TABLE `tmercancia`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `toolback`
--
ALTER TABLE `toolback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `acciontback_idx` (`acciontback`),
  ADD KEY `herramientaback_idx` (`herramientaback`),
  ADD KEY `cliente_idx` (`clientesb`),
  ADD KEY `admin_idx` (`admin`),
  ADD KEY `user_idx` (`user`),
  ADD KEY `idloan_idx` (`idloan`);

--
-- Indices de la tabla `tooloan`
--
ALTER TABLE `tooloan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accion_idx` (`acciontool`),
  ADD KEY `acciontool_idx` (`acciontool`),
  ADD KEY `herramienta_idx` (`herramienta`),
  ADD KEY `clientes_idx` (`clientes`),
  ADD KEY `usuarioadmin_idx` (`usuarioadmin`),
  ADD KEY `usuariouser_idx` (`usuariouser`),
  ADD KEY `cantext_idx` (`cantext`),
  ADD KEY `estatus_idx` (`estatus`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Usuario_UNIQUE` (`Usuario`),
  ADD KEY `Estado_idx` (`Privilegio`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `accion`
--
ALTER TABLE `accion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `almacen`
--
ALTER TABLE `almacen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `altas`
--
ALTER TABLE `altas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=627;
--
-- AUTO_INCREMENT de la tabla `bajas`
--
ALTER TABLE `bajas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;
--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `ciudad`
--
ALTER TABLE `ciudad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;
--
-- AUTO_INCREMENT de la tabla `descripcion`
--
ALTER TABLE `descripcion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=567;
--
-- AUTO_INCREMENT de la tabla `estado`
--
ALTER TABLE `estado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `herramienta`
--
ALTER TABLE `herramienta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT de la tabla `herramientaunf`
--
ALTER TABLE `herramientaunf`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `imagen`
--
ALTER TABLE `imagen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `ingresos`
--
ALTER TABLE `ingresos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;
--
-- AUTO_INCREMENT de la tabla `loanback`
--
ALTER TABLE `loanback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=207;
--
-- AUTO_INCREMENT de la tabla `mercancia`
--
ALTER TABLE `mercancia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=565;
--
-- AUTO_INCREMENT de la tabla `privilegio`
--
ALTER TABLE `privilegio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT de la tabla `resultrma`
--
ALTER TABLE `resultrma`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `rma`
--
ALTER TABLE `rma`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT de la tabla `seccion`
--
ALTER TABLE `seccion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;
--
-- AUTO_INCREMENT de la tabla `tmercancia`
--
ALTER TABLE `tmercancia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;
--
-- AUTO_INCREMENT de la tabla `toolback`
--
ALTER TABLE `toolback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `tooloan`
--
ALTER TABLE `tooloan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `altas`
--
ALTER TABLE `altas`
  ADD CONSTRAINT `accion` FOREIGN KEY (`accion`) REFERENCES `accion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `estade` FOREIGN KEY (`estade`) REFERENCES `estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `marc` FOREIGN KEY (`marca`) REFERENCES `marcas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `mercancias` FOREIGN KEY (`mercancias`) REFERENCES `tmercancia` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `modelo` FOREIGN KEY (`modelo`) REFERENCES `mercancia` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `proveedor` FOREIGN KEY (`proveedor`) REFERENCES `proveedor` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `usuarios` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD CONSTRAINT `accionb` FOREIGN KEY (`accionb`) REFERENCES `accion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `cliente` FOREIGN KEY (`cliente`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `modelob` FOREIGN KEY (`modelob`) REFERENCES `mercancia` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `usuarioa` FOREIGN KEY (`usuarioa`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `usuariob` FOREIGN KEY (`usuariob`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `ciudad` FOREIGN KEY (`ciudad`) REFERENCES `ciudad` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `descripcion`
--
ALTER TABLE `descripcion`
  ADD CONSTRAINT `temerca` FOREIGN KEY (`temerca`) REFERENCES `tmercancia` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `herramienta`
--
ALTER TABLE `herramienta`
  ADD CONSTRAINT `almace` FOREIGN KEY (`almace`) REFERENCES `almacen` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `almacen` FOREIGN KEY (`almace`) REFERENCES `almacen` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `estado` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `marca` FOREIGN KEY (`marca`) REFERENCES `marcas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `seccion` FOREIGN KEY (`seccion`) REFERENCES `seccion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `herramientaunf`
--
ALTER TABLE `herramientaunf`
  ADD CONSTRAINT `almacenunf` FOREIGN KEY (`almacenunf`) REFERENCES `almacen` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `estadounf` FOREIGN KEY (`estadounf`) REFERENCES `estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `marcasunf` FOREIGN KEY (`marcasunf`) REFERENCES `marcas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `seccionunf` FOREIGN KEY (`seccionunf`) REFERENCES `seccion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `tool` FOREIGN KEY (`tool`) REFERENCES `herramienta` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ingresos`
--
ALTER TABLE `ingresos`
  ADD CONSTRAINT `usuario` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD CONSTRAINT `categoria` FOREIGN KEY (`categoria`) REFERENCES `categoria` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `mercancia`
--
ALTER TABLE `mercancia`
  ADD CONSTRAINT `descripcion` FOREIGN KEY (`descripcion`) REFERENCES `descripcion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `marcas` FOREIGN KEY (`marcas`) REFERENCES `marcas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `mercancia` FOREIGN KEY (`mercancia`) REFERENCES `tmercancia` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `seccionm` FOREIGN KEY (`seccionm`) REFERENCES `seccion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD CONSTRAINT `ciudesta` FOREIGN KEY (`ciudesta`) REFERENCES `ciudad` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `rma`
--
ALTER TABLE `rma`
  ADD CONSTRAINT `clientesrma` FOREIGN KEY (`clientesrma`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `proveedorrma` FOREIGN KEY (`proveedorrma`) REFERENCES `proveedor` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `resultrmat` FOREIGN KEY (`resultrmat`) REFERENCES `resultrma` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `toolback`
--
ALTER TABLE `toolback`
  ADD CONSTRAINT `acciontback` FOREIGN KEY (`acciontback`) REFERENCES `loanback` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `admin` FOREIGN KEY (`admin`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `clientesb` FOREIGN KEY (`clientesb`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `herramientaback` FOREIGN KEY (`herramientaback`) REFERENCES `herramienta` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `idloan` FOREIGN KEY (`idloan`) REFERENCES `tooloan` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `user` FOREIGN KEY (`user`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tooloan`
--
ALTER TABLE `tooloan`
  ADD CONSTRAINT `acciontool` FOREIGN KEY (`acciontool`) REFERENCES `accion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `cantext` FOREIGN KEY (`cantext`) REFERENCES `herramienta` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `clientes` FOREIGN KEY (`clientes`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `estatus` FOREIGN KEY (`estatus`) REFERENCES `loanback` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `herramienta` FOREIGN KEY (`herramienta`) REFERENCES `herramienta` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `usuarioadmin` FOREIGN KEY (`usuarioadmin`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `usuariouser` FOREIGN KEY (`usuariouser`) REFERENCES `usuarios` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `Privilegio` FOREIGN KEY (`Privilegio`) REFERENCES `privilegio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
