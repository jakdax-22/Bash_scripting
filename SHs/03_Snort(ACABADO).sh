#!/bin/bash

#mkdir c:\Snort

#INTRODUCCIÓN
#docker run --net host --rm --name Snort -v c:\snort:/etc/snort -it ubuntu:latest bash

#apt-get update && apt-get install nano && nano /etc/snort/sc.sh && chmod +rwx /etc/snort/sc.sh && cd /etc/snort && ./sc.sh

echo "
     ......       ......    ......      .....      .....     ......         ......      .....       
    'kXXKKKOd;.  lKXXKKKc .o0XXXKO,  .oOKXXX0:   .ckXXXO,   .dXXKKK0d,   .lkKXXXKk'    :0XXXd.      
    ,KMXo;l0WNo. oWM0c;;..oWMKl;::. ,0MXd;,::.  .oNWNOKWx.  .kMWx;dNMO' ,0WNk:,;:;.   'OMKONNl      
    ,KMK,  :XMK, oWMXOkd' ;0WW0xc. .dWWx.       :XMMk,oWNl  .kMWOlkWNd. oWMk..clll;  .oWNl,OMK,     
    ,KMK,  cNM0' oWMKdol.  .:dONWK:.xMWd.      .OMMWOlkNM0, .kMMXXWWx.  dWMk.'d0WMk. ;XMNxl0MWx.    
    ,KMXo:oKWXl  oWMO:;;..;c;,c0MWo.:KMXd;,;:..oNMWNK00XWWx..kMNo,kWXl. ,0MNx:;dNMk..kMWX00KNMNc    
    'OXXXKKOo,   lXXXKKKc.lKXXXX0l.  ,d0XXXXO,,OX0kc...,OX0;.dXK: .dKKo. 'o0XXXXXKo.cKXk,...cKXk.   
     ......      ........  ..'..       ..'...  ....     .... ...    ...     ..'...  ....     ...    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                        .......      ........                                       
                                       'ONXXKK0x:.   lXNXXXKl                                       
                                       ,KMXo;l0WWd'. oWM0c;;.                                       
                                       ,KMK,  :XMKx, oWMNOOx,                                       
                                       ,KMK,  cNM0o' oWMKolc.                                       
                                       ,KMNdcdKWXc.  oWM0l::.                                       
                                       'kKKKK0kl'    cKKKKKKl                                       
                                        ......        ......                                        
                                                                                                    
                                                                                                    
          ...;:'  .....                                                                             
          :xkkxxooxkkdlc;. ..                                                                       
          ;kkodO0O00OOdoOd;:c.                                                                      
        .';clokOO000K0xxOx;..                                                                       
      .;oxddkO00000000000Od:'..                                                                     
  .,;;:dkkkOO00000000000O00OOkdolc:,'',;;,.                                                         
  ,dkOOOOOkOO000000000000000000Oxddxxxk0KKl.                                                        
  .;okkOOOOO0O00000000000000OOdodxkocoO000c.                                                        
 .:xkOOOO00000OOO0000000000OdlokOl'.lxookd.                                                         
 ;xkkOO0O0000OOkxkO000OO0Oxllk0o..,lc';xd'                                                          
 :kkkkO00O00OOOkocokOOOOkocx0k;..cl,.lkl.                                                           
 .:dxOOOOOO00OkOx,.;okOxcck0o..:dc',cc;'',,,'.   ....    ...    ..',,'.    .........  ..........    
 .lxdoxkkkOOOOkdc.  .cdccO0l';xxc:l:,:do:,lkko. .okkx;...lxc. 'cdl;;okkc. 'okxc;lxxo. 'cokkkdlc;.   
 .''. .;;;::cc,. .   .':kKkoxKKxol,'lOx;  .:c,..cOOOk:..:kd' ,xOo' .lOOc..lOkc. ,xOo.  .:kOd'       
        .;;,;;.        ,kKKKKOd:.  ,xOkl'.     ;kOOOk:.,xx, 'dOx, .;xOo..:kOd,.'ldl.   'dOx;        
        .c:,,;'         '::;,.     .;okOkd:.  'dkdodkdcdk:..oOk:. 'dOx, ,xOxl:lo:.    .lOkc.        
             .;.                     .'lkOk: .okl..;kOOOl..ckOl. .oOk:..dOk:..ckx;   .:kOo.         
             ..                 .;oc...,xOd'.cko. .;kOOd' ;xOd' .ckkc..lOOc. 'dOd.   ,xOd,          
                                'dOx;.,oko,.;xx,  .;kOx; .cOOo'.cxd:. :kOo. .lOx,   .oOk:           
                                .':c:;;;'.  ';'    .;;'.  .;::;;;'.   ';;.  .,;'.   .;;,.           
