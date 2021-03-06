open! Core

let rec dfs grid i j di dj back ~f =
  let turn () =
    match
      [ i - 1, j; i, j - 1; i, j + 1; i + 1, j ]
      |> List.filter ~f:(fun (x, y) ->
        0 <= x && x < Array.length grid && 0 <= y && y < String.length grid.(x))
      |> List.filter ~f:(fun (x, y) ->
        not ([%equal: (int * int) option] (Some (x, y)) back))
      |> List.filter ~f:(fun (x, y) -> Char.( <> ) grid.(x).[y] ' ')
    with
    | [] -> () (* done *)
    | [ (i', j') ] -> dfs grid i' j' (i' - i) (j' - j) (Some (i, j)) ~f
    | l -> raise_s [%message (l : (int * int) list) (i : int) (j : int)]
  in
  let proceed () =
    match grid.(i + di).[j + dj] with
    | ' ' -> turn ()
    | exception _ -> turn ()
    | _ -> dfs grid (i + di) (j + dj) di dj (Some (i, j)) ~f
  in
  match grid.(i).[j] with
  | 'A' .. 'Z' | '-' | '|' | '+' ->
    f ();
    proceed ()
  | ' ' -> ()
  | exception _ -> ()
  | c -> invalid_arg (String.of_char c)
;;

let () =
  let input =
    In_channel.with_file (Sys.get_argv ()).(1) ~f:In_channel.input_lines |> Array.of_list
  in
  let count = ref 0 in
  for j = 0 to String.length input.(0) do
    dfs input 0 j 1 0 None ~f:(fun () -> incr count)
  done;
  !count |> printf "%d\n"
;;
