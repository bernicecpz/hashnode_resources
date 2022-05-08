const jsdom = require("jsdom");
const { JSDOM } = jsdom;
const fs = require("fs");
const axios = require('axios').default;


// Read content of cookie
const buffer = fs.readFileSync("cookie.txt");
const fileContent = buffer.toString();

// The API seems to be based on pages, each page has max length of 10
let pageCounter=1;
let arr = [];

// Valid values seem be recent or popular
let sortByMethod = 'popular'

// Global enable of verbose logs
isEnabled = true;

const verboseLogs = (prefixMsg, data, isEnabled) => {
    if(isEnabled) {
        console.log(`${prefixMsg}: ${data}`);
    }
    
};

const recursionFunc = (pageCounter => {

    let config = {
        method: 'get',
        url: `https://hashnode.com/api/feed/rfa?page=${pageCounter}&sortBy=${sortByMethod}`,
        headers: {
            'cookie': fileContent
        }
    }
    
    axios(config).then( async response => {

        let jsonObj = response.data;
        
        verboseLogs('CONFIG URL: ', config.url, isEnabled);        
        
        if (jsonObj.posts.length !== 0) {

            for (let item of jsonObj.posts) {
    
                let newItem = {
                    'title': item.content.replace(/\r?\n|\r/g, " "),
                    'upvote': item.numLikes
                }
                verboseLogs('CURRENT ITEM: ', JSON.stringify(newItem), isEnabled); 
                arr.push(newItem);
            }
        }

        return jsonObj.posts.length;

    }).then((postLength) => {
        verboseLogs('CURRENT POST LENGTH: ', postLength, isEnabled);
        
        if (postLength == 0) {
            fs.unlinkSync('rfas.json');
            fs.writeFileSync('rfas.json', JSON.stringify(arr), 'utf8');
            return 0;
        } else {
            pageCounter = pageCounter + 1;
            return recursionFunc(pageCounter);
        }
    }).catch(error => {
        verboseLogs('AXIOS ERROR: ', error, isEnabled);
    });
    
});

recursionFunc(pageCounter);