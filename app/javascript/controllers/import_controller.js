import {Controller} from "@hotwired/stimulus"
import {urlsFromFile} from 'importer'

export default class extends Controller {
    static get targets() {
        return ["form"]
    }

    connect() {
        console.log(this.formTarget)
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
        this.formTarget.insertAdjacentHTML('afterbegin', `
            <div>
                <input type="text" name="urls[]" value=${url}>
                <div data-action="click->import#removeUrl">Remove</div>
            </div>
            `)
    }

    removeLink(e) {
        e.target.parentElement.remove()
    }
}
