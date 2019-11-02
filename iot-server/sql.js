// connect with PostgresSQL
var pg = require('pg');


// Database config
var config = {
    user: "iobphfnwodostn",
    database: "d4ff3bi33bcge9",
    password: "97f0f8aa11c97461a5590d843b2b4215455938c721fd07c4950b464f594128c1",
    host: "ec2-54-197-232-203.compute-1.amazonaws.com",
    port: 5432,
    ssl: true,

    // extended attributes
    poolSize: 5,
    poolIdleTimeout: 30000,
    reapIntervalMillis: 10000
}

var pool = new pg.Pool(config);


pool.connect(function (isErr, client, done) {
    if (isErr) {
        console.log('Connect query:' + isErr.message);
        return;
    }
    client.query('select now();', [], function (isErr, rst) {
        done();
        if (isErr) {
            console.log('Query error:' + isErr.message);
        } else {
            console.log('Query success, data is: ' + rst.rows[0].now);
        }
    })
});

var SQLQuery = function (sql, callback) {
    pool.query(sql, (err, res) => {
        callback(err, res);

        if (err) {
            console.log('Query error:', err.message);
        } else {
            //console.log('Query return:', res.rows);
        }
    });
};


pool.on("error", function (err, client) {
    console.log("error --> ", err)
});

pool.on('acquire', function (client) {
    //console.log("acquire Event")
});

pool.on('connect', function () {
    //console.log("connect Event")
});


module.exports = SQLQuery;