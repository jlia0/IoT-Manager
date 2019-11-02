var SQLQuery = require('./sql.js');
var Getter = require('./getters.js');

module.exports = function () {

};


String.prototype.format = function () {
    if (arguments.length === 0) return this;
    var obj = arguments[0];
    var s = this;
    for (var key in obj) {
        s = s.replace(new RegExp("\\{" + key + "\\}", "g"), obj[key]);
    }
    return s;
};

//SETTERS

//Example
module.exports.setUser = function (user_id, username, country, state, city, email, callback) {
    var _username, _country, _state, _city, _email;

    Getter.getUser(user_id, function (status, getres) {
        if (status === 0) {
            //return -1 means unknown sql query error
            callback(-1);
        }
        if (status === 1) {
            if (getres.rows.length === 0) {
                //return 0 means this user does not exist
                callback(0);
            } else {
                (!username) ? _username = getres.rows[0].username : _username = username;
                (!country) ? _country = getres.rows[0].country : _country = country;
                (!state) ? _state = getres.rows[0].state : _state = state;
                (!city) ? _city = getres.rows[0].city : _city = city;
                (!email) ? _email = getres.rows[0].email : _email = email;

                // There is one more bug. If the original attribute is NULL, then the query will input 'undefine' to the database
                var data = {
                    username: _username,
                    country: _country,
                    state: _state,
                    city: _city,
                    email: _email,
                    user_id: user_id
                };
                var query = "UPDATE public.user SET username = '{username}', country = '{country}', state = '{state}', city = '{city}', email = '{email}' WHERE user_id = '{user_id}'".format(data);
                console.log(query);
                SQLQuery(query, function (err, res) {
                    if (err) {
                        //return -1 means unknown sql query error
                        status = -1;
                        callback(status);
                    } else {
                        status = 1;
                        callback(status, res);
                    }
                });
            }
        }
    });
};

module.exports.setProfile = function (user_id, birthday, profilepicture, callback) {
    var _birthday, _profilepicture;

    Getter.getProfile(user_id, function (status, getres) {
        if (status === 0) {
            //return -1 means unknown sql query error
            callback(-1);
        }
        if (status === 1) {
            if (getres.rows.length === 0) {
                //return 0 means this user does not exist
                callback(0);
            } else {
                (!birthday) ? _birthday = getres.rows[0].birthday : _birthday = birthday;
                (!profilepicture) ? _profilepicture = getres.rows[0].profilepicture : _profilepicture = profilepicture;

                var data = {
                    birthday: _birthday,
                    profilepicture: _profilepicture,
                    userid: user_id
                };
                var query = "UPDATE public.profile SET birthday = '{birthday}', profilepicture = '{profilepicture}' WHERE user_id = '{userid}'".format(data);
                SQLQuery(query, function (err, res) {
                    if (err) {
                        //return -1 means unknown sql query error
                        status = -1;
                        callback(status);
                    } else {
                        status = 1;
                        callback(status, res);
                    }
                });
            }
        }
    });
};

module.exports.setRegistry = function (email, password, md5, callback) {
    var _password, _md5;

    Getter.getRegistry(email, function (status, getres) {
        if (status === 0) {
            //return -1 means unknown sql query error
            callback(-1);
        }
        if (status === 1) {
            if (getres.rows.length === 0) {
                //return 0 means this user does not exist
                callback(0);
            } else {
                (!password) ? _password = getres.rows[0].password : _password = password;
                (!md5) ? _md5 = getres.rows[0].md5 : _md5 = md5;

                var data = {
                        password: _password,
                        md5: _md5,
                        email: email
                    }
                ;
                var query = "UPDATE public.registry SET password = '{password}', md5 = '{md5}' WHERE email = '{email}'".format(data);
                SQLQuery(query, function (err, res) {
                    if (err) {
                        //return -1 means unknown sql query error
                        status = -1;
                        callback(status);
                    } else {
                        status = 1;
                        callback(status, res);
                    }
                });
            }
        }
    });
};

module.exports.setSocialMedia = function (user_id, account, fb_flag, ins_flag, tw_flag, email, callback) {
    var _account, _fb_flag, _ins_flag, _tw_flag, _email;

    Getter.getSocialMedia(user_id, function (status, getres) {
        if (status === 0) {
            //return -1 means unknown sql query error
            callback(-1);
        }
        if (status === 1) {
            if (getres.rows.length === 0) {
                //return 0 means this user does not exist
                callback(0);
            } else {
                (!account) ? _account = getres.rows[0].account : _account = account;
                (!fb_flag) ? _fb_flag = getres.rows[0].fb_flag : _fb_flag = fb_flag;
                (!ins_flag) ? _ins_flag = getres.rows[0].ins_flag : _ins_flag = ins_flag;
                (!tw_flag) ? _tw_flag = getres.rows[0].tw_flag : _tw_flag = tw_flag;
                (!email) ? _email = getres.rows[0].email : _email = email;

                var data = {
                        account: _account,
                        fb_flag: _fb_flag,
                        ins_flag: _ins_flag,
                        tw_flag: _tw_flag,
                        email: _email,
                        user_id: user_id
                    }
                ;
                var query = "UPDATE public.socialmedia SET account = '{account}', fb_flag = '{fb_flag}', ins_flag = '{ins_flag}', tw_flag = '{tw_flag}', email = '{email}' WHERE user_id = '{user_id}'".format(data);
                SQLQuery(query, function (err, res) {
                    if (err) {
                        //return -1 means unknown sql query error
                        status = -1;
                        callback(status);
                    } else {
                        status = 1;
                        callback(status, res);
                    }
                });
            }
        }
    });
};

