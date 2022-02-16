import {Controller} from "@hotwired/stimulus"
import {toggle} from 'utils/el-transition';

export default class extends Controller {
    static get targets() {
        return ['toggleable']
    }

    static get values() {
        return {auto: Number}
    }

    static get classes() {
        return ['toggle']
    }

    connect() {
        if (this.autoValue) this.auto()
    }

    toggle(e) {
        e?.preventDefault();
        this.toggleableTargets.forEach(t => toggle(t, this.toggleClass))
    }

    auto() {
        let toggles = this.toggleableTargets
        setTimeout(function () {
            toggles.forEach(t => toggle(t, this.toggleClass))
        }, this.autoValue)
    }
}