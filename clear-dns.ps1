echo "clearing DNS IP configuration..."
set-DnsClientServerAddress -InterfaceAlias Wi-Fi -ResetServerAddresses
echo "Done!"
echo "Closing in 3 seconds..."
start-sleep -seconds 3
