
//Default filename to store the logon session cookie value
export const COOKIE_FILENAME="cookie.txt"

//Sort by recent (used to have popular as the option, but not anymore)
export const SORT_METHOD="recent"

//Flag to toggle whether verbose logging is enabled
export const TOGGLE_LOGGING=true

export const CLI_OPTIONS = {
    t: {
        alias: 'tags',
        describe: 'Indicate the tags to filter by in common-delimited manner',
        type: 'string',
        demandOption: true
    }
}
