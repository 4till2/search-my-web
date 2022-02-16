import {Controller} from "@hotwired/stimulus"
import {urlsFromFile} from 'utils/importer'

export default class extends Controller {
    static get targets() {
        return ["textInput", 'fileInput']
    }

    async readFile(evt) {
        //Retrieve the first (and only!) File from the FileList object
        let f = evt.target.files[0];

        if (f) {
            let result = await urlsFromFile(f)
            result.map(r => this.appendUrl(r))
        } else {
            alert("Failed to load file");
        }
    }

    appendUrl(url) {
        console.log(this.textInputTarget.value)
        this.textInputTarget.value += (url + '\n')
    }

    importFile(){
        console.log('fsaf')
        this.fileInputTarget.click()
    }
}
