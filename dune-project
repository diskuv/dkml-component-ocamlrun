(lang dune 3.6)

(name dkml-component-staging-ocamlrun)
(version 4.14.0~v2.0.3)

(generate_opam_files true)

(source
 (github diskuv/dkml-component-ocamlrun))
(license Apache-2.0)
(authors "Diskuv, Inc. <opensource+diskuv-ocaml@support.diskuv.com>")
(maintainers "opensource+diskuv-ocaml@support.diskuv.com")

(package
 (name dkml-component-staging-ocamlrun)
 (synopsis "DKML staging component for ocamlrun")
 (description
  "Standalone bytecode distribution of OCaml in <share>/staging-files containing just ocamlrun, the OCaml Stdlib and the other OCaml libraries (str, unix, bigarray, etc.)")
 (depends
  (dkml-install (>= 0.2.0))
  (dkml-runtime-common (>= 1.0.2~prerel9))
  dkml-compiler-src
  (diskuvbox (>= 0.1.0))))

(package
 (name dkml-component-offline-ocamlrun)
 (synopsis "DKML staging component for ocamlrun")
 (description
  "Standalone bytecode distribution of OCaml in <share>/staging-files containing just ocamlrun, the OCaml Stdlib and the other OCaml libraries (str, unix, bigarray, etc.)")
 (depends
  (dkml-install (>= 0.2.0))
  (dkml-component-staging-ocamlrun (= :version))
  (diskuvbox (>= 0.1.0))))
