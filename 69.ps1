$composite = New-Object "boolean[]" 1000001 # false if prime
$length = $composite.Length
$primeProducts = New-Object "int32[]" $length # contains a prime factor for the number at the given index
$totients = New-Object "int32[]" $length
$highestMultiplicand = New-Object "int32[]" $length # Index i has calculated indices up to the number at highestMultiplicand[i]

# Fills in sieve up to len indexes. Assumes len <= sieve.Length.
function fillSieve($len){ 
    $limit = [Math]::Sqrt($len)
    for($i=2; $i -le $limit; $i++){
        if(!$composite[$i]){
            for($j=2*$i; $j -le $len; $j+=$i){
                $composite[$j] = $true
            }
        }
    }
}

function fillProducts($len){
    for($i=2; $i -le $len; $i++){ #remove?
        $highestMultiplicand[$i] = 1
    }
    $limit = [Math]::Sqrt($len)
    for($i=2; $i -le $limit; $i++){
        if(!$composite[$i]){ #find first prime
            for($j=$i+1; $i*$j -le $len; $j++){
                if(!$composite[$j]){ #find second prime
                    $primeProducts[$i*$j] = $j
                }
            }
        }
    }    
}

# Returns how many numbers less than n are relatively prime to n. Assumes sieve is filled.
function totient([int] $n){
    if(!$composite[$n]){ #if prime, we can cut out euclidean calculations
        return $n-1
    } elseif($primeProducts[$n] -ne 0) {
       return ($primeProducts[$n]-1)*($n/$primeProducts[$n] - 1)
    } else {
        $result = 1 # 1 is relatively prime to all integers
        $skip = New-Object "boolean[]" $n #track which numbers to test
        for($i=2; $i -lt $n; $i++){
            if(!$skip[$i]){
                if((euclideanAlgorithm $n $i) -eq 1) {
                    $result++
                } else {
                    for($j=2*$i; $j -lt $n; $j+=$i){
                        $skip[$j] = $true
                    }
                }
            }
        }
        return $result
    }
}

# Returns GCD of a and b
function euclideanAlgorithm($a, $b){
    if($b -eq 0){ return $a }
    else { return euclideanAlgorithm $b ($a % $b) }
}

# Finds maximum n for n/totient(n) for all n <= limit.
function findMaxTotientRatio($limit){
    $max = 0
    $maxN = 0

    $nextWindow = 150

    fillSieve($limit)
    fillProducts($limit)

    for($i=2; $i -le $limit; $i++){
        if($i -eq $nextWindow){
            regenerateTotients($limit)
            $nextWindow += $nextWindow
        }
        if($totients[$i] -eq 0) {
            $totients[$i] = totient($i) #first totient
            $prod = 2*$i
            for($j=2; $j -le $i -and $prod -le $limit; $j++){
                if($totients[$prod] -eq 0 -and $totients[$j] -ne 0 -and (euclideanAlgorithm $i $j) -eq 1) { #second totient - calculate multiples
                    $totients[$prod] = $totients[$i] * $totients[$j]
                }
                $prod += $i
            }
        }
        if(($temp = $i / $totients[$i]) -gt $max){
            $max = $temp
            $maxN = $i
        }
    }

    return $maxN
}

# Continue generating totients from our last location.
function regenerateTotients($limit){
    for($i=2; $i -lt $limit/3; $i++){ # go to last calculated?
        if($totients[$i] -ne 0) { # first totient
            $j=$highestMultiplicand[$i]+1
            for($prod = $j*$i; $j -le $i -and $prod -le $limit; $j++){ 
                if($totients[$prod] -eq 0 -and 
                   $totients[$j] -ne 0 -and 
                   (euclideanAlgorithm $i $j) -eq 1) { #second totient - calculate multiples
                    $totients[$prod] = $totients[$i] * $totients[$j]
                }
                $prod += $i
            }
            $highestMultiplicand[$i] = $j
        }
    }
}

for($i=1000000; $i -le 1000000; $i*=10){
    Write-Host -noNewLine $i": `n" 
    Measure-Command { $output = findMaxTotientRatio($i) }
    echo $output "`n"
}