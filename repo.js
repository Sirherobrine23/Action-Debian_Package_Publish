var exec = require('child_process').exec;
const core = require('@actions/core');
const time = (new Date()).toTimeString();
core.setOutput("time", time);
// -
// --
// ---
const command = `. ${__dirname}/src/repo.sh`
var serverstated = exec(command, {detached: false, maxBuffer: Infinity});
function logoutpu(out){
    if (out.slice(-1) == '\n'){
        var out = out.slice(0, -1)
    }
    console.log(out)
}
serverstated.stdout.on('data', function (data) {
    logoutpu(data)
});
serverstated.on('exit', function (code) {
    if (!(code == 0)) {core.setFailed('Error code: ' + code);};
});
