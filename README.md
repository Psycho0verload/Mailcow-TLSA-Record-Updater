# Mailcow-TLSA-Record-Updater

Mailcow-TLSA-Record-Updater is a Bash script designed to automatically generate and update TLSA (Transport Layer Security Authentication) records for your Mailcow mail server. It supports creating TLSA records using SHA-256 and SHA-512 hashes and updates the records if there are any changes in the certificate hashes. The script utilizes DNSControl to push the updates to your DNS provider.

## Features

- Generates TLSA 3 1 1 and TLSA 3 1 2 records
- Checks for changes in certificate hashes and updates the JSON file accordingly
- Executes DNSControl to push changes when updates are detected
- Debug mode for detailed logging

## Prerequisites

- `openssl`: Used to generate certificate hashes
- `jq`: Used to parse and update JSON files
- `docker`: Used to run DNSControl
- `DNSControl`: DNS management tool by StackExchange

## Installation

1. **Clone the Repository**

   ```sh
   git clone https://github.com/yourusername/Mailcow-TLSA-Record-Updater.git
   cd Mailcow-TLSA-Record-Updater
   ```
2.	**Install Required Tools**
    
    Ensure openssl, jq, docker, and DNSControl are installed on your system. Use your package manager to install them if necessary. For example, on Debian-based systems:
    ```sh
    sudo apt install openssl jq
    ```
    For DNSControl, follow the installation instructions from the [DNSControl documentation](https://dnscontrol.org/).

## Configuration

1.	**Edit settings.env**
    
    Create and edit the settings.env file in the project directory with your settings:
    ```sh
    # activate debug
    debug=false
    # Directory in which the script works
    tlsaScriptDir="/path/to/Mailcow-TLSA-Record-Updater"
    # Domain for which the TLSA entries are to be created
    tlsaScriptMailcowDomain="your.mailcow.domain"
    # Path to the main certificate of your domain
    tlsaScriptMailcowCert="/path/to/mailcow/data/assets/ssl/cert.pem"
    ```
2.	**Ensure Permissions**
    
    Ensure the script has executable permissions:
    ```sh
    chmod +x tlsa_check.sh
    ```
## Usage
Run the script manually:
```sh
./tlsa_check.sh
```
Or set up a cron job to run it periodically. For example, to run the script every day at midnight, add the following line to your crontab:
```sh
*/15 * * * * /path/to/Mailcow-TLSA-Record-Updater/tlsa_check.sh > /path/to/Mailcow-TLSA-Record-Updater/tlsa_check.log
```
Alternatively, use `inotifywait` to monitor the certificate file and run the script whenever the certificate changes:
```sh
while inotifywait -e close_write /path/to/mailcow/data/assets/ssl/cert.pem; do
  /path/to/Mailcow-TLSA-Record-Updater/tlsa_check.sh >> /path/to/Mailcow-TLSA-Record-Updater/tlsa_check.log
done
```

## Debugging
To enable debugging, set the debug variable to true in the script or export it as an environment variable before running the script:
- Set the variable `debug` to `true` in **settings.env** to activate debugging

## Contributing
1.	Fork the repository.
2.	Create a new branch (git checkout -b feature-branch).
3.	Make your changes.
4.	Commit your changes (git commit -am 'Add some feature').
5.	Push to the branch (git push origin feature-branch).
6.	Create a new Pull Request.

## License
This project is licensed under the GNU GENERAL PUBLIC LICENSE v3 License. See the [LICENSE](LICENSE) file for details.