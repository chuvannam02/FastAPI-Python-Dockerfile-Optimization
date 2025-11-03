const express = require('express');
const redis = require('redis');
const app = express();
const client = redis.createClient();
client.connect();
app.get('/', (req, res) => {
  client.incr('hits').then(n => res.send(`Anh đã thắng! Hits: ${n}`));
});
app.listen(3000);