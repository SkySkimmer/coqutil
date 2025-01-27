Require Import Ltac2.Ltac2.
Require coqutil.Ltac2Lib.Char.

Ltac2 concat (ss : string list) : string :=
  let l := List.fold_right Int.add 0 (List.map String.length ss) in
  let ret := String.make l (Char.of_int 0) in
  let rec loop (i : int) (ss : string list) : unit :=
    match ss with
    | [] => ()
    | s::ss =>
        let l := String.length s in
        let rec inner (j : int) : unit :=
          if Int.equal j l then ()
          else (String.set ret (Int.add i j) (String.get s j); inner (Int.add j 1)) in
        inner 0;
        loop (Int.add i l) ss
    end in
  loop 0 ss; ret.

Ltac2 join (sep : string) (ss : string list) : string :=
  match ss with
  | [] => String.make 0 (Char.of_int 0)
  | s::ss =>
      match ss with
      | [] => s
      | _ => concat (s::(List.flat_map (fun s => [sep; s]) ss))
      end
  end.

Ltac2 append (s1 : string) (s2 : string) :=
  concat [s1; s2].

Ltac2 starts_with(prefix: string)(s: string) :=
  let rec loop i :=
    if Int.le (String.length prefix) i then true
    else if Int.le (String.length s) i then false
         else if Char.equal (String.get prefix i) (String.get s i)
              then loop (Int.add i 1)
              else false in
  loop 0.
