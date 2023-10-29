import express from 'express';
import cors from 'cors';
import { get_all_ideas, get_all_tags, filter_by_tags } from './backend.js';

const app = express();
const port = 5000;

const BASE_VERSION = 'latest';
const outputFolderName = 'outputs';

const allowedOrigins = [
    'http://localhost:3000',
    'http://127.0.0.1:3000'
]

app.use(cors({
    origin: function(origin, callback) {
        if (!origin) return callback(null, true);

        if (allowedOrigins.indexOf(origin) == -1) {
            let message = 'The CORS policy of this site does not ' +
                          'allow access from the specified origin.'
            return callback(new Error(message), false);
        }
        return callback(null, true);
    }
}));


app.get(`/api/${BASE_VERSION}/ideas`, async (req, res) => {

    const data = await get_all_ideas();
    console.log(data.keys());
    res.send(data);
});

app.get(`/api/${BASE_VERSION}/tags`, async (req, res) => {

    const data = await get_all_tags();

    console.log(Object.keys(data));

    res.send(Object.keys(data));
});

app.post(`/api/${BASE_VERSION}/filter`, async (req, res) => {
    console.log(req);
    filter_by_tags(req.tags);
    res.status(200).send('ok');
})

app.listen(port, () => {
    console.log(`Backend app listening on port ${port}`);
})
