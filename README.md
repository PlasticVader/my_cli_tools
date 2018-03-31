### Helpful CLI tools

**The repository contains the following scripts:**

1. dtr
1. hexme
1. pns

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

**Installation**

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
