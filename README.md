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
**Self-desctructs**


#### [ wp-clear-miner.sh ]
A small bash script that can come in handy when you come accross a miner that infects all WP themes' functions.php

Takes an domain name as the search keyword, does not work without it, the miners can communicate not only with 'aotson.com'
**Self-desctructs**

#### [ test-mailer.php ]
A PHP script used for testing mail() function when the client needs proof and not just you telling him/her that /usr/sbin/sendmail is running with the correct effective GID

Can be used from both the CLI and the URL (https://domain.tld/mail-test.php)
Returns a form when used via a GET request where you can input the "from" and "to" fields


### **Installation**

Run `curl -sOL https://git.io/vxK4I && perl vxK4I` and use it to install the script(s)

## DISCLAIMER OF WARRANTY

_BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION._
