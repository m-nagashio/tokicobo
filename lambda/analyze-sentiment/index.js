const request = require('sync-request');
const mysql = require('mysql');
const util = require('util');

const pool = mysql.createPool({
  connectionLimit: 10,
  host : 'tokicobo-mysql-public.cjzqiuaqkjbq.ap-northeast-1.rds.amazonaws.com',
  user : 'admin',
  password : '5RULDddNdeF57zKhSkWV',
  port : 3306,
  database: 'tokicobo'
})

const ACCESS_TOKEN_URL = 'https://api.ce-cotoha.com/v1/oauth/accesstokens';
const SENTIMENT_API_URL = 'https://api.ce-cotoha.com/api/dev/nlp/v1/sentiment';

const SENTIMENT_NEGATIVE = 'Negative';

const SENTIMENT_TYPE_NEGATIVE = 0;
const SENTIMENT_TYPE_POSITIVE = 1;

async function fetchTalkKeywords(sentimentType, talkCount) {
  pool.query = util.promisify(pool.query)
  try {
    var results = await pool.query('select * from talk_keyword where sentiment_type = ? and talk_count = ?', 
    [sentimentType, talkCount]);
    pool.end();
  } catch (err) {
    throw new Error(err)
  }
  return results;
}

exports.handler = async (event) => {
  const inputText = event.input_text;
  // const inputText = "行きたい";
  var accessTokenRes = request('POST', ACCESS_TOKEN_URL, {
    headers: {
      "content-type": "application/json"
    },
    json: {
      "grantType": "client_credentials",
      "clientId": "Pb8KQuSwmc0xATlfcC4wn4LhpvktMXE8", 
      "clientSecret": "cAkkDPKMQNq329DC"
    }
  });
  const accessTokenBody = JSON.parse(accessTokenRes.getBody('utf8'));
  var accessToken = accessTokenBody.access_token;

  var sentimentRes = request('POST', SENTIMENT_API_URL, {
    headers: {
      "content-type": "application/json",
      "Authorization": "Bearer " + accessToken,
    },
    json: {
      "sentence": inputText
    }
  });
  const sentimentBody = JSON.parse(sentimentRes.getBody('utf8'));
  const sentiment = sentimentBody.result.sentiment;

  // if (sentiment == SENTIMENT_NEGATIVE) {
  //   return { statusCode: 200, body: SENTIMENT_TYPE_NEGATIVE};
  // }

  // const talkCount = event.talk_count;
  // const talkCount = 1;

  // var sentimentType = SENTIMENT_TYPE_NEGATIVE
  // var response = {
  //   statusCode: 200,
  //   body: sentimentType,
  // };

  // fetchTalkKeywords(SENTIMENT_TYPE_POSITIVE, talkCount).then(
  //   result => {
  //     result.some(function(record){
  //       if (inputText.indexOf(record.keyword) != -1) {
  //         sentimentType = SENTIMENT_TYPE_POSITIVE;
  //         return true;
  //       }
  //     });
  //     console.log("sentimentType");
  //     console.log(sentimentType);
  //   }
  // );

  // console.log(sentimentType);
  const response = {
    statusCode: 200,
    body: sentiment,
  };
  return response;
};
