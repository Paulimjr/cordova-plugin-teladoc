const fs = require("fs");
const path = require("path");
const async = require("async");

module.exports = context => {
    "use strict";

    var TELADOC_API_KEY = "";
    if (process.argv.join("|").indexOf("TELADOC_API_KEY=") > -1) {
        TELADOC_API_KEY = process.argv.join("|").match(/TELADOC_API_KEY=(.*?)(\||$)/)[1]
    } else {
        var config = fs.readFileSync("config.xml").toString()
        TELADOC_API_KEY = getPreferenceValue(config, "TELADOC_API_KEY")
    }

    const repoUrl = "https://mobile-api-dev1.teladoc.com/sdk/"+TELADOC_API_KEY+"/maven";    
    const gradleRepo = 'maven { url "' + repoUrl + '" }';
    
    return new Promise((resolve, reject) => {
        const platformRoot = path.join(context.opts.projectRoot, "platforms/android");
        const gradleFiles = findGradleFiles(platformRoot);

        async.each(
            gradleFiles,
            function(file, callback) {
                let fileContents = fs.readFileSync(file, "utf8");

                let insertLocations = [];
                const myRegexp = /\brepositories\s*{(.*)$/gm;
                let match = myRegexp.exec(fileContents);
                while (match != null) {
                    if (match[1].indexOf(repoUrl) < 0) {
                        insertLocations.push(match.index + match[0].length);
                    }
                    match = myRegexp.exec(fileContents);
                }

                if (insertLocations.length > 0) {
                    insertLocations.reverse(); // process locations end -> beginning to preserve indices
                    insertLocations.forEach(location => {
                        fileContents =
                            fileContents.substr(0, location) +
                            gradleRepo +
                            fileContents.substr(location);
                    });

                    fs.writeFileSync(file, fileContents, "utf8");
                    console.log("updated " + file + " to include repo " + repoUrl);
                }

                callback();
            },
            function(err) {
                if (err) {
                    console.error("unable to update gradle files", err);
                    reject();
                } else {
                    resolve();
                }
            },
        );
    });

    function findGradleFiles(dir) {
        let results = [];
        const list = fs.readdirSync(dir);
        list.forEach(fileName => {
            const filePath = path.join(dir, fileName);
            const stat = fs.statSync(filePath);
            if (stat && stat.isDirectory()) {
                // recurse into subdirectory
                results = results.concat(findGradleFiles(filePath));
            } else if (path.extname(filePath) === ".gradle") {
                results.push(filePath);
            }
        });
        return results;
    }
};