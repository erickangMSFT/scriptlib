

# list resources

$rgs = az resource list -n "SqlDataTools" | ConvertFrom-Json 

foreach($rg in  $rgs){
    "---"
    $rg.name
    "---"
    $svrs = az sql server list -g $rg.name | ConvertFrom-Json
    foreach($svr in $svrs ){
        $svr.fullyQualifiedDomainName
        "---"
        $dbs = az sql db list -g $rg.name -s $svr.name | ConvertFrom-Json
        foreach($db in $dbs){
            $db
            "---"
        }
    }
}

 