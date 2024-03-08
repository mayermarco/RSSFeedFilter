const express = require('express');
const multer = require('multer');
const cors = require('cors');
const fs = require('fs');
const upload = multer();

const app = express();
app.use(cors());
const port = 81;

const keywords_file = './keywords.txt';

app.post('/api/set/keywords', upload.none(), (req, res) => {
  fs.writeFile(keywords_file, req.body.keyword, (err) => {
    if (err) {
      console.error(err);
      res.status(500).json('Internal Server Error');
    }
  });
  res.status(200).json('ok');
});

app.get('/api/get/keywords', (req, res) => {
  fs.readFile(keywords_file, 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      res.status(500).json('Internal Server Error');
    }
    res.status(200).json(data);
  });
})

app.listen(port, () => {
  console.log(`RSS Admin listening at http://localhost:${port}`);
});