"

#ACTUALIZACIÓN
apt-get update &&

#INSTALACIÓN DE LAS APLICACIONES QUE USARÉ
read -p "apt-get install wget ethtool make nano curl iputils-ping net-tools -y" pause
apt-get install wget ethtool make nano curl iputils-ping net-tools -y &&

#INSTALACION DE LAS LIBRERÍAS
read -p "apt-get install bison flex libpcre++-dev libdumbnet-dev zlib1g-dev libssl-dev libpcap-dev libnghttp2-dev libluajit-5.1-dev -y" pause
apt-get install bison flex libpcre++-dev libdumbnet-dev zlib1g-dev libssl-dev libpcap-dev libnghttp2-dev libluajit-5.1-dev -y &&

#CREACIÓN Y ACCESO A LA CARPETA
read -p "mkdir snort && cd snort" pause
mkdir /snort && cd /snort &&

#INSTALACION DE LOS ARCHIVOS COMPRIMIDOS EN LA CARPETA SNORT
read -p "wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz https://www.snort.org/downloads/snort/snort-2.9.17.1.tar.gz" pause
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz https://www.snort.org/downloads/snort/snort-2.9.17.1.tar.gz &&

#DESCOMPRESION DE LOS ARCHIVOS DE SNORT
read -p "tar -zxvf daq-2.0.7.tar.gz && tar -zxvf snort-2.9.17.1.tar.gz" pause
tar -zxvf daq-2.0.7.tar.gz && tar -zxvf snort-2.9.17.1.tar.gz &&

#ELIMINACION DE LOS ARCHIVOS COMPRIMIDOS
read -p "rm daq-2.0.7.tar.gz snort-2.9.17.1.tar.gz" pause
rm daq-2.0.7.tar.gz snort-2.9.17.1.tar.gz &&

echo "
                                                                                                    
oo' .ldd:. .:o,  ,odxdc',odddddl.  .lddc.   ,ol.       .lddl.    .:odxd:..lo,  .;ldxdo;.  ,odo,  .co
WNl ;XWWNo..kWo.:XWOlll''lxXMKdc. .dWXXNo   oWK,      .dWXXNo.  ;KNOolo:.,KWd .xNXdldXWk. lWWWK: ,KW
WNl ;XXkKNo,kWo.,0NKxc'   '0Mx.   :XXclNK;  dWK,      :XNllXX; .kM0'     ,KWo.cNWo   lNNl.lWKkXXc:KW
WNl ;XK:;KNOKWo  .;o0WX:  '0Mx.  .OMNkkNMk. dWK,     .OMNkkNMk..kM0'     ,KWo.cNWd.  oWNc.lWO,lXXOXW
WNl ;XK; ;0WMWo.:xooONX:  '0Mx. .oWNkookNNl.oWNkoooc'oWNkookNWo.:KN0ood: ,KWd .dNXkoxXNx. lWO. cXWMW
ll' .cc.  'lol, 'lodoc'   .:o;  .:o:.  .:o:.,loooooc,:o:.  .:o:. .:oool, .cl,   ,codol,.  'l:.  ;lol
                                                                                                    
"
#CONFIGURACION DEL DAQ, COMPRESIÓN E INSTALAR LA COMPRESIÓN
read -p "cd /snort/daq-2.0.7/ && ./configure && make -j 4 && make install" pause
cd /snort/daq-2.0.7/ && ./configure && make -j 4 && make install &&

#CONFIGURACION DE SNORT
read -p "cd /snort/snort-2.9.17.1/ && ./configure && make -j 4 && make install" pause
cd /snort/snort-2.9.17.1/ && ./configure && make -j 4 && make install &&

#CREACION DEL ENLACE SIMBÓLICO
read -p "ldconfig" pause
ldconfig &&

#MOVEMOS TODOS LOS ARCHIVOS A SUS LUGARES CORRESPONDIENTES
read -p "mv /snort/snort-2.9.17.1/etc/{*.conf*,*.map} /etc/snort/" pause
mv /snort/snort-2.9.17.1/etc/{*.conf*,*.map} /etc/snort/ &&

