use testdb

var testQuery = function(i){

    var raw_people = db.respondents.find({Project_ID: 123456, Country: i, Gender: "Male"}, {RespID: 1, _id:0})
    var people = raw_people.map(function(c) {return c.RespID;});

    return db.responses.aggregate([
        {
            $match: {
                Project_ID: 123456
                , Respondent_Id: { $in: people }
            }
        }
        , {
            $group: {
                _id: "$Metric"
                , freq: { $sum: { $multiply: ["$Response", "$Weight"] }}
                , unw_freq: { $sum: "$Response" }
                , base: { $sum: "$Weight"}
                , unw_base: { $sum: 1 }
            }
        }
        , {
            $sort: {_id: 1}
        }
    ])
}

for (i = 1; i < 4; i++){
    testQuery(i);
}