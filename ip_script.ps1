if (!(Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Host "Instalowanie modułu ImportExcel..."
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

$inputFile = "adresy.xlsx"
$outputFile = "wyniki.xlsx"

$sheetName = "IP-Addresses"

if (-Not (Test-Path $inputFile)) {
    Write-Host "Plik wejściowy $inputFile nie istnieje. Upewnij się, że plik jest w katalogu skryptu." -ForegroundColor Red
    exit
}

$ipAddresses = Import-Excel -Path $inputFile -WorksheetName $sheetName | Select-Object -First 5

if ($ipAddresses -eq $null -or $ipAddresses.Count -eq 0) {
    Write-Host "Nie znaleziono żadnych adresów IP w pliku Excel." -ForegroundColor Red
    exit
}

$results = @()

foreach ($ip in $ipAddresses) {
    $address = $ip."Column1"

    $result = Test-Connection -ComputerName $address -Count 1 -ErrorAction SilentlyContinue

    if ($result) {
        $status = "Odpowiedź otrzymana: Czas = $($result.ResponseTime)ms"
    } else {
        $status = "Brak odpowiedzi lub błąd połączenia."
    }

    $results += [PSCustomObject]@{
        Adres = $address
        Wynik = $status
    }
}

$results | Export-Excel -Path $outputFile -WorksheetName "Wyniki" -AutoSize

Write-Host "Wyniki zapisano do pliku $outputFile." -ForegroundColor Green