echo "
                                                                                                    
                                                                                              .     
.oOOc.  'dOk;   ,kOOOl.   .oOOOOkxl.  .dOx'    :OOOOO:    'xOOOOkxo'  ,xOo.     .dOOOOOx' .lxO00Od' 
 cNMK; .dWMO'  .kMXKWXc   'OMWOlOWMO' '0MX:   ,KMXOXWK,   ,KMNxlOWM0' :NM0'     ,KMNkllc..xWW0lldo. 
 .xWWx.,KMX:   oNWd:0M0'  'OMWd,dNMO' '0MX:  .xWNl.cXWk.  ;KMNxlOWNd. :NM0'     ,KMNkll;..dWMKd:'.  
  ,0MXlxWWd.  ;KMXl;kWWd. .OMMNNWWk'  '0MX:  cNMKc.:0MNl  ;KMWKOXWXo. :NM0'     ,KMWK00d. .:xKNWNk' 
   lNWXNM0'  .kMMWNXNWMXc .OMWdlKW0;  '0MX: ,0MMWXXXNMMK, ;KMXc.lXMX: :NM0;...  ,KMXl...  ....cKMWd 
   .kWMMXc   lNMKl;;;xWM0''OMNc ;0WXl.'0MX:.xWM0c,;;:OWWx.;KMWK0XWNx. :NMWX000o.,KMWXKKO,'OX00KNNO, 
    .:cc;.   ,cc,    .:c:..;c:.  .cc:..;c:..;cc.     .:c;..:ccccc;.   .:cccccc, .;ccccc:. 'clllc,.  
                                                                                                    
                                                                                                   
"
#CREACIÓN Y ACCESO A LA CARPETA
read -p "mkdir /etc/snort/rules /etc/snort/log /usr/local/lib/snort_dynamicrules" pause
mkdir /etc/snort/rules /etc/snort/log /usr/local/lib/snort_dynamicrules &&

#INTERCAMBNIMOS LAS VARIABLES
read -p "
sed -i 's/var RULE\_PATH ..\/rules/var RULE\_PATH rules/g' /etc/snort/snort.conf &&
sed -i 's/var SO\_RULE\_PATH ..\/rules/var SO\_RULE\_PATH rules/g' /etc/snort/snort.conf &&
sed -i 's/var PREPROC\_RULE\_PATH ..\/rules/var PREPROC\_RULE\_PATH rules/g' /etc/snort/snort.conf &&
sed -i 's/var WHITE\_LIST\_PATH ..\/rules/#var WHITE\_LIST\_PATH \/etc\/snort\/rules/g' /etc/snort/snort.conf &&
sed -i 's/var BLACK\_LIST\_PATH ..\/rules/#var BLACK\_LIST\_PATH \/etc\/snort\/rules/g' /etc/snort/snort.conf &&
" pause

sed -i 's/var RULE\_PATH ..\/rules/var RULE\_PATH rules/g' /etc/snort/snort.conf &&
sed -i 's/var SO\_RULE\_PATH ..\/rules/var SO\_RULE\_PATH rules/g' /etc/snort/snort.conf &&
sed -i 's/var PREPROC\_RULE\_PATH ..\/rules/var PREPROC\_RULE\_PATH rules/g' /etc/snort/snort.conf &&
sed -i 's/var WHITE\_LIST\_PATH ..\/rules/var WHITE\_LIST\_PATH \/etc\/snort\/rules/g' /etc/snort/snort.conf &&
sed -i 's/var BLACK\_LIST\_PATH ..\/rules/var BLACK\_LIST\_PATH \/etc\/snort\/rules/g' /etc/snort/snort.conf &&

read -p "
sed -i '544i\ ' /etc/snort/snort.conf &&
sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/g' /etc/snort/snort.conf &&
sed -i '545i\#=========INCLUIMOS NUESTRAS PROPIAS REGLAS================#' /etc/snort/snort.conf &&
sed -i '546i\include \$RULE\_PATH\/owner.rules' /etc/snort/snort.conf &&
sed -i '547i\#=========COMENTAMOS LAS REGLAS QUE NO INCLUIMOS===========#' /etc/snort/snort.conf
" pause

