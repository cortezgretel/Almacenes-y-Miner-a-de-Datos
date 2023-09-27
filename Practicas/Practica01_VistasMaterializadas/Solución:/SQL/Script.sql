
/*1er vista */
CREATE VIEW VISTA1 AS 
SELECT curp, nombre, paterno, materno FROM Empleado WHERE nombre LIKE 'A%';

SELECT *FROM VISTA1;
/*No se pudo realizar una insercion a la vista1*/
INSERT INTO VISTA1  (curp, nombre, paterno, materno) VALUES ('AXWB749657FGULDZ78', 'Ianthe', 'Hightown', 'Lacotte');

/*DELETE: si se pudo realizar */
DELETE FROM VISTA1 WHERE curp='ACWU948539FDBQAR18';

/*UPDATE: si se pudo realizar */
UPDATE VISTA1 SET nombre = 'Alfredo' WHERE curp='ADFX122663FNYWRC01';


/*2da vista*/
CREATE VIEW VISTA2 AS
SELECT E.curp, E.nombre, E.paterno, E.materno, E.nacimiento,
	E.genero, E.calle, E.cp, E.ciudad, E.numDepto AS EmpleadoNumDepto,
    D.numDepto AS DepartamentoNumDepto,
    D.fecha,
    D.nombreDepto
FROM Empleado E INNER JOIN Departamento D ON E.numDepto = D.numDepto; 

SELECT *FROM VISTA2;

/*INSERT: No es actualizable ya que la modificacion afecta a varias tablas base*/
INSERT INTO VISTA2 (curp, nombre, paterno, materno, nacimiento, genero, calle, cp, ciudad, EmpleadoNumDepto,
DepartamentoNumDepto,fecha,nombreDepto) VALUES 
('ARYH966626FIKCND36', 'Alma', 'Michael', 'Gebbe', 72236, 'F', '05/08/1977', 'Ver', 'Garrison', 58588, 793, 793, '14/10/2000', 'Beta');

/*DELETE: No es actualizable ya que la modificacion afecta a varias tablas base*/
DELETE FROM VISTA2 WHERE curp='QORI674750HNEFSQ17';

/*UPDATE: Permite el cambio */
UPDATE VISTA2 SET nombre = 'Axel' WHERE curp='QORI674750HNEFSQ17';

/*3er vista */
CREATE VIEW VISTA3 AS
SELECT Proyecto.numProy, Proyecto.nombreProy,
sum(colaborar.numHoras) AS horas,
count(curp) AS totalEmpleados
FROM Proyecto 
left join Colaborar ON (Colaborar.numProy=Proyecto.numProy)
GROUP BY Proyecto.numProy, Proyecto.nombreProy;

SELECT *FROM VISTA3;
/*INSERT: No puede actualizar ni insertar la vista o función 'VISTA3' porque contiene un campo derivado o constante.*/
INSERT INTO VISTA3 (numProy, nombreProy, horas, totalEmpleados) VALUES (501, 'aplicados', 2120, 0);

/*DELETE: La vista o función 'VISTA3' no es actualizable porque la modificación afecta a varias tablas base*/
DELETE FROM VISTA3 WHERE numProy = 1;

/*UPDATE: No se puede actualizar la vista o función 'VISTA3' porque contiene agregados o una cláusula DISTINCT o GROUP BY, o un operador PIVOT o UNPIVOT.
*/
UPDATE VISTA3 SET nombreProy = 'Aplicados' WHERE numProy='1';


/*
select Proyecto.numProy, Proyecto.nombreProy, 
sum(colaborar.numHoras) as horas,
count(curp) as totalEmpleados
from Proyecto 
left join Colaborar on (Colaborar.numProy=Proyecto.numProy)
group by Proyecto.numProy, Proyecto.nombreProy;

select curp, nombreProy, colaborar.numHoras 
from Colaborar left join Proyecto on Colaborar.numProy=Proyecto.numProy
where Proyecto.numProy = 1; 
*/


/*Vista materializada 1*/
CREATE VIEW VISTAMAT1 WITH SCHEMABINDING AS 
SELECT curp, nombre, paterno, materno FROM dbo.Empleado WHERE nombre LIKE 'A%';

SELECT *FROM VISTAMAT1;

/*INSERT: No se puede insertar el valor NULL en la columna 'numDepto', tabla 'master.dbo.Empleado'. La columna no admite valores NULL. Error de INSERT.*/
INSERT INTO VISTAMAT1(curp, nombre, paterno, materno) VALUES ('AXWB749657FGULDZ78', 'Ianthe', 'Hightown', 'Lacotte');

/*DELETE: si se pudo realizar */
DELETE FROM VISTAMAT1 WHERE curp='BNMR859072HIBZAN70';

/*UPDATE: si se pudo realizar */
UPDATE VISTAMAT1 SET nombre = 'Axel' WHERE curp='ARYH966626FIKCND36';


/*Vista materializada 2*/
CREATE VIEW VISTAMAT2 WITH SCHEMABINDING AS
SELECT E.curp, E.nombre, E.paterno, E.materno, E.nacimiento,
	E.genero, E.calle, E.cp, E.ciudad, E.numDepto AS EmpleadoNumDepto,
    D.numDepto AS DepartamentoNumDepto,
    D.fecha,
    D.nombreDepto
FROM dbo.Empleado E INNER JOIN dbo.Departamento D ON E.numDepto = D.numDepto; 

SELECT *FROM VISTAMAT2;

/*INSERT: La vista o función 'VISTAMAT2' no es actualizable porque la modificación afecta a varias tablas base. */
INSERT INTO VISTAMAT2 (curp, nombre, paterno, materno, nacimiento, genero, calle, cp, ciudad, EmpleadoNumDepto,
DepartamentoNumDepto,fecha,nombreDepto) VALUES 
('ARYH966626FIKCND36', 'Alma', 'Michael', 'Gebbe', 72236, 'F', '05/08/1977', 'Ver', 'Garrison', 58588, 793, 793, '14/10/2000', 'Beta');

/*DELETE: No es actualizable ya que la modificacion afecta a varias tablas base*/
DELETE FROM VISTAMAT2 WHERE curp='QORI674750HNEFSQ17';

/*UPDATE: Permite el cambio */
UPDATE VISTAMAT2 SET nombre = 'Antonio' WHERE curp='QORI674750HNEFSQ17';

/*Vista materializada 3*/
CREATE VIEW VISTAMAT3 WITH SCHEMABINDING AS
SELECT Proyecto.numProy, Proyecto.nombreProy,
sum(colaborar.numHoras) AS horas,
count(curp) AS totalEmpleados
FROM dbo.Proyecto 
left join dbo.Colaborar ON (Colaborar.numProy=Proyecto.numProy)
GROUP BY Proyecto.numProy, Proyecto.nombreProy;

SELECT *FROM VISTAMAT3;

/*INSERT: No puede actualizar ni insertar la vista o función 'VISTAMAT3' porque contiene un campo derivado o constante.*/
INSERT INTO VISTAMAT3(numProy, nombreProy, horas, totalEmpleados) VALUES (501, 'aplicados', 2120, 0);

/*DELETE: La vista o función 'VISTAMAT3' no es actualizable porque la modificación afecta a varias tablas base*/
DELETE FROM VISTAMAT3 WHERE numProy = 1;

/*UPDATE: No se puede actualizar la vista o función 'VISTAMAT3' porque contiene agregados o una cláusula DISTINCT o GROUP BY, o un operador PIVOT o UNPIVOT.
*/
UPDATE VISTAMAT3 SET nombreProy = 'Aplicados+' WHERE numProy='1';



