@echo off
echo - - - - - - - CREACION DE LA UNIDAD ORGANIZATIVA DE TALLER - - - - - - - 
echo .
dsadd ou "ou=Taller, dc=ASIR20, dc=LOCAL"
echo .
echo - - - - - - - CREACION DE LAS SECCIONES QUE PERTENECEN A TALLER - - - - - - - 
echo .
FOR /F "tokens=1-2 delims=: skip=1" %%a in (secciones.csv) do dsadd ou "ou=%%a, ou=Taller, dc=ASIR20, dc=LOCAL" -desc "%%b"
echo .
echo - - - - - - - CREACION DE LOS DEPARTAMENTOS DENTRO DE LAS SECCIONES - - - - - - - 
echo .
FOR /F "tokens=1-3 delims=: skip=1" %%a in (departamentos.csv) do dsadd ou "ou=%%b, ou=%%a, ou=Taller, dc=ASIR20, dc=LOCAL" -desc "%%c"
echo .
echo - - - - - - - CREACION DEL GRUPO TALLER - - - - - - - 
echo .
dsadd group "cn=Taller, ou=Taller, dc=ASIR20, dc=LOCAL"
echo .
echo - - - - - - - CREACION DE LOS GRUPOS DE CADA SECCION PERTENECIENTES AL GRUPO TALLER- - - - - - - 
echo .
FOR /F "tokens=1-2 delims=: skip=1" %%a in (secciones.csv) do dsadd group "cn=%%a, ou=%%a, ou=Taller, dc=ASIR20, dc=LOCAL" -desc "%%b" -memberof "cn=Taller, ou=Taller, dc=ASIR20, dc=LOCAL"
echo .
echo - - - - - - - CREACION DE USUARIOS EN CADA SECCION PERTENECIENTES AL GRUPO TALLER- - - - - - - 
echo .
FOR /F "tokens=1-5 delims=: skip=1" %%a in (empleados.csv) do dsadd user "cn=%%d, ou=%%b, ou=%%a, ou=Taller, dc=ASIR20, dc=LOCAL" -upn "%%d_%%e@ASIR20.LOCAL" -pwd "Taller#19" -fn %%d -ln %%e  -mustchpwd yes -canchpwd yes -disabled no -desc "%%c" -memberof "cn=%%a, ou=%%a, ou=Taller, dc=ASIR20, dc=LOCAL" 
