import
    std/[strutils, base64, os],
    zippy, zippy/ziparchives, minify

proc packIndex(index: string): string =
    var file = readFile(index)
    return encode(compress(file, BestCompression, dfZlib))

proc packModules(modules: seq[string]): string =
    for files in walkDirRec("node_modules"):
        if files.endsWith(".js"):
            writeFile(files, minifyJs(readFile(files)))