const { Client } = require('@elastic/elasticsearch');
const client = new Client({ node: 'http://localhost:9200' });


async function indexNews() {
    await client.index({
      index: 'news',
      id: '1', // Use a unique ID for each article
      document: {
        title: 'Sample News Title',
        content: 'Full news article content...',
        date: '2024-04-01',
        tags: ['Example', 'News'],
      },
    });
  
    // Ensure the indexing operation is complete
    await client.indices.refresh({ index: 'news' });
  }
  
  indexNews().catch(console.error);

async function searchNews(query) {
  const { body } = await client.search({
    index: 'news',
    query: {
      match: { content: query },
    },
  });

  return body.hits.hits;
}

// Example usage
searchNews('search keyword').then(console.log).catch(console.error);

  