open System
open System.IO
open System.Text.RegularExpressions

type Post = { Path: string; Title: string; Date: DateTime }

let root =
    __SOURCE_DIRECTORY__
    |> Path.GetFullPath
    |> string

let rxTitle = Regex(@"\+TITLE:\s?(.+)", RegexOptions.Compiled)

let readFile(path: string) =
    let text =
        File.ReadAllLines(path)
        |> String.concat "\n"
    (path, text)

let check (regex: Regex) expr =
    let m = regex.Match(expr)
    if m.Success then Some (m.Value, m.Groups[1])
    else None

let parse path (content: string) =
    let group = check rxTitle content
    match group with
    | Some (_, t) ->
        let date = DateTime.UtcNow
        Some { Title = t.Value; Date = date; Path = path; }
    | _ -> None

let generateHtml (posts: Post []) filename outpath =
    let render (p: Post) =
        let path =
            p.Path.Replace(root, ".").Replace(".org", ".html")
        $"<li><a href={path}>{p.Title}</a></li>"
    let list =
        posts
        |> Array.sortByDescending (fun p -> p.Date)
        |> Array.map render
        |> String.concat "\n"

    let orgTemplate = $"
        #+begin_export html
        {list}
        #+end_export
    "
    use writer = new StreamWriter(path = outpath + $"/{filename}.org")
    writer.WriteLine(orgTemplate)

let posts =
    Directory.GetFiles(root, "*.org")
    |> Array.map readFile
    |> Array.choose (fun (p,c) -> parse p c)

generateHtml posts root
