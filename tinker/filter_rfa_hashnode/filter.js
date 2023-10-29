// import yargs from 'yargs';
// import { hideBin } from 'yargs/helpers';
import { LowSync } from 'lowdb';
import { JSONFileSync } from 'lowdb/node';

import { CLI_OPTIONS } from './common.js';
// const yargs_helper = yargs(hideBin(process.argv));


// const options = yargs_helper
//     .version(true)
//     .usage(
//         'Usage: node filter.js -t <TAG1,TAG2...>'
//     ).strictOptions(true)
//     .options(CLI_OPTIONS);

// const filterInit = async argvs => {
//     tags = argvs.tags
// }

const db = new LowSync(new JSONFileSync('outputs/ideas.json'), {});

db.read();

console.info(db.data);

// TODO: Create a DB Wrapper Class
/*
Read db
*/