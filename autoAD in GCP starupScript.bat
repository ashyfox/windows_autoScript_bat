@echo off
for /f "tokens=*" %%a in ('
curl -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/instance/hostname') do set "string=%%a"
for /f "tokens=1 delims=." %%a in ("%string%") do set result=%%a
echo GCE name: %result%
echo computer_name: %computername%
set template_name=BILL-TEST-AD   # template domain 名稱
if %computername%==%template_name% (
    echo y| netdom renamecomputer %computername% /newname:%result% /REBoot  # echo y| 不能有空格，| 後要不要空格都可以。
    echo rename computer_name 
) else (
    netdom join %result% /domain:ADdomain /userd:"ADadmin" /passwordd:"password" /REBoot  # domain: AD domain， used:  AD 管理員，passwordd: AD 管理員密碼
    echo start join domain
)
