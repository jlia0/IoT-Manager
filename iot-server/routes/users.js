var express = require('express');
var router = express.Router();
var Query = require('../actions.js');
var crypto = require('crypto');
var Getter =  require('../getters.js');
var Setter = require('../setters.js');
var md5cryto = crypto.createHash('md5');


/* GET users listing. */
router.get('/register', function (req, res, next) {
    res.render('register', {title: 'Register'});
});

router.get('/login', function (req, res, next) {
    res.render('login', {title: 'Login'});
});

// router.get('/setter', function (req, res, next) {
//     Setter.setUser(4,"Test","Canada","Alberta","Calgary",null,function (status,setres) {
//         if(status===1){
//             res.send("set success");
//         }
//
//     });
// });

router.get('/json', function (req, res, next) {

    Query.getAds(function (status,sqlres) {
        res.send(JSON.stringify(sqlres.rows));
    });

});


router.post('/register', function (req, res) {
    var email = req.body.email;
    var pwd = req.body.pwd;
    var username =  req.body.username;
    var md5 = md5cryto.update(pwd).digest('hex');


    Query.register(email,username, pwd, md5, function (status) {

        if (status === 1) {
            console.log('email is: ', email, 'password is:', pwd, 'md5 is:', pwd);
            res.send('Registry successfully');
        } else {
            res.send('Registry failed');
        }

    });

});


router.post('/login', function (req, res) {
    var email = req.body.email;
    var pwd = req.body.pwd;
    var sqlpwd;

    Query.login(email, pwd, function (status, sqlres) {
        if (status === 1) {

            if (sqlres.rows.length === 0) {
                res.send('Account does not exist');
            } else {
                sqlpwd = sqlres.rows[0].password;
                console.log('email:', email, 'password:', pwd, 'query password:', sqlpwd);
                if (pwd === sqlpwd) {
                    res.send('Login success');
                } else {
                    res.send('Password is not correct');
                }
            }

        } else {
            res.send('Login failed');
        }
    });

});

module.exports = router;
