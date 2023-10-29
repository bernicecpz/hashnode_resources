import { COOKIE_FILENAME, SORT_METHOD, TOGGLE_LOGGING } from './common.js';
import { logger, backgroundLogger } from './log.js';
import axios from 'axios';
import fs, { write } from 'fs';
import { parse } from 'json2csv';

// Read content of cookie
const buffer = fs.readFileSync(`${COOKIE_FILENAME}`);
const fileContent = buffer.toString();

// Valid values seem be recent or popular
const sortByMethod = `${SORT_METHOD}`

// Global enable of verbose logs
const toggleLogging = TOGGLE_LOGGING;

const writeFileOptions = {encoding: 'utf8', flag: 'w'};

// Output folder name
let outputFolderName = 'outputs'

// The API seems to be based on pages, each page has max length of 10
let pageCounter=1;
let tagMapsGlobal = new Map();
let tagObj = [];
let ideasArr = [];
let tempArr = [];
let ideaCount = 0;


const verboseLogs = (prefixMsg, data, isEnabled) => {
    if(isEnabled) {
        logger.info(`${prefixMsg}: ${JSON.stringify(data)}`)
    }
};

const errorLogs = (prefixMsg, data) => {
    backgroundLogger.error(`${prefixMsg}: ${data}`);
}

if (!fs.existsSync(outputFolderName)) {
    fs.mkdirSync(outputFolderName);
} else {
    fs.rmSync(outputFolderName, {recursive:true, force:true});
    fs.mkdirSync(outputFolderName);
} 

//source: https://www.c-sharpcorner.com/UploadFile/fc34aa/sort-json-object-array-based-on-a-key-attribute-in-javascrip/
function sortByUpvotes(prop) {    
    return function(a, b) {    
        if (a[prop] < b[prop]) {    
            return 1;    
        } else if (a[prop] > b[prop]) {    
            return -1;    
        }    
        return 0;    
    }    
}   

const compileTags = async (tagsMap, articleSlug, hostname) => {

    const queryBody = {
        query: `
            query {
                post(slug:"${articleSlug}", hostname: "${hostname}") {
                    tags {
                    name
                    }
                }
            }
        `
    }

    const config = {
        method: 'post',
        url: 'https://api.hashnode.com',
        headers: {
            'Content-type': 'application/json'
        }
    }
    
    let tagNames = []
    await axios.post(config.url, queryBody, config).then(async response => {
        
        if (response.data.data.post != null) {
            let tags = response.data.data.post.tags;
            
            await tags.forEach(async tag => {
                tagNames.push(tag.name);

                if (tagsMap.has(tag.name)) {
                    tagsMap.set(tag.name,tagsMap.get(tag.name)+1);
                } else {
                    tagsMap.set(tag.name, 1);
                }
            });
            
        }
        
    });

    return tagNames;
}

const recursionFunc = (pageCounter => {

    const config = {
        method: 'get',
        url: `https://hashnode.com/api/ideas?page=${pageCounter}&sortBy=${sortByMethod}`,
        headers: {
            'cookie': fileContent
        }
    }
    
    axios(config).then( async response => {
        let jsonObj = response.data;

        try {
            verboseLogs('RFA Current Page URL: ', config.url, toggleLogging);
            
            ideaCount = ideaCount + jsonObj.ideas.length

            // Loop through each idea
            for (let currentIdea of jsonObj.ideas) {

                // Loop through each submitted post
                for (let currentSubmittedPost of currentIdea.submittedPosts) {

                    //Determine if user using default domain or custom domain
                    let targetDomain = currentSubmittedPost.author.publicationDomain;
                    if (!currentSubmittedPost.author.publicationDomain) {
                        targetDomain = `${currentSubmittedPost.author.username}.hashnode.dev`
                    }

                    let postItem = {
                        'title': currentSubmittedPost.title,
                        'totalReactions': currentSubmittedPost.totalReactions,
                        'slug': currentSubmittedPost.slug,
                        'username': currentSubmittedPost.author.username,
                        'hostname': targetDomain,
                        'article_url': `https://${targetDomain}/${currentSubmittedPost.slug}`
                    }

                    //To count the tags and return the tags for submitted posts
                    const post_tags = await compileTags(tagMapsGlobal, postItem.slug, postItem.hostname);

                    // Add tags into the postItem
                    postItem.tags = post_tags;

                    verboseLogs('Current Post Item: ', postItem, toggleLogging);

                    tempArr.push(postItem);

                } // End of loop for submitted posts

                // RFA Idea Details
                let ideaItem = {
                    'title': currentIdea.content.replace(/\r?\n|\r/g, " "),
                    'upvote': currentIdea.numLikes,
                    'submittedPostCount': currentIdea.submittedPosts.length,
                    'submittedPosts': [...tempArr]
                }

                ideasArr.push(ideaItem);
                
                // Clear the array
                tempArr = [];


            } // End of Loop for Ideas

        } catch(err) {
            errorLogs('ERROR: ', err);
        }

        return jsonObj;
        
    }).then((obj) => {
        if (obj.ideas.length == 0) {
            
            verboseLogs('END OF PAGINATION, Total Idea Count', ideaCount, toggleLogging);
            // Write to file
            ideasArr.sort(sortByUpvotes("upvote"));
            fs.writeFileSync('outputs/ideas.json', JSON.stringify(ideasArr), writeFileOptions);
            
            const ideasCsv = parse(ideasArr);
            fs.writeFileSync('outputs/ideas.csv', ideasCsv, writeFileOptions);

            // Sort tags in descending order
            // Source: https://stackoverflow.com/questions/37982476/how-to-sort-a-map-by-value-in-javascript
            let sorted = new Map([...tagMapsGlobal.entries()].sort((a,b) => b[1] -a[1]));
            tagObj = Object.fromEntries(sorted);
            fs.writeFileSync('outputs/tags.json', JSON.stringify(tagObj), writeFileOptions);
            const tagsCsv = parse(tagObj);
            fs.writeFileSync('outputs/tags.csv', tagsCsv, writeFileOptions);

            console.info(`RFA Count: ${ideaCount}`);
            console.info('Retrieval of RFA ideas complete');
            
            return 0;
        } else {
            pageCounter = pageCounter + 1;
            return recursionFunc(pageCounter);
        }
    });



});

recursionFunc(pageCounter);
