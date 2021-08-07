# M4dh4v45b1n

Custom dir fuzzer, subdomain enum, ...

![](https://img.shields.io/gem/v/m4dh4v45b1n)
![](https://img.shields.io/gem/dt/m4dh4v45b1n)
![](https://img.shields.io/gem/rt/m4dh4v45b1n)
![](https://img.shields.io/gem/dtv/m4dh4v45b1n)
![](https://img.shields.io/github/license/Madhava-mng/m4dh4v45b1n)

## require

- ruby-3.x.x

## Installation

```bash
gem install 'm4dh4v45b1n'
```

## Usage

```bash
$ m4dh4v45b1n.rb
```

## version 0.2.4

* added -E for dissable extension search. in 'fuzz-web-dir.rb'


## fuzz-web-dir.rb

**Ability**: _hide or show statuscode, chars, line.runs with random user-agent.And firewall evation with decoys._

**Todo**: create "~/.proxies.txt" for default decoy proxy list. x.x.x.x:port format.

```ruby
$ fuzz-web-dir.rb -h

Usage: fuzz-web-dir.rb [-h] [-w DICT] [-t MAXTHREAD] [..] URL
des: Directory fuzzer.

Eg: fuzz-web-dir.rb -e php,txt --hc 303,404  https://example.com

    -w WORDLIST     Use custom wordlist. (default:dict/dirs.txt)
    -e EXT          Add extension.Use comma for multiple value. (default:txt,php,html)
    -p PAUSE        Pause the fuzz for N.0 second.
    -d 		    Enable decoy (default:~/.proxies.txt)
    -D DECOY	    Use New decoy file.
    -n 		    Run with out checking proxy status.
    -t MAXTHREAD    Maximum concurrency. (default:24)
    -T TIMEOUT      Set timeout for each try. (default:1s)
    -u URL          Target url.
    -o OUTPUT       Write output to the file.
    -H HEAD         Add header in json format with in apostrophy. eg:'{"key":29}' .
    -s, --hs STATUS Hide status code. Use comma for multiple value. (default:404)
    -c, --hc CHARS  Hide No.Of.Chars. Use comma for multiple value.
    -l, --hl LINES  Hide No.of.Lines. Use comma for multiple value.
    -S, --ss STATUS Show status code. Use comma for multiple value.
    -C, --sc CHARS  Show No.Of.Chars. Use comma for multiple value.
    -L, --sl LINES  Show No.of.Lines. Use comma for multiple value.
    -h, --help      Print this help banner.

```

```ruby
$ fuzz-web-dir.rb -D proxy/list.txt -e txt,db --hs 404,303 -p 1 http://example.com/
```

```ruby
$ fuzz-web-dir.rb -u https://example.com/api/ -t 1 -p 2 -d -H '{"key1":"open"}' -o result.txt --hc 0
```

## enum-subdimain.rb

**Ability**: _Once It get the subdomain via *RANDOM DNS*.It never enumarate again if you don't use '-C' flag.The data logs under ~/.cache/enum-subdomain/._

```ruby
$ enum-subdomain.rb -h

Usage: enum-subdomain.rb [-h] [-v] [-w DICT] [-t MAXTHREAD] [-T TIMEOUT] [-o OUT] DOMAIN
des: enumarate subdomain with randomize dns.

ability: Once It get the subdomain via R(dns).
         It never enumarate again if you don't use '-C' flag.
         The data logs under ~/.cache/enum-subdomain/.

Eg: enum-subdomain.rb -v example.com

    -v             Enable verbose mode.
    -t MAXTHREAD   Maximum concurrency. (default:25)
    -w WORDLIST    Use custom wordlist. (default:dict/subdomain.txt)
    -T TIMEOUT     Set time out for each try. (default:1s)
    -o OUTPUT      Append output to the file.
    -c             Show cached subdomain and exit.
    -C             Ignore cached subdomain and enumarate again.
    -n             Hide cached subdomain and show only new.
    -h, --help     Print this help banner.

```

```ruby
$ enum-subdomain.rb -v test.net
```

```ruby
$ enum-subdomain.rb -c test.net
```

## recon-passive-subdomain.rb

```ruby
$ recon-passive-subdomain.rb

Usage: recon-passive-subdomain.rb [ARG] DOMAIN

des: Passive recon for subdomains. data collected
from sdcd files. with out intract target or dns.
Edit the ~/.s-passive.conf for more customize.
licensed under GNU.You can modify If you
willing to read my code. :) (0.1.9)

		-o, --out [FILE]         Put the domains to file
		-d, --depth [INT]        Incress If you need more result. default is 1.
		-s, --source-depth [INT] Print only from n number of source. default is 1.

		-m, --max-result [INT]   Print only n number of result. default is 500.
		-h, --help               Print this banner and exit
```

```ruby
$ enum-wordpress-user.rb http://test.wordpress.com
```

## Contributing

Bug reports and pull requests https://github.com/Madhava-mng/m4dh4v45b1n