sed -i '544i\ ' /etc/snort/snort.conf &&
sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/g' /etc/snort/snort.conf
sed -i '545i\#=========INCLUIMOS NUESTRAS PROPIAS REGLAS================#' /etc/snort/snort.conf &&
#sed -i '546i\include \$RULE\_PATH\/decodificador.rules' /etc/snort/snort.conf &&
#sed -i '547i\include \$RULE\_PATH\/preprocesador_frag3.rules' /etc/snort/snort.conf &&
#sed -i '548i\include \$RULE\_PATH\/preprocesador_stream5.rules' /etc/snort/snort.conf &&
#sed -i '549i\include \$RULE\_PATH\/preprocesador_http_inspect.rules' /etc/snort/snort.conf &&
#sed -i '550i\include \$RULE\_PATH\/preprocesador_reputation.rules' /etc/snort/snort.conf &&
sed -i '546i\include \$RULE\_PATH\/owner.rules' /etc/snort/snort.conf &&
sed -i '547i\#=========COMENTAMOS LAS REGLAS QUE NO INCLUIMOS===========#' /etc/snort/snort.conf &&


read -p "
chmod +rwx /etc/snort/threshold.conf
sed -i 's/# event_filter gen_id 1, sig_id 0, type limit, track by_src, count 1, seconds 60/event_filter gen_id 1, sig_id 0, type limit, track by_src, count 1, seconds 30/g' /etc/snort/threshold.conf
" pause

chmod +rwx /etc/snort/threshold.conf &&
sed -i 's/# event_filter gen_id 1, sig_id 0, type limit, track by_src, count 1, seconds 60/event_filter gen_id 1, sig_id 0, type limit, track by_src, count 1, seconds 30/g' /etc/snort/threshold.conf &&

read -p "
touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules /etc/snort/rules/owner.rules &&
ls -l /etc/snort/rules
" pause

touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules /etc/snort/rules/owner.rules &&
ls -l /etc/snort/rules &&

#COMPROBACION QUE TODA LA INSTALCION SE HA HECHO CORRECTAMENTE (TEST)
read -p "snort -T -c /etc/snort/snort.conf" pause
snort -T -c /etc/snort/snort.conf &&
read pause &&

#COMPROBACIÓN DEL USO DE DAQ
echo "
                                                                                                    
            .;;;;;;;;;,'..                .;:::::::;.               .';:cccc:;'.                    
           .kWWWWWWWWWWNX0kl,.           'OWWWMMWWMWk.           .ckKNWMMMMMMWNKkc.                 
           .kMMMMMMMMMMMMMMMNO;         .dWMMMWWMMMMNl         .cKWMMMMMMWWMMMMMMWKc.               
           .kMMMMM0l:clxXMMMMMXl        :XMMMWkkWMMMMK;       .oNMMMMWKo:;;:dKWMMMMNo.              
           .kMMMMMx.    ,OWMMMMX;      .OMMMMK;;KMMMMWk.      :XMMMMWO'      'OMMMMMX;              
           .kMMMMMx.     ;XMMMMWd.    .oWMMMWd..dWMMMMNl     .xWMMMMX:        :XMMMMWd              
           .kMMMMMx.     '0MMMMMk.    :XMMMMK,  ,KMMMMMK,    .kMMMMM0'        ,KMMMMMx.             
           .kMMMMMx.     ,KMMMMMx.   .kMMMMMk,..,kWMMMMWx.   .kMMMMMK,        ;KMMMMMx.             
           .kMMMMMx.    .oWMMMMNc    oWMMMMMWXXXXWMMMMMMNl    oWMMMMNl        lWMMMMWl              
           .kMMMMMx.  .,dNMMMMWx.   ;KMMMMMMMMMMMMMMMMMMM0,   ,0MMMMMKl.    .lXMMMMM0'              
           .kMMMMMXOkOKNMMMMMNd.   .kWMMMMXxdddddddxXMMMMWx.   ;0MMMMMWKkxxkKWMMMMM0;               
           .kMMMMMMMMMMMMMWKd,     lNMMMMWo         oWMMMMNc    .oKWMMMMMMMMMMMMWXd'                
           .o000000000Okdl;.      .d00000x.         .x00000d.     .:ok0KXNWMMMMMXc                  
               .....                ... .             .....            ..'cKMMMMWKl.                
                                                                           .xNMMMMWO:.              
                                                                             ;xOOOOOx;              
                                                                                                    
                                                                                                    
                               ;cccc;.      ,lc'    'ccccccc.   ,lc'                                
                              .OWklok0x.   ,0XXO'   'coKW0oc.  ;0XXO'                               
                              .OX:  .xWd. .kK:cXd.    .xWo    .kK:lXd.                              
                              .OX:   oWk. oNKloKXc.   .xWo    oNKloKXc                              
                              .ONo.'lKK: ;KXxooxX0d,  .dWo   :XKxooxX0,                             
                              .oOkxxdl. .lO:    cOOc   cO:  .lk:    cOc                             
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
    ...       ..'..     .''..     ..    ..   ..     .''.   ..  ........  ..     .''..    ....    .. 
   ,OX0c    .oOkxxx, .:kOxxkOd'  cKo.  .kO, 'Ok' ,okOxxx: .x0,.lxOKKkxc.;0x. .ckOxxkOo.  cKXk'  'kx.
  .kKoO0,  .OXo.  .  cN0;  .lNO' lWx.  '0X; ,K0, oNNO,..  .OX:   :XK;   cNk. oNO,  .dNk. lNKK0; ,0O.
  oNx'lXk. ;X0'     .xWd    '0X: lWx.  '0X; ,K0' .;lO0kl. .OX:   ,K0'   cNk..kWl    ,KK, oNo;OK:;0O.
 :KNOxkXNo.'0Xc      lNO'   cX0, cNk.  ;KK, ,K0,    .'dNO..OX:   ,K0'   cNk. dNk.  .lNO. oNl 'kKOXO.
