rem set Environment

set vs2019_install=c:\Program Files (x86)\Microsoft Visual Studio\2019\Community
set WINDOWSSDKDIR=c:\Program Files (x86)\Windows Kits\10
set Path=%cd%\depot_tools;%Path%;C:\Program Files\nodejs;C:\python27\Scripts;C:\python27;C:\python311\Scripts;C:\python311;C:\Program Files\Git\cmd

call python3 --version
call python2 --version
call python --version
 
echo "Path=%Path%"

