import {Controller} from '@hotwired/stimulus'
import {debounce} from 'utils/debounce'

export default class extends Controller {
    static get targets() {
        return ['element']
    }
    static get values() {
        return {
            resizeDebounceDelay: {
                type: Number,
                default: 100
            }
        }
    }

    initialize() {
        this.autogrow = this.autogrow.bind(this)
    }

    connect() {
        this.elementTarget.style.overflow = 'hidden'
        const delay = this.resizeDebounceDelayValue

        this.onResize = delay > 0 ? debounce(this.autogrow, delay) : this.autogrow

        this.autogrow()

        this.elementTarget.addEventListener('input', this.autogrow)
        window.addEventListener('resize', this.onResize)
    }

    disconnect() {
        window.removeEventListener('resize', this.onResize)
    }

    autogrow() {
        this.elementTarget.style.height = 'auto' // Force re-print before calculating the scrollHeight value.
        this.elementTarget.style.height = `${this.elementTarget.scrollHeight}px`
    }
}