.kXl...;0K; ;O0kddo' .l0OxdkKO;  .d0OddO0c. ,00'.ckxddk0o..OK;   ,K0'   :Xk. .o0Oddk0k,  lXc  .xNWk.
.,'     .,.  .';;;'.   .';l0Xd.    .,;;'.    ''  .',;;,.   .'.    ''    .,.    .,;;,.    .,.   .',. 
                           .:c'                                                                     
                                                                                                    
"
read -p "ls -lht /usr/local/lib/daq" pause
ls  -lht /usr/local/lib/daq &&
read -p "ethtool -k eth0"
ethtool -k eth0 &&
read pause

#EXPLICACIÓN DECODIFICADOR
echo "
                                        ...             .....                                       
 ,k0OOOOOkxo:.     .x0OOOOOOOk,    .;ok0KKK0kd,     .:dk0KKK0Odc.     cOOOOOOOkxo;.     ;kOOOOOOOOd.
 cNMMMNXNWMMWXd.   ,KMMMWXXXX0;   :0WMMWXKXNWK;   .c0WMMWXKXWMMWKl.   dWMMWNXNWMMWKl.   cNMMMNXXXXk'
 cNMMNo..,dXMMWO'  ,KMMWx'....   cXMMWO;...';'   c0XMMWO:...;OWMMNl   dWMMXc.';kNMMWd.  cNMMNo..... 
 cNMMNc    oWMMNl  ,KMMM0dooo;. .OMMM0'         .OMMMMK;     ,KMMMO.  dWMMK,   .kMMMX;  cNMMWOoool, 
 cNMMNc    :NMMWo  ,KMMMMMMMMO. ,KMMMx.         '0MMMMO.     .OMMMK,  dWMMK,    oWMMN:  cNMMMMMMMWd.
 cNMMNc    oWMMNc  ,KMMMOc:::,  '0MMMO.         .OMMMMK,     '0MMM0'  dWMMK,   .kMMMK,  cNMMWkc:::' 
 cNMMNo..,oXMMWk.  ,KMMWx.....  .dWMMNx'.  ..'.  lKNMMWO;. .,kWMMNo   dWMMK:..;xNMMNo.  cNMMNl..... 
 cNMMMNKXNWMWXo.   ,KMMMNKKKKO,  .dNMMWN0O0KX0'  .'lXMMMNK0KNMMMXo.   dWMMWXKXWMMWKc.   cNMMWNKKKKx.
 ;0KKKKKK0kdc.     'kKKKKKKKKO;    ,okKXNNXK0o.     .lk0XXNXX0kl'     lKKKKKKK0ko:.     ;0KKKKKKKKx.
  ........          ..........        ......           .......         .......           .......... 
                                                                                                    
                                                                                                    
