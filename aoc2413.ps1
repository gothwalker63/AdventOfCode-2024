$start = Get-Date

Function FewestToken {
    param (
        [Parameter(Mandatory = $false)][int64]$offset
    )

    $data = gcb
    $tokens = 0
    foreach ($row in $data) {
        if ($row -like 'Button A*') {

            $ax = [int]($row -replace "^Button A: X\+(\d+).*$", '$1')
            $ay = [int]($row -replace "^.*?(\d+)$", '$1')
        }
        elseif ($row -like 'Button B*') {
        
            $bx = [int]($row -replace "^Button B: X\+(\d+).*$", '$1')
            $by = [int]($row -replace "^.*?(\d+)$", '$1')
        }
        elseif ($row -like 'Prize*') {
        
            $px = [int64]($row -replace "^Prize: X=(\d+).*$", '$1')+$offset
            $py = [int64]($row -replace "^.*?(\d+)$", '$1')+$offset
        
            $a = ($px*$by-$py*$bx)/($ax*$by-$ay*$bx)
            $aInt = $a -as [int64]
            $b = ($py*$ax-$px*$ay)/($ax*$by-$ay*$bx)
            $bInt = $b -as [int64]
            if ($a -eq $aInt -and $b -eq $bInt -and $ax*$a+$bx*$b -eq $px -and $ay*$a+$by*$b -eq $py) {
               $tokens += 3*$a+$b
            }
        }
    }

    $tokens
    }

Write-Host "Part 1:"
FewestToken
Write-Host "Elapsed time: $([math]::Round(((Get-Date) - $start).TotalSeconds,3)) seconds"
Write-Host "Part 2:"
FewestToken(10000000000000)
Write-Host "Elapsed time: $([math]::Round(((Get-Date) - $start).TotalSeconds,3)) seconds"