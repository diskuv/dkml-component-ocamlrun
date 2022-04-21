# staging-ocamlrun 4.12.1

The ocamlrun component is a standalone distribution of OCaml containing
just `ocamlrun` and the OCaml Stdlib.

These are components that can be used with [dkml-install-api](https://diskuv.github.io/dkml-install-api/index.html)
to generate installers.

## dkml-component-staging-ocamlrun

### Usage

FIRST, add a dependency to your .opam file:

```ocaml
depends: [
  "dkml-component-staging-ocamlrun"   {>= "4.12.1"}
  # ...
]
```

SECOND, add the package to your currently selected Opam switch:

```bash
opam install dkml-component-staging-ocamlrun
# Alternatively, if on Windows and you have Diskuv OCaml, then:
#   with-dkml opam install dkml-component-staging-ocamlrun
```

Be prepared to **wait several minutes** while one or more OCaml runtimes are
compiled for your machine.

THIRD, in your `dune` config file for your registration library include
`dkml-component-staging-ocamlrun.api` as a library as follows:

```lisp
(library
 (public_name dkml-component-something-great)
 (name something_great)
 (libraries
  dkml-install.register
  dkml-component-staging-ocamlrun.api
  ; bos is for constructing command line arguments (ex. Cmd.v)
  bos
  ; ...
  ))
```

FOURTH, in your registration component (ex. `something_great.ml`) use
`spawn_ocamlrun` as follows:

```ocaml
open Bos
open Dkml_install_api

let execute ctx =
  (* ... *)
  let bytecode =
    ctx.Dkml_install_api.Context.path_eval "%{_:share-generic}%/something_great.bc"
  in
  Staging_ocamlrun_api.spawn_ocamlrun
    ctx
    Cmd.(v (Fpath.to_string bytecode) % "arg1" % "arg2" % "etc.")
```

## Contributing

See [the Contributors section of dkml-install-api](https://github.com/diskuv/dkml-install-api/blob/main/contributors/README.md).

## Status

| Status                                                                                                                                                                                      |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [![Asset tests](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/asset.yml/badge.svg)](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/asset.yml)    |
| [![Syntax check](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/syntax.yml/badge.svg)](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/syntax.yml) |
