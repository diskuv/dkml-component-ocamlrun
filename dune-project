(lang dune 2.9)

(name dkml-component-staging-ocamlrun)
(version 4.12.1~v1.0.2)

(generate_opam_files true)

(source
 (github diskuv/dkml-component-ocamlrun))
(license Apache-2.0)
(authors "Diskuv, Inc. <opensource+diskuv-ocaml@support.diskuv.com>")
(maintainers "opensource+diskuv-ocaml@support.diskuv.com")

(package
 (name dkml-component-staging-ocamlrun)
 (synopsis "DKML component for ocamlrun")
 (description
  "Standalone distribution of OCaml in <share>/staging-files containing just ocamlrun, the OCaml Stdlib and the other OCaml libraries (str, unix, bigarray, etc.)")
 (depends
  (dkml-install (>= 0.2.0))))