module.exports.setIdentificationPicture = function (pic_id, link, res_id, callback) {
    var _link, _res_id;

    Getter.getIdentificationPicture(pic_id, function (status, getres) {
        if (status === 0) {
            //return -1 means unknown sql query error
            callback(-1);
        }
        if (status === 1) {
            if (getres.rows.length === 0) {
                //return 0 means this user does not exist
                callback(0);
            } else {
                (!link) ? _link = getres.rows[0].link : _link = link;
                (!res_id) ? _res_id = getres.rows[0].res_id : _res_id = res_id;


                var data = {
                        link: _link,
                        res_id: _res_id,
                        pic_id: pic_id
                    }
                ;
                var query = "UPDATE public.identification_picture SET link = '{link}', res_id = '{res_id}' WHERE pic_id = '{pic_id}'".format(data);
                SQLQuery(query, function (err, res) {
                    if (err) {
                        //return -1 means unknown sql query error
                        status = -1;
                        callback(status);
                    } else {
                        status = 1;
                        callback(status, res);
                    }
                });
            }
        }
    });
};

module.exports.setARResources = function (res_id, link, res_type, ad_id, callback) {
    var _link, _res_type, _ad_id;

    Getter.getARResources(res_id, function (status, getres) {
        if (status === 0) {
            //return -1 means unknown sql query error
            callback(-1);
        }
        if (status === 1) {
            if (getres.rows.length === 0) {
                //return 0 means this user does not exist
                callback(0);
            } else {
                (!link) ? _link = getres.rows[0].link : _link = link;
                (!res_type) ? _res_type = getres.rows[0].res_type : _res_type = res_type;
                (!ad_id) ? _ad_id = getres.rows[0].ad_id : _ad_id = ad_id;

                var data = {
                        link: _link,
                        res_type: _res_type,
                        ad_id: _ad_id,
                        res_id: res_id
                    }
                ;
                var query = "UPDATE public.ar_resources SET link = '{link}', res_type = '{res_type}', ad_id = '{ad_id}' WHERE res_id = '{res_id}'".format(data);
                SQLQuery(query, function (err, res) {
                    if (err) {
                        //return -1 means unknown sql query error
                        status = -1;
                        callback(status);
                    } else {
                        status = 1;
                        callback(status, res);
                    }
                });
            }
        }
    });
};


module.exports.setAdvertisements = function (ad_id, business_owner_userid, callback) {
    var _link, _res_id;

    Getter.getIdentificationPicture(pic_id, function (status, getres) {
        if (status === 0) {
            //return -1 means unknown sql query error
            callback(-1);
        }
        if (status === 1) {
            if (getres.rows.length === 0) {
                //return 0 means this user does not exist
                callback(0);
            } else {
                (!link) ? _link = getres.rows[0].link : _link = link;
                (!res_id) ? _res_id = getres.rows[0].res_id : _res_id = res_id;


                var data = {
                        link: _link,
                        res_id: _res_id,
                        pic_id: pic_id
                    }
                ;
                var query = "UPDATE public.identification_picture SET link = '{link}', res_id = '{res_id}' WHERE pic_id = '{pic_id}'".format(data);
                SQLQuery(query, function (err, res) {
                    if (err) {
                        //return -1 means unknown sql query error
                        status = -1;
                        callback(status);
                    } else {
                        status = 1;
                        callback(status, res);
                    }
                });
            }
        }
    });
};


module.exports.setBusinessOwner = function (user_id, callback) {

};

module.exports.setCard = function (card_name, callback) {
    var status = -1;
    var query = "SELECT * FROM card where card_name='" + card_name + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

module.exports.setCompany = function (company_name, callback) {
    var status = -1;
    var query = "SELECT * FROM company where company_name='" + company_name + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

module.exports.setEntertainmentComplex = function (complex_name, callback) {
    var status = -1;
    var query = "SELECT * FROM entertainment_complex where complex_name='" + complex_name + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

module.exports.setProduct = function (product_code, callback) {
    var status = -1;
    var query = "SELECT * FROM product where product_code='" + product_code + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

module.exports.setService = function (provider, callback) {
    var status = -1;
    var query = "SELECT * FROM service where provider='" + provider + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

// Set what user has provided, return a table
module.exports.setProvideRelation = function (user_id, callback) {
    var status = -1;
    var query = "SELECT * FROM provide where user_id='" + user_id + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

//Set what user has scanned, return a table
module.exports.setScanRelation = function (user_id, callback) {
    var status = -1;
    var query = "SELECT * FROM scan where user_id='" + user_id + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

//Set what user has shared, return a table
module.exports.setShareRelation = function (user_id, callback) {
    var status = -1;
    var query = "SELECT * FROM share where user_id='" + user_id + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};

//Set what user has viewed, return a table
module.exports.setViewRelation = function (user_id, callback) {
    var status = -1;
    var query = "SELECT * FROM view where user_id='" + user_id + "';";

    SQLQuery(query, function (err, res) {
        if (err) {
            status = 0;
            callback(status);
        } else {
            status = 1;
            callback(status, res);
        }
    });
};