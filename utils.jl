using Dates

"""
    {{meta}}
Plug in specific meta information for a blog page. The `meta` local page
variable should be given as a list of tuples of pairs like so:
```
@def meta = [("property"=>"og:video", "content"=>"http://example.com/"),
             ("propery"=>"og:title", "content"=>"The Rock")]
```
"""
function hfun_meta()
    m = locvar(:meta)
    io = IOBuffer()
    for tuple in locvar(:meta)
        write(io, "<meta ")
        for (prop, val) in tuple
            write(io, "$prop=\"$val\" ")
        end
        write(io, ">")
    end
    return String(take!(io))
end

function two_digits(n::Int)::String
    pre = ifelse(div(n, 10) == 0, "0", "")
    return "$pre$n"
end


"""
    {{blogposts}}
Plug in the list of blog posts contained in the `/blog/` folder.
"""
function hfun_blogposts()
    curyear = Dates.Year(Dates.today()).value
    io = IOBuffer()
    for year in curyear:-1:2016
        ys = "$year"
        year < curyear && write(io, "\n**$year**\n")
        for month in 12:-1:1
            ms = two_digits(month)
            # if you have an additional level of structure...
            for day in 31:-1:1
                ds = two_digits(day)
                # check the folder
                base = joinpath("news", ys, ms, ds)
                isdir(base) || continue
                # check the posts in the folder
                posts = filter!(p -> endswith(p, ".md"), readdir(base))
                for post in posts
                    ps       = splitext(post)[1]
                    url      = "/news/$ys/$ms/$ds/$ps/"
                    surl     = strip(url, '/')
                    title    = pagevar(surl, :title)
                    author   = pagevar(surl, :author)
                    isnothing(author) && (author = "")
                    pubdate  = "$ys-$ms-$ds"
                    write(io, "\n[$title]($url) $author ($pubdate) \n")
                end
            end
        end
    end
    # markdown conversion adds `<p>` beginning and end but
    # we want to  avoid this to avoid an empty separator
    r = Franklin.fd2html(String(take!(io)), internal=true)
    return r
end

function redirect(url)
    s = """
    <!-- REDIRECT - DO NOT MODIFY-->
    <!doctype html>
    <html>
      <head>
        <meta http-equiv="refresh" content="0; url=$url">
      </head>
    </html>
    """
    return s
end

function hfun_blog_post_redirects()
    basepath = Franklin.FOLDER_PATH[]
    for (root, _, files) in walkdir(joinpath(basepath, "news"))
        for file in files
            fullpath = joinpath(root, file)
            fullpath == joinpath(basepath, "news", "index.md") && continue
            # relative path: /news/...
            relpath = splitext(fullpath[length(basepath)+1:end])[1]
            dst = joinpath(basepath, "__site", strip(relpath, '/') * ".html")
            isfile(dst) && continue
            mkpath(splitdir(dst)[1])
            write(dst, redirect(relpath * "/"))
        end
    end
    return ""
end

function hfun_add_redirects()
  basepath = Franklin.FOLDER_PATH[]
  for n in readdir(basepath)
    endswith(n, ".md") || continue
    n in ("index.md", "config.md") && continue
    name = splitext(n)[1]
    dst = joinpath(basepath, "__site", name * ".html")
    isfile(dst) && continue
    prepath = globvar("prepath")
    pre = ""
    if prepath !== nothing && !isempty(prepath)
      pre = "/" * strip(prepath, '/')
    end
    s = redirect("$pre/$name/")
    write(dst, s)
  end
  return ""
end
