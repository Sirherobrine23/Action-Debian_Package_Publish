var exec = require('child_process').exec;
function logoutpu(dados){
    console.log(dados)
};
var npmi = exec(`cd ${__dirname} && pwd && npm install`, {detached: false,shell: true});
console.log('Node Modules install')
npmi.on('exit', function (code) {
    if (code == 0) {
        logoutpu('NPM install Sucess')
    } else {
        console.log('npm left with an error, code: '+code);
    }
});
