open Bos
open Astring

let is_not_defined name env =
  match String.Map.find name env with
  | None -> true
  | Some "" -> true
  | Some _ -> false

let ocamlrun_exe { Dkml_install_api.Context.path_eval; _ } =
  path_eval "%{staging-ocamlrun:share-abi}%/bin/ocamlrun"

let lib_ocaml { Dkml_install_api.Context.path_eval; _ } =
  path_eval "%{staging-ocamlrun:share-abi}%/lib/ocaml"

(** [get_and_remove_path env] finds the first of the ["PATH"] or the ["Path"] environment variable (the latter
    is present sometimes on Windows), and removes the same two environment variables from [env]. *)
let get_and_remove_path env =
  let old_path_as_list =
    match String.Map.find_opt "PATH" env with
    | Some v when v != "" -> [ v ]
    | _ -> (
        match String.Map.find_opt "Path" env with
        | Some v when v != "" -> [ v ]
        | _ -> [])
  in
  let new_env = String.Map.remove "PATH" env in
  let new_env = String.Map.remove "Path" new_env in
  (old_path_as_list, new_env)

let spawn_ocamlrun ctx cmd =
  let lib_ocaml = lib_ocaml ctx in
  let host_abi = ctx.target_abi_v2 in
  let new_cmd = Cmd.(v (Fpath.to_string (ocamlrun_exe ctx)) %% cmd) in
  Logs.info (fun m -> m "Running bytecode with: %a" Cmd.pp new_cmd);
  let ( let* ) = Result.bind in
  let sequence =
    let* new_env = OS.Env.current () in
    let old_path_as_list, new_env = get_and_remove_path new_env in
    (* Definitely enable stacktraces *)
    let new_env =
      if is_not_defined "OCAMLRUNPARAM" new_env then
        String.Map.add "OCAMLRUNPARAM" "b" new_env
      else new_env
    in
    (* Handle dynamic loading *)
    let new_env =
      String.Map.add "OCAMLLIB" (Fpath.to_string lib_ocaml) new_env
    in
    (* Handle the early loading of dllunix by ocamlrun *)
    let stublibs = Fpath.(lib_ocaml / "stublibs") in
    let new_env =
      match host_abi with
      | _ when Dkml_install_api.Context.Abi_v2.is_windows host_abi ->
          (* Add lib/ocaml/stublibs to PATH for Win32
             to locate the dllunix.dll *)
          let path_sep = if Sys.win32 then ";" else ":" in
          let new_path_entries =
            [ Fpath.(to_string stublibs) ] @ old_path_as_list
          in
          let new_path = String.concat ~sep:path_sep new_path_entries in
          String.Map.add "PATH" new_path new_env
      | _ when Dkml_install_api.Context.Abi_v2.is_darwin host_abi ->
          (* Add lib/ocaml/stublibs to DYLD_FALLBACK_LIBRARY_PATH for macOS
             to locate the dllunix.so *)
          String.Map.add "DYLD_FALLBACK_LIBRARY_PATH"
            Fpath.(to_string stublibs)
            new_env
      | _ ->
          (* Add lib/ocaml/stublibs to LD_LIBRARY_PATH for Linux and Android
             and OpenBSD (etc.) to locate the dllunix.so *)
          String.Map.add "LD_LIBRARY_PATH" Fpath.(to_string stublibs) new_env
    in
    OS.Cmd.run_status ~env:new_env new_cmd
  in
  let fl = Dkml_install_api.Forward_progress.stderr_fatallog in
  match sequence with
  | Ok (`Exited 0) ->
      if Logs.level () = Some Logs.Debug then
        Logs.info (fun l ->
            l "The command %a ran successfully" Cmd.pp cmd)
      else
        Logs.info (fun l ->
          l "The command %a ran successfully" Fmt.(option string) (Cmd.line_tool cmd))
| Ok (`Exited c) ->
      (* An exit code from one of the predefined exit codes already has
         the root cause printed. Don't obscure the console by printing
         more errors. *)
      let conforming_exitcode =
        List.map Dkml_install_api.Forward_progress.Exit_code.to_int_exitcode
          Dkml_install_api.Forward_progress.Exit_code.values
        |> List.mem c
      in
      if not conforming_exitcode then
        fl ~id:"98b534b7"
          (Fmt.str "The command %a exited with status %d" Cmd.pp cmd c);
      exit
        (Dkml_install_api.Forward_progress.Exit_code.to_int_exitcode
           Exit_transient_failure)
  | Ok (`Signaled c) ->
      fl ~id:"dc5eac2d"
        (Fmt.str "The command %a terminated from a signal %d" Cmd.pp cmd c);
      exit
        (Dkml_install_api.Forward_progress.Exit_code.to_int_exitcode
           Exit_transient_failure)
  | Error rmsg ->
      fl ~id:"41d4fc65"
        (Fmt.str "The command %a could not be run due to: %a" Cmd.pp cmd
           Rresult.R.pp_msg rmsg);
      exit
        (Dkml_install_api.Forward_progress.Exit_code.to_int_exitcode
           Exit_transient_failure)
