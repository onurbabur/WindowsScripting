function Test-UDPConnection {
    param (
        [string]$ComputerName,
        [int]$Port
    )

    $UDPClient = New-Object System.Net.Sockets.UdpClient
    try {
        $UDPClient.Connect($ComputerName, $Port)
        "UDP connection to $ComputerName on port $Port succeeded."
    } catch {
        "UDP connection to $ComputerName on port $Port failed. Error: $_"
    } finally {
        $UDPClient.Close()
    }
}

# Kullanım örneği:
#Test-UDPConnection -ComputerName 192.168.1.1 -Port 1234