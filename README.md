# M4dh4v45b1n

It just binaries written in ruby for linux

## Installation


```bash
gem install 'm4dh4v45b1n'
```


## Usage

```bash
$ m4dh4v45b1n.rb
```

## fuzz-web-dir.rb

__Ability__: _hide or show statuscode, chars, line. add headers. with random user-agent_

```ruby
$ fuzz-web-dir.rb -h

Usage: fuzz-web-dir.rb [-h] [-w DICT] [-t MAXTHREAD] [..] URL
des: Directory fuzzer.

Eg: fuzz-web-dir.rb -e php,txt --hc 303,404  https://example.com

    -w WORDLIST     Use custom wordlist. (default:dict/dirs.txt)
    -e EXT          Add extension.Use comma for multiple value. (default:txt,php,html
    -p PAUSE        Pause the fuzz for N second.
    -t MAXTHREAD    Maximum concurrency. (default:24)
    -T TIMEOUT      Set time out for each try. (default:1s)
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

## enum-subdimain.rb

__Ability__: _Once It get the subdomain via *RANDOM DNS*.It never enumarate again if you don't use '-C' flag.The data logs under ~/.cache/enum-subdomain/._

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

```bash
$ enum-wordpress-user.rb http://test.wordpress.com
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Madhava-mng/m4dh4v45b1n.
