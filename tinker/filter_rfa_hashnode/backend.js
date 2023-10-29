import { LowSync } from 'lowdb';
import { JSONFileSync } from 'lowdb/node';


const db = new LowSync(new JSONFileSync('outputs/ideas.json'), {});
const tag_db = new LowSync(new JSONFileSync('outputs/tags.json'), {});

export const get_all_ideas = async () => {
    db.read();
   return db.data;
}

export const get_all_tags = async() => {
    tag_db.read()
    return tag_db.data;
}


function filter_posts_by_tag(idea) {
    return 
}

export const filter_by_tags = async(tags) => {
    db.read();

    db.data.forEach(idea => {
        idea.submittedPosts.forEach(post => {
            console.log(post.tags);
        })
    })
}

