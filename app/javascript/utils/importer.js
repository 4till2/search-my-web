const URL_FROM_HREF_REGEX = /(?:href|HREF)="(.+)"/g
const URL_FROM_PLAIN_TEXT = /^((http|https):\/\/)?(www.)?(?!.*(http|https|www.))[a-zA-Z0-9_-]+(\.[a-zA-Z]+)+((\/)[\w#]+)*(\/\w+\?[a-zA-Z0-9_]+=\w+(&[a-zA-Z0-9_]+=\w+)*)?$/gi
const FILE_EXTENSION_REGEX = /\.[0-9a-z]+$/
const PERMITTED_FILE_TYPES = ['text/html']

export const urlsFromFile = async (file) => {
    if (!PERMITTED_FILE_TYPES.includes(file.type)) {
        alert('Only HTML files permitted')
        return []
    }

    try {
        const fileContents = await readFileAsText(file)
        const fileUrls = extractLinksFromHtml(fileContents)
        return fileUrls
    } catch (e) {
        console.warn(e.message)
        return null
    }
}

const extractLinksFromHtml = (text) => {
    let links = text.match(URL_FROM_HREF_REGEX)
    // Since javascript is javascript non capturing isn't supported from our regex so we need to remove some stuff.
    links = links.map(l => l.replace(/(href|HREF|=|"|')/g, ''))
    return links
}

const extractLinksFromText = (text) => {
    let links = text.match(URL_FROM_PLAIN_TEXT)
    return links
}


const readFileAsText = (inputFile) => {
    const temporaryFileReader = new FileReader();

    return new Promise((resolve, reject) => {
        temporaryFileReader.onerror = () => {
            temporaryFileReader.abort();
            reject(new DOMException("Problem parsing input file."));
        };

        temporaryFileReader.onload = () => {
            resolve(temporaryFileReader.result);
        };
        temporaryFileReader.readAsText(inputFile);
    });
};