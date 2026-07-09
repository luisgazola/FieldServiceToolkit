function ConvertTo-FssHtmlEncoded { param([string]$Text) return [System.Net.WebUtility]::HtmlEncode($Text) }
Export-ModuleMember -Function *
