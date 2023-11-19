# Filter RFA tags and posts on Hashnode

## High Level Design
1. Using session cookie stored in a file (cookie.txt) and `axios`, the RFA website URL will be called via a GET request.
2. Using recursion to loop through N pages, the RFA posts as well as attached posts will be retrieved.
3. The tags tagged to the articles will also be retrieved using Hashnode API.
4. `index.js` will compile the details in JSON format and output into individual files found under the `output` folder.

## Tech Stack
1. NodeJS v16.13.1 and/or above
2. NPM v9.3.1 and/or above
3. Hashnode API

## Get Started

1. Clone the specific folder from this project repository i.e. `tinker/filter_rfa_hashnode`

```shell
# Create a directory to store the source code, in this example, the hashnode_rfa folder is created
mkdir "hashnode_rfa"
git clone --sparse --no-checkout --depth=1 "https://github.com/bernicecpz/hashnode_resources.git"  ../hashnode_rfa

# To list the sub-folders to checkout
git sparse-checkout add tinker/filter_rfa_hashnode/

# Checkout the code
git checkout

# You should be able to see the following folder structure
.
├── LICENSE
├── README.md
└── tinker
    └── filter_rfa_hashnode
        ├── README.md
        ├── common.js
        ├── index.js
        ├── log.js
        ├── package-lock.json
        ├── package.json
        └── sample-outputs
            ├── ideas.json
            └── tags.json
```

2. Install the NPM packages
```shell
# Navigate to the target folder
cd /path/to/tinker/filter_rfa_hashnode
npm install
```


3. Create a file named `cookie.txt`. Retrieve your Hashnode Session Cookie by following the steps below:
- Open the Developer Console
- Navigate to the Application tab > Storage > Cookies

## Usage
After setting up the repo and the `cookie.txt`, you can run the utility script via this NPM script.
```
npm run extract
```



## Caveat

- As the JSON created is likely to be huge, you may not be able to format through VSCode. It may cause the IDE tool to crash or hang indefinitely. Consider using the following tool to format the JSON file
    - Linux/Unix: https://vi.stackexchange.com/questions/16906/how-to-format-json-file-:in-vim
    - PowerShell: https://stackoverflow.com/questions/24789365/prettify-json-in-powershell-3


## Resources
- Sorting Map: https://stackoverflow.com/questions/37982476/how-to-sort-a-map-by-value-in-javascript