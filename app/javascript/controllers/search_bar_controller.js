import {Controller} from "@hotwired/stimulus"
import {debounce} from "utils";

export default class extends Controller {
    static get targets() {
        return ["form", "input", "reset"]
    }

    connect() {
        this.moveCursorToEnd(this.inputTarget) // Focus input at end of query if present.
        this.inputTarget.oninput = debounce(() => this.formTarget.requestSubmit(), 500)
    }

    reset() {
        this.inputTarget.value = ''
        this.formTarget.requestSubmit()
    }

    moveCursorToEnd(el) {
        if (typeof el.selectionStart == "number") {
            el.selectionStart = el.selectionEnd = el.value.length;
        } else if (typeof el.createTextRange != "undefined") {
            el.focus();
            var range = el.createTextRange();
            range.collapse(false);
            range.select();
        }
    }
}