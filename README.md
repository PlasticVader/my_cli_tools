## Helpful CLI tools

**The repository contains the following scripts:**

1. dtr
1. hexme
1. pns
1. cp-check.sh
1. wp-clear-miner.sh
1. mail-test.php

### **Brief description**

#### [ dtr ]
A pretty large bash script, run with no arguments supplied -h|--help to see the options
It is rather talkative and produces "human-readable" output
By default, it is used with **"-t"** flag which performs a DNS trace of a domain name(s)
found in the passed arguments, e.g.: **dtr -t http://domain.tld sub.domain.tld**.

#### [ hexme ]
A small Perl5 script used for ASCII to hexadecimal representation encoding/decoding.
It is talkative as well, -h|--help or no CLI arguments will print out the usage

#### [ pns ]
A small bash script to check whether the nameserver(s) is properly configured
Its first argument should be the nameserver prefix, e.g.: **ns1** or a range: **ns1-5**
After that domain(s) are supplied

#### [ cp-check.sh ]
Another small bash script to fix permissions and check inode/disk space usage
Unfortunately, this is an unoptimized copy of it
The optimized one has been lost; however, it still does it's job
Logs everything into a **.txt** file in the home directory

It is useful when installed and run with either **-p** (permissions) or **-u** (usage)
`curl -sOL https://git.io/vx16J && bash vx16J -p`

**Self-desctructs**

#### [ wp-clear-miner.sh ]
A small bash script that can come in handy when you come accross a miner that infects all WP themes' functions.php
Takes an domain name as the search keyword, does not work without it, the miners can communicate not only with 'aotson.com'
Copies the files before changing them and logs everything into a **.txt** file in the home directory

It is useful when installed and run quickly with the command/cron job
`curl -sOL https://git.io/vx1KF && bash vx1KF`

**Self-desctructs**

#### [ test-mailer.php ]
A PHP script used for testing mail() function when the client needs proof and not just you telling him/her that /usr/sbin/sendmail is running with the correct effective GID

Can be used from both the CLI and the URL (https://domain.tld/mail-test.php)
Returns a form when used via a GET request where you can input the "from" and "to" fields

It is useful when installed quickly on a target host by running the command/cron job
`curl -sL https://git.io/vx1KW -o $HOME/public_html/test-mailer.php`
And then opening it in the browser

### **Installation**
To install with the "interactive" installer, run
`curl -sOL https://git.io/vxK4I && perl vxK4I`

## Disclaimer of warranty

**This is a free software and there is no warranty for it to the extent permitted by applicable law.
The user has four essential freedoms when using this software:
1. The freedom to run the program as you wish, for any purpose (freedom
0).
1. The freedom to study how the program works, and change it so it does your computing as you wish (freedom 1). Access to the source
code is a precondition for this.
1. The freedom to redistribute copies so you can help your neighbor (freedom 2).
1. The freedom to distribute copies of your modified versions to others (freedom 3). By doing this you can give the whole community a
chance to benefit from your changes. Access to the source code is a precondition for this.**
