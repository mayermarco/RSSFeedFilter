$url = 'https://wid.cert-bund.de/content/public/securityAdvisory/rss'
$savePath = '.\rssfeed.xml'
Invoke-RestMethod -Uri $url -OutFile $savePath
[xml]$Content = Get-Content $savePath -Encoding utf8
$Feed = $Content.rss.channel

$newRSSSavePath = '.\rssfeed_filtered.rss'

$filterlist = "Grafana", "Windows", "Microsoft", "Edge", "Chrome"

$newRSS = [PSCustomObject]@()

$rssContent = @"
<rss version="2.0">
  <channel>
    <title>BSI Warn- und Informationsdienst (WID): Schwachstellen-Informationen (Security Advisories) Gefiltert</title>
    <link>https://wid.cert-bund.de/portal/wid/securityadvisory</link>
    <description>BSI Warn- und Informationsdienst (WID) RSS Feed zur Verteilung Schwachstellen-Informationen (Security Advisories). Wurde durch uns gefiltert</description>
    <pubDate>$($Content.rss.channel.pubDate)</pubDate>
"@

# Filter RSS Feed
ForEach ($msg in $Feed.Item) {
  foreach ($filter in $filterlist) {
    if ($msg.title.Contains($filter)) {
      $item = [PSCustomObject]@{
        'title'       = $msg.title
        'link'        = $msg.link
        'description' = $msg.description
        'category'    = $msg.category
        'pubDate'     = $msg.pubDate
      }

      $newRSS += $item
    }
  }
}

#Filter out duplicates
$newRSS = $newRSS | Sort-object -Property title -Unique

foreach ($msg in $newRSS) {
  $rssContent += @"
      
    <item>
      <title>$($msg.title)</title>
      <link>$($msg.link)</link>
      <description>$($msg.description)</description>
      <category>$($msg.category)</category>
      <pubDate>$($msg.pubDate)</pubDate>
    </item>
"@
}

$rssContent += @"

  </channel>
</rss>
"@

# Save filtered RSS Feed to file rssfeed_filtered.rss
$rssContent | Out-File -FilePath $newRSSSavePath -Force -Encoding utf8