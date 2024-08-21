(lang dune 3.6)

(name dkml-component-staging-ocamlrun)
(version 4.14.2~v2.1.2)

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
  dkml-host-abi
  (dkml-install (>= 0.4.0))
  (dkml-runtime-common (>= 2.1.2))
  (dkml-compiler-src (>= 2.1.0))
  (diskuvbox (>= 0.1.0))))

(package
 (name dkml-component-offline-ocamlrun)
 (synopsis "DKML staging component for ocamlrun")
 (description
  "Standalone bytecode distribution of OCaml in <share>/staging-files containing just ocamlrun, the OCaml Stdlib and the other OCaml libraries (str, unix, bigarray, etc.)")
 (depends
  (dkml-install (>= 0.4.0))
  (dkml-component-staging-ocamlrun (= :version))
  (diskuvbox (>= 0.1.0))))
