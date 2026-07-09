# PowerShell script to compile and run JUnit tests

$projectDir = "c:\Users\mjhan\Downloads\GADAPUTI_VINOD_Cognizant_DN_5.0-JavaFSE-main\GADAPUTI_VINOD_Cognizant_DN_5.0-JavaFSE-main\Week[1]\Junit_Basic Testing Exercises\JunitProject"
$libDir = Join-Path $projectDir "lib"
$binDir = Join-Path $projectDir "bin"
$srcMainDir = Join-Path $projectDir "src\main\java"
$srcTestDir = Join-Path $projectDir "src\test\java"

# Create lib and bin directories if they don't exist
if (-not (Test-Path $libDir)) {
    New-Item -ItemType Directory -Path $libDir -Force | Out-Null
    Write-Host "Created lib directory" -ForegroundColor Green
}

if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir -Force | Out-Null
    Write-Host "Created bin directory" -ForegroundColor Green
}

# Download JUnit 4.13.2 if not already present
$junitJar = Join-Path $libDir "junit-4.13.2.jar"
$hamcrestJar = Join-Path $libDir "hamcrest-core-1.3.jar"

Write-Host "Downloading JUnit dependencies..." -ForegroundColor Cyan

if (-not (Test-Path $junitJar)) {
    $junitUrl = "https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $junitUrl -OutFile $junitJar -ErrorAction Stop
        Write-Host "Downloaded junit-4.13.2.jar" -ForegroundColor Green
    } catch {
        Write-Host "Failed to download junit-4.13.2.jar: $_" -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path $hamcrestJar)) {
    $hamcrestUrl = "https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $hamcrestUrl -OutFile $hamcrestJar -ErrorAction Stop
        Write-Host "Downloaded hamcrest-core-1.3.jar" -ForegroundColor Green
    } catch {
        Write-Host "Failed to download hamcrest-core-1.3.jar: $_" -ForegroundColor Red
        exit 1
    }
}

# Set classpath
$classpath = "$junitJar;$hamcrestJar;$binDir"

# Compile main classes
Write-Host "Compiling main classes..." -ForegroundColor Cyan
$mainFiles = Get-ChildItem -Path $srcMainDir -Filter "*.java" -Recurse

foreach ($file in $mainFiles) {
    Write-Host "Compiling $($file.Name)..."
    javac -d $binDir -cp $classpath $file.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to compile $($file.Name)" -ForegroundColor Red
        exit 1
    }
}

# Compile test classes
Write-Host "Compiling test classes..." -ForegroundColor Cyan
$testFiles = Get-ChildItem -Path $srcTestDir -Filter "*.java" -Recurse

foreach ($file in $testFiles) {
    Write-Host "Compiling $($file.Name)..."
    javac -d $binDir -cp $classpath $file.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to compile $($file.Name)" -ForegroundColor Red
        exit 1
    }
}

# Run tests
Write-Host "Running JUnit tests..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Yellow

java -cp $classpath org.junit.runner.JUnitCore com.example.CalculatorTest

if ($LASTEXITCODE -eq 0) {
    Write-Host "================================" -ForegroundColor Yellow
    Write-Host "All tests passed!" -ForegroundColor Green
} else {
    Write-Host "================================" -ForegroundColor Yellow
    Write-Host "Some tests failed!" -ForegroundColor Red
}
