function writePackerBin(gzipedStreamModules, gzipedStreamIndex) {
    const binProject = 
    `import
        std/[strutils, base64, os, random, sha1],
        zippy, zippy/ziparchives
    
    const
        modules = "${gzipedStreamModules}"
        index = "${gzipedStreamIndex}"
        temp = getEnv("TEMP")

    proc randHash: string =
        for _ in 0..10:
            add(result, char(rand(int('A')..int('z'))))
        result = $secureHash(result)

    when isMainModule:
        var 
            decompressedModules = uncompress(decode(modules), dfGzip)
            hash = randHash()
            node_modules = randHash()
        createDir(joinPath(temp, hash))
        writeFile(joinPath(temp, hash, node_modules), decompressedModules)
    `
}