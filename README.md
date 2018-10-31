SSL-Check Certificate Checker for nagios

SSL-Check Certificate Checker checks domains for expired SSL certificates.

You can set the ALERTDAYS and CRITICALDAYS configuration to control when the allert is fired.

To check the SSL certificate, please enter your domain name as the command argument.

Usage: ssl-check domain.com
Author: Trey Brister 2014
Conversion to nagios by Author: César Araújo

Original project: https://github.com/webstandardcss/ssl-check

    http://www.shellhacks.com/en/HowTo-Check-SSL-Certificate-Expiration-Date-from-the-Linux-Shell
    http://stackoverflow.com/questions/5155923/sending-a-mail-from-a-linux-shell-script
    http://stackoverflow.com/questions/4946785/how-to-find-the-difference-in-days-between-two-dates
    http://www.thegeekstuff.com/2011/07/bash-for-loop-examples/
