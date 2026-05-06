// app/javascript/controllers/terms_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box", "checkbox", "button"]

  connect() {
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
    }
    if (this.hasCheckboxTarget) {
      this.checkboxTarget.disabled = true
    }
  }

  scroll() {
    const box = this.boxTarget
    const atBottom = box.scrollTop + box.clientHeight >= box.scrollHeight - 5

    if (atBottom && this.hasCheckboxTarget) {
      this.checkboxTarget.disabled = false
    }
  }

  toggle() {
    if (this.hasButtonTarget && this.hasCheckboxTarget) {
      this.buttonTarget.disabled = !this.checkboxTarget.checked
    }
  }
}
