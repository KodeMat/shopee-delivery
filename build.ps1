# Shopee Delivery build script for Windows

Write-Host "Compiling Java sources..." -ForegroundColor Cyan
if (!(Test-Path "WebContent/WEB-INF/classes")) {
    New-Item -ItemType Directory -Force -Path "WebContent/WEB-INF/classes" | Out-Null
}

javac -source 1.8 -target 1.8 -cp "WebContent/WEB-INF/lib/servlet-api.jar;WebContent/WEB-INF/lib/jsp-api.jar;WebContent/WEB-INF/lib/mysql-connector-j.jar" -d WebContent/WEB-INF/classes src/edu/iacademy/cselec05/pm_rima/*.java

if ($LASTEXITCODE -ne 0) {
    Write-Error "Java compilation failed!"
    exit $LASTEXITCODE
}

Write-Host "Staging application..." -ForegroundColor Cyan
if (Test-Path "out") {
    Remove-Item -Recurse -Force "out" | Out-Null
}
New-Item -ItemType Directory -Force -Path "out/staging" | Out-Null

Copy-Item -Recurse -Force "WebContent/*" "out/staging/"

# Remove tomcat provided jars from staging
Remove-Item -Force "out/staging/WEB-INF/lib/servlet-api.jar" -ErrorAction SilentlyContinue
Remove-Item -Force "out/staging/WEB-INF/lib/jsp-api.jar" -ErrorAction SilentlyContinue

Write-Host "Packaging WAR file..." -ForegroundColor Cyan
Set-Location "out/staging"
jar cf ../../shopee-delivery.war *
Set-Location "../.."

Write-Host "Build completed successfully! shopee-delivery.war updated." -ForegroundColor Green
