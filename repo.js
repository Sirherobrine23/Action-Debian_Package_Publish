var exec = require('child_process').exec;
const core = require('@actions/core');
const time = (new Date()).toTimeString();
core.setOutput("time", time);
// -
// --
// ---
var serverstated = exec(`chmod 777 ${__dirname}/src/repo.sh && ${__dirname}/src/repo.sh`, {detached: false, maxBuffer: Infinity});
function logoutpu(dados){
    console.log(dados)
}
serverstated.stdout.on('data', function (data) {
    logoutpu(data)
});
serverstated.on('exit', function (code) {
    if (!code == 0) {core.setFailed('Error code: ' + code);};
});