"
read -p "snort -A console -d -q -e -v -y -n 1 -i eth0" pause
snort -A console -dqevyn 1 -i eth0 &&
read pause &&

#EXPLICACIÓN DE PREPROCESADOR
echo "
                                   .......    .......     ........                                  
                                  .kNNXXK0o. ,0NXKKKKOo.  oXNXKKKc                                  
                                  '0MNo:OWWd.;XMKc':OMWo .dMMO:;;.                                  
                                  '0MNxo0MWl ;XMXxldKW0; .dWMXOOx'                                  
                                  '0MWXK0x:. ;XMNK0NMX:  .dMM0olc.                                  
                                  '0MXc..    ;XM0;.:KW0; .dWWOc:;.                                  
                                  .xKO,      ,OKx.  ,kKO;.lKKKKK0c                                  
                                   ...        ...     ...  ......                                   
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
.......    .......       ..''..        .'''..  ........    .'''..    .'''..     .'''..     .......  
xNNXXX0d' 'ONXKKK0d'   ;kKXXXXKx;   .ckKXXXXd..dXNXXXX0: ,xKXXXXk' ;kKXXXXx. .:kKXXXXKd,  .kNXKKK0d'
OMWx:kWMk.'0MXl;kWMx. lNMKl,,oXMXc .dWWO:',:' .kMWNk:;;..xMWOc,;, .OMWk:,:' .oNM0c',dNMK; '0MNo;kWMk
OMWklOWWx.'0MNko0WKc .kMWo   .dWMk.;XMK,      .xMMWXOOd. :KWWKxc. .lXWN0x:. '0MNc   .kMWd.'0MNko0WXc
OMMNK0kl. '0MWKXMNl  .kMWd   .xMMx.;XMK;      .kMWW0ol:.  .:oONWK;  .:d0WW0''0MNl   .kMWd '0MWKXMNl 
OMNo..    '0MX:;0WKc  :XMXd::dXMK: .xWWOc;;c, .xMWNkc:;..:l:;lKMNc.cc:;oXMX; lNMKo::xNW0, '0MX:;OWKc
dK0:      .xKO' 'xK0c  ,dOKXXKOd'   .ckKXXK0l..oKKKKKK0;.oKKXXKk:..dKKXX0x;   ;x0KXXKOo.  .xKO, 'xK0
...        ...    ...     ....         .....    .......   .....     .....       .....      ...    ..
                                                                                                    
                                                                                                    
"
read -p "cat /etc/snort/snort.conf | grep reputation && cat /etc/snort/snort.conf | grep http_inspect && cat /etc/snort/snort.conf | grep frag3 && cat /etc/snort/snort.conf | grep stream5" pause
cat /etc/snort/snort.conf | grep reputation && cat /etc/snort/snort.conf | grep http_inspect && cat /etc/snort/snort.conf | grep frag3 && cat /etc/snort/snort.conf | grep stream5 &&
read pause

#EXPLICACIÓN DE MOTOR DE DETECCIÓN
echo "
                                                                                                    
   ......      .......  .........  .......     ......  .........  ...      .....      ....     ..   
  ;0XXKKKOo'  .dXXKKKO;;OKXXXXKKd.;0XKKKKd. .:kKXXXXKo'oKKXXXXK0:.oXKc  .ckKXXXKOo.  'OXXKo.  cK0;  
  cNMKl:dXMXc .kMWk::;..,:xWMKl;' :NMKl::' .xWWO:,,;c' .;l0MWk:;..kMWl .dWW0c;:kNWO' ;KMWWNd. lWNc  
  cNMO.  oWMk..kMWKkko.   cNMO.   :NMNOkx; :XM0,         .kMWl   .kMWl ,KMX:   '0MWl ;KWOxNWx.lWNc  
  cNMk.  oWMk..kMW0oo:.   cNMO.   :NMXxol, :NM0'         .kMWl   .xMWl ,KMX:   '0MNl ;KMd'oNWkkWNc  
  cNMKl:dXWK; .kMWx:;,.   cNMO.   :NMKl;;' .kWWk:,,;:,   .kMWl   .kMWl .dWW0c;:kNWO' ;KMd..lNWWMNc  
  ;0XXXK0kl.  .dXXXKX0;   ;0Xx.   ;0XXXXKd. .lOXXXXXKl   .dXK:   .dXKc  .ckKXXXXOo.  ,OXo.  lKXX0:  
   ......      .......     ...     .......     ..'...     ...     ...      ..'..      ...    ....   
                                                                                                    
                                                                                                    
