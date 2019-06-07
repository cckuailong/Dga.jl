# Dga.jl
[![Build Status](https://travis-ci.com/cckuailong/Dga.jl.svg?branch=master)](https://travis-ci.com/cckuailong/Dga.jl)
## What is Dga.jl?
Domain generate Algrithom is commonlly used in malware software.
Dga.jl can make you generate one or many DGAs in your own.

The included DGAs are [Banjori,Corebot,Cryptolocker,Dircrypt,Kraken,Lockyv2,Pykspa,Qakbot
Ramdo,Ramnit,Simda]
## Install & Import
```
import Pkg
Pkg.clone("https://github.com/cckuailong/Dga.jl.git")
```
## How to use it?
eg. Banjori
```
Dga.Banjori.gen_one()
Dga.Banjori.gen_many()
```
Or there are may params you can add in the func to customize you own Dga.
