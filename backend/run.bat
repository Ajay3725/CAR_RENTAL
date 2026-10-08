@echo off
if not defined JAVA_HOME (
    if exist "C:\Program Files\Java\jdk-24" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-24"
    )
)
set "PATH=%JAVA_HOME%\bin;%PATH%"
echo ========================================================
echo Starting Spring Boot Backend on http://localhost:8080
echo Using JAVA_HOME: %JAVA_HOME%
echo ========================================================
call mvnw.cmd spring-boot:run

