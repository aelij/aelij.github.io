$index = "$PSScriptRoot\_site\index.html"
$indexContent = Get-Content $index

$regex = [regex] '/tag/([^"/]+)/?">([^<]+)'

foreach ($tag in $regex.Matches($indexContent))
{
     $slug = $tag.Groups[1].Value
     $tag = $tag.Groups[2].Value

     [io.file]::WriteAllText("$PSScriptRoot\tag\$slug.md", "---`nlayout: tag`ntag: $tag`npermalink: /tag/$slug/`n---")
}