if (-not $env:JAVA_HOME) {
    if (Test-Path "C:\Program Files\Java\jdk-24") {
        $env:JAVA_HOME = "C:\Program Files\Java\jdk-24"
    }
}
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Starting Spring Boot Backend on http://localhost:8080" -ForegroundColor Green
Write-Host "Using JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Cyan

.\mvnw.cmd spring-boot:run

