# staging-ocamlrun 4.14.0

The ocamlrun component is a standalone distribution of OCaml containing
just `ocamlrun` and the OCaml Stdlib.

These are components that can be used with [dkml-install-api](https://diskuv.github.io/dkml-install-api/index.html)
to generate installers.

## dkml-component-staging-ocamlrun

### Usage

FIRST, add a dependency to your .opam file:

```ocaml
depends: [
  "dkml-component-staging-ocamlrun"   {>= "4.14.0~" & < "4.14.1~"}
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

To run the ocamlrun installer, do:

```bash
# 1. EITHER: download some version of the already-built ocamlrun component
URL=https://github.com/diskuv/dkml-component-ocamlrun/releases/download/4.14.0-v1.1.0-prerel1/dkml-component-staging-ocamlrun.tar.gz
install -d dist
if command -v wget; then
  wget -O dist/dkml-component-staging-ocamlrun.tar.gz "$URL"
else
  curl -L -o dist/dkml-component-staging-ocamlrun.tar.gz "$URL"
fi
(cd dist && tar xfz dkml-component-staging-ocamlrun.tar.gz)
STAGING_FILES=$PWD/dist/staging-files

# 1. OR: build the full ocamlrun component (all working files must be in a 'git commit')
opam install .
STAGING_FILES=$(opam var dkml-component-staging-ocamlrun:share)/staging-files

# 2. Build
dune build

# 3. Run
ABI=darwin_x86_64 # select the correct ABI; see the choices in $STAGING_FILES
ocamlrun _build/install/default/share/dkml-component-offline-ocamlrun/staging-files/generic/install.bc \
  --source-dir "$STAGING_FILES/$ABI" \
  --target-dir dist/installed

# Look in dist/installed to see what was installed
dist/installed/bin/ocamlc -config
```

## Status

| Status                                                                                                                                                                                      |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [![Asset tests](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/dkml.yml/badge.svg)](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/dkml.yml)      |
| [![Syntax check](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/syntax.yml/badge.svg)](https://github.com/diskuv/dkml-component-ocamlrun/actions/workflows/syntax.yml) |
