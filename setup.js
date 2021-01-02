var exec = require('child_process').exec;
function logoutpu(dados){
    if (dados.slice(-1) == '\n'){
        var dados = dados.slice(0, -1)
    }
    console.log(dados)
};
var npmi = exec(`cd ${__dirname} && pwd && npm install`, {detached: false,shell: true});
npmi.on('exit', function (code) {
    if (code == 0) {
        logoutpu('NPM install Sucess')
    } else {
        logoutpu(`npm left with an error, code: ${code}`);
    }
});
