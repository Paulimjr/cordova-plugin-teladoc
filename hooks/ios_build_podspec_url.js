module.exports = function (ctx) {
    var fs = require("fs");
    var path = require("path");

    /**
     * Recursively search for file with the tiven filter starting on startPath
     */
    function searchRecursiveFromPath(startPath, filter, rec, multiple) {
        if (!fs.existsSync(startPath)) {
            console.log("no dir ", startPath);
            return;
        }

        var files = fs.readdirSync(startPath);
        var resultFiles = [];
        for (var i = 0; i < files.length; i++) {
            var filename = path.join(startPath, files[i]);
            var stat = fs.lstatSync(filename);
            if (stat.isDirectory() && rec) {
                fromDir(filename, filter); //recurse
            }

            if (filename.indexOf(filter) >= 0) {
                if (multiple) {
                    resultFiles.push(filename);
                } else {
                    return filename;
                }
            }
        }
        if (multiple) {
            return resultFiles;
        }
    }

    function customPodfileContents(ctx, podFilePath) {
        console.log("podFilePath: ", podFilePath);
        var cmdLineElements = ctx.cmdLine.split(" ");
        var apiKeyVariable = cmdLineElements[cmdLineElements.length - 1].split("=");
        //console.log(apiKeyVariable);

        if (apiKeyVariable[0].indexOf("TELADOC") >= 0) {
            fs.readFile(podFilePath, "utf8", (err, contents) => {
                var podFileContents = contents.split("\n");
                var newPodfileContents = podFileContents
                    .map((line) => {
                        var lineElements = line.split(",");
                        if (lineElements[0].indexOf("pod 'Teladoc'") >= 0) {
                            return (
                                "\tpod 'Teladoc', :podspec => 'https://mobile-api-dev1.teladoc.com/sdk/" +
                                apiKeyVariable[1] +
                                "/podspec/latest.podspec'"
                            );
                        } else {
                            return line;
                        }
                    })
                    .join("\n");

                fs.writeFile(podFilePath, newPodfileContents, (err) => {
                    if (err) {
                        throw err;
                    }
                });
                //console.log(newContents);
            });
        }
    }

    customPodfileContents(ctx, searchRecursiveFromPath("platforms/ios", "Podfile", false));
};
