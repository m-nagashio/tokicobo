const request = require('sync-request');
const mysql = require('mysql');
const util = require('util');

const ACCESS_TOKEN_URL = 'https://api.ce-cotoha.com/v1/oauth/accesstokens';
const SENTIMENT_API_URL = 'https://api.ce-cotoha.com/api/dev/nlp/v1/sentiment';

const SENTIMENT_NEGATIVE = 'Negative';

const SENTIMENT_TYPE_NEGATIVE = 0;
const SENTIMENT_TYPE_POSITIVE = 1;

async function fetchTalkKeywords(sentimentType, talkCount) {
  const pool = mysql.createPool({
    connectionLimit: 10,
    host : 'XXXX',
    user : 'XXXX',
    password : 'XXXX',
    port : 9999,
    database: 'XXXX'
  })
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

  var accessTokenRes = request('POST', ACCESS_TOKEN_URL, {
    headers: {
      "content-type": "application/json"
    },
    json: {
      "grantType": "client_credentials",
      "clientId": "XXXX", 
      "clientSecret": "XXXX"
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

  if (sentiment == SENTIMENT_NEGATIVE) {
    return { statusCode: 200, body: SENTIMENT_TYPE_NEGATIVE};
  }

  const talkCount = event.talk_count;

  var sentimentType = SENTIMENT_TYPE_NEGATIVE;

  const keywards = await fetchTalkKeywords(SENTIMENT_TYPE_POSITIVE, talkCount);
  keywards.some(function(record){
    if (inputText.indexOf(record.keyword) != -1) {
      sentimentType = SENTIMENT_TYPE_POSITIVE;
      return true;
    }
  });

  const response = {
    statusCode: 200,
    body: sentimentType,
  };
  return response;
};
