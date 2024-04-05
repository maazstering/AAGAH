const express = require('express');
const app = express();
const port = 3000;

// Include your searchNews function here

app.get('/search', async (req, res) => {
  const query = req.query.q;
  const results = await searchNews(query);
  res.json(results);
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
