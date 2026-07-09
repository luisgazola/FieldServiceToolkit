function Get-FssTimestamp { Get-Date -Format 'yyyy-MM-dd HH:mm:ss' }
function Get-FssDatePathParts { $d=Get-Date; [pscustomobject]@{Year=$d.ToString('yyyy');Month=$d.ToString('MM');Day=$d.ToString('dd')} }
Export-ModuleMember -Function *
