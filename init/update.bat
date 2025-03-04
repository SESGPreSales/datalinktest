"C:\MagicInfoDataLink\flyway\flyway.cmd" -configFiles="C:\MagicInfoDataLink\DataLinkServer\conf\config.properties","C:\MagicInfoDataLink\flyway\conf\placeholder.conf" migrate >> "C:\MagicInfoDataLink\flywaylog.txt" 2>&1
EXIT /B %ERRORLEVEL%