"
read -p "cat /etc/snort/snort.conf | grep -i inclu | tail +4 | head -14" pause
cat /etc/snort/snort.conf | grep -i inclu | tail +4 | head -14 &&
cat /etc/snort/rules/owner.rules &&
read pause

#CREAMOS LOS FICHEROS DE NUESTRAS REGLAS
echo "alert icmp any any -> any any (msg:\"Estan haciendo un ping\";sid:1000001; gid:1000001; content:\"|10 11 12 13|\"; priority:1; rev:1000001;)" > /etc/snort/rules/owner.rules &&
echo "alert tcp any any -> any any (msg:\"Estan haciendo un peticion TCP\";sid:1000002; gid:1000002; priority:2; rev:1000002;)" > /etc/snort/rules/owner.rules &&

#EXPLICACIÓN DE OUTPUT
echo "
                                                                                                    
                  ......     ...    ...  ..........  ......     ...    ...  .........               
                ,d0XXXX0x;  .dX0:  .oXKc.oKKXXXXK0O:.oXXXKK0d' .xXO,  .dX0;.dKKXXXXKO;              
               :XMXd;;oXMXc .kMNc  .xMWo..;c0MWk:;,..xMWkcxWMO.'0MX;  .kMNc.';lKMNx:,.              
              .xMWx.   oWMk..kMNc  .xMWo   .xMWl    .xMWkckWMk.'0MX:  .kMNc   .OMN:                 
              .xMWx.   oWMO..kMNl  .xMWo   .xMWl    .xMMNXKOo. '0MX:  .OMNc   .OMN:                 
               :XMXd;;oXMNc  oWM0c;lKMX;   .xMWl    .xMWd..    .xWWO:;dXM0,   .OMN:                 
                ,d0XXXX0x;   .cOXXXXKx;    .oXKc    .oXKc       .lOXXXX0x,    .xX0;                 
                  ......        ..'..       ...      ...           .....       ...                  
                                                                                                    
                                                                                                   
"
echo "
alert icmp any any -> any any (msg:\"Estan haciendo un ping\";sid:1000001; gid:1000001; content:\"|10 11 12 13|\"; priority:1; rev:1000001;) > /etc/snort/rules/owner.rules
"
echo "
snort -A console -d -e -v -y -K pcap --daq-dir /usr/local/lib/daq -c /etc/snort/snort.conf -l /etc/snort/log -x -q -i eth0 -n 1
"
snort -A console -d -e -v -y -K pcap --daq-dir /usr/local/lib/daq -c /etc/snort/snort.conf -l /etc/snort/log -x -q -i eth0 -n 1 &&
read pause
echo "
alert tcp any any -> any any (msg:\"Estan haciendo un peticion TCP\";sid:1000002; gid:1000002; content:\"juegos\"; http_uri; nocase; priority:2; rev:1000002;) >> /etc/snort/rules/owner.rules
"
echo "
snort -A console -d -e -v -y -K pcap --daq-dir /usr/local/lib/daq -c /etc/snort/snort.conf -l /etc/snort/log -x -q -i eth0 -n 1
"
snort -A console -d -e -v -y -K pcap --daq-dir /usr/local/lib/daq -c /etc/snort/snort.conf -l /etc/snort/log -x -q -i eth0 -n 1
#*1read pause
snort -A console -d -e -v -y -K pcap --daq-dir /usr/local/lib/daq -c /etc/snort/snort.conf -l /etc/snort/log -x -q -i eth0 -n 1
sed -i 's/alert tcp any any -> any any (msg:"Estan haciendo un peticion TCP";sid:1000002; gid:1000002; priority:2; rev:1000002;)/#alert tcp any any -> any any (msg:"Estan haciendo un peticion TCP";sid:1000002; gid:1000002; priority:2; rev:1000002;)/g' /etc/snort/rules/owner.rules &&
#*1read pause
snort -A console -y -K pcap --daq-dir /usr/local/lib/daq -c /etc/snort/snort.conf -l /etc/snort/log -x -q -i eth0 -n 1
#*1read pause
cd /etc/snort/log && ls -l
echo "
cd /etc/snort/log && ls -l
"
echo Created By: Jose Maria Hormigo Maqueda 2º ASIR.